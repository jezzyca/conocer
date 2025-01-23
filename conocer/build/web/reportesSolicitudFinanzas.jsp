<%-- 
    Document   : reportesSolicitudFinanzas
    Created on : 9/01/2025, 06:44:51 PM
    Author     : Conocer
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray" %>
<%@ page import="reportes.ReportesSolicitudFinanzas" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="ReportesSolicitudFinanzas" class="reportes.ReportesSolicitudFinanzas" scope="page" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<!-- Validación de sesión -->
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
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
                    <option value="1">Solicitudes de Certificados</option>
                </select>
                <button id="descargarSp" type="button" class="btn btn-outline-danger btn-custom ms-2">
    <i class="bi bi-file-earmark-arrow-down-fill"></i>Descargar</button>
            </div>
            <!-- Información del usuario -->
            <div class="col-2 d-flex justify-content-end align-items-center ms-auto">
                <img src="img/userpersona.png" alt="Imagen usuario" class="rounded-circle me-2" width="55">
                <div class="media-body">
                    <h6 class="mb-0 usuario-nombre small">
                        Usuario: <c:out value="${sessionScope.usuario}" />
                    </h6>
                    <small class="text-muted usuario-fecha">
                        Fecha: <c:out value="${sessionScope.fecha}" />
                    </small>
                </div>
            </div>
        </div>

 <!-- Contenedor de Búsqueda Rápida Actualizado -->
<div id="quickSearchContainer" class="row align-items-center justify-content-center mt-3" style="display:none;">
    <div class="col-md-3 col-12 mb-2">
        <input type="text" id="quickSearchInput" class="form-control" placeholder="Buscar en la tabla...">
    </div>
    <div class="col-md-2 col-12 mb-2">
        <select id="searchColumnSelect" class="form-select">
            <option value="">Buscar en todas las columnas</option>
        </select>
    </div>
    <div class="col-md-2 col-12 mb-2 d-flex align-items-center">
        <div class="form-check">
            <input class="form-check-input" type="checkbox" id="exactMatchCheckbox">
            <label class="form-check-label" for="exactMatchCheckbox"></label>
        </div>
    </div>
    <div class="col-md-2 col-12 mb-2">
        <button id="searchButton" class="btn btn-primary w-100 d-flex align-items-center justify-content-center">
            <i class="bi bi-search me-2"></i> Buscar
        </button>
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
                <p class="small mb-1">•2025•©CONSEJO NACIONAL DE NORMALIZACIÓN Y CERTIFICACIÓN DE COMPETENCIAS LABORALES. MÉXICO•</p>
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
let globalTableData = [];
let currentSelectedReport = null;
let currentRequestId = 0; // Identificador único para solicitudes

// Evento de cambio de reporte
document.getElementById('seleccion').addEventListener('change', function () {
    const selectedValue = this.value;
    currentSelectedReport = selectedValue;
    cargarDatos(selectedValue, 1, 30);
});

// Función de búsqueda actualizada para buscar en todo el SP
function realizarBusqueda() {
    const searchTerm = document.getElementById('quickSearchInput').value.trim();
    const searchColumn = document.getElementById('searchColumnSelect').value;
    const exactMatch = document.getElementById('exactMatchCheckbox').checked;

    if (!currentSelectedReport) {
        alert('Por favor, seleccione un reporte primero');
        return;
    }

    // Si no hay término de búsqueda, recargar los datos originales
    if (!searchTerm) {
        cargarDatos(currentSelectedReport, 1, 30);
        return;
    }

    const params = new URLSearchParams({
        procedimientos: currentSelectedReport,
        searchTerm: searchTerm,
        searchColumn: searchColumn,
        exactMatch: exactMatch,
        fullSearch: 'true', // Nuevo parámetro para indicar búsqueda completa
        allRecords: 'true', // Nuevo parámetro para obtener todos los registros
        page: 1,
        pageSize: 1000000, // Número grande para obtener todos los registros
    });

    // Mostrar indicador de carga
    const tableBody = document.getElementById('tableBody');
    tableBody.innerHTML = `
        <tr>
            <td colspan="100%" class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Buscando...</span>
                </div>
            </td>
        </tr>`;

    fetch('ReportesSolicitudFinanzas?' + params.toString(), {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin',
    })
        .then((response) => response.json())
        .then((data) => {
            if (!data.success) {
                throw new Error(data.message || 'Error al realizar la búsqueda');
            }
            globalTableData = data.data[currentSelectedReport];
            renderTableRows(globalTableData);

            // Actualizar la paginación si es necesario
            if (data.totalPages && data.totalPages > 1) {
                generarPaginacion(data.totalPages, 1, currentSelectedReport, 30);
            }
        })
        .catch((error) => {
            console.error('Error en la búsqueda:', error);
            tableBody.innerHTML = `
                <tr>
                    <td colspan="100%" class="text-center text-danger">
                        <div class="alert alert-danger" role="alert">
                            Error al realizar la búsqueda: ${error.message}
                        </div>
                    </td>
                </tr>`;
        });
}

