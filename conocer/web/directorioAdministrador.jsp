<%-- 
    Document   : directorioAdministrador
    Created on : 9/01/2025, 06:10:33 PM
    Author     : Conocer
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="reportes.Usuario" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- Redirigir al login si no hay sesión activa -->
<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Directorio Admin</title>

    <!-- Favicon -->
    <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
    <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
    <!-- CSS Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

</head>
<body id="fondoBodyReportes2">
    <br>
    <div class="container-fluid">
        <div class="row align-items-center mb-4">
            <div class="col-md-3">
                <a href="informesMensuales.jsp" class="brand-logo">
                    <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                </a>
            </div>
            <div class="col-md-6 text-center">
                <h4 id="directory-title">Directorio de Usuarios</h4>
            </div>
            <div class="col-md-3 text-start">
                <div class=" col-s2 d-flex justify-content-center justify-content-md-end align-items-center">
                    <img src="img/userpersona.png" alt="Usuario" class="rounded-circle me-2" style="width: 40px">
                    <div>
                        <div class="small">Usuario: ${sessionScope.usuario}</div>
                        <div class="small text-muted">Fecha: ${sessionScope.fecha}</div>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong>Error:</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty mensaje}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${mensaje}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <div class="card mb-4">
            <div class="card-header">
                <h5 class="mb-0">Agregar Nuevo Usuario</h5>
            </div>
            <div class="card-body">
                <form action="DirectorioAdministrador" method="post" class="row g-3" onsubmit="return validarFormulario()">
                    <input type="hidden" name="action" value="alta">
                    <div class="col-md-5">
                        <input type="text" name="username" class="form-control" placeholder="Nombre de usuario" required
                               pattern="[A-Za-z0-9._]{3,}" title="El usuario debe tener al menos 3 caracteres y solo puede contener letras, números y guiones bajos">
                    </div>
                    <div class="col-md-5">
                        <input type="password" name="password" class="form-control" placeholder="Contraseña" required
                               minlength="6" title="La contraseña debe tener al menos 6 caracteres">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-secondary w-100">Agregar Usuario</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">Usuarios Registrados</h5>
                <a href="DirectorioAdministrador" class="btn btn-secondary btn-sm">
                    <i class="material-icons"></i>Ver Lista de Usuarios
                </a>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Usuario</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:if test="${not empty usuarios}">
                                <c:forEach var="usuario" items="${usuarios}">
                                    <tr>
                                        <td>${usuario.id}</td>
                                        <td>${usuario.access}</td>
                                        <td>
                                            <span class="badge ${usuario.status eq 'aS' ? 'bg-success text-white' : 'bg-danger text-white'}">
                                                ${usuario.status eq 'aS' ? 'Activo' : 'Activo'}
                                            </span>

                                        </td>
                                        <td>
                                <center>
                                            <form action="DirectorioAdministrador" method="post" class="d-inline">
                                                <input type="hidden" name="action" value="eliminar">
                                                <input type="hidden" name="id" value="${usuario.id}">
                                                <button type="submit" class="btn btn-danger btn-sm" 
                                                        onclick="return confirm('¿Está seguro de eliminar este usuario?')">
                                                    <i class="material-icons">delete</i> Eliminar
                                                </button>
                                            </form>
                                            <button type="button" class="btn btn-warning btn-sm" 
                                                    data-bs-toggle="modal" data-bs-target="#editarModal"
                                                    data-id="${usuario.id}" data-username="${usuario.access}">
                                                <i class="material-icons">edit</i> Editar
                                            </button>
                                </center>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            <c:if test="${empty usuarios}">
                                <tr id="promptMessage">
                                    <td colspan="4" class="text-center">Da click en ver lista de usuarios.</td>
                                </tr>
                            </c:if>
                                <tr id="loadingIndicator" style="display: none;">
                                    <td colspan="4" class="text-center">
                                        <div class="spinner-border text-primary" role="status">
                                            <span class="visually-hidden">Cargando...</span>
                                        </div>
                                        <p>Cargando, por favor espera...</p>
                                    </td>
                                </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
                    
   <!-- Modal para editar -->
<div class="modal fade" id="editarModal" tabindex="-1" aria-labelledby="editarModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editarModalLabel">Editar Usuario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="DirectorioAdministrador" method="post">
                    <input type="hidden" name="action" value="editar">
                    <input type="hidden" id="usuarioId" name="id">
                    <div class="mb-3">
                        <label for="username" class="form-label">Nuevo Nombre de Usuario</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <button type="submit" class="btn btn-primary">Guardar cambios</button>
                </form>
            </div>
        </div>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>

    <script>
function handleButtonVisibility() {
    const buttons = document.querySelectorAll('a.btn-secondary.btn-sm');
    const loadingIndicator = document.getElementById('loadingIndicator');
    const promptMessage = document.getElementById('promptMessage'); // Texto que se oculta

    const isDirectorioPage = window.location.href.includes('DirectorioAdministrador');

    buttons.forEach(button => {
        if (button.textContent.trim().includes('Ver Lista de Usuarios')) {
            const buttonState = localStorage.getItem('listButtonState');
            if (buttonState === 'hidden' && isDirectorioPage) {
                button.style.display = 'none';
            }

            button.addEventListener('click', function(event) {
                event.preventDefault();

                if (promptMessage) {
                    promptMessage.style.display = 'none';
                }

                loadingIndicator.style.display = 'table-row';

                localStorage.setItem('listButtonState', 'hidden');
                this.style.display = 'none';

                setTimeout(() => {
                    window.location.href = this.getAttribute('href');
                }, 500); 
            });
        }
    });
}


document.addEventListener('DOMContentLoaded', handleButtonVisibility);

window.addEventListener('load', handleButtonVisibility);

window.addEventListener('popstate', function() {
    if (!window.location.href.includes('DirectorioAdministrador')) {
        localStorage.removeItem('listButtonState');
    }
});


window.addEventListener('beforeunload', function() {
    if (!window.location.href.includes('DirectorioAdministrador')) {
        sessionStorage.removeItem('buttonClicked');
    }
});

        
    function validarFormulario() {
        var username = document.getElementsByName('username')[0].value;
        var password = document.getElementsByName('password')[0].value;
        
        if (username.length < 3) {
            alert('El nombre de usuario debe tener al menos 3 caracteres');
            return false;
        }
        
        if (!/^[A-Za-z0-9._]+$/.test(username)) {
            alert('El nombre de usuario solo puede contener letras, números y guiones bajos');
            return false;
        }
        
        if (password.length < 6) {
            alert('La contraseña debe tener al menos 6 caracteres');
            return false;
        }
        
        return true;
    }
 
    document.addEventListener('DOMContentLoaded', function() {
        var elems = document.querySelectorAll('.modal');
        M.Modal.init(elems);
        
     
        setTimeout(function() {
            var alertas = document.querySelectorAll('.alert');
            alertas.forEach(function(alerta) {
                var alert = bootstrap.Alert.getOrCreateInstance(alerta);
                alert.close();
            });
        }, 5000);
    });

    var editarModal = document.getElementById('editarModal')
    editarModal.addEventListener('show.bs.modal', function (event) {
        var button = event.relatedTarget
        var userId = button.getAttribute('data-id')
        var username = button.getAttribute('data-username')

        var modalBodyInput = editarModal.querySelector('.modal-body #usuarioId')
        var modalBodyUsername = editarModal.querySelector('.modal-body #username')

        modalBodyInput.value = userId
        modalBodyUsername.value = username
    })
</script>

</body>
</html>