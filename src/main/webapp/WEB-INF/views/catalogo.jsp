<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catálogo de Libros | BOOKHUB</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-4">
        <!-- Encabezado de página -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index" class="text-decoration-none">Inicio</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Catálogo</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Catálogo de Libros</h1>
                <p class="text-muted small mb-0">Explora nuestro acervo bibliográfico universitario y solicita tus lecturas.</p>
            </div>
            <div>
                <span class="badge bg-light text-secondary border px-3 py-2 fs-6">
                    <i class="bi bi-collection me-1 text-primary"></i> ${libros.size()} libro(s) encontrados
                </span>
            </div>
        </div>

        <!-- Filtros y Buscador Superior -->
        <div class="card border border-slate-200 rounded-4 p-3 mb-4 bg-white shadow-xs">
            <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-2 align-items-center">
                <div class="col-lg-5 col-md-12">
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="q" value="${q}" class="form-control bg-light border-start-0" placeholder="Buscar por título, autor o ISBN...">
                    </div>
                </div>

                <div class="col-lg-3 col-md-6">
                    <select name="categoria" class="form-select bg-light">
                        <option value="">Todas las categorías</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.idCategoria}" ${categoriaSeleccionada eq cat.idCategoria ? 'selected' : ''}>
                                ${cat.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-lg-3 col-md-6">
                    <select name="autor" class="form-select bg-light">
                        <option value="">Todos los autores</option>
                        <c:forEach var="aut" items="${autores}">
                            <option value="${aut.idAutor}" ${autorSeleccionado eq aut.idAutor ? 'selected' : ''}>
                                ${aut.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-lg-1 col-md-12">
                    <button type="submit" class="btn btn-bh-primary w-100" title="Filtrar">
                        <i class="bi bi-filter"></i>
                    </button>
                </div>
            </form>
        </div>

        <!-- Grilla de Libros -->
        <c:choose>
            <c:when test="${empty libros}">
                <div class="card border-0 bg-white text-center py-5 rounded-4 shadow-xs my-4">
                    <div class="my-3">
                        <i class="bi bi-journal-x text-muted" style="font-size: 3.5rem;"></i>
                    </div>
                    <h4 class="font-serif fw-bold text-dark">No se encontraron libros</h4>
                    <p class="text-muted small">Intenta ajustar los criterios de búsqueda o limpia los filtros.</p>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill px-4">
                            Ver todo el catálogo
                        </a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row g-4">
                    <c:forEach var="libro" items="${libros}">
                        <div class="col-xl-3 col-lg-4 col-md-6 col-sm-6">
                            <div class="card card-book">
                                <div class="book-cover-wrap">
                                    <img src="${libro.portadaUrl}" alt="${libro.titulo}" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                                    <div class="position-absolute top-0 start-0 m-2">
                                        <span class="badge bg-dark bg-opacity-75 backdrop-blur text-white small">${libro.nombreCategoria}</span>
                                    </div>
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <c:choose>
                                            <c:when test="${libro.isDisponible()}">
                                                <span class="badge-disp-si">${libro.ejemplaresDisponibles} disp.</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-disp-no">Agotado</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <div>
                                        <h5 class="book-title text-truncate" title="${libro.titulo}">${libro.titulo}</h5>
                                        <p class="book-author mb-2 text-truncate">${libro.nombreAutor}</p>
                                        <div class="d-flex align-items-center justify-content-between small text-muted mb-3">
                                            <span class="text-warning fw-bold">
                                                <i class="bi bi-star-fill"></i> ${libro.calificacion}
                                            </span>
                                            <span>${libro.paginas != null ? libro.paginas : 0} págs</span>
                                            <span>${libro.anioPublicacion}</span>
                                        </div>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/libro?id=${libro.idLibro}" class="btn btn-outline-primary btn-sm w-100 rounded-pill fw-semibold">
                                        Ver Ficha y Reservar
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
