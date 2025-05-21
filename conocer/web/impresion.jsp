<%-- 
    Document   : homeImpresion
    Created on : 9/01/2025, 06:01:47 PM
    Author     : Conocer
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray" %>
<%@ page import="reportes.Impresion" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:useBean id="Impresion" class="reportes.Impresion" scope="page" />
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
    <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
</head>
<body id="fondoBodyReportes2">
    <br>
    <div class="container-fluid">
        <div class="row align-items-center">
            <div class="col-3 d-flex justify-content-start align-items-center">
                <a href="informesMensuales.jsp" class="brand-logo">
                    <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                </a>
            </div>
            <div class="col-6 d-flex justify-content-center align-items-center">
                <label for="seleccion" class="colorLabel me-2">Selecciona el tipo de reporte:</label>
                <select name="procedimientos" id="seleccion" class="form-select w-50">
                    <option selected disabled>Selecciona:</option>
                    <option value="1">Certificados Emitidos Último Mes</option>
                    <option value="2">Cintinillos EC</option>
                    <option value="3">Instituciones Acreditadas</option>
                    <option value="4">Instituciones Acreditadas Básico</option>
                    <option value="5">Logos ECE / OC</option>
                    <option value="6">Solicitud de Certificados</option>
                    <option value="7">Solicitud de Reimpresión de Certificados</option>
                </select>
                <button id="descargarSp" type="button" class="btn btn-outline-danger btn-custom ms-2">
    <i class="bi bi-file-earmark-arrow-down-fill"></i>Descargar</button>
            </div>
            <div class="col-3 d-flex justify-content-end align-items-center">
                <div class="dropdown d-flex align-items-center">
                    <img src="img/userpersona.png"
                         alt="Imagen usuario"
                         class="rounded-circle me-2"
                         width="55"
                         style="cursor: pointer;"
                         id="dropdownUser"
                         data-bs-toggle="dropdown"
                         aria-expanded="false">

                    <div>
                        <h6 class="mb-1 usuario-nombre medium fw-bold text-primary">
                            <i class="fa-solid fa-user me-2"></i>
                            <c:out value="${sessionScope.usuario}" />
                        </h6>
                        <small class="text-muted usuario-fecha fst-italic">
                            <i class="fa-solid fa-calendar-days"></i> Fecha:
                            <c:out value="${sessionScope.fecha}"/>
                            <br>Hora:<span id="hora-actual">Hora: </span>
                        </small>
                    </div>

                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownUser">
                        <li><a class="dropdown-item" href="cambioContrasena.jsp">Cambiar Contraseña</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="Logout" onclick="cerrarSesion(); return false;">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </div>
                            
<div id="quickSearchContainer" class="row align-items-center justify-content-center mt-3" style="display:none;">
    <div class="col-md-3 col-12 mb-2">
        <input type="text" id="quickSearchInput" class="form-control" placeholder="Buscar en la tabla...">
    </div>
    <div class="col-md-1 col-12 mb-1">
        <select id="searchColumnSelect" class="form-select hide">
            <option value=""></option>
        </select>
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

        <div class="table-responsive mt-3">
            <h6 class="" id="procedimientos"></h6>
            <table class="table table-striped table-bordered table-hover">
                <thead class="table-dark sticky-top" id="tableHead">
                   
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

        <div id="pagination" class="d-flex justify-content-center mt-3">
        </div>
    </div>

    <footer class="container-fluid mt-auto py-3 bg-light">
        <div class="row align-items-center g-3">
            <div class="col-12 col-md-3 text-center text-md-start">
                <img src="img/sep.png" alt="Logo SEP" class="img-fluid" style="max-height: 60px;">
            </div>
            <div class="col-12 col-md-6 text-center">
                <p class="small mb-1"><b>•2025•©CONSEJO NACIONAL DE NORMALIZACIÓN Y CERTIFICACIÓN DE COMPETENCIAS LABORALES. MÉXICO•</b></p>
                <p class="small mb-1">•Barranca del Muerto 275, San José Insurgentes, Benito Juárez, 03900 Ciudad de México, D.F. 01 55 2282 0200</p>
                <a href="#" target="_blank" class="small text-decoration-none" id="custom-link">• CONOCER •</a>
            </div>
            <div class="col-12 col-md-3 text-center text-md-end">
                <img src="img/conocerLogo.png" alt="Logo CONOCER" class="img-fluid" style="max-height: 60px;">
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <script>
let globalTableData = [];
let currentSelectedReport = null;
let currentRequestId = 0;

