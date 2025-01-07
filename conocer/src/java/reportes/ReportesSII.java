package reportes;

import conexion.ConexionGeneral;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import org.json.JSONArray;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.WorkbookUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import com.opencsv.CSVWriter;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ReportesSII", urlPatterns = {"/ReportesSII"})
public class ReportesSII extends HttpServlet {

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
                case "csv":
                    exportarCSV(request, response);
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
            int page = parseIntOrDefault(request.getParameter("page"), DEFAULT_PAGE);
            int pageSize = parseIntOrDefault(request.getParameter("pageSize"), DEFAULT_PAGE_SIZE);
            List<String> procedimientos = obtenerProcedimientos(request);
            Map<String, List<Map<String, Object>>> allData = new HashMap<>();
            Map<String, Integer> totalRecords = new HashMap<>();

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
                        
                        totalRecords.put(procedimiento, resultados.size());
                        int offset = (page - 1) * pageSize;
                        List<Map<String, Object>> paginatedResults = paginarLista(resultados, offset, pageSize);
                        allData.put(procedimiento, paginatedResults);
                    }
                }
            }
            
            JSONObject resultado = new JSONObject();
            resultado.put("success", true);
            resultado.put("data", convertirResultadosAJson(allData));
            resultado.put("currentPage", page);
            resultado.put("pageSize", pageSize);

            int maxTotalRecords = totalRecords.values().stream()
                    .mapToInt(Integer::intValue)
                    .max()
                    .orElse(0);

            resultado.put("totalPages", (int) Math.ceil((double) maxTotalRecords / pageSize));
            resultado.put("totalRecords", maxTotalRecords);

            try (PrintWriter out = response.getWriter()) {
                out.print(resultado.toString());
            }
        } catch (Exception e) {
            manejarError(response, e);
        }
    }

    private void exportarExcel(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        try {
            List<String> procedimientos = obtenerProcedimientos(request);
            Map<String, List<Map<String, Object>>> datos = obtenerDatosReporte(procedimientos, request);

            String nombreReporte = request.getParameter("nombreReporte");
            if (nombreReporte == null || nombreReporte.isEmpty()) {
                nombreReporte = "Reporte";
            }

            String fechaActual = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String fileName = nombreReporte + "_" + fechaActual + ".xlsx";

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setHeader("Expires", "0");

            try (OutputStream outputStream = response.getOutputStream();
                 Workbook workbook = new XSSFWorkbook()) {

                CellStyle headerStyle = workbook.createCellStyle();
                Font headerFont = workbook.createFont();
                headerFont.setBold(true);
                headerStyle.setFont(headerFont);
                headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
                headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                for (Map.Entry<String, List<Map<String, Object>>> entry : datos.entrySet()) {
                    String sheetName = getNombreHoja(entry.getKey());
                    sheetName = WorkbookUtil.createSafeSheetName(sheetName);
                    
                    Sheet sheet = workbook.createSheet(sheetName);
                    List<Map<String, Object>> registros = entry.getValue();

                    if (!registros.isEmpty()) {
                        List<String> columnas = new ArrayList<>(registros.get(0).keySet());

                        Row headerRow = sheet.createRow(0);
                        for (int i = 0; i < columnas.size(); i++) {
                            Cell cell = headerRow.createCell(i);
                            cell.setCellValue(columnas.get(i));
                            cell.setCellStyle(headerStyle);
                        }

                        for (int rowIndex = 0; rowIndex < registros.size(); rowIndex++) {
                            Row dataRow = sheet.createRow(rowIndex + 1);
                            Map<String, Object> registro = registros.get(rowIndex);

                            for (int colIndex = 0; colIndex < columnas.size(); colIndex++) {
                                Cell cell = dataRow.createCell(colIndex);
                                Object valor = registro.get(columnas.get(colIndex));
                                setCellValue(cell, valor);
                            }
                        }

                        for (int i = 0; i < columnas.size(); i++) {
                            sheet.autoSizeColumn(i);
                        }
                    }
                }

                workbook.write(outputStream);
                outputStream.flush();
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "Error al generar el reporte");
                errorResponse.put("detalle", e.getMessage());
                out.print(errorResponse.toString());
            }
        }
    }

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
            cell.setCellValue(valor.toString());
        }
    }

    private void exportarCSV(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<String> procedimientos = obtenerProcedimientos(request);
            Map<String, List<Map<String, Object>>> datos = obtenerDatosReporte(procedimientos, request);

            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=Reporte.csv");

            try (CSVWriter writer = new CSVWriter(new OutputStreamWriter(response.getOutputStream(), "UTF-8"))) {
                for (Map.Entry<String, List<Map<String, Object>>> entry : datos.entrySet()) {
                    List<Map<String, Object>> registros = entry.getValue();

                    if (!registros.isEmpty()) {
                        writer.writeNext(new String[]{getNombreHoja(entry.getKey())});
                        writer.writeNext(registros.get(0).keySet().toArray(new String[0]));
                        
                        for (Map<String, Object> registro : registros) {
                            String[] linea = registro.values().stream()
                                    .map(valor -> valor != null ? valor.toString() : "")
                                    .toArray(String[]::new);
                            writer.writeNext(linea);
                        }
                        
                        writer.writeNext(new String[]{});
                    }
                }
            }
        } catch (Exception e) {
            manejarError(response, e);
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

    private String obtenerProcedimientoAlmacenado(String procedimiento) throws Exception {
        switch (procedimiento) {
            case "1":
                return "{CALL sp_Rep_AcreditacionesyRenovaciones()}";
            case "2":
                return "{CALL sp_REP_ReporteConSumaMarca()}";
            case "3":
                return "{CALL SP_CERTIFICADOSMARCA_X_ENTIDAD_EC_OC()}";
            case "4":
                return "{CALL SP_CERTIFICADOSMARCA_X_ENTIDAD_FEDERATIVA()}";
            case "5":
                return "{CALL SP_CERTIFICADOSMARCA_X_EXAMEN_GRID()}";
            case "6":
                return "{CALL sp_REP_CERTIFICADOS_EMITIDOS()}";
            case "7":
                return "{CALL sp_REP_Certificados_Emitidos_CE()}";
            case "8":
                return "{CALL sp_REP_Certificados_Emitidos_CE_SAC()}";
            case "9":
                return "{CALL sp_REP_CIFRAS_ACREDITACION()}";
            case "10":
                return "{CALL xspCifrasAnuales_SII()}";
            case "11":
                return "{CALL sp_REP_CINTILLOS_EC()}";
            case "12":
                return "{CALL SP_REP_DATOS_GENERALES_CE_EI()}";
            case "13":
                return "{CALL spRepDescargaInstrumentoEvaluacion()}";
            case "14":
                return "{CALL spRepDescargaEstandarCompetencia()}";
            case "15":
                return "{CALL sp_REP_Directorio()}";
            case "16":
                return "{CALL sp_REP_Directorio_Ampliado_Enlaces()}";
            case "17":
                return "{CALL sp_REP_ESTANDARES_EVALUADORES_CE_EI()}";
            case "18":
                return "{CALL sp_REP_Directorio_Ampliado_Enlaces()}";
            case "19":
                return "{CALL sp_REP_INST_ACDREDITADAS_AVANZADO()}";
            case "20":
                return "{CALL sp_REP_INST_ACDREDITADAS_BASICO()}";
            case "21":
                return "{CALL sp_REP_Inst_Educativa()}";
            case "22":
                return "{CALL sp_REP_LOGO_ECE_OC()}";
            case "23":
                return "{CALL sp_REP_LOTES_CERTIFICADOS()}";
            case "24":
                return "{CALL sp_REP_PERSONAS_CERTIFICADOS()}";
            case "25":
                return "{CALL sp_REP_PROCESOS_ACTIVOS_SII_SAC()}";
            case "26":
                return "{CALL SP_REP_RENEC_VS_SII()}";
            case "27":
                return "{CALL sp_Solicitud_Acreditacion_RenovascionEC()}";
            case "28":
                return "{CALL sp_Solicitud_Acreditacion_Inicial()}";
            case "29":
                return "{CALL sp_Solicitud_Certificados()}";
            case "30":
                return "{CALL sp_Solicitud_ReimpresionCER()}";
            case "31":
                return "{CALL sp_REP_ACREDITACIONES_CE_EI()}";
            case "32":
                return "{CALL sp_REP_ACREDITACIONES_ECE_OC()}";
            case "33":
                return "{CALL sp_REP_Inst_Empresarial()}";
            case "34":
                return "{CALL sp_REP_RENAC()}";
            case "35":
                return "{CALL sp_REP_RENOVACIONES_CE_EI()}";
            case "36":
                return "{CALL sp_REP_RENOVACIONES_ECE_OC()}";
            case "37":
                return "{CALL sp_REP_INTEGRAL()}";
            case "38":
                return "{CALL spCertificadosPorRegionEstadoSIISACMarca()}";
            case "39":
                return "{CALL sp_REP_SECTOR_PRODUCTIVO()}";
            case "40":
                return "{CALL sp_REP_SOLUCIONES_EVALUACION_CERTIFICACION_EC()}";
            case "41":
                return "{CALL sp_REP_VERFICADORES_EC_ECE_OC()}";
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
            Logger.getLogger(ReportesSII.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ReportesSII.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
