<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Panel de Lector | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">

        <!-- Banner de Bienvenida -->
        <div class="card border-0 bg-primary text-white rounded-4 p-4 p-md-5 mb-4 shadow-sm position-relative overflow-hidden">
            <div class="position-relative z-1">
                <span class="badge bg-white bg-opacity-20 text-white rounded-pill px-3 py-1 mb-2 small fw-semibold">
                    <i class="bi bi-person-badge me-1"></i> Área de Usuario
                </span>
                <h1 class="h2 font-serif fw-bold mb-1">¡Hola, ${sessionScope.usuarioLogueado.nombre}!</h1>
                <p class="text-light opacity-75 mb-0">Gestiona tus préstamos vigentes, reservas activas y consulta tu historial bibliotecario.</p>
            </div>
        </div>

        <!-- Tarjetas de Métricas -->
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card card-stat">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Préstamos Activos</small>
                        <div class="stat-number text-primary mt-1">${prestamosActivos}</div>
                        <a href="${pageContext.request.contextPath}/usuario/prestamos" class="small text-decoration-none fw-semibold text-primary">
                            Ver detalles &rarr;
                        </a>
                    </div>
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                        <i class="bi bi-journal-bookmark-fill"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card card-stat">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Reservas Pendientes</small>
                        <div class="stat-number text-warning mt-1">${reservasPendientes}</div>
                        <a href="${pageContext.request.contextPath}/usuario/reservas" class="small text-decoration-none fw-semibold text-warning">
                            Ver reservas &rarr;
                        </a>
                    </div>
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning">
                        <i class="bi bi-clock-history"></i>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card card-stat">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.72rem;">Devoluciones Realizadas</small>
                        <div class="stat-number text-success mt-1">${totalDevoluciones}</div>
                        <a href="${pageContext.request.contextPath}/usuario/devoluciones" class="small text-decoration-none fw-semibold text-success">
                            Ver historial &rarr;
                        </a>
                    </div>
                    <div class="stat-icon bg-success bg-opacity-10 text-success">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Accesos Rápidos y Últimos Préstamos -->
        <div class="row g-4">
            <div class="col-lg-12">
                <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
                    <div class="d-flex justify-content-between align-items-center mb-3 pb-2 border-bottom">
                        <h5 class="font-serif fw-bold text-dark mb-0">Tus Préstamos Recientes</h5>
                        <a href="${pageContext.request.contextPath}/usuario/prestamos" class="btn btn-sm btn-bh-outline">
                            Ver todos
                        </a>
                    </div>

                    <c:choose>
                        <c:when test="${empty ultimosPrestamos}">
                            <div class="text-center py-5 text-muted">
                                <i class="bi bi-book text-muted fs-1 mb-2 d-block"></i>
                                <p class="mb-2">No tienes ningún préstamo registrado actualmente.</p>
                                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-sm btn-bh-primary">
                                    <i class="bi bi-search me-1"></i> Explorar Catálogo
                                </a>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="table table-bh align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th>Libro</th>
                                            <th>Fecha Préstamo</th>
                                            <th>Fecha Devolución</th>
                                            <th>Estado</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${ultimosPrestamos}">
                                            <tr>
                                                <td>
                                                    <div class="d-flex align-items-center gap-3">
                                                        <img src="${p.portadaLibro}" alt="${p.tituloLibro}" class="rounded shadow-xs object-fit-cover" style="width: 40px; height: 55px;" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                                                        <div>
                                                            <div class="fw-bold text-dark">${p.tituloLibro}</div>
                                                            <small class="text-muted">Préstamo #${p.idPrestamo}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${p.fechaPrestamo}</td>
                                                <td>
                                                    <span class="${p.estado eq 'ACTIVO' ? 'fw-bold text-danger' : 'text-muted'}">
                                                        ${p.fechaDevolucionEsperada}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${p.estado eq 'ACTIVO'}">
                                                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> En Curso</span>
                                                        </c:when>
                                                        <c:when test="${p.estado eq 'DEVUELTO'}">
                                                            <span class="badge bg-success"><i class="bi bi-check-circle"></i> Devuelto</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">${p.estado}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

    </div>

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
