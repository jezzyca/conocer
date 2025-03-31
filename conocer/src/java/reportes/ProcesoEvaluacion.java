package reportes;

import static com.sun.corba.se.spi.presentation.rmi.StubAdapter.request;
import conexion.ConexionGeneral;
import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Blob;
import java.util.Base64;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import static javax.management.Query.value;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.WorkbookUtil;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import java.util.HashMap;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.VerticalAlignment;

/**
 *
 * @conocer
 * @juan fernandez
 */
@WebServlet(name = "ProcesoEvaluacion", urlPatterns = {"/ProcesoEvaluacion"})
public class ProcesoEvaluacion extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ReportesSII.class.getName());
    private static final int DEFAULT_PAGE_SIZE = 30;
    private static final int DEFAULT_PAGE = 1;
    private static final Map<String, String> NOMBRES_PROCEDIMIENTOS = new HashMap<>();
    static {
        NOMBRES_PROCEDIMIENTOS.put("1", "");
        NOMBRES_PROCEDIMIENTOS.put("2", "");
        NOMBRES_PROCEDIMIENTOS.put("3", "");
        NOMBRES_PROCEDIMIENTOS.put("4", "");
        NOMBRES_PROCEDIMIENTOS.put("5", "");
    }
    

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
            Map<String, List<String>> columnOrders = new HashMap<>();

            try (Connection conexion = new ConexionGeneral().getConnection()) {
                for (String procedimiento : procedimientos) {
                    String sqlProcedimiento = obtenerProcedimientoAlmacenado(procedimiento.trim());
                    try (CallableStatement stmt = conexion.prepareCall(sqlProcedimiento);
                         ResultSet rs = stmt.executeQuery()) {

                        List<Map<String, Object>> resultados = new ArrayList<>();
                        ResultSetMetaData metaData = rs.getMetaData();
                        int columnCount = metaData.getColumnCount();
                        
                        List<String> columnOrder = new ArrayList<>();
                        for (int i = 1; i <= columnCount; i++) {
                            columnOrder.add(metaData.getColumnLabel(i));
                        }
                        columnOrders.put(procedimiento, columnOrder);

                        while (rs.next()) {
                            Map<String, Object> fila = new LinkedHashMap<>();
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
            resultado.put("columnOrders", columnOrders); 

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

        // Generación del nombre del reporte
        String nombreReporte = request.getParameter("nombreReporte");
        if (nombreReporte == null || nombreReporte.isEmpty()) {
            String procId = procedimientos.get(0);
            nombreReporte = NOMBRES_PROCEDIMIENTOS.getOrDefault(procId, "Reporte_" + procId);
        }

        String fechaActual = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String fileName = nombreReporte + "_" + fechaActual + ".xlsx";

        LOGGER.log(Level.INFO, "Nombre del reporte recibido: {0}", nombreReporte);
        LOGGER.log(Level.INFO, "Nombre del archivo generado: {0}", fileName);

        response.reset();
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(fileName, "UTF-8") + "\"");

        workbook = new XSSFWorkbook();
        CellStyle headerStyle = crearEstiloEncabezado(workbook);
        CellStyle dateStyle = workbook.createCellStyle();
        CreationHelper createHelper = workbook.getCreationHelper();
        dateStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy"));

        Map<String, List<String>> columnOrders = new HashMap<>();

        for (String procedimiento : procedimientos) {
            try (Connection conexion = new ConexionGeneral().getConnection()) {
                String sqlProcedimiento = obtenerProcedimientoAlmacenado(procedimiento.trim());
                try (CallableStatement stmt = conexion.prepareCall(sqlProcedimiento);
                     ResultSet rs = stmt.executeQuery()) {

                    ResultSetMetaData metaData = rs.getMetaData();
                    int columnCount = metaData.getColumnCount();

                    List<String> columnOrder = new ArrayList<>();
                    for (int i = 1; i <= columnCount; i++) {
                        columnOrder.add(metaData.getColumnLabel(i));
                    }
                    columnOrders.put(procedimiento, columnOrder);
                }
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Error al obtener orden de columnas para " + procedimiento, e);
            }
        }

        for (Map.Entry<String, List<Map<String, Object>>> entry : datos.entrySet()) {
            String procedimiento = entry.getKey();
            String sheetName = WorkbookUtil.createSafeSheetName(procedimiento);
            Sheet sheet = workbook.createSheet(sheetName);
            List<Map<String, Object>> registros = entry.getValue();

            if (!registros.isEmpty()) {
                Row headerRow = sheet.createRow(0);

                List<String> columnas = columnOrders.get(procedimiento);
                if (columnas == null || columnas.isEmpty()) {
                    columnas = new ArrayList<>(registros.get(0).keySet());
                }

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
                        String columnName = columnas.get(colNum);
                        Object value = registro.get(columnName);

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
                    int maxWidth = 45 * 256;
                    if (sheet.getColumnWidth(i) > maxWidth) {
                        sheet.setColumnWidth(i, maxWidth);
                    }

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
    font.setFontHeightInPoints((short) 12); 
    font.setColor(IndexedColors.WHITE.getIndex()); 

    style.setFont(font); 
    
    // Agregar bordes delgados a todas las direcciones
    style.setBorderBottom(BorderStyle.THIN);
    style.setBorderTop(BorderStyle.THIN);
    style.setBorderRight(BorderStyle.THIN);
    style.setBorderLeft(BorderStyle.THIN);

    style.setFillForegroundColor(IndexedColors.RED.getIndex());
    style.setFillPattern(FillPatternType.SOLID_FOREGROUND);

    style.setAlignment(HorizontalAlignment.CENTER);
    style.setVerticalAlignment(VerticalAlignment.CENTER);

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

            String searchTerm = request.getParameter("searchTerm");
            String searchColumn = request.getParameter("searchColumn");
            boolean exactMatch = Boolean.parseBoolean(request.getParameter("exactMatch"));

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

                    List<String> columnNames = new ArrayList<>();
                    for (int i = 1; i <= columnCount; i++) {
                        columnNames.add(metaData.getColumnLabel(i));
                    }

                    while (rs.next()) {
                        Map<String, Object> fila = new LinkedHashMap<>();
                        boolean cumpleCriterio = false;

                        if (searchTerm == null || searchTerm.isEmpty()) {
                            cumpleCriterio = true;
                        } else {
                            for (int i = 1; i <= columnCount; i++) {
                                String nombreColumna = metaData.getColumnLabel(i);
                                Object valorColumna = rs.getObject(i);
                                String valorString = valorColumna != null ? valorColumna.toString().toLowerCase() : "";

                                if (searchColumn != null && !searchColumn.isEmpty() && !nombreColumna.equals(searchColumn)) {
                                    continue;
                                }

                                if (exactMatch) {
                                    if (valorString.equals(searchTerm.toLowerCase())) {
                                        cumpleCriterio = true;
                                        break;
                                    }
                                } else {
                                    if (valorString.contains(searchTerm.toLowerCase())) {
                                        cumpleCriterio = true;
                                        break;
                                    }
                                }
                            }
                        }

                        if (cumpleCriterio) {
                            for (String columnName : columnNames) {
                                int columnIndex = columnNames.indexOf(columnName) + 1;
                                Object valorColumna = rs.getObject(columnIndex);
                                fila.put(columnName, valorColumna != null ? valorColumna : "N/A");
                            }
                            resultados.add(fila);
                        }
                    }

                    LOGGER.info("Registros filtrados obtenidos: " + resultados.size());
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
                return "{CALL sp_REP_CIFRAS_ACREDITACION()}";
            case "3":
                return "{CALL sp_Rep_Directorio_CEEI()}";  
            case "4":
                return "{CALL sp_REP_INST_ACDREDITADAS_AVANZADO_AYE()}";
            case "5":
                return "{CALL sp_REP_INST_ACDREDITADAS_BASICO()}";
            case "6":
                return "{CALL sp_REP_LOGO_ECE_OC()}";
            case "7":
                return "{CALL sp_REP_ACREDITACIONES_CE_EI()}";
            case "8":
                return "{CALL sp_REP_ACREDITACIONES_ECE_OC()}";
            case "9":
                return "{CALL sp_REP_INST_ACDREDITADAS_BASICO_PASSWORD()}";
            case "10":
                return "{CALL sp_REP_RENOVACIONES_CE_EI()}";
            case "11":
                return "{CALL sp_REP_RENOVACIONES_ECE_OC()}";
            case "12":
                return "{CALL sp_REP_INTEGRAL()}";
            case "13":
                return "{CALL sp_REP_SOLUCIONES_EVALUACION_CERTIFICACION_EC()}";
            case "14":
                return "{CALL sp_REP_VERFICADORES_EC_ECE_OC()}";
            case "15":
                return "SELECT DISTINCT KCEV.FL_CENTRO_EVALUACION, KCEV.CL_ACREDITACION_CE_EI, KU.FL_USUARIO, KU.NB_USUARIO, KSU.SUS_FIELD1,\n"
                        + "	KCEV.FE_INICIO_VIGENCIA,\n"
                        + "	KCEV.FE_VIGENCIA_ACRED,\n"
                        + "	KPM.DS_RAZON_SOCIAL,\n"
                        + "    KPM.DS_SIGLAS,\n"
                        + "    CONCAT(KP.NB_PERSONA,' ',KP.NB_APELLIDO_PATERNO,' ',KP.NB_APELLIDO_MATERNO) AS REPRESENTANTE,\n"
                        + "--  KP.FL_PERSONA,\n"
                        + "    KCE.DS_CORREO_ELECTRONICO,\n"
                        + "    KT.NO_TELEFONO,\n"
                        + "    -- KCEV.FL_CENTRO_EVALUACION, \n"
                        + "    KDIR.NO_CODIGO_POSTAL, \n"
                        + "    CEF.NB_ENTIDAD_FEDERATIVA,\n"
                        + "   	CM.NB_MUNICIPIO,\n"
                        + "   	CCD.NB_CIUDAD,\n"
                        + "    CC.NB_COLONIA,\n"
                        + "    KDIR.DS_CALLE_NUMERO,\n"
                        + "    KDIR.DS_NUMERO_INTERIOR\n"
                        + "FROM \n"
                        + "K_CENTRO_EVALUACION KCEV\n"
                        + "LEFT JOIN K_CENTRO_EVALUACION_PERSONA KCEVP ON KCEVP.FL_CENTRO_EVALUACION = KCEV.FL_CENTRO_EVALUACION\n"
                        + "LEFT JOIN K_CENTRO_EVALUACION_X_PERSONA_MORAL KCEXPM ON KCEXPM.FL_CENTRO_EVALUACION = KCEV.FL_CENTRO_EVALUACION \n"
                        + "LEFT JOIN K_PERSONA_MORAL KPM ON KCEXPM.FL_PERSONA_MORAL = KPM.FL_PERSONA_MORAL\n"
                        + "LEFT JOIN K_DIRECCION KDIR ON KPM.FL_DIRECCION = KDIR.FL_DIRECCION\n"
                        + "LEFT JOIN C_ENTIDAD_FEDERATIVA CEF ON CEF.CL_ENTIDAD_FEDERATIVA = KDIR.CL_ENTIDAD_FEDERATIVA\n"
                        + "LEFT JOIN C_MUNICIPIO CM ON CM.CL_MUNICIPIO = KDIR.CL_MUNICIPIO\n"
                        + "LEFT JOIN C_COLONIA CC ON CC.CL_COLONIA = KDIR.CL_CIUDAD\n"
                        + "LEFT JOIN C_CIUDAD CCD ON CCD.CL_CIUDAD = KDIR.CL_CIUDAD\n"
                        + "LEFT JOIN K_USUARIO KU ON KU.FL_PERSONA = KCEVP.FL_PERSONA\n"
                        + "LEFT JOIN K_PERSONA KP ON KP.FL_PERSONA = KCEVP.FL_PERSONA\n"
                        + "LEFT JOIN K_PERSONA_X_CORREO KPXC ON KPXC.FL_PERSONA =  KP.FL_PERSONA\n"
                        + "LEFT JOIN K_CORREO_ELECTRONICO KCE ON KCE.FL_CORREO_ELECTRONICO = KPXC.FL_CORREO_ELECTRONICO\n"
                        + "LEFT JOIN K_PERSONA_X_TELEFONO KPXT ON KPXT.FL_PERSONA = KP.FL_PERSONA\n"
                        + "LEFT JOIN K_TELEFONO KT ON KPXT.FL_TELEFONO= KT.FL_TELEFONO\n"
                        + "LEFT JOIN K_SIGNEDUSERS KSU ON KSU.SUS_ACCESS = KU.NB_USUARIO;";
            case "16":
                return "{CALL SP_RENEC_SECTOR_PRODUCTIVO_CIAN()}";
            case "17":
                return  "SELECT * FROM C_SECTOR_PRODUCTIVO csp;";
            case "18":
                return "SELECT * FROM tblComites tc;";
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
    
 
    
