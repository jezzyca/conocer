/**
 *
 * @author Conocer
 * @estadisticas
 */

package reportes;

import conexion.ConexionGeneral;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.WorkbookUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet(name = "ReportesSII", urlPatterns = {"/ReportesSII"})
public class ReportesSII extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReportesSII.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 30;
    private static final int DEFAULT_PAGE = 1;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String formato = request.getParameter("formato");
            List<String> procedimientos = obtenerProcedimientos(request);

            LOGGER.log(Level.INFO, "Formato: {0}", formato);
            LOGGER.log(Level.INFO, "Procedimientos: {0}", procedimientos);

            if (procedimientos.isEmpty()) {
                throw new Exception("No se especificaron procedimientos para generar el reporte.");
            }

            if ("excel".equalsIgnoreCase(formato)) {
                exportarExcel(request, response);
            } else {
                procesarJSON(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error: {0}", e.getMessage());
            manejarError(response, e);
        }
    }

    private void procesarJSON(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        LOGGER.info("Procesando solicitud JSON...");

        try {
            int page = parseIntOrDefault(request.getParameter("page"), DEFAULT_PAGE);
            int pageSize = parseIntOrDefault(request.getParameter("pageSize"), DEFAULT_PAGE_SIZE);
            List<String> procedimientos = obtenerProcedimientos(request);
            LOGGER.log(Level.INFO, "Procedimientos solicitados: {0}", procedimientos);

            if (procedimientos.isEmpty()) {
                throw new Exception("No se especificaron procedimientos para generar el reporte.");
            }

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

    private void exportarExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        LOGGER.info("Iniciando exportación a Excel...");
        OutputStream outputStream = null;
        Workbook workbook = null;

        try {
            List<String> procedimientos = obtenerProcedimientos(request);
            if (procedimientos.isEmpty()) {
                throw new Exception("No se especificaron procedimientos para generar el reporte.");
            }

            Map<String, List<Map<String, Object>>> datos = obtenerDatosReporte(procedimientos, request);
            LOGGER.info("Datos obtenidos para el reporte: " + (datos != null ? "OK" : "NULL"));
            
            if (datos == null || datos.isEmpty()) {
                throw new Exception("No hay datos para generar el reporte.");
            }

            String nombreReporte = request.getParameter("nombreReporte");
            if (nombreReporte == null || nombreReporte.isEmpty()) {
                nombreReporte = "Reporte";
            }

            String fechaActual = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
            String fileName = nombreReporte + "_" + fechaActual + ".xlsx";

            // Configuración de la respuesta HTTP
            response.reset();
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");
            
            workbook = new XSSFWorkbook();
            CellStyle headerStyle = crearEstiloEncabezado(workbook);
            CellStyle dateStyle = workbook.createCellStyle();
            CreationHelper createHelper = workbook.getCreationHelper();
            dateStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

            for (Map.Entry<String, List<Map<String, Object>>> entry : datos.entrySet()) {
                String sheetName = WorkbookUtil.createSafeSheetName(entry.getKey());
                Sheet sheet = workbook.createSheet(sheetName);
                List<Map<String, Object>> registros = entry.getValue();

                if (!registros.isEmpty()) {
                    Row headerRow = sheet.createRow(0);
                    List<String> columnas = new ArrayList<>(registros.get(0).keySet());

                    for (int i = 0; i < columnas.size(); i++) {
                        Cell cell = headerRow.createCell(i);
                        cell.setCellValue(columnas.get(i));
                        cell.setCellStyle(headerStyle);
                    }

                    for (int rowNum = 0; rowNum < registros.size(); rowNum++) {
                        Row row = sheet.createRow(rowNum + 1);
                        Map<String, Object> registro = registros.get(rowNum);

                        for (int colNum = 0; colNum < columnas.size(); colNum++) {
                            Cell cell = row.createCell(colNum);
                            Object value = registro.get(columnas.get(colNum));

                            if (value != null) {
                                if (value instanceof Date) {
                                    cell.setCellValue((Date) value);
                                    cell.setCellStyle(dateStyle);
                                } else if (value instanceof Number) {
                                    cell.setCellValue(((Number) value).doubleValue());
                                } else if (value instanceof Boolean) {
                                    cell.setCellValue((Boolean) value);
                                } else {
                                    cell.setCellValue(value.toString());
                                }
                            }
                        }
                    }

                    for (int i = 0; i < columnas.size(); i++) {
                        sheet.autoSizeColumn(i);
                    }
                } else {
                    Row row = sheet.createRow(0);
                    Cell cell = row.createCell(0);
                    cell.setCellValue("No se encontraron registros para el procedimiento: " + entry.getKey());
                }
            }

            outputStream = response.getOutputStream();
            workbook.write(outputStream);
            outputStream.flush();
            LOGGER.log(Level.INFO, "Excel generado exitosamente: {0}", fileName);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error al generar el archivo Excel", e);
            throw e;
        } finally {
            if (workbook != null) {
                try {
                    workbook.close();
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "Error al cerrar el workbook", e);
                }
            }
            if (outputStream != null) {
                try {
                    outputStream.close();
                } catch (IOException e) {
                    LOGGER.log(Level.SEVERE, "Error al cerrar el outputStream", e);
                }
            }
        }
    }
    
    private CellStyle crearEstiloEncabezado(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        return style;
    }

    private Map<String, List<Map<String, Object>>> obtenerDatosReporte(List<String> procedimientos, HttpServletRequest request)
            throws Exception {
        Map<String, List<Map<String, Object>>> datos = new HashMap<>();
        Connection conexion = null;

        try {
            conexion = new ConexionGeneral().getConnection();
            LOGGER.info("Conexión establecida correctamente");

            for (String procedimiento : procedimientos) {
                String sqlProcedimiento = obtenerProcedimientoAlmacenado(procedimiento.trim());
                LOGGER.log(Level.INFO, "Ejecutando procedimiento: {0}", sqlProcedimiento);

                try (CallableStatement stmt = conexion.prepareCall(sqlProcedimiento)) {
                    ResultSet rs = stmt.executeQuery();
                    LOGGER.info("Query ejecutada correctamente");

                    List<Map<String, Object>> resultados = new ArrayList<>();
                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();
                    LOGGER.info("Número de columnas: " + columnCount);

                    while (rs.next()) {
                        Map<String, Object> fila = new HashMap<>();
                        for (int i = 1; i <= columnCount; i++) {
                            String nombreColumna = metaData.getColumnLabel(i);
                            Object valorColumna = rs.getObject(i);
                            fila.put(nombreColumna, valorColumna != null ? valorColumna : "N/A");
                        }
                        resultados.add(fila);
                    }

                    LOGGER.info("Registros obtenidos: " + resultados.size());
                    datos.put(procedimiento, resultados);
                    rs.close();
                }
            }
        } finally {
            if (conexion != null) {
                try {
                    conexion.close();
                    LOGGER.info("Conexión cerrada correctamente");
                } catch (SQLException e) {
                    LOGGER.log(Level.SEVERE, "Error al cerrar la conexión", e);
                }
            }
        }

        return datos;
    }

    // [Resto de métodos auxiliares sin cambios...]
    private void manejarError(HttpServletResponse response, Exception e) throws IOException {
        LOGGER.log(Level.SEVERE, "Error en la aplicación", e);
        response.reset();
        response.setContentType("application/json;charset=UTF-8");
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

        JSONObject error = new JSONObject();
        error.put("success", false);
        error.put("message", e.getMessage());
        error.put("details", e.toString());

        try (PrintWriter out = response.getWriter()) {
            out.print(error.toString());
        }
    }

    private List<String> obtenerProcedimientos(HttpServletRequest request) {
        List<String> procedimientos = new ArrayList<>();
        String[] procedimientosParam = request.getParameterValues("procedimientos");
        String procedimientoSingle = request.getParameter("procedimientos");

        if (procedimientosParam != null) {
            Collections.addAll(procedimientos, procedimientosParam);
        } else if (procedimientoSingle != null && !procedimientoSingle.trim().isEmpty()) {
            procedimientos.add(procedimientoSingle.trim());
        }

        return procedimientos;
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

        data.entrySet().forEach((entry) -> {
            JSONArray procedimientoArray = new JSONArray();

            entry.getValue().forEach((fila) -> {
                procedimientoArray.put(new JSONObject(fila));
            });
            datosJson.put(entry.getKey(), procedimientoArray);
        });
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
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}



