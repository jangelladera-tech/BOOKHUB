<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BOOKHUB | Biblioteca Digital y Universitaria</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Estilos personalizados -->
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <!-- Header / Navbar -->
    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <!-- Notificaciones y Mensajes Flash -->
    <c:if test="${not empty param.msg}">
        <div class="container mt-3">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.msg eq 'sesionCerrada'}">Has cerrado sesión correctamente.</c:when>
                    <c:otherwise>Operación realizada con éxito.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="container mt-3">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.error eq 'accesoDenegado'}">No tienes permisos para acceder a esa sección.</c:when>
                    <c:otherwise>Ha ocurrido un error en la solicitud.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>

    <div class="container my-4">

        <!-- HERO SECTION -->
        <section class="hero-bh">
            <div class="row align-items-center">
                <div class="col-lg-7 text-center text-lg-start mb-4 mb-lg-0">
                    <span class="badge bg-primary bg-opacity-25 text-primary-emphasis border border-primary border-opacity-25 px-3 py-2 rounded-pill mb-3 fw-semibold">
                        <i class="bi bi-mortarboard-fill me-1 text-warning"></i> Red Bibliotecaria Universitaria
                    </span>
                    <h1 class="display-4 fw-bold font-serif text-white">
                        Tu puerta de acceso al <span class="text-warning">conocimiento</span> y la investigación.
                    </h1>
                    <p class="lead text-light opacity-75 mb-4">
                        Consulta miles de títulos académicos y literarios, reserva ejemplares en tiempo real y gestiona tus préstamos bibliotecarios desde cualquier dispositivo.
                    </p>
                    <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-warning text-dark fw-bold px-4 py-3 rounded-3 shadow-sm">
                            <i class="bi bi-search me-1"></i> Explorar Catálogo
                        </a>
                        <c:if test="${empty sessionScope.usuarioLogueado}">
                            <a href="${pageContext.request.contextPath}/registro" class="btn btn-outline-light px-4 py-3 rounded-3 fw-semibold">
                                <i class="bi bi-person-plus me-1"></i> Crear Cuenta de Lector
                            </a>
                        </c:if>
                    </div>

                    <!-- Métricas globales del Hero -->
                    <div class="row mt-5 pt-3 border-top border-light border-opacity-10 text-center text-lg-start">
                        <div class="col-4">
                            <h4 class="fw-bold text-white mb-0 font-serif">${totalLibros > 0 ? totalLibros : '1,500+'}</h4>
                            <small class="text-light opacity-50">Libros Físicos y Digitales</small>
                        </div>
                        <div class="col-4">
                            <h4 class="fw-bold text-white mb-0 font-serif">${totalUsuarios > 0 ? totalUsuarios : '800+'}</h4>
                            <small class="text-light opacity-50">Lectores Universitarios</small>
                        </div>
                        <div class="col-4">
                            <h4 class="fw-bold text-white mb-0 font-serif">${prestamosActivos > 0 ? prestamosActivos : '250+'}</h4>
                            <small class="text-light opacity-50">Préstamos Activos</small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5 text-center">
                    <div class="position-relative d-inline-block">
                        <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&q=80&w=600" 
                             alt="Biblioteca BookHub" 
                             class="img-fluid rounded-4 shadow-2xl border border-light border-opacity-25" 
                             style="max-height: 400px; object-fit: cover;">
                        <div class="position-absolute bottom-0 start-0 translate-middle-y bg-white text-dark p-3 rounded-3 shadow-lg border text-start d-none d-sm-block ms-n3" style="max-width: 230px;">
                            <div class="d-flex align-items-center gap-2">
                                <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                <div>
                                    <div class="fw-bold small">Disponibilidad 24/7</div>
                                    <small class="text-muted" style="font-size: 0.72rem;">Reservas y préstamos automatizados</small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- BUSCADOR PRINCIPAL -->
        <section class="card border-0 shadow-sm rounded-4 p-4 mb-5 bg-white">
            <form action="${pageContext.request.contextPath}/catalogo" method="GET" class="row g-3 align-items-center">
                <div class="col-lg-5 col-md-6">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-1">Buscar por título o ISBN</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="bi bi-search text-muted"></i></span>
                        <input type="text" name="q" class="form-control bg-light border-start-0" placeholder="Ej. Cien Años de Soledad, Clean Code...">
                    </div>
                </div>

                <div class="col-lg-4 col-md-6">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-1">Filtrar por Categoría</label>
                    <select name="categoria" class="form-select bg-light">
                        <option value="">Todas las categorías</option>
                        <c:forEach var="cat" items="${categorias}">
                            <option value="${cat.idCategoria}">${cat.nombre} (${cat.totalLibros})</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="col-lg-3 col-md-12 d-flex align-items-end">
                    <button type="submit" class="btn btn-bh-primary w-100 py-2">
                        <i class="bi bi-funnel-fill me-1"></i> Buscar en el Catálogo
                    </button>
                </div>
            </form>
        </section>

        <!-- SECCIÓN: CATEGORÍAS -->
        <section id="seccion-categorias" class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="badge bg-indigo-subtle text-primary fw-bold text-uppercase small">Áreas del Conocimiento</span>
                    <h2 class="h3 font-serif fw-bold text-dark mt-1">Explora por Categorías</h2>
                </div>
                <a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none fw-semibold small text-primary">
                    Ver todo el catálogo <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <div class="row g-3">
                <c:forEach var="cat" items="${categorias}">
                    <div class="col-lg-2 col-md-4 col-6">
                        <a href="${pageContext.request.contextPath}/catalogo?categoria=${cat.idCategoria}" class="text-decoration-none text-dark">
                            <div class="card h-100 border border-slate-200 rounded-3 p-3 text-center transition-all hover-shadow bg-white">
                                <div class="bg-primary bg-opacity-10 text-primary rounded-circle mx-auto d-flex align-items-center justify-content-center mb-2" style="width: 48px; height: 48px;">
                                    <i class="bi ${cat.icono != null ? cat.icono : 'bi-bookmark-check'} fs-5"></i>
                                </div>
                                <h6 class="fw-bold mb-1 text-truncate" style="font-size: 0.88rem;">${cat.nombre}</h6>
                                <small class="text-muted">${cat.totalLibros} libros</small>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- SECCIÓN: LIBROS DESTACADOS -->
        <section class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="badge bg-warning-subtle text-warning-emphasis fw-bold text-uppercase small">Lecturas Recomendadas</span>
                    <h2 class="h3 font-serif fw-bold text-dark mt-1">Libros Destacados</h2>
                </div>
                <a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none fw-semibold small text-primary">
                    Explorar más <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach var="libro" items="${librosDestacados}">
                    <div class="col-lg-3 col-md-4 col-sm-6">
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
                                    <div class="d-flex align-items-center gap-1 text-warning small mb-3">
                                        <i class="bi bi-star-fill"></i>
                                        <span class="fw-bold text-dark">${libro.calificacion}</span>
                                        <span class="text-muted ms-1">(${libro.paginas} págs)</span>
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/libro?id=${libro.idLibro}" class="btn btn-outline-primary btn-sm w-100 rounded-pill fw-semibold">
                                    Ver Detalles y Préstamo
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- SECCIÓN: AUTORES DESTACADOS -->
        <section id="seccion-autores" class="mb-5">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <div>
                    <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase small">Grandes Pensadores</span>
                    <h2 class="h3 font-serif fw-bold text-dark mt-1">Autores Destacados</h2>
                </div>
            </div>

            <div class="row g-4">
                <c:forEach var="autor" items="${autoresDestacados}">
                    <div class="col-lg-3 col-md-6">
                        <div class="card border border-slate-200 rounded-4 p-4 text-center bg-white shadow-xs h-100">
                            <img src="${autor.fotoUrl}" alt="${autor.nombre}" class="rounded-circle mx-auto mb-3 object-fit-cover shadow-sm" style="width: 80px; height: 80px;" onerror="this.src='https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=300'">
                            <h5 class="fw-bold mb-1 font-serif text-dark">${autor.nombre}</h5>
                            <span class="text-muted small d-block mb-2">${autor.nacionalidad}</span>
                            <p class="text-secondary small mb-3 text-truncate-2">${autor.biografia}</p>
                            <div class="mt-auto">
                                <a href="${pageContext.request.contextPath}/catalogo?autor=${autor.idAutor}" class="btn btn-sm btn-light border rounded-pill px-3 fw-medium">
                                    Ver ${autor.totalLibros} obras
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

        <!-- SECCIÓN INFORMATIVA / BENEFICIOS -->
        <section class="card bg-white border border-slate-200 rounded-4 p-5 mb-5 shadow-xs">
            <div class="row g-4 align-items-center">
                <div class="col-lg-6">
                    <span class="badge bg-primary-subtle text-primary fw-bold text-uppercase small mb-2">Servicios Integrales</span>
                    <h2 class="h3 font-serif fw-bold text-dark mb-3">¿Por qué utilizar BOOKHUB?</h2>
                    <p class="text-muted">
                        BOOKHUB optimiza el ecosistema bibliotecario conectando estudiantes, docentes y administradores con un catálogo vivo, gestión ágil de reservas y control riguroso de préstamos y devoluciones.
                    </p>

                    <div class="d-flex flex-column gap-3 mt-4">
                        <div class="d-flex align-items-start gap-3">
                            <div class="bg-primary text-white p-2 rounded-3"><i class="bi bi-clock-history fs-5"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">Préstamos Rápidos y Transparentes</h6>
                                <p class="text-muted small mb-0">Lleva el control de tus fechas de vencimiento y evita sanciones innecesarias.</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start gap-3">
                            <div class="bg-warning text-dark p-2 rounded-3"><i class="bi bi-bookmark-star fs-5"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">Reservas Anticipadas</h6>
                                <p class="text-muted small mb-0">Separa ejemplares de alta demanda con 3 días de vigencia antes del préstamo.</p>
                            </div>
                        </div>

                        <div class="d-flex align-items-start gap-3">
                            <div class="bg-success text-white p-2 rounded-3"><i class="bi bi-shield-check fs-5"></i></div>
                            <div>
                                <h6 class="fw-bold mb-1">Área Administrativa Centralizada</h6>
                                <p class="text-muted small mb-0">Métricas en tiempo real, gestión de inventario, socios y auditoría de libros.</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-6 text-center">
                    <img src="https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=600" 
                         alt="Estudio en BookHub" 
                         class="img-fluid rounded-4 shadow-sm border" 
                         style="max-height: 380px; object-fit: cover;">
                </div>
            </div>
        </section>

    </div>

    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <!-- Bootstrap 5 Bundle JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
