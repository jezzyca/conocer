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
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
        <!-- Compiled and minified CSS -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
        <!-- Bootstrap JS Bundle con Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    </head>
    <body id="fondoBodyReportes">
        <br>
        <!-- Encabezado principal -->
        <div class="container-fluid">
            <div class="row align-items-center d-flex"> <!-- Agregamos d-flex aquí -->
                <!-- Logo a la izquierda -->
                <div class="col-3 d-flex justify-content-start align-items-center">
                    <a href="index.html" class="brand-logo">
                        <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                    </a>
                </div>

                <!-- Menú central con dropdowns -->
                <div class="col-7 d-flex justify-content-center align-items-center">
                    <!-- Dropdown Cuenta -->
                    <div class="btn-group">
                        <button type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false">
                            Cuenta&nbsp;&nbsp;<i class="fa-solid fa-user"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="cambioContrasena.html">Cambiar Contraseña</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="Logout" onclick="cerrarSesion(); return false;">Cerrar sesión</a></li>
                        </ul>
                    </div>

                    <!-- Menú dinámico -->
                    <div class="btn-group ms-3">
                        <button type="button" class="btn btn-danger dropdown-toggle" data-bs-toggle="dropdown">
                            Datos Generales&nbsp;&nbsp;<i class="fa-brands fa-windows"></i>
                        </button>
                        <ul class="dropdown-menu">
                            <c:if test="${sessionScope.tipoUsuario == '4FEBADDD-951A-4594-BDCC-D5EEEDB11FCD' or sessionScope.tipoUsuario == 'reportes'}">
                                <li><a class="dropdown-item" href="estadisticas.html">Estadísticas</a></li>
                                <li><hr class="dropdown-divider"></li>
                                </c:if>

                            <c:if test="${sessionScope.tipoUsuario == '4FEBADDD-951A-4594-BDCC-D5EEEDB11FCD'}">
                                <li class="dropend">
                                    <a class="dropdown-item dropdown-toggle" href="#" data-bs-toggle="dropdown">Reportes</a>
                                    <ul class="dropdown-menu">
                                        <li><a class="dropdown-item" href="reportesECE.html">Reportes EC Marca</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="reportesSII.jsp">Reportes</a></li>
                                    </ul>
                                </li>
                            </c:if>

                            <c:if test="${sessionScope.tipoUsuario == '091FFD8E-1C76-4723-B581-C67A99F0EC87'}">
                                <li><a class="dropdown-item" href="directorio.jsp">Reportes</a></li>
                                </c:if>
                            <c:if test="${sessionScope.tipoUsuario == '7459EE4B-B783-43CD-84EB-F8DFED5E56DC'}">
                                <li><a class="dropdown-item" href="directorioAdministrador.jsp">Administrar Usuarios</a></li>
                                </c:if>
                        </ul>
                    </div>
                </div>

                <!-- Perfil Usuario a la derecha -->
                <div class="col-2 d-flex justify-content-center justify-content-md-end align-items-center">
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
        </div>

        <br>



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



    </body>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
</html>