package estadisticas;

import conexion.ConexionGeneral;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

@WebServlet(name = "Comportamiento", urlPatterns = {"/Comportamiento"})
public class Comportamiento extends HttpServlet {
    
    
    private ConexionGeneral conexionGeneral;

    @Override
    public void init() throws ServletException {
        super.init();
        conexionGeneral = new ConexionGeneral();
    }
    
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("Servlet Comportamiento recibiendo petición GET");
    System.out.println("Todos los parámetros: " + request.getParameterMap());
    

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json; charset=UTF-8");

          String tipo = request.getParameter("tipo");
    System.out.println("Parámetro tipo recibido: [" + tipo + "]");
 
        System.out.println("Parámetro tipo recibido: [" + tipo + "]");


        if (tipo == null || tipo.trim().isEmpty()) {
            sendErrorResponse(response, "Tipo de datos no especificado", HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        tipo = tipo.trim().toLowerCase();

        // Determinar el stored procedure a ejecutar
        String spName;
        switch (tipo) {
            case "estado":
                spName = "SP_CERTIFICADOSMARCA_X_ENTIDAD_FEDERATIVA";
                break;
            case "examen":
                spName = "SP_CERTIFICADOSMARCA_X_EXAMEN_GRID";
                break;
            case "ece":
                spName = "SP_CERTIFICADOSMARCA_X_ENTIDAD_EC_OC";
                break;
            default:
                sendErrorResponse(response, "Tipo de datos no válido: " + tipo, HttpServletResponse.SC_BAD_REQUEST);
                return;
        }

        try {
            List<Map<String, Object>> data = fetchData(spName);
            if (data.isEmpty()) {
                sendSuccessResponse(response, new ArrayList<>(), "No se encontraron datos");
            } else {
                sendSuccessResponse(response, data, "Datos recuperados exitosamente");
            }
        } catch (SQLException e) {
            System.err.println("Error en la consulta SQL: " + e.getMessage());
            e.printStackTrace();
            sendErrorResponse(response, "Error al consultar la base de datos: " + e.getMessage(), 
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private List<Map<String, Object>> fetchData(String spName) throws SQLException {
        List<Map<String, Object>> dataList = new ArrayList<>();
        
        try (Connection conn = conexionGeneral.getConnection()) {
            
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET NAMES 'utf8mb4'");
                stmt.execute("SET CHARACTER SET utf8mb4");
            }
            
            String callStatement = "{CALL " + spName + "()}";
            System.out.println("Ejecutando SP: " + callStatement);
            
            try (CallableStatement stmt = conn.prepareCall(callStatement);
                 ResultSet rs = stmt.executeQuery()) {
                
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = metaData.getColumnName(i);
                        Object value = rs.getObject(i);
                        row.put(columnName, value);
                    }
                    dataList.add(row);
                }
            }
        }
        return dataList;
    }

    private void sendErrorResponse(HttpServletResponse response, String message, int statusCode) 
            throws IOException {
        response.setStatus(statusCode);
        Map<String, Object> errorMap = new HashMap<>();
        errorMap.put("error", true);
        errorMap.put("message", message);
        response.getWriter().write(new Gson().toJson(errorMap));
    }

    private void sendSuccessResponse(HttpServletResponse response, Object data, String message) 
            throws IOException {
        Map<String, Object> successMap = new HashMap<>();
        successMap.put("error", false);
        successMap.put("message", message);
        successMap.put("data", data);
        response.getWriter().write(new Gson().toJson(successMap));
    }
}