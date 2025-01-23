package validaciones;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import conexion.ConexionGeneral;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet(name = "validacionUsers", urlPatterns = {"/ValidarUsuarios"})
public class validacionUsers extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuario = request.getParameter("usuario");
        String contrasena = request.getParameter("contrasena");

        System.out.println("Parámetro usuario: " + usuario);
        System.out.println("Parámetro contrasena: " + contrasena);

        try (Connection conexion = new ConexionGeneral().getConnection()) { 
            if (conexion != null) {
                System.out.println("Conexión exitosa con la base de datos.");
            } else {
                System.err.println("No se pudo establecer conexión con la base de datos.");
                response.sendRedirect("login.jsp?error=true");
                return;
            }

            String queryValidation = "{ CALL validaResetUsuario(?, ?) }";
            try (CallableStatement stmt = conexion.prepareCall(queryValidation)) {
                stmt.setString(1, usuario);
                stmt.setString(2, contrasena);

                System.out.println("Ejecutando procedimiento almacenado...");
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("Usuario autenticado correctamente.");

                        String queryRole = "SELECT ROL_ID FROM K_REP_SIGNEDUSERS WHERE SUS_ACCESS = ?";
                        try (CallableStatement roleStmt = conexion.prepareCall(queryRole)) {
                            roleStmt.setString(1, usuario);

                            try (ResultSet roleRs = roleStmt.executeQuery()) {
                                String rolId = null;
                                if (roleRs.next()) {
                                    rolId = roleRs.getString("ROL_ID");
                                    System.out.println("Rol del usuario: " + rolId);
                                }

                                HttpSession session = request.getSession();

                                session.setAttribute("usuario", usuario); 
                                session.setAttribute("tipoUsuario", rolId);

                                Date fechaActual = new Date();
                                SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                String fechaFormateada = formatoFecha.format(fechaActual);

                                session.setAttribute("fecha", fechaFormateada);

                                System.out.println("Usuario: " + usuario);
                                System.out.println("Fecha formateada: " + fechaFormateada);

                                if (rolId != null) {
                                    // Redirección según rol
                                    switch (rolId) {
                                        case "091FFD8E-1C76-4723-B581-C67A99F0EC87":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "DF06A990-84EF-4443-8185-77F68F6500BD":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "2AE2D0AF-DD99-4B0B-A000-073FE17EDE79":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "D3625435-5295-4349-976C-12787488AC5B":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "0AD4C2A2-59A5-481C-A501-8E3F2BDEE1E6":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "4FEBADDD-951A-4594-BDCC-D5EEEDB11FCD":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "7B08059B-E39F-4007-9871-EA1EAB1045EF":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "7459EE4B-B783-43CD-84EB-F8DFED5E56DC":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "E6D10215-1531-482F-8AB7-D5497BD8E9DC":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "CA9A6633-D971-4FEC-B379-0B8CDC859C0E":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;
                                        case "FAA8565B-A5E5-4F16-A264-4335D5888B25":
                                            response.sendRedirect("informesMensuales.jsp");
                                            break;  
                                        default:
                                            response.sendRedirect("default.jsp");
                                            break;
                                    }
                                } else {
                                    response.sendRedirect("default.jsp");
                                }
                            }
                        }
                    } else {
                        System.err.println("Usuario o contraseña incorrectos.");
                        HttpSession session = request.getSession();
                        session.setAttribute("error", "Usuario o contraseña incorrectos.");
                        response.sendRedirect("login.jsp");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    System.err.println("Error ejecutando la consulta: " + e.getMessage());
                    HttpSession session = request.getSession();
                    session.setAttribute("error", "Error al validar el usuario.");
                    response.sendRedirect("login.jsp");
                }
            } catch (Exception e) {
                e.printStackTrace();
                System.err.println("Error al ejecutar el procedimiento almacenado: " + e.getMessage());
                HttpSession session = request.getSession();
                session.setAttribute("error", "Error al conectar a la base de datos.");
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error en la conexión: " + e.getMessage());
            HttpSession session = request.getSession();
            session.setAttribute("error", "Error interno en el servidor.");
            response.sendRedirect("login.jsp");
        }
    }
}
