
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray" %>
<%@ page import="reportes.ReportesSII" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="reportesSII" class="reportes.ReportesSII" scope="page" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>ReportesSII</title>

        <!-- Favicon -->
        <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">

        <!-- CSS Libraries -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">

        <!-- Custom CSS -->
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">

    </head>
    <body id="fondoBodyReportes2">
        <br>
        <div class="container-fluid">
            <div class="row align-items-center">
                <!-- Logo de la marca -->
                <div class="col-3 d-flex justify-content-start align-items-center">
                    <a href="informesMensuales.jsp" class="brand-logo">
                        <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                    </a>
                </div>
                <!-- Sección de Selección de Reporte -->
                <div class="col-6 d-flex justify-content-center align-items-center">
                    <label for="seleccion" class="colorLabel me-2">Selecciona el tipo de reporte:</label>
                    <select name="procedimientos" id="seleccion" class="form-select w-50">
                        <option selected disabled>Selecciona:</option>
                        <!-- Opciones de reporte (mantenidas igual que en el código original) -->
                        <option value="1">Acreditación y renovación</option>
                        <option value="2">Certificados de Marca con Totales</option>
                        <option value="3">Certificados de Marca por EC/OCE</option>
                        <option value="4">Certificados de Marca por Estado</option>
                        <option value="5">Certificados de Marca por Nombre de Certificado</option>
                        <option value="6">Certificados Emitidos</option>
                        <option value="7">Certificados Emitidos por CE/EI</option>
                        <option value="8">Certificados de Marca por CE/EI SAC - SOCIE</option>
                        <option value="9">Cifras de Acreditación</option>
                        <option value="10">Cifras de Més / Año</option>
                        <option value="11">Cintillos EC</option>
                        <option value="12">Datos Generales CE/EI</option>
                        <option value="13">Descarga de Instrumento de Evaluación</option>
                        <option value="14">Descarga del Estándar de Competencia</option>
                        <option value="15">Directorio CE/EI con Acreditaciónes</option>
                        <option value="16">Directorio ENLACES</option>
                        <option value="17">Evaluadores CE/EI por Estándar</option>
                        <option value="18">Inscripción al RENEC</option>
                        <option value="19">Instituciones Acreditadas</option>
                        <option value="20">Instituciones acreditadas Básico</option>
                        <option value="21">Instituciones Educativas</option>
                        <option value="22">Logos ECE/OC</option>
                        <option value="23">Lotes de Certificados</option>
                        <option value="24">Personas Certificadas</option>
                        <option value="25">Procesos activos SII/SAC</option>
                        <option value="26">RENEC VS SII</option>
                        <option value="27">REP_Solicitud De Acreditación/Renovación EC</option>
                        <option value="28">REP_Solicitud De Acreditación Inicial</option>
                        <option value="29">REP_Solicitud De Certificados</option>
                        <option value="30">REP_Solicitud De Reimpresión De Certificados</option>
                        <option value="31">Reporte de Acreditaciones CE/EI</option>
                        <option value="32">Reporte de Acreditaciones ECE/OC</option>
                        <option value="33">Reporte de Empresas</option>
                        <option value="34">Reporte de RENAC</option>
                        <option value="35">Reporte de Renovaciones CE/EI</option>
                        <option value="36">Reporte de Renovaciones ECE/OC</option>
                        <option value="37">Reporte de Integral</option>
                        <option value="38">Reporte Mensual por Región</option>
                        <option value="39">Sector Productivo</option>
                        <option value="40">Soluciones de Evaluación y Certificaciones EC</option>
                        <option value="41">Verificadores EC/ECE/OC</option>
                    </select>

                    <button id="descargarSp" type="submit" class="btn btn-outline-danger ms-2">Descargar Información</button>
                </div>
                <!-- Información del usuario -->
                <div class="col-2 d-flex justify-content-end align-items-center ms-auto">
            <img src="img/userpersona.png" alt="Imagen usuario" class="rounded-circle me-2" width="55">
            <div class="media-body">
                <!-- Mostrar "Usuario:" seguido del nombre -->
                <h6 class="mb-0 usuario-nombre small">
                    Usuario: <c:out value="${sessionScope.usuario}" />
                </h6>
                <!-- Mostrar "Fecha:" seguido de la fecha y hora -->
                <small class="text-muted usuario-fecha">
                    Fecha: <c:out value="${sessionScope.fecha}" />
                </small>
            </div>
        </div>
            </div>

            <!-- Contenedor de Búsqueda Rápida -->
            <div id="quickSearchContainer" class="row align-items-center justify-content-center mt-3" style="display:none;">
                <div class="col-md-3 col-12">
                    <input type="text" id="quickSearchInput" class="form-control" 
                           placeholder="Buscar en la tabla...">
                </div>
                <div class="col-md-3 col-12">
                    <select id="searchColumnSelect" class="form-select">
                        <option value="">Buscar en todas las columnas</option>
                    </select>
                </div>
                <div class="col-sm-1">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="exactMatchCheckbox">
                        <label class="form-check-label" for="exactMatchCheckbox">
                        </label>
                    </div>
                </div>
            </div>

            <!-- Contenedor de Tabla -->
            <div class="table-responsive mt-3">
                <table class="table table-striped table-bordered table-hover">
                    <thead class="table-dark sticky-top" id="tableHead">
                        <!-- Encabezados se generarán dinámicamente -->
                    </thead>
                    <tbody id="tableBody">
                        <tr>
                            <td colspan="10" class="text-center">
                                Selecciona un reporte para ver los datos.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Paginación -->
            <div id="pagination" class="d-flex justify-content-center mt-3">
                <!-- Botones de paginación se agregarán aquí -->
            </div>
        </div>
    </div>


    <!-- Footer -->
      <footer class="container-fluid mt-auto py-3 bg-light">
          <div class="row align-items-center g-3">
              <div class="col-12 col-md-3 text-center text-md-start">
                  <img src="img/sep.png" alt="Logo SEP" class="img-fluid" style="max-height: 60px;">
              </div>
              <div class="col-12 col-md-6 text-center">
                  <p class="small mb-1">•2024•©CONSEJO NACIONAL DE NORMALIZACIÓN Y CERTIFICACIÓN DE COMPETENCIAS LABORALES. MÉXICO•</p>
                  <p class="small mb-1">•Barranca del Muerto 275, San José Insurgentes, Benito Juárez, 03900 Ciudad de México, D.F. 01 55 2282 0200</p>
                  <a href="#" target="_blank" class="small text-decoration-none">• CONOCER •</a>
              </div>
              <div class="col-12 col-md-3 text-center text-md-end">
                  <img src="img/conocerLogo.png" alt="Logo CONOCER" class="img-fluid" style="max-height: 60px;">
              </div>
          </div>
      </footer>


    <!-- JavaScript Libraries -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

    <script>
        // Variables globales
        let globalTableData = []; // Almacena todos los datos del reporte
        let currentSelectedReport = null; // Almacena el tipo de reporte seleccionado

        // Evento de cambio de reporte
        document.getElementById('seleccion').addEventListener('change', function () {
            const selectedValue = this.value;
            currentSelectedReport = selectedValue;
            cargarDatos(selectedValue, 1, 30); // Carga inicial en la página 1
        });

        // Replace the cargarDatos function with this improved version