function cargarDatos(selectedValue, pagina, registrosPorPagina) {
    if (!selectedValue || selectedValue === 'Selecciona:') {
        alert('Por favor, selecciona un tipo de reporte');
        return;
    }

    // Incrementar el identificador único de solicitud
    const requestId = ++currentRequestId;

    const tableHead = document.getElementById('tableHead');
    const tableBody = document.getElementById('tableBody');
    const paginationDiv = document.getElementById('pagination');
    const quickSearchContainer = document.getElementById('quickSearchContainer');
    const searchColumnSelect = document.getElementById('searchColumnSelect');

    tableHead.innerHTML = '<tr><th class="text-center">Cargando datos...</th></tr>';
    tableBody.innerHTML = `
        <tr>
            <td class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
            </td>
        </tr>`;
    paginationDiv.innerHTML = '';
    quickSearchContainer.style.display = 'none';
    searchColumnSelect.innerHTML = '<option value="">Buscar en todas las columnas</option>';

    const params = new URLSearchParams({
        procedimientos: selectedValue,
        page: pagina,
        pageSize: registrosPorPagina,
    });

    fetch('ReportesSolicitudFinanzas?' + params.toString(), {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin',
    })
        .then(async (response) => {
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new Error('La respuesta del servidor no es JSON válido');
            }
            if (!response.ok) {
                const errorData = await response.json();
                throw new Error(errorData.error || `Error del servidor: ${response.status}`);
            }
            return response.json();
        })
        .then((data) => {
            if (requestId !== currentRequestId) return; // Ignorar si no es la solicitud más reciente

            tableHead.innerHTML = '';
            tableBody.innerHTML = '';
            paginationDiv.innerHTML = '';

            if (!data || !data.success || !data.data || !data.data[selectedValue]) {
                throw new Error('No se encontraron datos para el reporte seleccionado');
            }

            globalTableData = data.data[selectedValue];

            if (globalTableData.length === 0) {
                tableBody.innerHTML = `
                    <tr>
                        <td colspan="10" class="text-center">No hay datos disponibles para este reporte</td>
                    </tr>`;
                return;
            }

            const firstRow = globalTableData[0];
            const headerRow = document.createElement('tr');

            Object.keys(firstRow).forEach((key) => {
                const th = document.createElement('th');
                th.textContent = key;
                th.className = 'text-nowrap';
                headerRow.appendChild(th);

                const option = document.createElement('option');
                option.value = key;
                option.textContent = key;
                searchColumnSelect.appendChild(option);
            });

            tableHead.appendChild(headerRow);
            renderTableRows(globalTableData);
            quickSearchContainer.style.display = 'flex';

            if (data.totalPages && data.totalPages > 1) {
                generarPaginacion(data.totalPages, pagina, selectedValue, registrosPorPagina);
            }
        })
        .catch((error) => {
            if (requestId !== currentRequestId) return; // Ignorar si no es la solicitud más reciente

            console.error('Error al cargar datos:', error);

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
                </tr>`;

            quickSearchContainer.style.display = 'none';
            paginationDiv.innerHTML = '';
        });
}

function renderTableRows(data) {
    const tableBody = document.getElementById('tableBody');
    if (!tableBody) {
        console.error('No se encontró el elemento tableBody');
        return;
    }

    // Verificar si data es null, undefined o vacío
    if (!data || !Array.isArray(data) || data.length === 0) {
        tableBody.innerHTML = `
            <tr>
                <td colspan="100%" class="text-center">
                    <div class="alert alert-warning" role="alert">
                        <i class="fas fa-info-circle me-2"></i>
                        No se encontraron resultados para la búsqueda realizada
                    </div>
                </td>
            </tr>`;
        return;
    }

    tableBody.innerHTML = '';
    
    try {
        data.forEach(row => {
            const tr = document.createElement('tr');
            
            Object.entries(row).forEach(([key, value]) => {
                const td = document.createElement('td');
                
                if (key.toLowerCase() === 'imagen') {
                    if (value) {
                        try {
                            let imageSource;
                            
                            // Verificar si es un Array de bytes
                            if (Array.isArray(value)) {
                                // Convertir Array de bytes a Uint8Array
                                const uint8Array = new Uint8Array(value);
                                // Convertir Uint8Array a Blob
                                const blob = new Blob([uint8Array], { type: 'image/jpeg' });
                                // Crear URL del blob
                                imageSource = URL.createObjectURL(blob);
                            } else if (typeof value === 'string') {
                                // Si ya es string (URL o Base64), usarlo directamente
                                imageSource = value;
                            }
                            
                            if (imageSource) {
                                const img = document.createElement('img');
                                img.src = imageSource;
                                img.alt = 'Imagen';
                                img.style.maxWidth = '400px';
                                img.style.maxHeight = '400px';
                                img.style.objectFit = 'contain';
                                img.className = 'img-fluid cursor-pointer';
                                
                                // Manejar errores de carga
                                img.onerror = () => {
                                    console.error('Error al cargar la imagen');
                                    td.textContent = 'No tiene imagen';
                                };
                                // Limpiar el URL del blob cuando la imagen se carga
                                img.onload = () => {
                                    if (Array.isArray(value)) {
                                        URL.revokeObjectURL(imageSource);
                                    }
                                };
                                // Modal para previsualizar
                                img.onclick = () => createImageModal(imageSource);
                                
                                td.appendChild(img);
                            } else {
                                td.textContent = 'Formato de imagen no válido';
                            }
                        } catch (error) {
                            console.error('Error al procesar imagen:', error);
                            td.textContent = 'Error al procesar imagen';
                        }
                    } else {
                        td.textContent = 'Sin imagen';
                    }
                } else {
                    td.textContent = value ?? ''; // Usar el operador de coalescencia nula
                }
                
                tr.appendChild(td);
            });
            
            tableBody.appendChild(tr);
        });
    } catch (error) {
        console.error('Error al renderizar tabla:', error);
        tableBody.innerHTML = `
            <tr>
                <td colspan="100%" class="text-center">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        Error al cargar los datos: ${error.message}
                    </div>
                </td>
            </tr>`;
    }
}

document.getElementById('quickSearchInput').addEventListener('input', function() {
    const searchTerm = this.value.trim();
    const searchColumn = document.getElementById('searchColumnSelect').value;
    const exactMatch = document.getElementById('exactMatchCheckbox').checked;

    if (!searchTerm) {
        renderTableRows(globalTableData);
        return;
    }

    const filteredData = globalTableData.filter(row => {
        if (searchColumn) {
            const columnValue = row[searchColumn] !== null ? row[searchColumn].toString() : '';
            return exactMatch ? columnValue === searchTerm : columnValue.toLowerCase().includes(searchTerm.toLowerCase());
        }

        return Object.values(row).some(value => value !== null && (exactMatch ? value.toString() === searchTerm : value.toString().toLowerCase().includes(searchTerm.toLowerCase())));
    });

    renderTableRows(filteredData);
});

function generarPaginacion(totalPages, currentPage, selectedValue, registrosPorPagina) {
    const paginationDiv = document.getElementById('pagination');
    paginationDiv.innerHTML = '';

    // Botón "Anterior"
    if (currentPage > 1) {
        const prevButton = crearBotonPaginacion('Anterior', () => {
            cargarDatos(selectedValue, currentPage - 1, registrosPorPagina);
        }, false, 'bg-danger', 'text-white');
        paginationDiv.appendChild(prevButton);
    }

    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, currentPage + 2);

    if (startPage > 1) {
        const firstPageButton = crearBotonPaginacion('1', () => {
            cargarDatos(selectedValue, 1, registrosPorPagina);
        }, false, 'bg-primary', 'text-white');
        paginationDiv.appendChild(firstPageButton);

        if (startPage > 2) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            paginationDiv.appendChild(ellipsis);
        }
    }

    // Páginas intermedias
    for (let i = startPage; i <= endPage; i++) {
        const pageButton = crearBotonPaginacion(i.toString(), () => {
            cargarDatos(selectedValue, i, registrosPorPagina);
        }, i === currentPage, 'bg-primary', 'text-white');

        paginationDiv.appendChild(pageButton);
    }

    if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
            const ellipsis = document.createElement('span');
            ellipsis.textContent = '...';
            paginationDiv.appendChild(ellipsis);
        }

        const lastPageButton = crearBotonPaginacion(totalPages.toString(), () => {
            cargarDatos(selectedValue, totalPages, registrosPorPagina);
        }, false, 'bg-primary', 'text-white');

        paginationDiv.appendChild(lastPageButton);
    }

    // Botón "Siguiente"
    if (currentPage < totalPages) {
        const nextButton = crearBotonPaginacion('Siguiente', () => {
            cargarDatos(selectedValue, currentPage + 1, registrosPorPagina);
        }, false, 'bg-danger', 'text-white');
        paginationDiv.appendChild(nextButton);
    }
}

function crearBotonPaginacion(texto, clickHandler, esActual = false, bgClass = 'bg-light', textClass = 'text-dark') {
    const button = document.createElement('button');
    button.textContent = texto;
    button.classList.add('btn', 'mx-1', bgClass, textClass, 'btn-outline-secondary');

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
    botonDescargar.disabled = true;
    botonDescargar.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Descargando...';

    const reportNames = {
        "1": "Acreditaciones_y_Renovaciones",
        "2": "ReporteConSumaMarca",
        "3": "CertificadosMarca_X_Entidad_EC_OC"
    };

    const reportName = reportNames[selectedValue] || "Reporte_Desconocido";
    const fechaActual = new Date().toISOString().split('T')[0].replace(/-/g, '');

    const params = new URLSearchParams();
    params.append('formato', 'excel');
    params.append('procedimientos', selectedValue);
    params.append('nombreReporte', reportName);

    console.log('Iniciando descarga con parámetros:', Object.fromEntries(params));

    fetch('ReportesSolicitudFinanzas?' + params.toString(), {
        method: 'GET',
        credentials: 'same-origin',
        headers: {
            'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'Cache-Control': 'no-cache'
        }
    })
    .then(response => {
        console.log('Headers de respuesta:', Object.fromEntries(response.headers.entries()));
        console.log('Status:', response.status);
        
        if (!response.ok) {
            return response.text().then(text => {
                console.error('Error response:', text);
                throw new Error(text || `Error del servidor: ${response.status}`);
            });
        }

        const contentType = response.headers.get('content-type');
        console.log('Content-Type:', contentType);
        
        if (!contentType || !contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
            console.error('Content-Type incorrecto:', contentType);
            return response.text().then(text => {
                console.log('Contenido de respuesta:', text);
                throw new Error('El servidor no devolvió un archivo Excel válido');
            });
        }
        
        return response.blob();
    })
    .then(blob => {
        console.log('Tamaño del blob:', blob.size, 'bytes');
        console.log('Tipo del blob:', blob.type);

        if (blob.size === 0) {
            throw new Error('El archivo generado está vacío');
        }

        const fileName = `${reportName}_${fechaActual}.xlsx`;
        
        // Para navegadores modernos
        if (window.navigator && window.navigator.msSaveOrOpenBlob) {
            window.navigator.msSaveOrOpenBlob(blob, fileName);
            return;
        }

        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = fileName;
        document.body.appendChild(a);
        a.click();
        
        setTimeout(() => {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
        }, 0);
    })
    .catch(error => {
        console.error('Error detallado:', error);
        alert(`Error al descargar el reporte: ${error.message}\nPor favor, revise la consola para más detalles.`);
    })
    .finally(() => {
        botonDescargar.disabled = false;
        botonDescargar.innerHTML = 'Descargar Información';
    });
}

// Event Listeners
document.addEventListener('DOMContentLoaded', function() {
    // Event listener para el botón de búsqueda
    document.getElementById('searchButton').addEventListener('click', realizarBusqueda);

    // Event listener para búsqueda con Enter
    document.getElementById('quickSearchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            realizarBusqueda();
        }
    });

    // Event listener para cambio de reporte
    document.getElementById('seleccion').addEventListener('change', function() {
        const selectedValue = this.value;
        currentSelectedReport = selectedValue;
        cargarDatos(selectedValue, 1, 30);
    });

    // Event listener para botón de descarga
    document.getElementById('descargarSp').addEventListener('click', descargarReporte);
});

// Opcional: Cargar datos iniciales si hay un valor preseleccionado
const initialSelectedValue = document.getElementById('seleccion').value;
if (initialSelectedValue && initialSelectedValue !== 'Selecciona:') {
    currentSelectedReport = initialSelectedValue;
    cargarDatos(initialSelectedValue, 1, 30);
}
    </script>

</body>
</html>