package validaciones;

import conexion.ConexionGeneral;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;

@WebServlet(name = "UpdatePassword", urlPatterns = {"/UpdatePassword"})
public class UpdatePassword extends HttpServlet {

    private static boolean isPasswordStrong(String newPassword) {
        String regex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)[A-Za-z\\d]{8,}$";
        return Pattern.matches(regex, newPassword);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();
        Connection conexion = null;
        PreparedStatement stmt = null;

        try {
            String username = request.getParameter("username");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            if (username == null || newPassword == null || confirmPassword == null || 
                username.trim().isEmpty() || newPassword.trim().isEmpty() || 
                confirmPassword.trim().isEmpty()) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Todos los campos son obligatorios.");
                out.print(jsonResponse.toString());
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Las contraseñas no coinciden.");
                out.print(jsonResponse.toString());
                return;
            }

            if (!isPasswordStrong(newPassword)) {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "La contraseña debe cumplir con los requisitos de seguridad.");
                out.print(jsonResponse.toString());
                return;
            }

            conexion = ConexionGeneral.getConexion();
            if (conexion != null) {
                String sql = "UPDATE K_REP_SIGNEDUSERS SET SUS_FIELD1 = ? WHERE SUS_ACCESS = ?";
                stmt = conexion.prepareStatement(sql);
                stmt.setString(1, newPassword);  
                stmt.setString(2, username);

                int rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    jsonResponse.put("success", true);
                    jsonResponse.put("message", "Contraseña actualizada con éxito.");
                } else {
                    jsonResponse.put("success", false);
                    jsonResponse.put("message", "No se pudo actualizar la contraseña. Usuario no encontrado.");
                }
            } else {
                jsonResponse.put("success", false);
                jsonResponse.put("message", "Error de conexión a la base de datos.");
            }

        } catch (SQLException e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error en la base de datos: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            jsonResponse.put("success", false);
            jsonResponse.put("message", "Error inesperado: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conexion != null) conexion.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            out.print(jsonResponse.toString());
            out.flush();
        }
    }
}