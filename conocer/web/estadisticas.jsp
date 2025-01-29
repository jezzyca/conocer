<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="true" %>

<c:if test="${sessionScope.usuario == null}">
    <c:redirect url="login.jsp" />
</c:if>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>ReportesSII</title>
    <link rel="icon" type="image/png" sizes="96x96" href="img/favicon-96x96.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css">
    <link rel="stylesheet" type="text/css" href="styles/estilos_reporteador.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body id="fondoBodyReportes2">
    <br>
    <div id="loadingSpinner" class="position-fixed top-50 start-50 translate-middle" style="display: none; z-index: 1000;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Cargando...</span>
        </div>
    </div>

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
                        <li><a class="dropdown-item" href="directorioAdministrador.jsp">Administrar Usuarios</a></li>
                        <li><a class="dropdown-item" href="reportesSII.jsp">Reportes</a></li>
                    </ul>
                </div>
            </div>

            <div class="col-2 d-flex justify-content-end align-items-center ms-auto">
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

    <div class="container-fluid d-flex flex-column align-items-center mt-4">
        <div class="d-flex align-items-center gap-3">
            <div class="row" id="fondoGrafica">
                <div class="col text-center align-items-center">
                    <button type="button" class="btn btn-success" id="btnEstado">
                        Por Estado<i class="bi bi-map"></i>
                    </button>
                    &nbsp;
                    <button type="button" class="btn btn-danger" id="btnEce">
                        Por ECE/OC<i class="bi bi-wifi"></i>
                    </button>
                    &nbsp;
                    <button type="button" class="btn btn-warning" id="btnExamen">
                        Por Exámen<i class="bi bi-card-checklist"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>


    <div id="graficasContainer" class="container-fluid">
        <div class="chart-container">
            <canvas id="mainChart"></canvas>
        </div>
    </div>

    <footer class="container-fluid py-3 bg-light mt-4">
        <div class="row align-items-center text-center">
            <div class="col-md-3">
                <img src="img/sep.png" alt="Logo SEP" class="img-fluid" style="max-height: 60px;">
            </div>
            <div class="col-md-6">
                <p class="small mb-1">•2025•©CONSEJO NACIONAL DE NORMALIZACIÓN Y CERTIFICACIÓN DE COMPETENCIAS LABORALES. MÉXICO•</p>
                <p class="small mb-1">•Barranca del Muerto 275, San José Insurgentes, Benito Juárez, 03900 Ciudad de México, D.F. 01 55 2282 0200</p>
                <a href="#" class="small text-decoration-none">• CONOCER •</a>
            </div>
            <div class="col-md-3">
                <img src="img/conocerLogo.png" alt="Logo CONOCER" class="img-fluid" style="max-height: 60px;">
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/js/materialize.min.js"></script>
    <script>
        
 document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('btnEstado').addEventListener('click', () => cargarDatos('estado'));
    document.getElementById('btnEce').addEventListener('click', () => cargarDatos('ece'));
    document.getElementById('btnExamen').addEventListener('click', () => cargarDatos('examen'));
});

function cargarDatos(tipo) {
    console.log("Iniciando carga de datos para tipo:", tipo);
    
    if (!tipo || tipo.trim() === '') {
        console.error('Tipo no válido:', tipo);
        alert('Error: Tipo de datos no especificado');
        return;
    }

    showSpinner();
    
    fetch('Comportamiento?tipo=' + tipo, {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Cache-Control': 'no-cache'
        }
    })
    .then(response => {
        console.log("Status de la respuesta:", response.status);
        if (!response.ok) {
            throw new Error(`Error del servidor: ${response.status}`);
        }
        return response.json();
    })
    .then(data => {
        console.log("Datos recibidos:", data);
        if (data.error) {
            throw new Error(data.message || 'Error en el servidor');
        }
        createChart(tipo, data.data || data);
    })
    .catch(error => {
        console.error('Error en la petición:', error);
        alert('Error al cargar los datos: ' + error.message);
    })
    .finally(() => {
        hideSpinner();
    });
}

    cargarDatos('estado');
    
            let currentChart = null;
            
    const chartConfigs = {
    estado: {
        titulo: 'Certificados por Entidad Federativa',
        color: 'rgba(40, 167, 69, 0.8)',
        borderColor: 'rgba(40, 167, 69, 1)'
    },
    ece: {
        titulo: 'Certificados por ECE/OC',
        color: 'rgba(220, 53, 69, 0.8)',
        borderColor: 'rgba(220, 53, 69, 1)'
    },
    examen: {
        titulo: 'Certificados por Examen',
        color: 'rgba(255, 193, 7, 0.8)',
        borderColor: 'rgba(255, 193, 7, 1)'
    }
};
    
        function createChart(tipo, datos) {
    console.log("Datos recibidos en createChart:", datos);

    if (!datos || !Array.isArray(datos)) {
        console.error('Datos inválidos:', datos);
        alert('Error: Datos inválidos recibidos del servidor');
        return;
    }

    let labels, values;
    switch(tipo) {
    case 'ece':
        labels = datos.map(item => item.NB_ENTIDAD_EC_OC);
        values = datos.map(item => item.REGISTROS);
        break;
    case 'estado':
        labels = datos.map(item => item.ELEMENTO || item.NB_ENTIDAD_FEDERATIVA);
        values = datos.map(item => item.REGISTROS);
        break;
    case 'examen':
        labels = datos.map(item => item.ELEMENTO || item.NB_EXAMEN);
        values = datos.map(item => item.REGISTROS);
        break;
}
    const config = chartConfigs[tipo];
    const ctx = document.getElementById('mainChart').getContext('2d');
    
    if (currentChart) {
        currentChart.destroy();
    }

    currentChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'Número de Certificados',
                data: values,
                backgroundColor: config.color,
                borderColor: config.borderColor,
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'top',
                },
                title: {
                    display: true,
                    text: config.titulo,
                    font: {
                        size: 18
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Número de Certificados'
                    }
                },
                x: {
                    ticks: {
                        maxRotation: 45,
                        minRotation: 45,
                        autoSkip: true,
                        maxTicksLimit: 30 
                    }
                }
            }
        }
    });
}

        function showSpinner() {
            document.getElementById('loadingSpinner').style.display = 'block';
        }

        function hideSpinner() {
            document.getElementById('loadingSpinner').style.display = 'none';
        }
    </script>
</body>
</html>
