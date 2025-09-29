<%-- 
    Document   : Login
    Created on : 9/01/2025, 06:10:33 PM
    Author     : Conocer
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Acceso</title>
    <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
</head>
<body id="fondoBody">

<div class="container d-flex justify-content-center align-items-center vh-100">
    <div class="card shadow-sm p-4" style="width: 400px; height: 380px; background-color: black; border-color: white; opacity: 0.9">
        <div class="card-header text-center">
            <img src="img/logo_cono2.png" class="img-fluid" alt="Logo" style="max-width: 320px; margin: auto;">
        </div>
        <div class="card-body">
            <form id="loginForm" method="post" action="ValidarUsuarios">
                <div class="mb-3">
                    <label for="usuario" class="form-label" style="color: white">Usuario:</label>
                    <input type="text" class="form-control" id="usuario" name="usuario" required>
                </div>
                <div class="mb-3">
                    <label for="contrasena" class="form-label" style="color: white">Contraseña:</label>
                    <input type="password" class="form-control" id="contrasena" name="contrasena" required>
                </div>
                <div class="d-grid text-center">
                    <button type="submit" class="btn btn-danger btn-sm">Iniciar Sesión</button>
                </div>
            </form>
        </div>
    </div>
</div>

<%
    String error = (String) session.getAttribute("error");
    if (error != null) { 
%>
<div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-labelledby="errorModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="errorModalLabel">Error</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Cerrar">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <%= error %>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>
<%
        session.removeAttribute("error");
    }
%>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function () {
        <% if (error != null) { %>
            $('#errorModal').modal('show');
        <% } %>
    });
</script> 
</body>
</html>
