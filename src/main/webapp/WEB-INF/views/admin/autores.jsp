<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Autores | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Autores</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Gestión de Autores</h1>
                <p class="text-muted small mb-0">Registra y actualiza los autores de las obras del acervo.</p>
            </div>
            <div>
                <button type="button" class="btn btn-bh-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoAutor">
                    <i class="bi bi-person-plus me-1"></i> Registrar Autor
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
                            <th>Foto</th>
                            <th>Nombre</th>
                            <th>Nacionalidad</th>
                            <th>Biografía</th>
                            <th>Obras</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="a" items="${autores}">
                            <tr>
                                <td><span class="text-muted fw-bold">#${a.idAutor}</span></td>
                                <td>
                                    <img src="${a.fotoUrl}" alt="${a.nombre}" class="rounded-circle object-fit-cover shadow-xs" style="width: 40px; height: 40px;" onerror="this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300'">
                                </td>
                                <td><span class="fw-bold text-dark">${a.nombre}</span></td>
                                <td>${a.nacionalidad}</td>
                                <td><small class="text-muted text-truncate d-inline-block" style="max-width: 250px;">${a.biografia}</small></td>
                                <td><span class="badge bg-light text-dark border">${a.totalLibros} obras</span></td>
                                <td class="text-end">
                                    <form action="${pageContext.request.contextPath}/admin/autores" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro de eliminar este autor?');">
                                        <input type="hidden" name="action" value="eliminar">
                                        <input type="hidden" name="idAutor" value="${a.idAutor}">
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

    <!-- MODAL NUEVO AUTOR -->
    <div class="modal fade" id="modalNuevoAutor" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/autores" method="POST">
                    <input type="hidden" name="action" value="crear">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold">Registrar Autor</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nombre Completo *</label>
                            <input type="text" name="nombre" class="form-control" required placeholder="Ej. Mario Vargas Llosa">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Nacionalidad</label>
                            <input type="text" name="nacionalidad" class="form-control" placeholder="Ej. Peruana">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">URL de la Foto</label>
                            <input type="url" name="fotoUrl" class="form-control" placeholder="https://images.unsplash.com/...">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Biografía Breve</label>
                            <textarea name="biografia" class="form-control" rows="3" placeholder="Resumen biográfico del autor..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-bh-primary">Guardar Autor</button>
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
