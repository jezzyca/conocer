package reportes;

import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import conexion.ConexionGeneral;

/**
 *
 * @author Conocer / Omar bahena
 */
@WebServlet(name = "DirectorioDescuentos", urlPatterns = {"/DirectorioDescuentos"})
public class DirectorioDescuentos extends HttpServlet {

   @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Part archivoPart = request.getPart("archivoExcel");
        InputStream archivoInputStream = archivoPart.getInputStream();
        
        try (Workbook workbook = new XSSFWorkbook(archivoInputStream)) {
            Sheet sheet = workbook.getSheetAt(0);
            int rowCount = sheet.getPhysicalNumberOfRows(); 

            // Conexión a la base de datos
            try (Connection conn = ConexionGeneral.getConexion()) {
                String sql = "INSERT INTO Prestadores_CriteriosPrueba (Cedula, Nombre, Siglas, Estandar, Criterio, Clasificacion) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                
                for (int i = 1; i < rowCount; i++) {
                    Row row = sheet.getRow(i);
                    if (row == null || row.getCell(0) == null) {
                        continue;
                    }
                    String cedula = obtenerValorCelda(row, 0);
                    String nombre = obtenerValorCelda(row, 1);
                    String siglas = obtenerValorCelda(row, 2);
                    String estandar = obtenerValorCelda(row, 3);
                    String criterio = obtenerValorCelda(row, 4);
                    String clasificacion = obtenerValorCelda(row, 5);

                    ps.setString(1, cedula);
                    ps.setString(2, nombre);
                    ps.setString(3, siglas);
                    ps.setString(4, estandar);
                    ps.setString(5, criterio);
                    ps.setString(6, clasificacion);
                    ps.addBatch();
                }
                // Ejecutar todas las inserciones en batch
                ps.executeBatch();
                
                response.setContentType("text/plain");
                response.getWriter().write("Registros guardados correctamente desde el archivo Excel.");
                
                /*response.setContentType("text/html;charset=UTF-8");
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('✔ Registros guardados correctamente desde el archivo Excel.');");
                response.getWriter().println("window.history.back();"); // o window.location.href = 'tuPagina.jsp';
                response.getWriter().println("</script>");*/


            } catch (Exception e) {
                e.printStackTrace(); 
                response.setContentType("text/plain");
                e.printStackTrace(response.getWriter()); 
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/plain");
            response.getWriter().write("❌ Error al guardar los registros: " + e.getMessage());
            /*response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('⚠ Error al guardar los registros: " + e.getMessage().replace("'", "") + "');");
            response.getWriter().println("window.history.back();");
            response.getWriter().println("</script>");*/
        }
        
    }
    
    private String obtenerValorCelda(Row row, int index) {
    if (row == null) return "";
    Cell cell = row.getCell(index);
    if (cell == null) return "";
    cell.setCellType(CellType.STRING);
    return cell.getStringCellValue().trim();
}

}
