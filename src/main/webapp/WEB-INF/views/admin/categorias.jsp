<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Categorías | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Categorías</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Gestión de Categorías Temáticas</h1>
                <p class="text-muted small mb-0">Clasifica y organiza las áreas temáticas del catálogo bibliográfico.</p>
            </div>
            <div>
                <button type="button" class="btn btn-bh-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalNuevaCategoria">
                    <i class="bi bi-tag me-1"></i> Registrar Categoría
                </button>
            </div>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> Operación realizada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <div class="table-responsive">
                <table class="table table-bh align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Ícono</th>
                            <th>Categoría</th>
                            <th>Descripción</th>
                            <th>Total Libros</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categorias}">
                            <tr>
                                <td><span class="text-muted fw-bold">#${c.idCategoria}</span></td>
                                <td>
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 36px; height: 36px;">
                                        <i class="bi ${c.icono != null ? c.icono : 'bi-bookmark-check'}"></i>
                                    </div>
                                </td>
                                <td><span class="fw-bold text-dark">${c.nombre}</span></td>
                                <td><small class="text-muted">${c.descripcion}</small></td>
                                <td><span class="badge bg-light text-dark border">${c.totalLibros} libros</span></td>
                                <td class="text-end">
                                    <form action="${pageContext.request.contextPath}/admin/categorias" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro de eliminar esta categoría?');">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="idCategoria" value="${c.idCategoria}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm" title="Eliminar">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- MODAL NUEVA CATEGORÍA -->
    <div class="modal fade" id="modalNuevaCategoria" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/categorias" method="POST">
                    <input type="hidden" name="action" value="crear">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold">Registrar Categoría</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nombre de la Categoría *</label>
                            <input type="text" name="nombre" class="form-control" required placeholder="Ej. Medicina y Ciencias de la Salud">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Clase de Ícono Bootstrap</label>
                            <input type="text" name="icono" class="form-control" value="bi-bookmark-check" placeholder="Ej. bi-heart-pulse, bi-code-slash">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Descripción</label>
                            <textarea name="descripcion" class="form-control" rows="3" placeholder="Alcance o temática de la categoría..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-bh-primary">Guardar Categoría</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
