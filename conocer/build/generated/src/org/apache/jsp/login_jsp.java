package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class login_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"utf-8\">\n");
      out.write("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n");
      out.write("    <title>Acceso</title>\n");
      out.write("    <link rel=\"icon\" type=\"image/png\" sizes=\"96x96\" href=\"img/favicon-96x96.png\">\n");
      out.write("    <link href=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("    <link rel=\"stylesheet\" type=\"text/css\" href=\"styles/estilos_reporteador.css\">\n");
      out.write("</head>\n");
      out.write("<body id=\"fondoBody\">\n");
      out.write("\n");
      out.write("<!-- Contenedor principal para centrar el login -->\n");
      out.write("<div class=\"container d-flex justify-content-center align-items-center vh-100\">\n");
      out.write("    <div class=\"card shadow-sm p-4\" style=\"width: 400px;\">\n");
      out.write("        <div class=\"card-header text-center\">\n");
      out.write("            <h2>REPORTES SII</h2>\n");
      out.write("            <img src=\"img/logo_cono2.png\" class=\"img-fluid\" alt=\"Logo\" style=\"max-width: 300px; margin: auto;\">\n");
      out.write("        </div>\n");
      out.write("        <div class=\"card-body\">\n");
      out.write("            <!-- Formulario de inicio de sesión -->\n");
      out.write("            <form id=\"loginForm\" method=\"post\" action=\"ValidarUsuarios\">\n");
      out.write("                <div class=\"mb-3\">\n");
      out.write("                    <label for=\"usuario\" class=\"form-label\">Usuario</label>\n");
      out.write("                    <input type=\"text\" class=\"form-control\" id=\"usuario\" name=\"usuario\" required>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"mb-3\">\n");
      out.write("                    <label for=\"contrasena\" class=\"form-label\">Contraseña</label>\n");
      out.write("                    <input type=\"password\" class=\"form-control\" id=\"contrasena\" name=\"contrasena\" required>\n");
      out.write("                </div>\n");
      out.write("                <div class=\"d-grid text-center\">\n");
      out.write("                    <button type=\"submit\" class=\"btn btn-primary\">Iniciar Sesión</button>\n");
      out.write("                </div>\n");
      out.write("            </form>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("</div>\n");
      out.write("\n");

    String error = (String) session.getAttribute("error");
    if (error != null) { 

      out.write("\n");
      out.write("<div class=\"modal fade\" id=\"errorModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"errorModalLabel\" aria-hidden=\"true\">\n");
      out.write("  <div class=\"modal-dialog\" role=\"document\">\n");
      out.write("    <div class=\"modal-content\">\n");
      out.write("      <div class=\"modal-header\">\n");
      out.write("        <h5 class=\"modal-title\" id=\"errorModalLabel\">Error</h5>\n");
      out.write("        <button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-label=\"Cerrar\">\n");
      out.write("          <span aria-hidden=\"true\">&times;</span>\n");
      out.write("        </button>\n");
      out.write("      </div>\n");
      out.write("      <div class=\"modal-body\">\n");
      out.write("        ");
      out.print( error );
      out.write("\n");
      out.write("      </div>\n");
      out.write("      <div class=\"modal-footer\">\n");
      out.write("        <button type=\"button\" class=\"btn btn-secondary\" data-dismiss=\"modal\">Cerrar</button>\n");
      out.write("      </div>\n");
      out.write("    </div>\n");
      out.write("  </div>\n");
      out.write("</div>\n");

        session.removeAttribute("error");
    }

      out.write("\n");
      out.write("<script>\n");
      out.write("    $(document).ready(function () {\n");
      out.write("        ");
 if (error != null) { 
      out.write("\n");
      out.write("            $('#errorModal').modal('show');\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("    });\n");
      out.write("</script>\n");
      out.write("<!-- Scripts de Bootstrap -->\n");
      out.write("<script src=\"https://code.jquery.com/jquery-3.5.1.slim.min.js\"></script>\n");
      out.write("<script src=\"https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js\"></script>\n");
      out.write("<script src=\"https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js\"></script>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("    $(document).ready(function () {\n");
      out.write("        ");
 if (error != null) { 
      out.write("\n");
      out.write("            $('#errorModal').modal('show');\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("    });\n");
      out.write("</script>\n");
      out.write("    \n");
      out.write("</body>\n");
      out.write("<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css\" integrity=\"sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==\" crossorigin=\"anonymous\" referrerpolicy=\"no-referrer\" />\n");
      out.write("</html>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
