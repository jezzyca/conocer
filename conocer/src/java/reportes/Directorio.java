
 package reportes;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.OutputStreamWriter;

import conexion.ConexionGeneral;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.json.JSONArray;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.WorkbookUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.opencsv.CSVWriter;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import javax.servlet.http.*;
import java.io.*;

@WebServlet(name = "Directorio", urlPatterns = {"/Directorio"})
public class Directorio extends HttpServlet {

    // Constantes de paginación
    private static final int DEFAULT_PAGE_SIZE = 30;
    private static final int DEFAULT_PAGE = 1;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String formato = request.getParameter("formato");

        if (formato != null) {
            switch (formato.toLowerCase()) {
                case "excel":
                    exportarExcel(request, response);
                    break;
                default:
                    procesarJSON(request, response);
            }
        } else {
            procesarJSON(request, response);
        }
    }

    private void procesarJSON(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        try {
            List<String> procedimientos = obtenerProcedimientos(request);
            JSONObject resultado = ejecutarProcedimientos(procedimientos, request);

            try (PrintWriter out = response.getWriter()) {
                out.print(resultado.toString());
            }
        } catch (Exception e) {
            manejarError(response, e);
        }
    }

    private void exportarExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
    try {
        List<String> procedimientos = obtenerProcedimientos(request);
        Map<String, List<Map<String, Object>>> datos = obtenerDatosReporte(procedimientos, request);

        String nombreReporte = request.getParameter("nombreReporte");
        if (nombreReporte == null || nombreReporte.isEmpty()) {
            nombreReporte = "Reporte";
        }

        String fechaActual = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = nombreReporte + "_" + fechaActual + ".xlsx";

        // Configuración de la respuesta HTTP para indicar que se está enviando un archivo Excel
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName);

        try (OutputStream outputStream = response.getOutputStream(); Workbook workbook = new XSSFWorkbook()) {

            // Estilo de encabezado
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // Iterar sobre cada conjunto de datos
            for (Map.Entry<String, List<Map<String, Object>>> entry : datos.entrySet()) {
                String sheetName = getNombreHoja(entry.getKey());

                // Asegurar que el nombre de la hoja sea válido
                sheetName = WorkbookUtil.createSafeSheetName(sheetName);

                Sheet sheet = workbook.createSheet(sheetName);
                List<Map<String, Object>> registros = entry.getValue();

                if (!registros.isEmpty()) {
                    // Obtener todas las columnas
                    List<String> columnas = new ArrayList<>(registros.get(0).keySet());

                    // Crear fila de encabezado
                    Row headerRow = sheet.createRow(0);
                    for (int i = 0; i < columnas.size(); i++) {
                        Cell cell = headerRow.createCell(i);
                        cell.setCellValue(columnas.get(i));
                        cell.setCellStyle(headerStyle);
                    }

                    // Llenar datos
                    for (int rowIndex = 0; rowIndex < registros.size(); rowIndex++) {
                        Row dataRow = sheet.createRow(rowIndex + 1);
                        Map<String, Object> registro = registros.get(rowIndex);

                        for (int colIndex = 0; colIndex < columnas.size(); colIndex++) {
                            Object valor = registro.get(columnas.get(colIndex));
                            setCellValue(dataRow.createCell(colIndex), valor);
                        }
                    }
                }
            }

            // Escribir el libro de trabajo al flujo de salida (es decir, al cliente)
            workbook.write(outputStream);
            outputStream.flush();

        }
    } catch (Exception e) {
        e.printStackTrace();
        manejarError(response, e);
    }
}


    // Establecer valores de celda
    private void setCellValue(Cell cell, Object valor) {
        if (valor == null) {
            cell.setCellValue("");
            return;
        }

        try {
            if (valor instanceof String) {
                cell.setCellValue((String) valor);
            } else if (valor instanceof Number) {
                if (valor instanceof Integer) {
                    cell.setCellValue((Integer) valor);
                } else if (valor instanceof Long) {
                    cell.setCellValue((Long) valor);
                } else if (valor instanceof Double) {
                    cell.setCellValue((Double) valor);
                } else if (valor instanceof Float) {
                    cell.setCellValue((Float) valor);
                } else {
                    cell.setCellValue(valor.toString());
                }
            } else if (valor instanceof Date) {
                CreationHelper createHelper = cell.getSheet().getWorkbook().getCreationHelper();
                CellStyle dateStyle = cell.getSheet().getWorkbook().createCellStyle();
                dateStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));
                cell.setCellStyle(dateStyle);
                cell.setCellValue((Date) valor);
            } else if (valor instanceof Boolean) {
                cell.setCellValue((Boolean) valor);
            } else {
                cell.setCellValue(valor.toString());
            }
        } catch (Exception e) {
            // En caso de cualquier error, establecer el valor como cadena
            cell.setCellValue(valor != null ? valor.toString() : "");
        }
    }

  public JSONObject ejecutarProcedimientos(List<String> procedimientos, HttpServletRequest request) throws Exception {
        // Parámetros de paginación
        int page = parseIntOrDefault(request.getParameter("page"), DEFAULT_PAGE);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), DEFAULT_PAGE_SIZE);
        int offset = (page - 1) * pageSize;

        try (Connection conexion = new ConexionGeneral().getConnection()) {
            Map<String, List<Map<String, Object>>> data = new HashMap<>();

            for (String procedimiento : procedimientos) {
                String sqlProcedimiento = obtenerProcedimientoAlmacenado(procedimiento.trim());
                try (CallableStatement stmt = conexion.prepareCall(sqlProcedimiento)) {
                    boolean tieneResultados = stmt.execute();
                    if (tieneResultados) {
                        try (ResultSet rs = stmt.getResultSet()) {
                            List<Map<String, Object>> resultados = new ArrayList<>();
                            ResultSetMetaData metaData = rs.getMetaData();
                            int columnCount = metaData.getColumnCount();

                            while (rs.next()) {
                                Map<String, Object> fila = new HashMap<>();
                                for (int i = 1; i <= columnCount; i++) {
                                    String nombreColumna = metaData.getColumnLabel(i);
                                    Object valorColumna = rs.getObject(i);
                                    fila.put(nombreColumna, valorColumna != null ? valorColumna : "N/A");
                                }
                                resultados.add(fila);
                            }

                            // Aplica paginación solo para formato JSON
                            if (request.getParameter("formato") == null) {
                                List<Map<String, Object>> paginaResultados = paginarLista(resultados, offset, pageSize);
                                data.put(procedimiento, paginaResultados);
                            } else {
                                data.put(procedimiento, resultados);
                            }
                        }
                    }
                }
            }

            // Crear respuesta JSON con metadata de paginación
            JSONObject respuesta = new JSONObject();
            respuesta.put("success", true);
            respuesta.put("data", convertirResultadosAJson(data));

            // Incluir metadata de paginación solo para formato JSON
            if (request.getParameter("formato") == null) {
                int totalRegistros = obtenerTotalRegistros(data);
                respuesta.put("currentPage", page);
                respuesta.put("pageSize", pageSize);
                respuesta.put("totalPages", (int) Math.ceil((double) totalRegistros / pageSize));
                respuesta.put("totalRecords", totalRegistros);
            }

            return respuesta;

        } catch (SQLException e) {
            JSONObject errorRespuesta = new JSONObject();
            errorRespuesta.put("success", false);
            errorRespuesta.put("error", "Error de base de datos: " + e.getMessage());
            return errorRespuesta;
        }
    }

    private List<String> obtenerProcedimientos(HttpServletRequest request) {
        List<String> procedimientos = new ArrayList<>();
        String[] procedimientosParam = request.getParameterValues("procedimientos");
        if (procedimientosParam != null) {
            Collections.addAll(procedimientos, procedimientosParam);
        }
        return procedimientos;
    }

    private Map<String, List<Map<String, Object>>> obtenerDatosReporte(List<String> procedimientos, HttpServletRequest request)
            throws Exception {
        Map<String, List<Map<String, Object>>> datos = new HashMap<>();

        try (Connection conexion = new ConexionGeneral().getConnection()) {
            for (String procedimiento : procedimientos) {
                String sqlProcedimiento = obtenerProcedimientoAlmacenado(procedimiento.trim());
                try (CallableStatement stmt = conexion.prepareCall(sqlProcedimiento);
                        ResultSet rs = stmt.executeQuery()) {

                    List<Map<String, Object>> resultados = new ArrayList<>();
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();

                    while (rs.next()) {
                        Map<String, Object> fila = new HashMap<>();
                        for (int i = 1; i <= columnCount; i++) {
                            String nombreColumna = metaData.getColumnLabel(i);
                            Object valorColumna = rs.getObject(i);
                            fila.put(nombreColumna, valorColumna != null ? valorColumna : "N/A");
                        }
                        resultados.add(fila);
                    }

                    datos.put(procedimiento, resultados);
                }
            }
        }

        return datos;
    }

    private String getNombreHoja(String procedimiento) {
        return "Reporte_" + procedimiento;
    }

    private void manejarError(HttpServletResponse response, Exception e) throws IOException {
        e.printStackTrace();
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        try (PrintWriter out = response.getWriter()) {
            JSONObject error = new JSONObject();
            error.put("success", false);
            error.put("error", e.getMessage());
            out.print(error.toString());
        }
    }

    private List<Map<String, Object>> paginarLista(List<Map<String, Object>> lista, int offset, int pageSize) {
        int totalRegistros = lista.size();
        int toIndex = Math.min(offset + pageSize, totalRegistros);

        if (offset >= totalRegistros) {
            return Collections.emptyList();
        }

        return lista.subList(offset, toIndex);
    }

    private JSONObject convertirResultadosAJson(Map<String, List<Map<String, Object>>> data) {
        JSONObject datosJson = new JSONObject();
        for (Map.Entry<String, List<Map<String, Object>>> entry : data.entrySet()) {
            JSONArray procedimientoArray = new JSONArray();
            for (Map<String, Object> fila : entry.getValue()) {
                procedimientoArray.put(new JSONObject(fila));
            }
            datosJson.put(entry.getKey(), procedimientoArray);
        }
        return datosJson;
    }

    private int parseIntOrDefault(String param, int defaultValue) {
        try {
            return Integer.parseInt(param);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private int obtenerTotalRegistros(Map<String, List<Map<String, Object>>> data) {
        return data.values().stream()
                .mapToInt(List::size)
                .sum();
    }

    private String obtenerProcedimientoAlmacenado(String procedimiento) throws Exception {
        switch (procedimiento) {
            case "1":
                return "{CALL sp_REP_ACREDITACIONES_ECE_OC()}";
            case "2":
                return "{CALL sp_Rep_Directorio_CEEI()}";
            default:
                throw new Exception("Procedimiento no válido: " + procedimiento);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String procedimientos = request.getParameter("procedimientos");
        if (procedimientos == null || procedimientos.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\": \"El parámetro 'procedimientos' es requerido\"}");
            return;
        }

        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(Directorio.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(Directorio.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}

