<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="reportes.Usuario" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Editar Usuario</title>
</head>
<body>
    <h2>Editar Usuario</h2>


    <form action="DirectorioAdministrador" method="post">
        <input type="hidden" name="action" value="guardarEdicion">
        <input type="hidden" name="id" value="${usuarioEditar.id}">

        <div>
            <label for="username">Usuario:</label>
            <input type="text" id="username" name="username" value="${usuarioEditar.access}" required>
        </div>
        <div>
            <label for="status">Estado:</label>
            <select name="status" id="status">
                <option value="aS" ${usuarioEditar.status == 'aS' ? 'selected' : ''}>Activo</option>
                <option value="iS" ${usuarioEditar.status == 'iS' ? 'selected' : ''}>Inactivo</option>
            </select>
        </div>
        <button type="submit">Guardar Cambios</button>
    </form>

    <a href="DirectorioAdministrador">Cancelar</a>
    
    <script>
    console.log("errorMessage: ${errorMessage}");
</script>
</body>

</html>
