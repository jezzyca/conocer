<%-- 
    Document   : busqueda
    Created on : 10/02/2025, 01:52:01 PM
    Author     : Conocer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="busqueda.BusquedaPW"%>
<jsp:useBean id="BusquedaPW" class="busqueda.BusquedaPW" scope="page" />
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page session="true" %>
<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Reportes ECE</title>
        <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap JS Bundle con Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script>
        </script>
    </head>
    <body id="fondoBodyReportes">
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
                            <li><a class="dropdown-item" href="cambioContrasena.jsp">Cambiar Contraseña</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="Logout" onclick="cerrarSesion(); return false;">Cerrar sesión</a></li>
                        </ul>
                    </div>


                    <div class="btn-group ms-3">
                        <button type="button" class="btn btn-danger dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
                            Datos Generales <i class="fa-brands fa-windows ms-2 align-middle"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="procesoEvaluacion.jsp">Reportes</a></li>
                            <li><a class="dropdown-item" href="repECMarca.jsp">Reportes EC Marca</a></li>
                            <li><a class="dropdown-item" href="estadisticas.jsp">Comportamiento</a></li>
                        </ul>
                    </div>
                </div>

                <div class="col-3 d-flex justify-content-end align-items-center ms-auto">
                    <img src="img/userpersona.png" alt="Imagen usuario" class="rounded-circle me-2" width="55" style="cursor: pointer;" data-bs-toggle="dropdown">
                    <div class="media-body">
                        <h6 class="mb-0 usuario-nombre small">
                            Usuario: <c:out value="${sessionScope.usuario}" />
                        </h6>
                        <small class="text-muted usuario-fecha">
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

       <div class="container bg-light rounded shadow-sm d-flex flex-column justify-content-center align-items-center my-4">
            <div class="row my-4">
                <div class="col-12">
                    <h3 class="text-center">Búsqueda</h3>
                </div>
            </div>
            
            <!-- Botones de navegación -->
            <div class="row text-center mb-4">
                <div class="col-md-4 d-flex flex-column align-items-center">
                    <button type="button" class="btn btn-outline-danger small-button" id="accUs">
                        <img class="imagebuton" src="img/Acceso.png" alt="Accesos de Evaluador" width="65" height="65">
                    </button>
                    <label class="mt-2">Accesos de Evaluador</label>
                </div>
                <div class="col-md-4 d-flex flex-column align-items-center">
                    <button type="button" class="btn btn-outline-danger small-button" id="solCert">
                        <img class="imagebuton" src="img/buscarSC.png" alt="Solicitud Certificado" width="65" height="65">
                    </button>
                    <label class="mt-2">Estatus Solicitud Certificado</label>
                </div>
                <div class="col-md-4 d-flex flex-column align-items-center">
                    <button type="button" class="btn btn-outline-danger" id="accCentEv">
                        <img class="imagebuton" src="img/iecxusuario.png" alt="Centros de Evaluación" width="65" height="65">
                    </button>
                    <label class="mt-2">Accesos Centros de Evaluación</label>
                </div>
            </div>

            <!-- Formulario Accesos de Evaluador -->
            <form action="BusquedaPW" method="post" id="formAccEvaluador" class="${sessionScope.formActivo == 'formAccEvaluador' ? '' : 'd-none'}">
                <input type="hidden" name="formType" value="accEvaluador">
                <input type="hidden" name="formActivo" value="formAccEvaluador">
                <div class="container" id="accEvaluador">
                    <h4 class="left-center mb-4">Accesos de Evaluador</h4>
                    
                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="razonsocial" class="form-label">Razón Social:</label>
                            <input type="text" id="razon" name="razonsocial" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="acreditacion" class="form-label">Cédula:</label>
                            <input type="text" id="cedula" name="acreditacion" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="nombre" class="form-label">Nombre:</label>
                            <input type="text" id="nombre" name="nombre" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="paterno" class="form-label">A. Paterno:</label>
                            <input type="text" id="paterno" name="paterno" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label for="materno" class="form-label">A. Materno:</label>
                            <input type="text" id="materno" name="materno" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="rfc" class="form-label">R.F.C:</label>
                            <input type="text" id="rfc" name="rfc" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="curp" class="form-label">CURP:</label>
                            <input type="text" id="curp" name="curp" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="siglas" class="form-label">Siglas:</label>
                            <input type="text" id="siglas" name="siglas" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-4 d-flex justify-content-center">
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-info btn-sm w-50">
                                <i class="fas fa-search me-2 text-center"></i>Buscar
                            </button>
                        </div>
                        <div class="col-md-6 d-flex justify-content-center">
                            <button type="button" class="btn btn-secondary  btn-sm w-50" id="btnNuevaBusqueda">
                                <i class="fas fa-redo me-2 text-center"></i>Nueva Búsqueda
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <!-- Formulario Solicitud de Certificados -->
            <form action="BusquedaPW" method="post" id="formSolCertificado" class="${sessionScope.formActivo == 'formSolCertificado' ? '' : 'd-none'}">
                <input type="hidden" name="formType" value="solCertificado">
                <input type="hidden" name="formActivo" value="formSolCertificado">
                <div class="container" id="solCertificado">
                    <h4 class="left-center mb-4">Estatus de Solicitud de Certificados</h4>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="DS_CURP" class="form-label">CURP:</label>
                            <input type="text" id="DS_CURP" name="DS_CURP" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label for="ESTANDAR_COMP" class="form-label">Estándar:</label>
                            <input type="text" id="ESTANDAR_COMP" name="ESTANDAR_COMP" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="NOMBRE" class="form-label">Nombre:</label>
                            <input type="text" id="NOMBRE" name="NOMBRE" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="APELLIDO_P" class="form-label">A. Paterno:</label>
                            <input type="text" id="APELLIDO_P" name="APELLIDO_P" class="form-control">
                        </div>
                        <div class="col-md-4">
                            <label for="APELLIDO_M" class="form-label">A. Materno:</label>
                            <input type="text" id="APELLIDO_M" name="APELLIDO_M" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-md-6 d-flex justify-content-center"">
                            <button type="submit" class="btn btn-info btn-sm w-50">
                                <i class="fas fa-search me-2"></i>Buscar
                            </button>
                        </div>
                        <div class="col-md-6 d-flex justify-content-center"">
                            <button type="reset" class="btn btn-secondary btn-sm w-50" id="btnNuevaBusqueda">
                                <i class="fas fa-redo me-2"></i>Nueva Búsqueda
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <!-- Formulario Centros de Evaluación -->
            <form action="BusquedaPW" method="post" id="formAccCentros" class="${sessionScope.formActivo == 'formAccCentros' ? '' : 'd-none'}">
                <input type="hidden" name="formType" value="accCentros">
                <input type="hidden" name="formActivo" value="formAccCentros">
                <div class="container" id="accCentEval">
                    <h4 class="left-center mb-4">Accesos Centros de Evaluación</h4>
                    
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="razonCentro" class="form-label">Razón Social:</label>
                            <input type="text" id="razonsocial" name="razonsocial" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label for="siglas" class="form-label">Siglas:</label>
                            <input type="text" id="siglas" name="siglas" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="rfc" class="form-label">RFC:</label>
                            <input type="text" id="rfc" name="rfc" class="form-control">
                        </div>
                        <div class="col-md-6">
                            <label for="cedula" class="form-label">Cédula Centro:</label>
                            <input type="text" id="cedula" name="cedula" class="form-control">
                        </div>
                    </div>

                    <div class="row mb-4 d-flex justify-content-center"">
                        <div class="col-md-6">
                            <button type="submit" class="btn btn-info w-100">
                                <i class="fas fa-search me-2"></i>Buscar
                            </button>
                        </div>
                        <div class="col-md-6 d-flex justify-content-center"">
                            <button type="button" class="btn btn-secondary w-100" id="btnNuevaBusqueda">
                                <i class="fas fa-redo me-2"></i>Nueva Búsqueda
                            </button>
                        </div>
                    </div>
                </div>
            </form>

            <!-- Tabla de resultados -->
            <c:if test="${not empty resultados}">
                <div class="container mt-4" id="tablaResultados">
                    <h3 class="text-center mb-4">Resultados de la Búsqueda</h3>
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered">
                            <thead class="table-primary">
                                <tr>
                                    <c:forEach var="entry" items="${resultados[0]}">
                                        <th>${entry.key}</th>
                                    </c:forEach>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="resultado" items="${resultados}">
                                    <tr>
                                        <c:forEach var="entry" items="${resultado}">
                                            <td>${entry.value}</td>
                                        </c:forEach>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:if>

            <!-- Mensajes -->
            <div class="container mt-3">
                <c:if test="${not empty mensaje}">
                    <div class="alert alert-info">${mensaje}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
            </div>
        </div>
                
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




    </body>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <script>
    $(document).ready(function() {
                // Verificar si hay un formulario activo guardado en la sesión
                const formActivoGuardado = '${sessionScope.formActivo}';
                
                // Función para mostrar el formulario seleccionado
                function showForm(formId) {
                    // Ocultar todos los formularios
                    $('#formAccEvaluador, #formSolCertificado, #formAccCentros').addClass('d-none');
                    
                    // Mostrar el formulario seleccionado
                    $(formId).removeClass('d-none');
                    
                    // Actualizar el input hidden del formulario activo
                    $('input[name="formActivo"]').val(formId.replace('#', ''));
                }

                // Función para limpiar formulario
                function limpiarFormulario(formId) {
                    $(formId).find('input[type="text"]').val('');
                    $(formId).find('select').prop('selectedIndex', 0);
                }

                // Función para ocultar la tabla de resultados
                function ocultarTabla() {
                    $('#tablaResultados').hide();
                    $('.alert').remove();
                }

                // Event listeners para los botones principales
                $('#accUs').click(function() {
                    showForm('#formAccEvaluador');
                    ocultarTabla();
                });

                $('#solCert').click(function() {
                    showForm('#formSolCertificado');
                    ocultarTabla();
                });

                $('#accCentEv').click(function() {
                    showForm('#formAccCentros');
                    ocultarTabla();
                });

                // Event listener para el botón de Nueva Búsqueda
                $('.btnNuevaBusqueda').click(function() {
                    const formActual = $(this).closest('form').attr('id');
                    limpiarFormulario('#' + formActual);
                    ocultarTabla();
                });

                // Validación de formularios
                $('form').on('submit', function(e) {
                    let isValid = false;
                    $(this).find('input[type="text"]').each(function() {
                        if ($(this).val().trim() !== '') {
                            isValid = true;
                            return false;
                        }
                    });

                    if (!isValid) {
                        e.preventDefault();
                        alert('Por favor, complete al menos un campo de búsqueda.');
                    }
                });

                // Mostrar el formulario activo al cargar la página
                if (formActivoGuardado) {
                    showForm('#' + formActivoGuardado);
                } else {
                    // Si no hay formulario activo, mostrar el primero por defecto
                    showForm('#formAccEvaluador');
                }
            });
    </script>
</html>