document.getElementById('seleccion').addEventListener('change', function () {
    const selectedValue = this.value;
    currentSelectedReport = selectedValue;
    cargarDatos(selectedValue, 1, 30);
});

function getSearchParams() {
    const searchTerm = document.getElementById('quickSearchInput')?.value?.trim() || '';
    const searchColumn = document.getElementById('columnSelector')?.value || '';
    const exactMatch = document.getElementById('exactMatchCheck')?.checked || false;
    
    return {
        searchTerm,
        searchColumn,
        exactMatch
    };
}

function realizarBusqueda() {
    const { searchTerm, searchColumn, exactMatch } = getSearchParams();
    
    if (!currentSelectedReport) {
        alert('Por favor, seleccione un reporte primero');
        return;
    }
    
    const tableBody = document.getElementById('tableBody');
    tableBody.innerHTML = `
        <tr>
            <td colspan="100%" class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Buscando...</span>
                </div>
            </td>
        </tr>`;

    const params = new URLSearchParams({
        procedimientos: currentSelectedReport,
        page: 1,
        pageSize: 100, 
        fullSearch: 'true'
    });

    if (searchTerm) {
        params.append('searchTerm', searchTerm);
        if (searchColumn) {
            params.append('searchColumn', searchColumn);
        }
        params.append('exactMatch', exactMatch);
        params.append('allRecords', 'true'); 
    }

    fetch('Impresion_1?' + params.toString(), {
        method: 'GET',
        headers: { 
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    })
    .then(response => {
        if (!response.ok) throw new Error(`Error del servidor: ${response.status}`);
        return response.json();
    })
    .then(data => {
        if (!data.success) throw new Error(data.message || 'Error en la búsqueda');
        
        globalTableData = data.data[currentSelectedReport] || [];
        renderTableRows(globalTableData);
        
        const feedback = document.createElement('div');
        feedback.className = 'alert alert-info mt-2';
        feedback.innerHTML = `
            <i class="bi bi-info-circle"></i> 
            Búsqueda ${searchTerm ? 'global' : 'completa'} realizada. 
            ${globalTableData.length} resultados encontrados.
        `;
        document.getElementById('quickSearchContainer').appendChild(feedback);
        setTimeout(() => feedback.remove(), 3000);
    })
    .catch(error => {
        console.error('Error en la búsqueda:', error);
        tableBody.innerHTML = `
            <tr>
                <td colspan="100%" class="text-center text-danger">
                    Error al realizar la búsqueda: ${error.message}
                </td>
            </tr>`;
    });
}

document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('quickSearchInput');
    const searchButton = document.getElementById('searchButton');

    searchInput?.addEventListener('input', realizarBusquedaLocal);

    searchInput?.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            realizarBusqueda();
        }
    });

    searchButton?.addEventListener('click', realizarBusqueda);
});

const reportTitles = {
    "1": "Reporte de Certificados Emitidos Último Mes",
    "2": "Reporte de Cintinillos EC",
    "3": "Reporte de Instituciones Acreditadas",
    "4": "Reporte de Instituciones Acreditadas Básico",
    "5": "Reporte de Logos ECE / OC",
    "6": "Reporte de Solicitud de Certificados",
    "7": "Reporte de Solicitud de Reimpresión de Certificados",
}