function cargarDatos(selectedValue, pagina, registrosPorPagina) {
    if (!selectedValue || selectedValue === 'Selecciona:') {
        alert('Por favor, selecciona un tipo de reporte');
        return;
    }

    // Referencias a elementos del DOM
    const tableHead = document.getElementById('tableHead');
    const tableBody = document.getElementById('tableBody');
    const paginationDiv = document.getElementById('pagination');
    const quickSearchContainer = document.getElementById('quickSearchContainer');
    const searchColumnSelect = document.getElementById('searchColumnSelect');

    // Mostrar estado de carga
    tableHead.innerHTML = '<tr><th class="text-center">Cargando datos...</th></tr>';
    tableBody.innerHTML = '<tr><td class="text-center"><div class="spinner-border text-primary" role="status"><span class="visually-hidden">Cargando...</span></div></td></tr>';
    paginationDiv.innerHTML = '';
    quickSearchContainer.style.display = 'none';
    searchColumnSelect.innerHTML = '<option value="">Buscar en todas las columnas</option>';

    // Construir los parámetros de la solicitud
    const params = new URLSearchParams({
        procedimientos: selectedValue,
        page: pagina,
        pageSize: registrosPorPagina
    });

    // Realizar la solicitud al servidor
    fetch('ReportesSII?' + params.toString(), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
        },
        credentials: 'same-origin'
    })
    .then(async response => {
        // Verificar el tipo de contenido de la respuesta
        const contentType = response.headers.get('content-type');
        
        if (!contentType || !contentType.includes('application/json')) {
            throw new Error('La respuesta del servidor no es JSON válido');
        }

        // Verificar si la respuesta es exitosa
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || `Error del servidor: ${response.status}`);
        }

        return response.json();
    })
    .then(data => {
        // Limpiar los contenedores
        tableHead.innerHTML = '';
        tableBody.innerHTML = '';
        paginationDiv.innerHTML = '';

        // Verificar que los datos son válidos
        if (!data || !data.success || !data.data || !data.data[selectedValue]) {
            throw new Error('No se encontraron datos para el reporte seleccionado');
        }

        // Procesar los datos recibidos
        globalTableData = data.data[selectedValue];

        if (globalTableData.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="10" class="text-center">No hay datos disponibles para este reporte</td></tr>';
            return;
        }

        // Generar encabezados de tabla
        const firstRow = globalTableData[0];
        const headerRow = document.createElement('tr');
        
        Object.keys(firstRow).forEach(key => {
            const th = document.createElement('th');
            th.textContent = key;
            th.className = 'text-nowrap'; // Prevenir saltos de línea en encabezados
            headerRow.appendChild(th);

            // Añadir opciones de búsqueda
            const option = document.createElement('option');
            option.value = key;
            option.textContent = key;
            searchColumnSelect.appendChild(option);
        });
        
        tableHead.appendChild(headerRow);

        // Renderizar filas y mostrar controles
        renderTableRows(globalTableData);
        quickSearchContainer.style.display = 'flex';
        
        // Generar paginación si hay múltiples páginas
        if (data.totalPages && data.totalPages > 1) {
            generarPaginacion(data.totalPages, pagina, selectedValue, registrosPorPagina);
        }
    })
    .catch(error => {
        console.error('Error al cargar datos:', error);
        
        // Mostrar mensaje de error amigable al usuario
        tableHead.innerHTML = '';
        tableBody.innerHTML = `
            <tr>
                <td colspan="10" class="text-center text-danger">
                    <div class="alert alert-danger" role="alert">
                        <h5 class="alert-heading">Error al cargar los datos</h5>
                        <p>${error.message || 'Ocurrió un error inesperado. Por favor, intente nuevamente.'}</p>
                        <hr>
                        <p class="mb-0">Si el problema persiste, contacte al administrador del sistema.</p>
                    </div>
                </td>
            </tr>
        `;
        
        // Ocultar elementos innecesarios en caso de error
        quickSearchContainer.style.display = 'none';
        paginationDiv.innerHTML = '';
    });
}

        // Función para renderizar filas de tabla
        function renderTableRows(data) {
            const tableBody = document.getElementById('tableBody');
            tableBody.innerHTML = ''; // Limpiar filas existentes

            data.forEach(row => {
                const tr = document.createElement('tr');
                Object.values(row).forEach(value => {
                    const td = document.createElement('td');
                    td.textContent = value !== null ? value.toString() : '';
                    tr.appendChild(td);
                });
                tableBody.appendChild(tr);
            });
        }

        // Función de búsqueda rápida
        document.getElementById('quickSearchInput').addEventListener('input', function () {
            const searchTerm = this.value.trim();
            const searchColumn = document.getElementById('searchColumnSelect').value;
            const exactMatch = document.getElementById('exactMatchCheckbox').checked;

            // Validar término de búsqueda
            if (!searchTerm) {
                renderTableRows(globalTableData);
                return;
            }

            // Filtrar datos
            const filteredData = globalTableData.filter(row => {
                // Búsqueda en columna específica
                if (searchColumn) {
                    const columnValue = row[searchColumn] !== null ?
                            row[searchColumn].toString() : '';

                    return exactMatch
                            ? columnValue === searchTerm
                            : columnValue.toLowerCase().includes(searchTerm.toLowerCase());
                }

                // Búsqueda en todas las columnas
                return Object.values(row).some(value =>
                    value !== null &&
                            (exactMatch
                                    ? value.toString() === searchTerm
                                    : value.toString().toLowerCase().includes(searchTerm.toLowerCase()))
                );
            });

            // Renderizar filas filtradas
            renderTableRows(filteredData);
        });

        // Función para generar controles de paginación
        function generarPaginacion(totalPages, currentPage, selectedValue, registrosPorPagina) {
            const paginationDiv = document.getElementById('pagination');
            paginationDiv.innerHTML = ''; // Limpiar paginación anterior

            // Botón Anterior
            if (currentPage > 1) {
                const prevButton = crearBotonPaginacion('Anterior', () => {
                    cargarDatos(selectedValue, currentPage - 1, registrosPorPagina);
                });
                paginationDiv.appendChild(prevButton);
            }

            // Calcular rango de páginas a mostrar
            const startPage = Math.max(1, currentPage - 2);
            const endPage = Math.min(totalPages, currentPage + 2);

            // Mostrar primera página si no está en rango
            if (startPage > 1) {
                const firstPageButton = crearBotonPaginacion('1', () => {
                    cargarDatos(selectedValue, 1, registrosPorPagina);
                });
                paginationDiv.appendChild(firstPageButton);

                if (startPage > 2) {
                    const ellipsis = document.createElement('span');
                    ellipsis.textContent = '...';
                    paginationDiv.appendChild(ellipsis);
                }
            }

            // Botones de páginas
            for (let i = startPage; i <= endPage; i++) {
                const pageButton = crearBotonPaginacion(i.toString(), () => {
                    cargarDatos(selectedValue, i, registrosPorPagina);
                }, i === currentPage);
                paginationDiv.appendChild(pageButton);
            }

            // Mostrar última página si no está en rango
            if (endPage < totalPages) {
                if (endPage < totalPages - 1) {
                    const ellipsis = document.createElement('span');
                    ellipsis.textContent = '...';
                    paginationDiv.appendChild(ellipsis);
                }

                const lastPageButton = crearBotonPaginacion(totalPages.toString(), () => {
                    cargarDatos(selectedValue, totalPages, registrosPorPagina);
                });
                paginationDiv.appendChild(lastPageButton);
            }

            // Botón Siguiente
            if (currentPage < totalPages) {
                const nextButton = crearBotonPaginacion('Siguiente', () => {
                    cargarDatos(selectedValue, currentPage + 1, registrosPorPagina);
                });
                paginationDiv.appendChild(nextButton);
            }
        }

        console.log(`Creando botones de paginación: totalPages=${totalPages}, currentPage=${currentPage}`);

        // Función auxiliar para crear botones de paginación
        function crearBotonPaginacion(texto, clickHandler, esActual = false) {
            const button = document.createElement('button');
            button.textContent = texto;
            button.classList.add('btn', 'btn-outline-secondary', 'mx-1');

            if (esActual) {
                button.disabled = true;
                button.classList.add('active');
            }

            button.addEventListener('click', clickHandler);
            return button;
        }

