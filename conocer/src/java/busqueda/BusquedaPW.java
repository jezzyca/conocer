/*package busqueda;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import conexion.ConexionGeneral;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BusquedaPW", urlPatterns = {"/BusquedaPW"})
public class BusquedaPW extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response) 
        throws ServletException, IOException {
    request.setCharacterEncoding("UTF-8");
    String formType = request.getParameter("formType");
    String formActivo = request.getParameter("formActivo"); // Recibir el formulario activo

    System.out.println("Tipo de formulario recibido: " + formType); 
    System.out.println("Formulario activo recibido: " + formActivo);

    String action = request.getParameter("action");

    // Si la acción es limpiar, limpiamos la sesión
    if ("limpiar".equals(action)) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("resultados");
            session.removeAttribute("mensaje");
            session.removeAttribute("error");
        }
        response.setStatus(HttpServletResponse.SC_OK);
        return;
    }

    try (Connection conn = ConexionGeneral.getConexion()) {
        List<Map<String, String>> resultados = new ArrayList<>();

        System.out.println("Conexión establecida correctamente");

        switch(formType) {
            case "accEvaluador":
                System.out.println("Iniciando búsqueda de evaluador");
                resultados = buscarAccEvaluador(conn, request);
                break;
            case "solCertificado":
                System.out.println("Iniciando búsqueda de certificado"); 
                resultados = buscarSolCertificado(conn, request);
                break;
            case "accCentros":
                System.out.println("Iniciando búsqueda de centros"); 
                resultados = buscarAccCentros(conn, request);
                break;
            default:
                throw new ServletException("Tipo de formulario no válido");
        }

        System.out.println("Resultados obtenidos: " + resultados.size()); 

        if (resultados.isEmpty()) {
            request.setAttribute("mensaje", "No se encontraron resultados para la búsqueda.");
        } else {
            request.setAttribute("resultados", resultados);
        }

        // Devolver el formulario activo al cliente
        request.setAttribute("formActivoGuardado", formActivo);

        request.getRequestDispatcher("busqueda.jsp").forward(request, response);

    } catch (SQLException e) {
        e.printStackTrace();
        System.out.println("Error SQL: " + e.getMessage()); 
        request.setAttribute("error", "Error en la base de datos: " + e.getMessage());
        request.getRequestDispatcher("busqueda.jsp").forward(request, response);
    }
}

    private List<Map<String, String>> buscarAccEvaluador(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL spBusquedaUsuarioSII(?,?,?,?,?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "razonsocial"));
            stmt.setString(2, getParameterSafe(request, "rfc"));
            stmt.setString(3, getParameterSafe(request, "siglas"));
            stmt.setString(4, getParameterSafe(request, "acreditacion"));
            stmt.setString(5, getParameterSafe(request, "nombre"));
            stmt.setString(6, getParameterSafe(request, "paterno"));
            stmt.setString(7, getParameterSafe(request, "materno"));
            stmt.setString(8, getParameterSafe(request, "curp"));

            try (ResultSet rs = stmt.executeQuery()) {
        while (rs.next()) {
            Map<String, String> fila = new LinkedHashMap<>();
            fila.put("Razón social", rs.getString("Razón Social")); 
            fila.put("Siglas", rs.getString("Siglas"));
            fila.put("Acreditacion EC/OC", rs.getString("Acreditacion EC/OC"));
            fila.put("Nombre Completo", rs.getString("Nombre Completo"));
            fila.put("CURP", rs.getString("CURP"));
            fila.put("Usuario", rs.getString("Usuario"));
            fila.put("Contraseña", rs.getString("Contraseña"));
            fila.put("Comentarios", rs.getString("Comentarios <BR>*Si no tiene indica que no se ha usado la cuenta"));
            fila.put("Correo Electronico", rs.getString("Correo Electronico"));
            fila.put("Estado del Usuario", rs.getString("Estado del Usuario"));
            fila.put("Perfil en el SII", rs.getString("Perfil en el SII"));
            resultados.add(fila);
        }
            }
        }
        return resultados;
    }

    private List<Map<String, String>> buscarSolCertificado(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL SP_SOLICITUD_CERT(?,?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "DS_CURP"));
            stmt.setString(2, getParameterSafe(request, "ESTANDAR_COMP"));
            stmt.setString(3, getParameterSafe(request, "NOMBRE"));
            stmt.setString(4, getParameterSafe(request, "APELLIDO_P"));
            stmt.setString(5, getParameterSafe(request, "APELLIDO_M"));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fila = new LinkedHashMap<>();
                    fila.put("Candidato", rs.getString("Candidato"));
                    fila.put("CURP", rs.getString("CURP"));
                    fila.put("Estándar Competencia", rs.getString("Estándar Competencia"));
                    fila.put("Est. Evaluación", rs.getString("Est. Evaluación"));
                    fila.put("Est. Certificado", rs.getString("Est. Certificado"));
                    fila.put("Lote Dictamen", rs.getString("Lote Dictamen"));
                    fila.put("Est. Lote Dictamen", rs.getString("Est. Lote Dictamen"));
                    fila.put("Folio Sol. Cert.", rs.getString("Folio Sol. Cert."));
                    fila.put("Est. Sol. Certificado", rs.getString("Est. Sol. Certificado"));
                    fila.put("Migrado", rs.getString("Migrado"));
                    resultados.add(fila);
                }
            }
        }
        return resultados;
    }

    private List<Map<String, String>> buscarAccCentros(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL spBuscaUsuarioCESII(?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "razonsocial"));
            stmt.setString(2, getParameterSafe(request, "rfc"));
            stmt.setString(3, getParameterSafe(request, "siglas"));
            stmt.setString(4, getParameterSafe(request, "cedula"));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fila = new LinkedHashMap<>();
                    fila.put("Cedula Centro", rs.getString("Cedula Centro"));
                    fila.put("Razon Social Centro", rs.getString("Razon Social Centro"));
                    fila.put("Usuario", rs.getString("Usuario"));
                    fila.put("Contraseña", rs.getString("Contraseña"));
                    fila.put("E-mail Notificaiones", rs.getString("E-mail Notificaiones"));
                    fila.put("Requiere cambio de Contraseña", rs.getString("Requiere cambio de Contraseña"));
                    fila.put("Fecha Ultima Modificacion", rs.getString("Fecha Ultima Modificacion"));
                    resultados.add(fila);
                }
            }
        }
        return resultados;
    }

    private String getParameterSafe(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value != null ? value.trim() : "";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("busqueda.jsp");
    }
}*/

