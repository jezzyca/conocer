<%-- 
    Document   : registroDescuentos
    Created on : 12/05/2025, 11:45:53 AM
    Author     : Conocer
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <title>Registro de descuentos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    </head>
    <body>
    <div class="container-fluid">
        <div class="row align-items-center d-flex">
            <div class="col-3 d-flex justify-content-start align-items-center">
                <a href="informesMensuales.jsp" class="brand-logo">
                    <img src="img/Logo-Conocer.png" class="responsive-img" alt="Logo Conocer">
                </a>
            </div>

            <div class="col-7 d-flex justify-content-center align-items-center">
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

            <div class="col-2 d-flex justify-content-end align-items-center">
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
                            <i class="fa-solid fa-calendar-days"></i>
                            <c:out value="${sessionScope.fecha}" /><br>
                            <span id="hora-actual"></span>
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
    </div>
                            
    <div class="container mt-5">
        <h4>Registro Masivo de Estándares desde Excel</h4>
        <form action="${pageContext.request.contextPath}/DirectorioDescuentos" id="formularioExcel" method="POST" enctype="multipart/form-data">
          <div class="mb-3">
            <label for="archivoExcel" class="form-label">Seleccionar archivo Excel</label>
            <input type="file" class="form-control" name="archivoExcel" id="archivoExcel" required>
          </div>
          <button type="submit" class="btn btn-primary">Subir y Guardar</button>
        </form>
    </div>
          
          <div id="modalExito" style="display:none; position:fixed; top:30%; left:30%; background:white; padding:20px; border:2px solid green; z-index:9999;">
              <p id="mensajeModal"></p>
              <button onclick="cerrarModal()">Cerrar</button>
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
    </body>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWIX+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkcmfRyVX3pBnMFcV7oQPJkl9QevSCWr3W6A==" crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <script>     
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
    
    const formulario = document.getElementById('formularioExcel');
  formulario.addEventListener('submit', function(e) {
    e.preventDefault(); 

    const formData = new FormData(formulario);

    fetch('DirectorioDescuentos', {
      method: 'POST',
      body: formData
    })
    .then(response => response.text())
    .then(texto => {
      document.getElementById('archivoExcel').value = '';
      mostrarModal(texto);
    })
    .catch(error => {
      mostrarModal('❌ Error al enviar archivo: ' + error);
    });
  });

  function mostrarModal(mensaje) {
    document.getElementById('mensajeModal').innerText = mensaje;
    document.getElementById('modalExito').style.display = 'block';
  }

  function cerrarModal() {
    document.getElementById('modalExito').style.display = 'none';
  }
    </script>
</html>
