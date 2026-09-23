<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Libros | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">
        <!-- Header -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none">Administración</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Libros</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Gestión del Catálogo de Libros</h1>
                <p class="text-muted small mb-0">Crea, edita, audita stock de ejemplares y administra obras del acervo.</p>
            </div>
            <div>
                <button type="button" class="btn btn-bh-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoLibro">
                    <i class="bi bi-plus-circle me-1"></i> Registrar Nuevo Libro
                </button>
            </div>
        </div>

        <!-- Alertas -->
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.msg eq 'creado'}">Libro registrado correctamente en el catálogo.</c:when>
                    <c:when test="${param.msg eq 'actualizado'}">Datos del libro actualizados exitosamente.</c:when>
                    <c:when test="${param.msg eq 'eliminado'}">Libro eliminado del acervo.</c:when>
                    <c:otherwise>Operación procesada con éxito.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                No se pudo completar la operación (puede tener préstamos activos asociados).
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Tabla de Libros -->
        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <div class="table-responsive">
                <table class="table table-bh align-middle mb-0">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Libro</th>
                            <th>Autor</th>
                            <th>Categoría</th>
                            <th>ISBN</th>
                            <th>Ejemplares</th>
                            <th>Calificación</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="l" items="${libros}">
                            <tr>
                                <td><span class="text-muted fw-bold">#${l.idLibro}</span></td>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${l.portadaUrl}" alt="${l.titulo}" class="rounded shadow-xs object-fit-cover" style="width: 42px; height: 58px;" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                                        <div>
                                            <div class="fw-bold text-dark">${l.titulo}</div>
                                            <small class="text-muted">${l.editorial} • ${l.anioPublicacion}</small>
                                            <c:if test="${l.destacado}">
                                                <span class="badge bg-warning text-dark ms-1" style="font-size: 0.65rem;">Destacado</span>
                                            </c:if>
                                        </div>
                                    </div>
                                </td>
                                <td>${l.nombreAutor}</td>
                                <td><span class="badge bg-light text-dark border">${l.nombreCategoria}</span></td>
                                <td><code>${l.isbn}</code></td>
                                <td>
                                    <span class="fw-bold ${l.ejemplaresDisponibles > 0 ? 'text-success' : 'text-danger'}">
                                        ${l.ejemplaresDisponibles}
                                    </span>
                                    <span class="text-muted">/ ${l.ejemplaresTotales}</span>
                                </td>
                                <td>
                                    <span class="text-warning fw-bold"><i class="bi bi-star-fill"></i> ${l.calificacion}</span>
                                </td>
                                <td class="text-end">
                                    <div class="btn-group btn-group-sm">
                                        <button type="button" class="btn btn-outline-secondary" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalEditarLibro"
                                                data-id="${l.idLibro}"
                                                data-titulo="${l.titulo}"
                                                data-isbn="${l.isbn}"
                                                data-autor="${l.idAutor}"
                                                data-categoria="${l.idCategoria}"
                                                data-editorial="${l.editorial}"
                                                data-anio="${l.anioPublicacion}"
                                                data-paginas="${l.paginas}"
                                                data-ejemplares="${l.ejemplaresTotales}"
                                                data-portada="${l.portadaUrl}"
                                                data-descripcion="${l.descripcion}"
                                                data-destacado="${l.destacado}"
                                                title="Editar libro">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <form action="${pageContext.request.contextPath}/admin/libros" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro que deseas eliminar este libro?');">
                                            <input type="hidden" name="action" value="eliminar">
                                            <input type="hidden" name="idLibro" value="${l.idLibro}">
                                            <button type="submit" class="btn btn-outline-danger" title="Eliminar libro">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- MODAL NUEVO LIBRO -->
    <div class="modal fade" id="modalNuevoLibro" tabindex="-1" aria-labelledby="modalNuevoLibroLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/libros" method="POST">
                    <input type="hidden" name="action" value="crear">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold" id="modalNuevoLibroLabel">Registrar Nuevo Libro</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">Título del Libro *</label>
                                <input type="text" name="titulo" class="form-control" required placeholder="Ej. El Alquimista">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">ISBN *</label>
                                <input type="text" name="isbn" class="form-control" required placeholder="978-...">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Autor *</label>
                                <select name="idAutor" class="form-select" required>
                                    <c:forEach var="a" items="${autores}">
                                        <option value="${a.idAutor}">${a.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Categoría *</label>
                                <select name="idCategoria" class="form-select" required>
                                    <c:forEach var="c" items="${categorias}">
                                        <option value="${c.idCategoria}">${c.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Editorial</label>
                                <input type="text" name="editorial" class="form-control" placeholder="Ej. Planeta">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Año Publicación</label>
                                <input type="number" name="anioPublicacion" class="form-control" placeholder="Ej. 2021">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Páginas</label>
                                <input type="number" name="paginas" class="form-control" placeholder="Ej. 350">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Total Ejemplares *</label>
                                <input type="number" name="ejemplaresTotales" class="form-control" min="1" value="3" required>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">URL de la Portada</label>
                                <input type="url" name="portadaUrl" class="form-control" placeholder="https://images.unsplash.com/...">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Sinopsis o Argumento</label>
                                <textarea name="descripcion" class="form-control" rows="3" placeholder="Breve descripción del contenido..."></textarea>
                            </div>
                            <div class="col-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="destacado" id="destacadoCheck">
                                    <label class="form-check-label small" for="destacadoCheck">
                                        Mostrar como libro destacado en la página de inicio
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-bh-primary">Guardar Libro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL EDITAR LIBRO -->
    <div class="modal fade" id="modalEditarLibro" tabindex="-1" aria-labelledby="modalEditarLibroLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/libros" method="POST">
                    <input type="hidden" name="action" value="editar">
                    <input type="hidden" name="idLibro" id="edit_idLibro">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold" id="modalEditarLibroLabel">Editar Libro</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">Título del Libro *</label>
                                <input type="text" name="titulo" id="edit_titulo" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">ISBN *</label>
                                <input type="text" name="isbn" id="edit_isbn" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Autor *</label>
                                <select name="idAutor" id="edit_idAutor" class="form-select" required>
                                    <c:forEach var="a" items="${autores}">
                                        <option value="${a.idAutor}">${a.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold text-muted">Categoría *</label>
                                <select name="idCategoria" id="edit_idCategoria" class="form-select" required>
                                    <c:forEach var="c" items="${categorias}">
                                        <option value="${c.idCategoria}">${c.nombre}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Editorial</label>
                                <input type="text" name="editorial" id="edit_editorial" class="form-control">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Año Publicación</label>
                                <input type="number" name="anioPublicacion" id="edit_anioPublicacion" class="form-control">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Páginas</label>
                                <input type="number" name="paginas" id="edit_paginas" class="form-control">
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold text-muted">Total Ejemplares *</label>
                                <input type="number" name="ejemplaresTotales" id="edit_ejemplaresTotales" class="form-control" min="1" required>
                            </div>
                            <div class="col-md-8">
                                <label class="form-label small fw-bold text-muted">URL de la Portada</label>
                                <input type="url" name="portadaUrl" id="edit_portadaUrl" class="form-control">
                            </div>
                            <div class="col-12">
                                <label class="form-label small fw-bold text-muted">Sinopsis o Argumento</label>
                                <textarea name="descripcion" id="edit_descripcion" class="form-control" rows="3"></textarea>
                            </div>
                            <div class="col-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" name="destacado" id="edit_destacado">
                                    <label class="form-check-label small" for="edit_destacado">
                                        Mostrar como libro destacado en la página de inicio
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-bh-primary">Guardar Cambios</button>
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
