<%-- 
    Document   : directorio
    Created on : 23/12/2024, 11:17:53 AM
    Author     : CONOCER
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray" %>
<%@ page import="reportes.Directorio" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="Directorio" class="reportes.Directorio" scope="page" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Directorio</title>
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
                        <option value="1">Acreditaciones EC/OCE</option>
                        <option value="2">Directorio CE / EI</option>
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

// Función principal de carga de datos
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

    // Preparar la interfaz para la carga
    tableHead.innerHTML = '<tr><th>Cargando...</th></tr>';
    tableBody.innerHTML = '<tr><td colspan="10">Cargando datos...</td></tr>';
    paginationDiv.innerHTML = '';
    quickSearchContainer.style.display = 'none';
    searchColumnSelect.innerHTML = '<option value="">Buscar en todas las columnas</option>';

    // Solicitud de datos al servidor en formato JSON
    fetch('Directorio?procedimientos=' + selectedValue + '&page=' + pagina + '&pageSize=' + registrosPorPagina, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json', // Solicitar datos en formato JSON
        },
        body: JSON.stringify({
            procedimientos: selectedValue,
            page: pagina,
            pageSize: registrosPorPagina
        }) // Enviar datos en formato JSON
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Error en la respuesta del servidor: ' + response.status);
        }
        return response.json();
    })
    .then(data => {
        console.log('Datos recibidos:', data); // Verifica qué datos está recibiendo el cliente
        // Limpiar indicadores de carga
        tableHead.innerHTML = '';
        tableBody.innerHTML = '';
        paginationDiv.innerHTML = '';

        if (data.success && data.data[selectedValue]) {
            // Almacenar datos globalmente
            globalTableData = data.data[selectedValue];

            // Generar encabezados de tabla
            const firstRow = globalTableData[0];
            const headerRow = document.createElement('tr');
            Object.keys(firstRow).forEach(key => {
                const th = document.createElement('th');
                th.textContent = key;
                headerRow.appendChild(th);

                // Añadir opciones de búsqueda por columna
                const option = document.createElement('option');
                option.value = key;
                option.textContent = key;
                searchColumnSelect.appendChild(option);
            });
            tableHead.appendChild(headerRow);

            // Renderizar filas de tabla
            renderTableRows(globalTableData);

            // Mostrar contenedor de búsqueda
            quickSearchContainer.style.display = 'flex';

            // Generar controles de paginación
            generarPaginacion(data.totalPages || 1, pagina, selectedValue, registrosPorPagina);
        } else {
            tableBody.innerHTML = '<tr><td colspan="10">No se encontraron datos</td></tr>';
        }
    })
    .catch(error => {
        console.error('Error al cargar datos:', error);
        tableHead.innerHTML = '';
        tableBody.innerHTML = `<tr><td colspan="10">Error al cargar los datos: ${error.message}</td></tr>`;
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
            const columnValue = row[searchColumn] !== null ? row[searchColumn].toString() : '';
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

// Función para renderizar las filas de la tabla
function renderTableRows(data) {
    const tableBody = document.getElementById('tableBody');
    tableBody.innerHTML = ''; // Limpiar filas anteriores

    data.forEach(row => {
        const rowElement = document.createElement('tr');
        Object.values(row).forEach(value => {
            const td = document.createElement('td');
            td.textContent = value !== null ? value : '';
            rowElement.appendChild(td);
        });
        tableBody.appendChild(rowElement);
    });
}

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

    // Cambiar el estado del botón a "Descargando..."
    const botonDescargar = document.getElementById('descargarSp');
    const textoOriginal = botonDescargar.innerHTML;
    botonDescargar.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Descargando...';
    botonDescargar.disabled = true;

    // Crear el cuerpo de la solicitud
    const formData = new URLSearchParams();
    formData.append('procedimientos', selectedValue);
    formData.append('formato', 'excel'); // El servidor debe aceptar esto para generar el Excel

    fetch('Directorio', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded', // Enviar en este formato para descarga
        },
        body: formData.toString() // Cuerpo con parámetros URL-encoded
    })
    .then(response => {
        const contentType = response.headers.get('content-type');

        // Verificar el tipo de contenido (debe ser Excel)
        if (!response.ok) {
            const errorMessage = `Error del servidor: ${response.status}`;
            console.error(errorMessage);
            throw new Error(errorMessage);
        }

        if (contentType && contentType.includes('application/json')) {
            return response.json(); // Si es JSON, intentar leer el error
        }

        if (contentType && contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
            return response.blob(); // Si es un archivo Excel, leerlo como Blob
        }

        throw new Error('El servidor no devolvió un archivo Excel válido');
    })
    .then(blob => {
        if (blob instanceof Blob) {
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
        } else {
            throw new Error('El servidor no devolvió un archivo Excel válido');
        }
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