package busqueda;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import conexion.ConexionGeneral;
import javax.servlet.http.HttpSession;

@WebServlet(name = "BusquedaPW", urlPatterns = {"/BusquedaPW"})
public class BusquedaPW extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String formType = request.getParameter("formType");
        String formActivo = request.getParameter("formActivo");
        HttpSession session = request.getSession();

        System.out.println("Tipo de formulario recibido: " + formType); 
        System.out.println("Formulario activo recibido: " + formActivo);

        session.setAttribute("formActivo", formActivo);

        try (Connection conn = ConexionGeneral.getConexion()) {
            List<Map<String, String>> resultados = new ArrayList<>();

            System.out.println("Conexión establecida correctamente");

            switch(formType) {
                case "accEvaluador":
                    System.out.println("Iniciando búsqueda de evaluador");
                    resultados = buscarAccEvaluador(conn, request);
                    break;
                case "solCertificado":
                    System.out.println("Iniciando búsqueda de certificado"); 
                    resultados = buscarSolCertificado(conn, request);
                    break;
                case "accCentros":
                    System.out.println("Iniciando búsqueda de centros"); 
                    resultados = buscarAccCentros(conn, request);
                    break;
                default:
                    throw new ServletException("Tipo de formulario no válido");
            }

            System.out.println("Resultados obtenidos: " + resultados.size()); 

            if (resultados.isEmpty()) {
                session.setAttribute("mensaje", "No se encontraron resultados para la búsqueda.");
            } else {
                session.setAttribute("resultados", resultados);
            }

            session.setAttribute("formActivo", formActivo);
            response.sendRedirect("busqueda.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error SQL: " + e.getMessage()); 
            session.setAttribute("error", "Error en la base de datos: " + e.getMessage());
            response.sendRedirect("busqueda.jsp");
        }
    }

    private List<Map<String, String>> buscarAccEvaluador(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL spBusquedaUsuarioSII(?,?,?,?,?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "razonsocial"));
            stmt.setString(2, getParameterSafe(request, "rfc"));
            stmt.setString(3, getParameterSafe(request, "siglas"));
            stmt.setString(4, getParameterSafe(request, "acreditacion"));
            stmt.setString(5, getParameterSafe(request, "nombre"));
            stmt.setString(6, getParameterSafe(request, "paterno"));
            stmt.setString(7, getParameterSafe(request, "materno"));
            stmt.setString(8, getParameterSafe(request, "curp"));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fila = new LinkedHashMap<>();
                    fila.put("Razón social", rs.getString("Razón Social")); 
                    fila.put("Siglas", rs.getString("Siglas"));
                    fila.put("Acreditacion EC/OC", rs.getString("Acreditacion EC/OC"));
                    fila.put("Nombre Completo", rs.getString("Nombre Completo"));
                    fila.put("CURP", rs.getString("CURP"));
                    fila.put("Usuario", rs.getString("Usuario"));
                    fila.put("Contraseña", rs.getString("Contraseña"));
                    fila.put("Comentarios", rs.getString("Comentarios <BR>*Si no tiene indica que no se ha usado la cuenta"));
                    fila.put("Correo Electronico", rs.getString("Correo Electronico"));
                    fila.put("Estado del Usuario", rs.getString("Estado del Usuario"));
                    fila.put("Perfil en el SII", rs.getString("Perfil en el SII"));
                    resultados.add(fila);
                }
            }
        }
        return resultados;
    }

    private List<Map<String, String>> buscarSolCertificado(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL SP_SOLICITUD_CERT(?,?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "DS_CURP"));
            stmt.setString(2, getParameterSafe(request, "ESTANDAR_COMP"));
            stmt.setString(3, getParameterSafe(request, "NOMBRE"));
            stmt.setString(4, getParameterSafe(request, "APELLIDO_P"));
            stmt.setString(5, getParameterSafe(request, "APELLIDO_M"));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fila = new LinkedHashMap<>();
                    fila.put("Candidato", rs.getString("Candidato"));
                    fila.put("CURP", rs.getString("CURP"));
                    fila.put("Estándar Competencia", rs.getString("Estándar Competencia"));
                    fila.put("Est. Evaluación", rs.getString("Est. Evaluación"));
                    fila.put("Est. Certificado", rs.getString("Est. Certificado"));
                    fila.put("Lote Dictamen", rs.getString("Lote Dictamen"));
                    fila.put("Est. Lote Dictamen", rs.getString("Est. Lote Dictamen"));
                    fila.put("Folio Sol. Cert.", rs.getString("Folio Sol. Cert."));
                    fila.put("Est. Sol. Certificado", rs.getString("Est. Sol. Certificado"));
                    fila.put("Migrado", rs.getString("Migrado"));
                    resultados.add(fila);
                }
            }
        }
        return resultados;
    }

    private List<Map<String, String>> buscarAccCentros(Connection conn, HttpServletRequest request) throws SQLException {
        List<Map<String, String>> resultados = new ArrayList<>();
        
        try (CallableStatement stmt = conn.prepareCall("{CALL spBuscaUsuarioCESII(?,?,?,?)}")) {
            stmt.setString(1, getParameterSafe(request, "razonsocial"));
            stmt.setString(2, getParameterSafe(request, "rfc"));
            stmt.setString(3, getParameterSafe(request, "siglas"));
            stmt.setString(4, getParameterSafe(request, "cedula"));

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, String> fila = new LinkedHashMap<>();
                    fila.put("Cedula Centro", rs.getString("Cedula Centro"));
                    fila.put("Razon Social Centro", rs.getString("Razon Social Centro"));
                    fila.put("Usuario", rs.getString("Usuario"));
                    fila.put("Contraseña", rs.getString("Contraseña"));
                    fila.put("E-mail Notificaiones", rs.getString("E-mail Notificaiones"));
                    fila.put("Requiere cambio de Contraseña", rs.getString("Requiere cambio de Contraseña"));
                    fila.put("Fecha Ultima Modificacion", rs.getString("Fecha Ultima Modificacion"));
                    resultados.add(fila);
                }
            }
        }
        return resultados;
    }

    private String getParameterSafe(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return value != null ? value.trim() : "";
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("busqueda.jsp");
    }
}