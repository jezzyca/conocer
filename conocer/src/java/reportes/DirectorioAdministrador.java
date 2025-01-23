package reportes;

import conexion.ConexionGeneral;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "DirectorioAdministrador", urlPatterns = {"/DirectorioAdministrador"})
public class DirectorioAdministrador extends HttpServlet {

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); 
        } catch (ClassNotFoundException e) {
            throw new ServletException("No se pudo cargar el driver de la base de datos", e);
        }
    }

    private void cargarUsuarios(HttpServletRequest request) {
        List<Usuario> usuarios = new ArrayList<>();

        try (Connection conexion = new ConexionGeneral().getConnection()) {
            String sql = "SELECT SUS_ID, SUS_ACCESS, SUS_STATUS FROM K_REP_SIGNEDUSERS ORDER BY SUS_ID";
            try (PreparedStatement ps = conexion.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Usuario usuario = new Usuario();
                    usuario.setId(rs.getString("SUS_ID"));
                    usuario.setAccess(rs.getString("SUS_ACCESS"));
                    usuario.setStatus(rs.getString("SUS_STATUS"));
                    usuarios.add(usuario);
                }
            }
            request.setAttribute("usuarios", usuarios);
        } catch (SQLException ex) {
            System.out.println("Error al cargar usuarios: " + ex.getMessage());
            request.setAttribute("errorMessage", "Error al cargar usuarios: " + ex.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cargarUsuarios(request);
        request.getRequestDispatcher("directorioAdministrador.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        System.out.println("Acción recibida: " + action);

        try (Connection conexion = new ConexionGeneral().getConnection()) {
            conexion.setAutoCommit(false); // Manejo de transacciones

            switch (action) {
                case "alta":
                    altaUsuario(request, conexion);
                    break;

                case "editar":
                    editarUsuario(request, conexion);
                    break;

                case "eliminar":
                    eliminarUsuario(request, conexion);
                    break;

                default:
                    request.setAttribute("errorMessage", "Acción no válida.");
            }

            conexion.commit(); 
        } catch (SQLException ex) {
            System.out.println("Error SQL en POST: " + ex.getMessage());
            ex.printStackTrace();
            request.setAttribute("errorMessage", "Error en la operación: " + ex.getMessage());
        }

        doGet(request, response); 
    }

    private void altaUsuario(HttpServletRequest request, Connection conexion) throws SQLException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        String sqlInsert = "INSERT INTO K_REP_SIGNEDUSERS (SUS_ID, SUS_ACCESS, SUS_CODE, SUS_STATUS) VALUES (?, ?, ?, 'aS')";
        try (PreparedStatement ps = conexion.prepareStatement(sqlInsert)) {
            ps.setString(1, generarIdUnico());
            ps.setString(2, username);
            ps.setBytes(3, ajustarCodigo(password));
            ps.executeUpdate();
            System.out.println("Usuario insertado: " + username);
            request.setAttribute("mensaje", "Usuario agregado con éxito.");
        }
    }

    private void editarUsuario(HttpServletRequest request, Connection conexion) throws SQLException {
        String id = request.getParameter("id");
        String username = request.getParameter("username");

        System.out.println("Editando usuario con ID: " + id + " y nuevo nombre: " + username);

        String sqlUpdate = "UPDATE K_REP_SIGNEDUSERS SET SUS_ACCESS = ? WHERE SUS_ID = ?";
        try (PreparedStatement ps = conexion.prepareStatement(sqlUpdate)) {
            ps.setString(1, username);
            ps.setString(2, id);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Usuario actualizado correctamente.");
                request.setAttribute("mensaje", "Usuario actualizado con éxito.");
            } else {
                System.out.println("No se encontró el usuario para actualizar.");
                request.setAttribute("mensaje", "No se encontró el usuario para actualizar.");
            }
        }
    }

    private void eliminarUsuario(HttpServletRequest request, Connection conexion) throws SQLException {
        String id = request.getParameter("id");

        String sqlDelete = "DELETE FROM K_REP_SIGNEDUSERS WHERE SUS_ID = ?";
        try (PreparedStatement ps = conexion.prepareStatement(sqlDelete)) {
            ps.setString(1, id);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Usuario eliminado: " + id);
                request.setAttribute("mensaje", "Usuario eliminado con éxito.");
            } else {
                System.out.println("No se encontró el usuario para eliminar.");
                request.setAttribute("mensaje", "No se encontró el usuario para eliminar.");
            }
        }
    }

    private String generarIdUnico() {
        return UUID.randomUUID().toString(); 
    }

    private byte[] ajustarCodigo(String password) {
        byte[] bytes = password.getBytes(StandardCharsets.UTF_8);
        byte[] result = new byte[20];
        System.arraycopy(bytes, 0, result, 0, Math.min(bytes.length, 20));
        return result;
    }
}