function handleLoadError(error, elements) {
    console.error('Error al cargar los datos:', error);

    if (elements.tableBody) {
        elements.tableBody.innerHTML = `
            <tr>
                <td colspan="100%" class="text-center">
                    <div class="alert alert-danger" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        Error al cargar los datos: ${error.message}
                    </div>
                </td>
            </tr>`;
    }

    if (elements.tableHead) {
        elements.tableHead.innerHTML = '';
    }
    if (elements.pagination) {
        elements.pagination.innerHTML = '';
    }

    if (elements.quickSearch) {
        elements.quickSearch.style.display = 'none';
    }
}

      function cargarDatos(selectedValue, pagina, registrosPorPagina) {
    if (!selectedValue || selectedValue === 'Selecciona:') {
        alert('Por favor, selecciona un tipo de reporte');
        return;
    }

    const requestId = ++currentRequestId;
    const reportTitle = reportTitles[selectedValue] || 'Reporte';
    document.getElementById('procedimientos').textContent = reportTitle;

    const elements = {
        tableHead: document.getElementById('tableHead'),
        tableBody: document.getElementById('tableBody'),
        pagination: document.getElementById('pagination'),
        quickSearch: document.getElementById('quickSearchContainer'),
        searchColumn: document.getElementById('searchColumnSelect')
    };

    elements.tableHead.innerHTML = '<tr><th class="text-center">Cargando datos...</th></tr>';
    elements.tableBody.innerHTML = `
        <tr>
            <td class="text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Cargando...</span>
                </div>
            </td>
        </tr>`;
    elements.pagination.innerHTML = '';
    elements.quickSearch.style.display = 'none';
    elements.searchColumn.innerHTML = '<option value="">Buscar en todas las columnas</option>';

    const params = new URLSearchParams({
        procedimientos: selectedValue,
        page: pagina,
        pageSize: registrosPorPagina
    });

    fetch('Impresion_1?' + params.toString(), {
        method: 'GET',
        headers: { 'Accept': 'application/json' },
        credentials: 'same-origin'
    })
    .then(async response => {
        if (!response.headers.get('content-type')?.includes('application/json')) {
            throw new Error('La respuesta del servidor no es JSON válido');
        }
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || `Error del servidor: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        if (requestId !== currentRequestId) return;

        resetTableElements(elements);

        if (!data?.success || !data?.data?.[selectedValue]) {
            throw new Error('No se encontraron datos para el reporte seleccionado');
        }

        globalTableData = data.data[selectedValue];

        if (globalTableData.length === 0) {
            displayNoDataMessage(elements.tableBody);
            return;
        }

        updateTableHeader();

        renderTableRows(globalTableData);
        elements.quickSearch.style.display = 'flex';

        if (data.totalPages > 1) {
            generarPaginacion(data.totalPages, pagina, selectedValue, registrosPorPagina);
        }
    })
    .catch(error => {
        if (requestId !== currentRequestId) return;
        handleLoadError(error, elements);
    });
}
        
 function updateTableHeader() {
    const tableHead = document.getElementById('tableHead');
    if (!tableHead) {
        console.error('No se encontró el elemento tableHead');
        return;
    }

    const columnOrder = columnOrderMap[currentSelectedReport] || [];

    tableHead.innerHTML = '';

    const headerRow = document.createElement('tr');

    columnOrder.forEach(columnName => {
        const th = document.createElement('th');
        th.textContent = columnName;
        th.className = 'text-nowrap';
        headerRow.appendChild(th);
    });

    tableHead.appendChild(headerRow);
}

 function createTableHeader(columns, elements) {
    const headerRow = document.createElement('tr');

    window.columnOrder = columns;
    
    columns.forEach(column => {
        const th = document.createElement('th');
        th.textContent = column;
        th.className = 'text-nowrap';
        headerRow.appendChild(th);

        const option = document.createElement('option');
        option.value = column;
        option.textContent = column;
        elements.searchColumn.appendChild(option);
    });
    elements.tableHead.appendChild(headerRow);
}

const columnOrderMap = {
    "1": ["FECHA", "NO FOLIO CONOCER", "NO FOLIO PREIMPRESO", "CURP", "NOMBRE PERSONA CERTIFICADA", "APELLIDO PATERNO PERSONA CERTIFICADA", "APELLIDO MATERNO PERSONA CERTIFICADA", "NOMBRE COMPLETO PERSONA CERTIFICADA", "ENTIDAD FEDERATIVA DE LA PERSONA CERTIFICADA", "TIPO CERTIFICADO", "CÓDIGO", "TITULO EC", "ENTIDAD CERTIFICADORA", "SIGLAS CERTIFICADOR", "CEDULA", "CEDULA DEL CENTRO DE EVALUACION EVALUADOR INDEPENDIENTE", "ORIGEN"],
    "2": ["Imagen", "Código Estándar de Competencia", "Cintillo", "Tiene Imagen", "Fecha Publ. D.O.F.",],
    "3": ["Cédula", "Razón Social", "Siglas / Acronimo", "Pagina Web", "RFC", "Estado Acreditación", "Nombre Representante Legal", "Cargo Representante", "Correo Representante", "Telefono Representante", "Celular Representante"], 
    "4": ["FL PRESTADOR SERVICIOS", "Cédula", "Siglas", "Fecha Acreditación", "Prestador Servicios", "Tipo Prestador", "Estado Acreditación Inicial", "Estado Acreditación", "Estado"], 
    "5": ["Imagen", "Siglas", "Nombre", "Cédula", "Tiene Imagen"], 
    "6": ["Consecutivo", "No. Folio", "Estado Actual", "Folio CONOCER", "Folio CONOCER", "Razón Social", "Estado de la Impresión", "No. Linea de Captura"],
    "7": ["SOLICITUD", "FECHA", "CEDULA", "SIGLAS", "ESTANDAR", "CURP", "NOMBRE", "FOLIO_CONOCER", "FOLIO_PRE_IMPRESO_ANTERIOR", "FOLIO_PRE_IMPRESO_NUEVO", "FECHA_DE_ENVIO", "ESTATUS"],
};

function renderTableRows(data) {
    const tableBody = document.getElementById('tableBody');
    if (!tableBody) {
        console.error('No se encontró el elemento tableBody');
        return;
    }

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
       
        const columnOrder = columnOrderMap[currentSelectedReport] || Object.keys(data[0]);

        data.forEach(row => {
            const tr = document.createElement('tr');

            columnOrder.forEach(columnName => {
                const td = document.createElement('td');
                const value = row[columnName];

                if (columnName.toLowerCase() === 'imagen') {
                    if (value) {
                        try {
                            let imageSource;

                            if (Array.isArray(value)) {
                                const uint8Array = new Uint8Array(value);
                                const blob = new Blob([uint8Array], { type: 'image/jpeg' }); 
                                imageSource = URL.createObjectURL(blob);
                            } else if (typeof value === 'string') {
                                imageSource = value;
                            }

                            if (imageSource) {
                                const img = document.createElement('img');
                                img.src = imageSource;
                                img.alt = 'Imagen';
                                img.style.maxWidth = '500px';
                                img.style.maxHeight = '400px';
                                img.style.objectFit = 'contain';
                                img.className = 'img-fluid cursor-pointer';
                                img.onerror = () => {
                                    console.error('Error al cargar la imagen');
                                    td.textContent = 'No tiene imagen';
                                };
                                img.onload = () => {
                                    if (Array.isArray(value)) {
                                        URL.revokeObjectURL(imageSource);
                                    }
                                };
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
                    
                    td.textContent = value ?? '';
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

function resetTableElements(elements) {
    if (!elements) {
        console.error('No se proporcionaron elementos para resetear');
        return;
    }

    if (elements.tableHead) {
        elements.tableHead.innerHTML = '';
    }

    if (elements.tableBody) {
        elements.tableBody.innerHTML = '';
    }

    if (elements.pagination) {
        elements.pagination.innerHTML = '';
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
    const selectedOptions = Array.from(selectElement.selectedOptions).map(option => option.value);

    if (selectedOptions.length === 0 || selectedOptions.includes('Selecciona:')) {
        alert('Por favor, seleccione al menos un tipo de reporte antes de descargar.');
        return;
    }

    const validOptions = ["1", "2", "3", "4", "5", "6", "7"]; // Lista de opciones válidas
    const selectedValidOptions = selectedOptions.filter(option => validOptions.includes(option));

    if (selectedValidOptions.length === 0) {
        alert('Selección inválida. Por favor, elija un tipo de reporte válido.');
        return;
    }

    const botonDescargar = document.getElementById('descargarSp');
    botonDescargar.disabled = true;
    botonDescargar.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Descargando...';

    const nombreReporte = {
        "1": "Certificados_Emitidos_Ultimo_es",
        "2": "Cintinillos_EC",
        "3": "Instituciones_Acreditadas",
        "4": "Instituciones_Acreditadas_Basico",
        "5": "Logos_ECE_OC",
        "6": "Solicitud_de_Certificados",
        "7": "Solicitud_de_Reimpresion_de_Certificados",
    };

    const reportNames = selectedValidOptions.map(value => nombreReporte[value] || `Reporte_${value}`).join("_");

    const params = new URLSearchParams();
    params.append('formato', 'excel');
    params.append('procedimientos', selectedValidOptions.join(',')); 
    params.append('nombreReporte', reportNames);

    console.log('Iniciando descarga con parámetros:', Object.fromEntries(params));

    fetch('Impresion_1?' + params.toString(), {
        method: 'GET',
        credentials: 'same-origin',
        headers: {
            'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'Cache-Control': 'no-cache'
        }
    })
    .then(response => {
        if (!response.ok) {
            return response.text().then(text => {
                throw new Error(text || `Error del servidor: ${response.status}`);
            });
        }

        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
            return response.text().then(text => {
                throw new Error('El servidor no devolvió un archivo Excel válido.');
            });
        }

        const disposition = response.headers.get('content-disposition');
        let fileName;

        if (disposition && disposition.includes('filename=')) {
            const filenameRegex = /filename[^;=\n]*=((['"]).*?\2|[^;\n]*)/;
            const matches = filenameRegex.exec(disposition);
            if (matches != null && matches[1]) {
                fileName = decodeURIComponent(matches[1].replace(/['"]/g, ''));
            }
        }

        if (!fileName) {
            const fechaActual = new Date().toISOString().slice(0, 19).replace(/[-:T]/g, '');
            fileName = `${reportNames}_${fechaActual}.xlsx`;
        }

        return response.blob().then(blob => {
            return { blob, fileName };
        });
    })
    .then(data => {
        const { blob, fileName } = data;

        if (blob.size === 0) {
            throw new Error('El archivo generado está vacío.');
        }

        if (window.navigator && window.navigator.msSaveOrOpenBlob) {
            window.navigator.msSaveOrOpenBlob(blob, fileName);
        } else {
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
        }
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

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('searchButton').addEventListener('click', realizarBusqueda);

    document.getElementById('quickSearchInput').addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            realizarBusqueda();
        }
    });
    document.getElementById('seleccion').addEventListener('change', function() {
        const selectedValue = this.value;
        currentSelectedReport = selectedValue;
        cargarDatos(selectedValue, 1, 30);
    });

    document.getElementById('descargarSp').addEventListener('click', descargarReporte);
});

const initialSelectedValue = document.getElementById('seleccion').value;
if (initialSelectedValue && initialSelectedValue !== 'Selecciona:') {
    currentSelectedReport = initialSelectedValue;
    cargarDatos(initialSelectedValue, 1, 30);
}

function actualizarHora() {
        const fechaActual = new Date();
        const opciones = {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: true,
            timeZone: 'America/Mexico_City'
        };

        const horaFormateada = new Intl.DateTimeFormat('es-MX', opciones).format(fechaActual);
        document.getElementById('hora-actual').innerText = ' ' + horaFormateada;  
    }

    setInterval(actualizarHora, 1000);
    actualizarHora();
    </script>

</body>
</html>
