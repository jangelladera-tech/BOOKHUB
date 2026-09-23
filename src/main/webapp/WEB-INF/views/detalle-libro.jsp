<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${libro.titulo} | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">

        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index" class="text-decoration-none">Inicio</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none">Catálogo</a></li>
                <li class="breadcrumb-item active" aria-current="page">${libro.titulo}</li>
            </ol>
        </nav>

        <!-- Mensajes de estado -->
        <c:if test="${param.error eq 'yaReservado'}">
            <div class="alert alert-warning alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                Ya cuentas con una reserva pendiente activa para este libro.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border border-slate-200 rounded-4 overflow-hidden bg-white shadow-sm p-4 p-md-5">
            <div class="row g-5">
                <!-- Portada y Estado de Disponibilidad -->
                <div class="col-lg-4 text-center">
                    <div class="position-relative d-inline-block shadow-lg rounded-4 overflow-hidden mb-3">
                        <img src="${libro.portadaUrl}" alt="${libro.titulo}" class="img-fluid" style="max-height: 440px; width: 100%; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                    </div>

                    <!-- Estado del libro -->
                    <div class="p-3 rounded-3 bg-light border text-center mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small text-muted fw-bold">Disponibilidad en Biblioteca:</span>
                            <c:choose>
                                <c:when test="${libro.isDisponible()}">
                                    <span class="badge-disp-si">${libro.ejemplaresDisponibles} de ${libro.ejemplaresTotales} ejemplares</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-disp-no">Sin ejemplares disponibles</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Botón de acción para el usuario -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioLogueado}">
                            <c:choose>
                                <c:when test="${tieneReservaActiva}">
                                    <button class="btn btn-secondary w-100 py-2.5 rounded-3 fw-bold disabled" disabled>
                                        <i class="bi bi-clock-history me-1"></i> Tienes una reserva activa
                                    </button>
                                </c:when>
                                <c:when test="${libro.isDisponible()}">
                                    <form action="${pageContext.request.contextPath}/usuario/reservar" method="POST">
                                        <input type="hidden" name="idLibro" value="${libro.idLibro}">
                                        <button type="submit" class="btn btn-bh-primary w-100 py-2.5 rounded-3 fw-bold shadow-sm">
                                            <i class="bi bi-bookmark-plus me-1"></i> Reservar este Ejemplar
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/usuario/reservar" method="POST">
                                        <input type="hidden" name="idLibro" value="${libro.idLibro}">
                                        <button type="submit" class="btn btn-warning w-100 py-2.5 rounded-3 fw-bold shadow-sm text-dark">
                                            <i class="bi bi-hourglass-split me-1"></i> Reservar en Lista de Espera
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary w-100 py-2.5 rounded-3 fw-bold">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Inicia sesión para reservar
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Detalles e Información Bibliográfica -->
                <div class="col-lg-8">
                    <div class="mb-3">
                        <span class="badge bg-primary bg-opacity-10 text-primary border border-primary border-opacity-25 px-3 py-1.5 rounded-pill fw-semibold small">
                            ${libro.nombreCategoria}
                        </span>
                        <c:if test="${libro.destacado}">
                            <span class="badge bg-warning bg-opacity-25 text-warning-emphasis px-3 py-1.5 rounded-pill fw-semibold small ms-1">
                                <i class="bi bi-star-fill text-warning"></i> Recomendado
                            </span>
                        </c:if>
                    </div>

                    <h1 class="display-6 fw-bold font-serif text-dark mb-1">${libro.titulo}</h1>
                    <h5 class="text-primary fw-semibold mb-3">por ${libro.nombreAutor}</h5>

                    <!-- Puntuación y estrellas -->
                    <div class="d-flex align-items-center gap-2 mb-4 pb-3 border-bottom">
                        <div class="text-warning fs-5">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <span class="fw-bold text-dark fs-5">${libro.calificacion}</span>
                        <span class="text-muted small">/ 5.0 en la comunidad universitaria</span>
                    </div>

                    <!-- Sinopsis -->
                    <div class="mb-4">
                        <h6 class="text-uppercase text-muted fw-bold small mb-2">Sinopsis y Argumento</h6>
                        <p class="text-secondary leading-relaxed" style="font-size: 0.98rem;">
                            ${libro.descripcion}
                        </p>
                    </div>

                    <!-- Ficha Técnica -->
                    <div class="card border border-slate-200 rounded-3 p-3 bg-light">
                        <h6 class="text-uppercase text-dark fw-bold small mb-3">Ficha Técnica</h6>
                        <div class="row g-3 small">
                            <div class="col-sm-6 col-md-3">
                                <span class="text-muted d-block">Editorial:</span>
                                <strong class="text-dark">${libro.editorial != null ? libro.editorial : 'No especificada'}</strong>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="text-muted d-block">Año de Publicación:</span>
                                <strong class="text-dark">${libro.anioPublicacion}</strong>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="text-muted d-block">Páginas:</span>
                                <strong class="text-dark">${libro.paginas}</strong>
                            </div>
                            <div class="col-sm-6 col-md-3">
                                <span class="text-muted d-block">ISBN:</span>
                                <strong class="text-dark">${libro.isbn}</strong>
                            </div>
                        </div>
                    </div>

                    <!-- Política de Préstamos -->
                    <div class="alert alert-info border-0 rounded-3 mt-4 small d-flex gap-2 align-items-center">
                        <i class="bi bi-info-circle-fill fs-5 text-info"></i>
                        <div>
                            Los préstamos tienen una duración regular de <strong>14 días naturales</strong> con posibilidad de renovación si no existen reservas pendientes.
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
