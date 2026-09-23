<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Usuarios | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Administración</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Usuarios</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Gestión de Lectores y Usuarios</h1>
                <p class="text-muted small mb-0">Administra cuentas, roles y estados de acceso al sistema bibliotecario.</p>
            </div>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.msg eq 'estadoActualizado'}">Estado de usuario actualizado correctamente.</c:when>
                    <c:when test="${param.msg eq 'usuarioEliminado'}">Usuario eliminado del sistema.</c:when>
                    <c:otherwise>Operación procesada con éxito.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                No puedes modificar o eliminar tu propia cuenta de administrador mientras estás en sesión.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <div class="table-responsive">
                <table class="table table-bh align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Usuario</th>
                            <th>Correo Electrónico</th>
                            <th>Teléfono</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th>Registro</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${usuarios}">
                            <tr>
                                <td><span class="text-muted fw-bold">#${u.idUsuario}</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 32px; height: 32px; font-size: 0.85rem;">
                                            ${u.nombre.substring(0,1)}
                                        </div>
                                        <span class="fw-bold text-dark">${u.nombreCompleto}</span>
                                    </div>
                                </td>
                                <td>${u.email}</td>
                                <td>${u.telefono != null && !u.telefono.isEmpty() ? u.telefono : '-'}</td>
                                <td>
                                    <span class="badge ${u.idRol eq 1 ? 'bg-danger' : 'bg-primary'}">
                                        ${u.nombreRol}
                                    </span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/usuarios" method="POST" class="d-inline">
                                        <input type="hidden" name="action" value="cambiarEstado">
                                        <input type="hidden" name="idUsuario" value="${u.idUsuario}">
                                        <select name="estado" class="form-select form-select-sm d-inline-block w-auto" onchange="this.form.submit()" ${u.idUsuario eq sessionScope.usuarioLogueado.idUsuario ? 'disabled' : ''}>
                                            <option value="ACTIVO" ${u.estado eq 'ACTIVO' ? 'selected' : ''}>Activo</option>
                                            <option value="INACTIVO" ${u.estado eq 'INACTIVO' ? 'selected' : ''}>Inactivo</option>
                                            <option value="SUSPENDIDO" ${u.estado eq 'SUSPENDIDO' ? 'selected' : ''}>Suspendido</option>
                                        </select>
                                    </form>
                                </td>
                                <td><small class="text-muted">${u.fechaRegistro}</small></td>
                                <td class="text-end">
                                    <c:if test="${u.idUsuario ne sessionScope.usuarioLogueado.idUsuario}">
                                        <form action="${pageContext.request.contextPath}/admin/usuarios" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro que deseas eliminar este usuario?');">
                                            <input type="hidden" name="action" value="eliminar">
                                            <input type="hidden" name="idUsuario" value="${u.idUsuario}">
                                            <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar usuario">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