function descargarReporte() {
    const selectElement = document.getElementById('seleccion');
    const selectedValue = selectElement.value;
    
    if (!selectedValue || selectedValue === 'Selecciona:') {
        alert('Por favor, seleccione un tipo de reporte antes de descargar');
        return;
    }

    const botonDescargar = document.getElementById('descargarSp');
    const textoOriginal = botonDescargar.innerHTML;
    botonDescargar.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Descargando...';
    botonDescargar.disabled = true;

    const formData = new FormData();
    formData.append('procedimientos', selectedValue);
    formData.append('formato', 'excel');

    fetch('ReportesSII', {
        method: 'POST',
        body: formData
    })
    .then(async response => {
        const contentType = response.headers.get('content-type');
        
        if (contentType && contentType.includes('application/json')) {
            // Es una respuesta JSON, probablemente un error
            const jsonResponse = await response.json();
            if (jsonResponse.error) {
                throw new Error(jsonResponse.error);
            }
            throw new Error('No se pudo generar el Excel');
        }
        
        if (!response.ok) {
            throw new Error(`Error del servidor: ${response.status}`);
        }
        
        return response.blob();
    })
    .then(blob => {
        const fechaActual = new Date().toLocaleDateString('es-MX').replace(/\//g, '-');
        const nombreReporte = selectElement.options[selectElement.selectedIndex].text;
        const fileName = `Reporte_${nombreReporte}_${fechaActual}.xlsx`;

        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = fileName;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        a.remove();
    })
    .catch(error => {
        console.error('Error en la descarga:', error);
        alert(error.message || 'Error al descargar el reporte');
    })
    .finally(() => {
        botonDescargar.innerHTML = textoOriginal;
        botonDescargar.disabled = false;
    });
}
document.getElementById('descargarSp').addEventListener('click', descargarReporte);
    </script>
    
    
</body>
</html>