package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.*;
import org.json.JSONObject;
import org.json.JSONArray;
import reportes.ReportesSII;
import java.util.List;
import java.util.Map;

public final class reportesSII_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.apache.jasper.runtime.TagHandlerPool _jspx_tagPool_c_redirect_url_nobody;
  private org.apache.jasper.runtime.TagHandlerPool _jspx_tagPool_c_out_value_nobody;
  private org.apache.jasper.runtime.TagHandlerPool _jspx_tagPool_c_if_test;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _jspx_tagPool_c_redirect_url_nobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _jspx_tagPool_c_out_value_nobody = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
    _jspx_tagPool_c_if_test = org.apache.jasper.runtime.TagHandlerPool.getTagHandlerPool(getServletConfig());
  }

  public void _jspDestroy() {
    _jspx_tagPool_c_redirect_url_nobody.release();
    _jspx_tagPool_c_out_value_nobody.release();
    _jspx_tagPool_c_if_test.release();
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
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!-- Validación de sesión -->\n");
      if (_jspx_meth_c_if_0(_jspx_page_context))
        return;
      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"es\">\n");
      out.write("<head>\n");
      out.write("    <meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("    <title>ReportesSII</title>\n");
      out.write("\n");
      out.write("    <!-- Favicon -->\n");
      out.write("    <link rel=\"icon\" type=\"image/png\" sizes=\"96x96\" href=\"img/favicon-96x96.png\">\n");
      out.write("\n");
      out.write("    <!-- CSS Libraries -->\n");
      out.write("    <link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css\" rel=\"stylesheet\">\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css\">\n");
      out.write("\n");
      out.write("    <!-- Custom CSS -->\n");
      out.write("    <link rel=\"stylesheet\" type=\"text/css\" href=\"styles/estilos_reporteador.css\">\n");
      out.write("</head>\n");
      out.write("<body id=\"fondoBodyReportes2\">\n");
      out.write("    <br>\n");
      out.write("    <div class=\"container-fluid\">\n");
      out.write("        <div class=\"row align-items-center\">\n");
      out.write("            <!-- Logo de la marca -->\n");
      out.write("            <div class=\"col-3 d-flex justify-content-start align-items-center\">\n");
      out.write("                <a href=\"informesMensuales.jsp\" class=\"brand-logo\">\n");
      out.write("                    <img src=\"img/Logo-Conocer.png\" class=\"responsive-img\" alt=\"Logo Conocer\">\n");
      out.write("                </a>\n");
      out.write("            </div>\n");
      out.write("            <!-- Sección de Selección de Reporte -->\n");
      out.write("            <div class=\"col-6 d-flex justify-content-center align-items-center\">\n");
      out.write("                <label for=\"seleccion\" class=\"colorLabel me-2\">Selecciona el tipo de reporte:</label>\n");
      out.write("                <select name=\"procedimientos\" id=\"seleccion\" class=\"form-select w-50\">\n");
      out.write("                    <option selected disabled>Selecciona:</option>\n");
      out.write("                    <!-- Opciones de reportes -->\n");
      out.write("                    <option value=\"1\">Acreditación y renovación</option>\n");
      out.write("                    <option value=\"2\">Certificados de Marca con Totales</option>\n");
      out.write("                    <!-- Añade aquí las demás opciones -->\n");
      out.write("                </select>\n");
      out.write("                <button id=\"descargarSp\" type=\"button\" class=\"btn btn-outline-danger ms-2\">Descargar Información</button>\n");
      out.write("            </div>\n");
      out.write("            <!-- Información del usuario -->\n");
      out.write("            <div class=\"col-2 d-flex justify-content-end align-items-center ms-auto\">\n");
      out.write("                <img src=\"img/userpersona.png\" alt=\"Imagen usuario\" class=\"rounded-circle me-2\" width=\"55\">\n");
      out.write("                <div class=\"media-body\">\n");
      out.write("                    <h6 class=\"mb-0 usuario-nombre small\">\n");
      out.write("                        Usuario: ");
      if (_jspx_meth_c_out_0(_jspx_page_context))
        return;
      out.write("\n");
      out.write("                    </h6>\n");
      out.write("                    <small class=\"text-muted usuario-fecha\">\n");
      out.write("                        Fecha: ");
      if (_jspx_meth_c_out_1(_jspx_page_context))
        return;
      out.write("\n");
      out.write("                    </small>\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <!-- Contenedor de Búsqueda Rápida -->\n");
      out.write("        <div id=\"quickSearchContainer\" class=\"row align-items-center justify-content-center mt-3\" style=\"display:none;\">\n");
      out.write("            <div class=\"col-md-3 col-12\">\n");
      out.write("                <input type=\"text\" id=\"quickSearchInput\" class=\"form-control\" placeholder=\"Buscar en la tabla...\">\n");
      out.write("            </div>\n");
      out.write("            <div class=\"col-md-3 col-12\">\n");
      out.write("                <select id=\"searchColumnSelect\" class=\"form-select\">\n");
      out.write("                    <option value=\"\">Buscar en todas las columnas</option>\n");
      out.write("                </select>\n");
      out.write("            </div>\n");
      out.write("            <div class=\"col-sm-1\">\n");
      out.write("                <div class=\"form-check\">\n");
      out.write("                    <input class=\"form-check-input\" type=\"checkbox\" id=\"exactMatchCheckbox\">\n");
      out.write("                    <label class=\"form-check-label\" for=\"exactMatchCheckbox\">\n");
      out.write("                        Búsqueda exacta\n");
      out.write("                    </label>\n");
      out.write("                </div>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <!-- Contenedor de Tabla -->\n");
      out.write("        <div class=\"table-responsive mt-3\">\n");
      out.write("            <table class=\"table table-striped table-bordered table-hover\">\n");
      out.write("                <thead class=\"table-dark sticky-top\" id=\"tableHead\">\n");
      out.write("                    <!-- Encabezados se generarán dinámicamente -->\n");
      out.write("                </thead>\n");
      out.write("                <tbody id=\"tableBody\">\n");
      out.write("                    <tr>\n");
      out.write("                        <td colspan=\"10\" class=\"text-center\">\n");
      out.write("                            Selecciona un reporte para ver los datos.\n");
      out.write("                        </td>\n");
      out.write("                    </tr>\n");
      out.write("                </tbody>\n");
      out.write("            </table>\n");
      out.write("        </div>\n");
      out.write("\n");
      out.write("        <!-- Paginación -->\n");
      out.write("        <div id=\"pagination\" class=\"d-flex justify-content-center mt-3\">\n");
      out.write("            <!-- Botones de paginación se agregarán aquí -->\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <!-- Footer -->\n");
      out.write("    <footer class=\"container-fluid mt-auto py-3 bg-light\">\n");
      out.write("        <div class=\"row align-items-center g-3\">\n");
      out.write("            <div class=\"col-12 col-md-3 text-center text-md-start\">\n");
      out.write("                <img src=\"img/sep.png\" alt=\"Logo SEP\" class=\"img-fluid\" style=\"max-height: 60px;\">\n");
      out.write("            </div>\n");
      out.write("            <div class=\"col-12 col-md-6 text-center\">\n");
      out.write("                <p class=\"small mb-1\">•2025•©CONSEJO NACIONAL DE NORMALIZACIÓN Y CERTIFICACIÓN DE COMPETENCIAS LABORALES. MÉXICO•</p>\n");
      out.write("                <p class=\"small mb-1\">•Barranca del Muerto 275, San José Insurgentes, Benito Juárez, 03900 Ciudad de México, D.F. 01 55 2282 0200</p>\n");
      out.write("                <a href=\"#\" target=\"_blank\" class=\"small text-decoration-none\">• CONOCER •</a>\n");
      out.write("            </div>\n");
      out.write("            <div class=\"col-12 col-md-3 text-center text-md-end\">\n");
      out.write("                <img src=\"img/conocerLogo.png\" alt=\"Logo CONOCER\" class=\"img-fluid\" style=\"max-height: 60px;\">\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("    </footer>\n");
      out.write("\n");
      out.write("    <!-- JavaScript Libraries -->\n");
      out.write("    <script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js\"></script>\n");
      out.write("    <script src=\"https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js\"></script>\n");
      out.write("\n");
      out.write("    <script>\n");
      out.write("// Variables globales\n");
      out.write("let globalTableData = [];\n");
      out.write("let currentSelectedReport = null;\n");
      out.write("\n");
      out.write("// Evento de cambio de reporte\n");
      out.write("document.getElementById('seleccion').addEventListener('change', function() {\n");
      out.write("    const selectedValue = this.value;\n");
      out.write("    currentSelectedReport = selectedValue;\n");
      out.write("    cargarDatos(selectedValue, 1, 30);\n");
      out.write("});\n");
      out.write("\n");
      out.write("function cargarDatos(selectedValue, pagina, registrosPorPagina) {\n");
      out.write("    if (!selectedValue || selectedValue === 'Selecciona:') {\n");
      out.write("        alert('Por favor, selecciona un tipo de reporte');\n");
      out.write("        return;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    const tableHead = document.getElementById('tableHead');\n");
      out.write("    const tableBody = document.getElementById('tableBody');\n");
      out.write("    const paginationDiv = document.getElementById('pagination');\n");
      out.write("    const quickSearchContainer = document.getElementById('quickSearchContainer');\n");
      out.write("    const searchColumnSelect = document.getElementById('searchColumnSelect');\n");
      out.write("\n");
      out.write("    tableHead.innerHTML = '<tr><th class=\"text-center\">Cargando datos...</th></tr>';\n");
      out.write("    tableBody.innerHTML = '<tr><td class=\"text-center\"><div class=\"spinner-border text-primary\" role=\"status\"><span class=\"visually-hidden\">Cargando...</span></div></td></tr>';\n");
      out.write("    paginationDiv.innerHTML = '';\n");
      out.write("    quickSearchContainer.style.display = 'none';\n");
      out.write("    searchColumnSelect.innerHTML = '<option value=\"\">Buscar en todas las columnas</option>';\n");
      out.write("\n");
      out.write("    const params = new URLSearchParams({\n");
      out.write("        procedimientos: selectedValue,\n");
      out.write("        page: pagina,\n");
      out.write("        pageSize: registrosPorPagina\n");
      out.write("    });\n");
      out.write("\n");
      out.write("    fetch('ReportesSII?' + params.toString(), {\n");
      out.write("        method: 'GET',\n");
      out.write("        headers: { 'Accept': 'application/json' },\n");
      out.write("        credentials: 'same-origin'\n");
      out.write("    })\n");
      out.write("    .then(async response => {\n");
      out.write("        const contentType = response.headers.get('content-type');\n");
      out.write("        if (!contentType || !contentType.includes('application/json')) {\n");
      out.write("            throw new Error('La respuesta del servidor no es JSON válido');\n");
      out.write("        }\n");
      out.write("        if (!response.ok) {\n");
      out.write("            const errorData = await response.json();\n");
      out.write("            throw new Error(errorData.error || `Error del servidor: ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${response.status}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write("`);\n");
      out.write("        }\n");
      out.write("        return response.json();\n");
      out.write("    })\n");
      out.write("    .then(data => {\n");
      out.write("        tableHead.innerHTML = '';\n");
      out.write("        tableBody.innerHTML = '';\n");
      out.write("        paginationDiv.innerHTML = '';\n");
      out.write("\n");
      out.write("        if (!data || !data.success || !data.data || !data.data[selectedValue]) {\n");
      out.write("            throw new Error('No se encontraron datos para el reporte seleccionado');\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        globalTableData = data.data[selectedValue];\n");
      out.write("\n");
      out.write("        if (globalTableData.length === 0) {\n");
      out.write("            tableBody.innerHTML = '<tr><td colspan=\"10\" class=\"text-center\">No hay datos disponibles para este reporte</td></tr>';\n");
      out.write("            return;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        const firstRow = globalTableData[0];\n");
      out.write("        const headerRow = document.createElement('tr');\n");
      out.write("\n");
      out.write("        Object.keys(firstRow).forEach(key => {\n");
      out.write("            const th = document.createElement('th');\n");
      out.write("            th.textContent = key;\n");
      out.write("            th.className = 'text-nowrap';\n");
      out.write("            headerRow.appendChild(th);\n");
      out.write("\n");
      out.write("            const option = document.createElement('option');\n");
      out.write("            option.value = key;\n");
      out.write("            option.textContent = key;\n");
      out.write("            searchColumnSelect.appendChild(option);\n");
      out.write("        });\n");
      out.write("\n");
      out.write("        tableHead.appendChild(headerRow);\n");
      out.write("        renderTableRows(globalTableData);\n");
      out.write("        quickSearchContainer.style.display = 'flex';\n");
      out.write("\n");
      out.write("        if (data.totalPages && data.totalPages > 1) {\n");
      out.write("            generarPaginacion(data.totalPages, pagina, selectedValue, registrosPorPagina);\n");
      out.write("        }\n");
      out.write("    })\n");
      out.write("    .catch(error => {\n");
      out.write("        console.error('Error al cargar datos:', error);\n");
      out.write("\n");
      out.write("        tableHead.innerHTML = '';\n");
      out.write("        tableBody.innerHTML = `\n");
      out.write("            <tr>\n");
      out.write("                <td colspan=\"10\" class=\"text-center text-danger\">\n");
      out.write("                    <div class=\"alert alert-danger\" role=\"alert\">\n");
      out.write("                        <h5 class=\"alert-heading\">Error al cargar los datos</h5>\n");
      out.write("                        <p>");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${error.message || 'Ocurrió un error inesperado. Por favor, intente nuevamente.'}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write("</p>\n");
      out.write("                        <hr>\n");
      out.write("                        <p class=\"mb-0\">Si el problema persiste, contacte al administrador del sistema.</p>\n");
      out.write("                    </div>\n");
      out.write("                </td>\n");
      out.write("            </tr>\n");
      out.write("        `;\n");
      out.write("\n");
      out.write("        quickSearchContainer.style.display = 'none';\n");
      out.write("        paginationDiv.innerHTML = '';\n");
      out.write("    });\n");
      out.write("}\n");
      out.write("\n");
      out.write("function renderTableRows(data) {\n");
      out.write("    const tableBody = document.getElementById('tableBody');\n");
      out.write("    tableBody.innerHTML = '';\n");
      out.write("\n");
      out.write("    data.forEach(row => {\n");
      out.write("        const tr = document.createElement('tr');\n");
      out.write("        Object.values(row).forEach(value => {\n");
      out.write("            const td = document.createElement('td');\n");
      out.write("            td.textContent = value !== null ? value.toString() : '';\n");
      out.write("            tr.appendChild(td);\n");
      out.write("        });\n");
      out.write("        tableBody.appendChild(tr);\n");
      out.write("    });\n");
      out.write("}\n");
      out.write("\n");
      out.write("document.getElementById('quickSearchInput').addEventListener('input', function() {\n");
      out.write("    const searchTerm = this.value.trim();\n");
      out.write("    const searchColumn = document.getElementById('searchColumnSelect').value;\n");
      out.write("    const exactMatch = document.getElementById('exactMatchCheckbox').checked;\n");
      out.write("\n");
      out.write("    if (!searchTerm) {\n");
      out.write("        renderTableRows(globalTableData);\n");
      out.write("        return;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    const filteredData = globalTableData.filter(row => {\n");
      out.write("        if (searchColumn) {\n");
      out.write("            const columnValue = row[searchColumn] !== null ? row[searchColumn].toString() : '';\n");
      out.write("            return exactMatch ? columnValue === searchTerm : columnValue.toLowerCase().includes(searchTerm.toLowerCase());\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        return Object.values(row).some(value => value !== null && (exactMatch ? value.toString() === searchTerm : value.toString().toLowerCase().includes(searchTerm.toLowerCase())));\n");
      out.write("    });\n");
      out.write("\n");
      out.write("    renderTableRows(filteredData);\n");
      out.write("});\n");
      out.write("\n");
      out.write("function generarPaginacion(totalPages, currentPage, selectedValue, registrosPorPagina) {\n");
      out.write("    const paginationDiv = document.getElementById('pagination');\n");
      out.write("    paginationDiv.innerHTML = '';\n");
      out.write("\n");
      out.write("    if (currentPage > 1) {\n");
      out.write("        const prevButton = crearBotonPaginacion('Anterior', () => {\n");
      out.write("            cargarDatos(selectedValue, currentPage - 1, registrosPorPagina);\n");
      out.write("        });\n");
      out.write("        paginationDiv.appendChild(prevButton);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    const startPage = Math.max(1, currentPage - 2);\n");
      out.write("    const endPage = Math.min(totalPages, currentPage + 2);\n");
      out.write("\n");
      out.write("    if (startPage > 1) {\n");
      out.write("        const firstPageButton = crearBotonPaginacion('1', () => {\n");
      out.write("            cargarDatos(selectedValue, 1, registrosPorPagina);\n");
      out.write("        });\n");
      out.write("        paginationDiv.appendChild(firstPageButton);\n");
      out.write("\n");
      out.write("        if (startPage > 2) {\n");
      out.write("            const ellipsis = document.createElement('span');\n");
      out.write("            ellipsis.textContent = '...';\n");
      out.write("            paginationDiv.appendChild(ellipsis);\n");
      out.write("        }\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    for (let i = startPage; i <= endPage; i++) {\n");
      out.write("        const pageButton = crearBotonPaginacion(i.toString(), () => {\n");
      out.write("            cargarDatos(selectedValue, i, registrosPorPagina);\n");
      out.write("        }, i === currentPage);\n");
      out.write("\n");
      out.write("        paginationDiv.appendChild(pageButton);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    if (endPage < totalPages) {\n");
      out.write("        if (endPage < totalPages - 1) {\n");
      out.write("            const ellipsis = document.createElement('span');\n");
      out.write("            ellipsis.textContent = '...';\n");
      out.write("            paginationDiv.appendChild(ellipsis);\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        const lastPageButton = crearBotonPaginacion(totalPages.toString(), () => {\n");
      out.write("            cargarDatos(selectedValue, totalPages, registrosPorPagina);\n");
      out.write("        });\n");
      out.write("\n");
      out.write("        paginationDiv.appendChild(lastPageButton);\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    if (currentPage < totalPages) {\n");
      out.write("        const nextButton = crearBotonPaginacion('Siguiente', () => {\n");
      out.write("            cargarDatos(selectedValue, currentPage + 1, registrosPorPagina);\n");
      out.write("        });\n");
      out.write("        paginationDiv.appendChild(nextButton);\n");
      out.write("    }\n");
      out.write("}\n");
      out.write("\n");
      out.write("function crearBotonPaginacion(texto, clickHandler, esActual = false) {\n");
      out.write("    const button = document.createElement('button');\n");
      out.write("    button.textContent = texto;\n");
      out.write("    button.classList.add('btn', 'btn-outline-secondary', 'mx-1');\n");
      out.write("\n");
      out.write("    if (esActual) {\n");
      out.write("        button.disabled = true;\n");
      out.write("        button.classList.add('active');\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    button.addEventListener('click', clickHandler);\n");
      out.write("    return button;\n");
      out.write("}\n");
      out.write("\n");
      out.write("\n");
      out.write("function descargarReporte() {\n");
      out.write("    const selectElement = document.getElementById('seleccion');\n");
      out.write("    const selectedValue = selectElement.value;\n");
      out.write("\n");
      out.write("    if (!selectedValue || selectedValue === 'Selecciona:') {\n");
      out.write("        alert('Por favor, seleccione un tipo de reporte antes de descargar');\n");
      out.write("        return;\n");
      out.write("    }\n");
      out.write("\n");
      out.write("    const botonDescargar = document.getElementById('descargarSp');\n");
      out.write("    botonDescargar.disabled = true;\n");
      out.write("    botonDescargar.innerHTML = '<span class=\"spinner-border spinner-border-sm\"></span> Descargando...';\n");
      out.write("\n");
      out.write("    const reportNames = {\n");
      out.write("        \"1\": \"Acreditaciones_y_Renovaciones\",\n");
      out.write("        \"2\": \"ReporteConSumaMarca\",\n");
      out.write("        \"3\": \"CertificadosMarca_X_Entidad_EC_OC\"\n");
      out.write("    };\n");
      out.write("\n");
      out.write("    const reportName = reportNames[selectedValue] || \"Reporte_Desconocido\";\n");
      out.write("    const fechaActual = new Date().toISOString().split('T')[0].replace(/-/g, '');\n");
      out.write("\n");
      out.write("    const params = new URLSearchParams();\n");
      out.write("    params.append('formato', 'excel');\n");
      out.write("    params.append('procedimientos', selectedValue);\n");
      out.write("    params.append('nombreReporte', reportName);\n");
      out.write("\n");
      out.write("    console.log('Iniciando descarga con parámetros:', Object.fromEntries(params));\n");
      out.write("\n");
      out.write("    fetch('ReportesSII?' + params.toString(), {\n");
      out.write("        method: 'GET',\n");
      out.write("        credentials: 'same-origin',\n");
      out.write("        headers: {\n");
      out.write("            'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',\n");
      out.write("            'Cache-Control': 'no-cache'\n");
      out.write("        }\n");
      out.write("    })\n");
      out.write("    .then(response => {\n");
      out.write("        console.log('Headers de respuesta:', Object.fromEntries(response.headers.entries()));\n");
      out.write("        console.log('Status:', response.status);\n");
      out.write("        \n");
      out.write("        if (!response.ok) {\n");
      out.write("            return response.text().then(text => {\n");
      out.write("                console.error('Error response:', text);\n");
      out.write("                throw new Error(text || `Error del servidor: ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${response.status}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write("`);\n");
      out.write("            });\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        const contentType = response.headers.get('content-type');\n");
      out.write("        console.log('Content-Type:', contentType);\n");
      out.write("        \n");
      out.write("        if (!contentType || !contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {\n");
      out.write("            console.error('Content-Type incorrecto:', contentType);\n");
      out.write("            return response.text().then(text => {\n");
      out.write("                console.log('Contenido de respuesta:', text);\n");
      out.write("                throw new Error('El servidor no devolvió un archivo Excel válido');\n");
      out.write("            });\n");
      out.write("        }\n");
      out.write("        \n");
      out.write("        return response.blob();\n");
      out.write("    })\n");
      out.write("    .then(blob => {\n");
      out.write("        console.log('Tamaño del blob:', blob.size, 'bytes');\n");
      out.write("        console.log('Tipo del blob:', blob.type);\n");
      out.write("\n");
      out.write("        if (blob.size === 0) {\n");
      out.write("            throw new Error('El archivo generado está vacío');\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        const fileName = `");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${reportName}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write('_');
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${fechaActual}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write(".xlsx`;\n");
      out.write("        \n");
      out.write("        // Para navegadores modernos\n");
      out.write("        if (window.navigator && window.navigator.msSaveOrOpenBlob) {\n");
      out.write("            window.navigator.msSaveOrOpenBlob(blob, fileName);\n");
      out.write("            return;\n");
      out.write("        }\n");
      out.write("\n");
      out.write("        const url = window.URL.createObjectURL(blob);\n");
      out.write("        const a = document.createElement('a');\n");
      out.write("        a.href = url;\n");
      out.write("        a.download = fileName;\n");
      out.write("        document.body.appendChild(a);\n");
      out.write("        a.click();\n");
      out.write("        \n");
      out.write("        setTimeout(() => {\n");
      out.write("            document.body.removeChild(a);\n");
      out.write("            window.URL.revokeObjectURL(url);\n");
      out.write("        }, 0);\n");
      out.write("    })\n");
      out.write("    .catch(error => {\n");
      out.write("        console.error('Error detallado:', error);\n");
      out.write("        alert(`Error al descargar el reporte: ");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${error.message}", java.lang.String.class, (PageContext)_jspx_page_context, null));
      out.write("\\nPor favor, revise la consola para más detalles.`);\n");
      out.write("    })\n");
      out.write("    .finally(() => {\n");
      out.write("        botonDescargar.disabled = false;\n");
      out.write("        botonDescargar.innerHTML = 'Descargar Información';\n");
      out.write("    });\n");
      out.write("}\n");
      out.write(" \n");
      out.write("// Event listener for download button click\n");
      out.write("document.getElementById('descargarSp').addEventListener('click', descargarReporte);\n");
      out.write("\n");
      out.write("// Opcional: Cargar datos iniciales si hay un valor preseleccionado\n");
      out.write("const initialSelectedValue = document.getElementById('seleccion').value;\n");
      out.write("if (initialSelectedValue && initialSelectedValue !== 'Selecciona:') {\n");
      out.write("    currentSelectedReport = initialSelectedValue;\n");
      out.write("    cargarDatos(initialSelectedValue, 1, 30);\n");
      out.write("}\n");
      out.write("\n");
      out.write("    </script>\n");
      out.write("</body>\n");
      out.write("</html>\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write(" \n");
      out.write(" \n");
      out.write("\n");
      out.write(" \n");
      out.write(" ");
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

  private boolean _jspx_meth_c_if_0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:if
    org.apache.taglibs.standard.tag.rt.core.IfTag _jspx_th_c_if_0 = (org.apache.taglibs.standard.tag.rt.core.IfTag) _jspx_tagPool_c_if_test.get(org.apache.taglibs.standard.tag.rt.core.IfTag.class);
    _jspx_th_c_if_0.setPageContext(_jspx_page_context);
    _jspx_th_c_if_0.setParent(null);
    _jspx_th_c_if_0.setTest(((java.lang.Boolean) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${sessionScope.usuario == null}", java.lang.Boolean.class, (PageContext)_jspx_page_context, null)).booleanValue());
    int _jspx_eval_c_if_0 = _jspx_th_c_if_0.doStartTag();
    if (_jspx_eval_c_if_0 != javax.servlet.jsp.tagext.Tag.SKIP_BODY) {
      do {
        out.write("\n");
        out.write("    ");
        if (_jspx_meth_c_redirect_0((javax.servlet.jsp.tagext.JspTag) _jspx_th_c_if_0, _jspx_page_context))
          return true;
        out.write('\n');
        int evalDoAfterBody = _jspx_th_c_if_0.doAfterBody();
        if (evalDoAfterBody != javax.servlet.jsp.tagext.BodyTag.EVAL_BODY_AGAIN)
          break;
      } while (true);
    }
    if (_jspx_th_c_if_0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _jspx_tagPool_c_if_test.reuse(_jspx_th_c_if_0);
      return true;
    }
    _jspx_tagPool_c_if_test.reuse(_jspx_th_c_if_0);
    return false;
  }

  private boolean _jspx_meth_c_redirect_0(javax.servlet.jsp.tagext.JspTag _jspx_th_c_if_0, PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:redirect
    org.apache.taglibs.standard.tag.rt.core.RedirectTag _jspx_th_c_redirect_0 = (org.apache.taglibs.standard.tag.rt.core.RedirectTag) _jspx_tagPool_c_redirect_url_nobody.get(org.apache.taglibs.standard.tag.rt.core.RedirectTag.class);
    _jspx_th_c_redirect_0.setPageContext(_jspx_page_context);
    _jspx_th_c_redirect_0.setParent((javax.servlet.jsp.tagext.Tag) _jspx_th_c_if_0);
    _jspx_th_c_redirect_0.setUrl("login.jsp");
    int _jspx_eval_c_redirect_0 = _jspx_th_c_redirect_0.doStartTag();
    if (_jspx_th_c_redirect_0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _jspx_tagPool_c_redirect_url_nobody.reuse(_jspx_th_c_redirect_0);
      return true;
    }
    _jspx_tagPool_c_redirect_url_nobody.reuse(_jspx_th_c_redirect_0);
    return false;
  }

  private boolean _jspx_meth_c_out_0(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:out
    org.apache.taglibs.standard.tag.rt.core.OutTag _jspx_th_c_out_0 = (org.apache.taglibs.standard.tag.rt.core.OutTag) _jspx_tagPool_c_out_value_nobody.get(org.apache.taglibs.standard.tag.rt.core.OutTag.class);
    _jspx_th_c_out_0.setPageContext(_jspx_page_context);
    _jspx_th_c_out_0.setParent(null);
    _jspx_th_c_out_0.setValue((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${sessionScope.usuario}", java.lang.Object.class, (PageContext)_jspx_page_context, null));
    int _jspx_eval_c_out_0 = _jspx_th_c_out_0.doStartTag();
    if (_jspx_th_c_out_0.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _jspx_tagPool_c_out_value_nobody.reuse(_jspx_th_c_out_0);
      return true;
    }
    _jspx_tagPool_c_out_value_nobody.reuse(_jspx_th_c_out_0);
    return false;
  }

  private boolean _jspx_meth_c_out_1(PageContext _jspx_page_context)
          throws Throwable {
    PageContext pageContext = _jspx_page_context;
    JspWriter out = _jspx_page_context.getOut();
    //  c:out
    org.apache.taglibs.standard.tag.rt.core.OutTag _jspx_th_c_out_1 = (org.apache.taglibs.standard.tag.rt.core.OutTag) _jspx_tagPool_c_out_value_nobody.get(org.apache.taglibs.standard.tag.rt.core.OutTag.class);
    _jspx_th_c_out_1.setPageContext(_jspx_page_context);
    _jspx_th_c_out_1.setParent(null);
    _jspx_th_c_out_1.setValue((java.lang.Object) org.apache.jasper.runtime.PageContextImpl.evaluateExpression("${sessionScope.fecha}", java.lang.Object.class, (PageContext)_jspx_page_context, null));
    int _jspx_eval_c_out_1 = _jspx_th_c_out_1.doStartTag();
    if (_jspx_th_c_out_1.doEndTag() == javax.servlet.jsp.tagext.Tag.SKIP_PAGE) {
      _jspx_tagPool_c_out_value_nobody.reuse(_jspx_th_c_out_1);
      return true;
    }
    _jspx_tagPool_c_out_value_nobody.reuse(_jspx_th_c_out_1);
    return false;
  }
}
