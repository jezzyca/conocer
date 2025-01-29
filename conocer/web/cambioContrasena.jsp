<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="org.json.JSONObject, org.json.JSONArray" %>
<%@ page import="validaciones.UpdatePassword" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Actualizar Contraseña</title>
    <link rel="icon" type="image/png" href="img/favicon-96x96.png">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="styles/estilos_reporteador.css">
</head>
<body id="fondoBodyReportes2" class="d-flex flex-column min-vh-100">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg bg-white shadow-sm">
        <div class="container-fluid">
            <a href="informesMensuales.jsp" class="navbar-brand">
                <img src="img/Logo-Conocer.png" alt="Logo Conocer" height="50">
            </a>
            <div class="navbar-nav">
                <div class="nav-item dropdown">
                    <button class="btn btn-danger dropdown-toggle d-flex align-items-center justify-content-center" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person me-2"></i> Cuenta
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="cambioContrasena.jsp">Cambiar Contraseña</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="login.jsp" id="logoutBtn">Cerrar sesión</a></li>
                    </ul>
                </div>
            </div>
            <div class="d-flex align-items-center">
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
    </nav>

    <!-- Contenido Principal -->
    <div class="container my-4">
        <h2 class="text-center text-danger mb-4">Actualiza tu Contraseña</h2>
        
        <div class="row justify-content-center">
            <div class="col-md-6">
                <form id="updatePasswordForm" class="bg-white rounded shadow p-4">
                    <input type="hidden" id="username" name="username" value="<c:out value='${sessionScope.usuario}'/>">
                    
                    <div class="mb-3">
                        <label for="newPassword" class="form-label">Nueva Contraseña</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="8">
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Confirmar Contraseña</label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required minlength="8">
                            <button class="btn btn-outline-secondary" type="button" id="toggleConfirmPassword">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div id="message" class="alert d-none"></div>
                    
                    <div class="password-requirements mb-3">
                        <h6 class="text-muted">La contraseña debe cumplir:</h6>
                        <ul class="small text-muted">
                            <li>Mínimo 8 caracteres</li>
                            <li>Al menos una letra mayúscula</li>
                            <li>Al menos una letra minúscula</li>
                            <li>Al menos un número</li>
                            <li>Las contraseñas deben coincidir</li>
                        </ul>
                    </div>

                    <div class="d-grid">
                        <button type="submit" class="btn btn-danger">Actualizar Contraseña</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="mt-auto py-3 bg-light">
        <div class="container">
            <div class="row align-items-center text-center">
                <div class="col-md-4">
                    <img src="img/sep.png" alt="Logo SEP" class="img-fluid" style="max-height: 60px;">
                </div>
                <div class="col-md-4">
                    <p class="small mb-1">•2025•©CONOCER, MÉXICO•</p>
                    <p class="small mb-1">•Barranca del Muerto 275, Ciudad de México•</p>
                </div>
                <div class="col-md-4">
                    <img src="img/conocerLogo.png" alt="Logo CONOCER" class="img-fluid" style="max-height: 60px;">
                </div>
            </div>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
     // Primero definimos todas las funciones necesarias
function showMessage(type, message) {
    const messageElement = document.getElementById("message");
    messageElement.classList.remove("d-none", "alert-success", "alert-danger");
    messageElement.classList.add("alert", type === "success" ? "alert-success" : "alert-danger");
    messageElement.textContent = message;
}

function togglePassword(inputId, buttonId) {
    const passwordInput = document.getElementById(inputId);
    const icon = document.querySelector(`#${buttonId} i`);
    
    if (passwordInput.type === "password") {
        passwordInput.type = "text";
        icon.classList.remove("bi-eye");
        icon.classList.add("bi-eye-slash");
    } else {
        passwordInput.type = "password";
        icon.classList.remove("bi-eye-slash");
        icon.classList.add("bi-eye");
    }
}


document.addEventListener('DOMContentLoaded', function() {
 
    document.getElementById("updatePasswordForm").addEventListener("submit", function(event) {
        event.preventDefault();

        const username = document.getElementById("username").value.trim();
        const newPassword = document.getElementById("newPassword").value.trim();
        const confirmPassword = document.getElementById("confirmPassword").value.trim();


        if (!username || !newPassword || !confirmPassword) {
            showMessage("error", "Todos los campos son obligatorios.");
            return;
        }
        
        const passwordRegex = /^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d]{8,}$/;
        if (!passwordRegex.test(newPassword)) {
            showMessage("error", "La contraseña debe cumplir con todos los requisitos de seguridad");
            return;
        }

        if (newPassword !== confirmPassword) {
            showMessage("error", "Las contraseñas no coinciden");
            return;
        }

        const data = new URLSearchParams();
        data.append("username", username);
        data.append("newPassword", newPassword);
        data.append("confirmPassword", confirmPassword);

        fetch("${pageContext.request.contextPath}/UpdatePassword", {
            method: "POST",
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: data
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Error en la respuesta del servidor');
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showMessage("success", data.message);
                setTimeout(() => {
                    window.location.href = "login.jsp";
                }, 2000);
            } else {
                showMessage("error", data.message || "Error al actualizar la contraseña");
            }
        })
        .catch(error => {
            console.error("Error:", error);
            showMessage("error", "Error al procesar la solicitud");
        });
    });

    document.getElementById("togglePassword").addEventListener("click", function() {
        togglePassword("newPassword", "togglePassword");
    });

    document.getElementById("toggleConfirmPassword").addEventListener("click", function() {
        togglePassword("confirmPassword", "toggleConfirmPassword");
    });

    // Event listener para el botón de cerrar sesión
    document.getElementById("logoutBtn").addEventListener("click", function() {
        window.location.href = "logout.jsp";
    });
});
    </script>
</body>
</html>