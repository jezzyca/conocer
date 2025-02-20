<%-- 
    Document   : informesMensuales
    Created on : 9/01/2025, 06:10:33 PM
    Author     : Conocer
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>
<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Informes</title>
        <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body id="fondoBodyReportes">
        <br>
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
                            <c:if test="${sessionScope.tipoUsuario == '4FEBADDD-951A-4594-BDCC-D5EEEDB11FCD'}">
                                <li><a class="dropdown-item" href="reportesSII.jsp">Reportes</a></li>
                                <li><a class="dropdown-item" href="repECMarca.jsp">Reportes EC Marca</a></li>
                                <li><a class="dropdown-item" href="estadisticas.jsp">Comportamiento</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '091FFD8E-1C76-4723-B581-C67A99F0EC87'}">
                                <li><a class="dropdown-item" href="directorio.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '24acc47d-d42c-11ef-a4c6-000c296c6b68'}">
                                <li><a class="dropdown-item" href="directorioAdministrador.jsp">Administrar Usuarios</a></li>
                                <li><a class="dropdown-item" href="reportesSII.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == 'DF06A990-84EF-4443-8185-77F68F6500BD'}">
                                <li><a class="dropdown-item" href="impresion.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '2AE2D0AF-DD99-4B0B-A000-073FE17EDE79'}">
                                <li><a class="dropdown-item" href="procesoEvaluacion.jsp">Reportes</a></li>
                                <li><a class="dropdown-item" href="estadisticas.jsp">Comportamiento</a></li>
                                <li><a class="dropdown-item" href="busqueda.jsp">Busqueda</a>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == 'D3625435-5295-4349-976C-12787488AC5B'}">
                                <li><a class="dropdown-item" href="institucionesAcred.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '0AD4C2A2-59A5-481C-A501-8E3F2BDEE1E6'}">
                                <li><a class="dropdown-item" href="certificadosMarca.jsp">Reportes</a></li>
                                <li><a class="dropdown-item" href="estadisticas.jsp">Comportamiento</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '7B08059B-E39F-4007-9871-EA1EAB1045EF'}">
                                <li><a class="dropdown-item" href="reportesSector.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == '7459EE4B-B783-43CD-84EB-F8DFED5E56DC'}">
                                <li><a class="dropdown-item" href="informesEjecutivo.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == 'E6D10215-1531-482F-8AB7-D5497BD8E9DC'}">
                                <li><a class="dropdown-item" href="reporteSolicitud.jsp">Reportes</a></li>
                                <li><a class="dropdown-item" href="busqueda.jsp">Busqueda</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == 'CA9A6633-D971-4FEC-B379-0B8CDC859C0E'}">
                                <li><a class="dropdown-item" href="reportesSolicitudFinanzas.jsp">Reportes</a></li>
                                </c:if>
                                <c:if test="${sessionScope.tipoUsuario == 'FAA8565B-A5E5-4F16-A264-4335D5888B25'}">
                                <li><a class="dropdown-item" href="reportesCertificados.jsp">Reportes</a></li>
                                </c:if>
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
        <br>
        
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
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
</html>