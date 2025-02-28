<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.JSONObject, org.json.JSONArray" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reportes de Solicitudes</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous"></script>
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
        <style>
            .loading {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 9999;
                text-align: center;
                padding-top: 300px;
                color: white;
            }
            
            .table-bordered-red {
                border: 2px solid #cc0000; 
            }

            .thead-red {
                background-color: #dc3545 !important;
            }
 
.pagination-custom .page-item .page-link {
    color: #dc3545;
    border: 1px solid #dc3545; 
    background-color: transparent;
}

.pagination-custom .page-item.active .page-link {
    background-color: #dc3545; 
    border-color: #dc3545; 
    color: white;
}

.pagination-custom .page-item.disabled .page-link {
    color: #6c757d;
    border-color: #dee2e6;
    background-color: transparent;
}

.pagination-custom .page-item:not(.disabled):not(.active) .page-link:hover {
    background-color: #dc3545;
    color: white; 
}
        </style>
    </head>
    <body>
        <div class="container-fluid">
        <div class="row align-items-center d-flex">
            <div class="col-3 d-flex justify-content-start align-items-center">
                <a href="informesMensuales.jsp" class="brand-logo">
                    <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                </a>
            </div>

            <div class="col-6 d-flex justify-content-center align-items-center">
                <div class="btn-group">
                    <button type="button" class="btn btn-danger dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
                        Cuenta <i class="fa-solid fa-user ms-2 align-middle"></i>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="cambioContrasena.html">Cambiar Contraseña</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="Logout" onclick="cerrarSesion(); return false;">Cerrar sesión</a></li>
                    </ul>
                </div>
                <div class="btn-group ms-3">
                    <button type="button" class="btn btn-danger dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
                        Datos Generales<i class="fa-brands fa-windows ms-2 align-middle"></i>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="informesMensuales.jsp">Ir a Inicio</a></li>
                    </ul>
                </div>
            </div>

            <div class="col-2 d-flex justify-content-end align-items-center ms-auto">
                <img src="img/userpersona.png" alt="Imagen usuario" class="rounded-circle me-2" width="55" style="cursor: pointer;" data-bs-toggle="dropdown">
                <div class="media-body">
                    <h6 class="mb-0 usuario-nombre medium">
                        Usuario: <c:out value="${sessionScope.usuario}" />
                    </h6>
                    <small class="text-muted usuario-fecha medium">
                        Fecha: <c:out value="${sessionScope.fecha}" />
                    </small>
                </div>

                <div class="btn-group">
                    <button type="button" class="btn btn-danger dropdown-toggle d-none" data-bs-toggle="dropdown">
                        Cuenta <i class="fa-solid fa-user ms-2 align-middle"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li><a class="dropdown-item" href="cambioContrasena.jsp">Cambiar Contraseña</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="Logout" onclick="cerrarSesion(); return false;">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
                 
        <div class="container mt-4">
            <h1 class="mb-4">Reportes de Solicitudes</h1>
            
            <div class="card mb-4">
                <div class="card-header">
                    <h5>Buscar Solicitudes</h5>
                </div>
                <div class="card-body">
                    <form id="formReporte" action="ReportesSolicitudFinanzas" method="post">
                        <div class="form-row">
                            <div class="form-group col-md-4">
                                <label for="procedimientos">Tipo de Reporte:</label>
                                <select class="form-control" id="procedimientos" name="procedimientos" required>
                                    <option value="" selected disabled>Seleccione un tipo de reporte</option>
                                    <option value="1">Solicitud de Certificación</option>
                                    <option value="2">Solicitud de Acreditación EC</option>
                                    <option value="3">Solicitud de Reposición de Certificados</option>
                                </select>
                            </div>
                            <div class="form-group col-md-4">
                                <label for="numeroSolicitud">Número de Solicitud Inicial:</label>
                                <input type="number" class="form-control" id="numeroSolicitud" name="numeroSolicitud" 
                                       placeholder="Desde el número de solicitud">
                            </div>
                            <div class="form-group col-md-4">
                                <label for="formato">Formato:</label>
                                <select class="form-control" id="formato" name="formato" required>
                                    <option value="json">Tabla</option>
                                    <option value="excel">Excel</option>
                                </select>
                            </div>
                        </div>
                        <input type="hidden" name="page" id="page" value="1">
                        <input type="hidden" name="pageSize" id="pageSize" value="30">
                        <input type="hidden" name="nombreReporte" id="nombreReporte" value="Reporte_Solicitudes">
                        
                        <div class="form-group">
                            <button type="submit" class="btn btn-danger" id="btnGenerar">Generar Reporte</button>
                            
                            <button id="limpiarFormulario" class="btn btn-secondary">Limpiar</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div id="resultados" class="card">
                <div class="card-header">
                    <h5>Resultados del Reporte</h5>
                </div>
                <div class="card-body">
                    <div id="tablaResultados"></div>
                    <nav aria-label="Paginación" id="paginacion" class="mt-3">
                        <ul class="pagination justify-content-center" id="paginacionItems">
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
        
        <div class="loading" id="loading">
            <div class="spinner-border text-light" role="status">
                <span class="sr-only">Cargando...</span>
            </div>
            <p class="mt-2">Generando reporte, por favor espere...</p>
        </div>
        
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
 <script>
  $(document).ready(function() {
    $('#resultados').hide(); 
    $('#loading').hide(); 

    $('#limpiarFormulario').on('click', function() {
        $('#formReporte')[0].reset(); 
        $('#resultados').hide(); 
        $('#tablaResultados').empty();
        $('#paginacionItems').empty();
    });

    function cargarDatos(pagina) {
        $('#page').val(pagina);
        $('#loading').show(); 

        $.ajax({
            url: 'ReportesSolicitudFinanzas',
            type: 'POST',
            data: $('#formReporte').serialize(),
            dataType: 'json',
            success: function(response) {
                $('#loading').hide(); 

                if (response.success) {
                    mostrarResultados(response);
                    generarPaginacion(response.totalPages, pagina); 
                } else {
                    alert('Error: ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                $('#loading').hide(); 
                try {
                    var errorObj = JSON.parse(xhr.responseText);
                    alert('Error: ' + errorObj.message); 
                } catch (e) {
                    alert('Error en la solicitud: ' + error); 
                }
            }
        });
    }

    $(document).on('click', '.page-link', function(e) {
        e.preventDefault();
        var pagina = $(this).data('page');
        if (pagina) {
            cargarDatos(pagina);
        }
    });

    $('#formReporte').on('submit', function(e) {
        e.preventDefault(); 

        var formato = $('#formato').val(); 
        $('#page').val(1); 
        
        if (formato === 'excel') {
            $('#loading').show(); 
            this.submit();
            setTimeout(function() {
                $('#loading').hide(); 
            }, 2000);
        } else {
            cargarDatos(1); 
        }
    });

    function generarPaginacion(totalPaginas, paginaActual) {
        var paginacionItems = $('#paginacionItems');
        paginacionItems.empty();

        if (!totalPaginas || totalPaginas <= 1) {
            return;
        }

        var prevDisabled = paginaActual === 1 ? 'disabled' : '';
        paginacionItems.append(
            '<li class="page-item ' + prevDisabled + '">' +
            '<a class="page-link" href="#" data-page="' + (paginaActual - 1) + '" aria-label="Anterior">' +
            '<span aria-hidden="true">&laquo;</span>' +
            '</a>' +
            '</li>'
        );

        var startPage = Math.max(1, paginaActual - 2);
        var endPage = Math.min(totalPaginas, startPage + 4);
        
        // Ajusta el rango si estamos cerca del final
        if (endPage - startPage < 4) {
            startPage = Math.max(1, endPage - 4);
        }

        for (var i = startPage; i <= endPage; i++) {
            var active = i === paginaActual ? 'active' : '';
            paginacionItems.append(
                '<li class="page-item ' + active + '">' +
                '<a class="page-link" href="#" data-page="' + i + '">' + i + '</a>' +
                '</li>'
            );
        }

        var nextDisabled = paginaActual === totalPaginas ? 'disabled' : '';
        paginacionItems.append(
            '<li class="page-item ' + nextDisabled + '">' +
            '<a class="page-link" href="#" data-page="' + (paginaActual + 1) + '" aria-label="Siguiente">' +
            '<span aria-hidden="true">&raquo;</span>' +
            '</a>' +
            '</li>'
        );

        $('#paginacion ul').addClass('pagination-custom');
    }

    function mostrarResultados(response) {
        console.log("Respuesta del servidor:", response); 
        $('#resultados').show();
        var tablaResultados = $('#tablaResultados');
        tablaResultados.empty(); 

        var procedimientoSeleccionado = $('#procedimientos').val(); 
        var dataProcedimiento = response.data[procedimientoSeleccionado]; 

        console.log("Datos del procedimiento:", dataProcedimiento);

        if (!dataProcedimiento || dataProcedimiento.length === 0) {
  
            tablaResultados.html('<div class="alert alert-info">No se encontraron registros.</div>');
            return;
        }

        var columnOrder = dataProcedimiento[0].__COLUMN_ORDER__; 
        if (!columnOrder || columnOrder.length === 0) {
            console.warn("No se encontró __COLUMN_ORDER__. Generando orden de columnas dinámicamente...");
            columnOrder = Object.keys(dataProcedimiento[0]); 
        }

        console.log("Orden de columnas:", columnOrder); 

        if (dataProcedimiento[0].__COLUMN_ORDER__) {
            dataProcedimiento = dataProcedimiento.slice(1); 
        }

        var tabla = $('<table class="table table-striped table-bordered table-bordered-red"></table>'); 
        var thead = $('<thead class="thead-red text-white"></thead>'); 
        var tbody = $('<tbody></tbody>');
        var headerRow = $('<tr></tr>'); 

        // Agrega las columnas al encabezado
        columnOrder.forEach(function(header) {
            headerRow.append('<th>' + header + '</th>');
        });
        thead.append(headerRow);
        tabla.append(thead);

        dataProcedimiento.forEach(function(registro) {
            var row = $('<tr></tr>');
            columnOrder.forEach(function(header) {
                var valor = registro[header];

                if (typeof valor === 'string' && valor.startsWith('data:image')) {

                    row.append('<td><img src="' + valor + '" width="100"></td>');
                } else {
                    row.append('<td>' + (valor !== null ? valor : '') + '</td>');
                }
            });
            tbody.append(row);
        });

        tabla.append(tbody);
        tablaResultados.append(tabla); 
    }
});
</script>
    </body>
</html>