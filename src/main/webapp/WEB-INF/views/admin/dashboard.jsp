<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Administrativo | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body>

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">

        <!-- Header Panel -->
        <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4 pb-3 border-bottom">
            <div>
                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-1 rounded-pill small fw-bold">
                    <i class="bi bi-shield-lock-fill me-1"></i> Administración General
                </span>
                <h1 class="h2 font-serif fw-bold text-dark mt-2 mb-0">Panel de Control de Biblioteca</h1>
                <p class="text-muted small mb-0">Métricas en tiempo real del acervo, circulación de libros y actividad de usuarios.</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/admin/libros" class="btn btn-bh-primary btn-sm">
                    <i class="bi bi-journal-plus me-1"></i> Gestionar Libros
                </a>
                <a href="${pageContext.request.contextPath}/admin/prestamos" class="btn btn-warning btn-sm text-dark fw-bold">
                    <i class="bi bi-arrow-left-right me-1"></i> Préstamos & Devoluciones
                </a>
            </div>
        </div>

        <!-- 6 Tarjetas de Métricas Estadísticas -->
        <div class="row g-3 mb-4">
            <!-- Total Libros -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Total Libros</small>
                        <div class="stat-number text-dark mt-1" style="font-size: 1.8rem;">${stats.totalLibros}</div>
                        <a href="${pageContext.request.contextPath}/admin/libros" class="small text-decoration-none text-primary" style="font-size: 0.75rem;">Ver catálogo</a>
                    </div>
                    <div class="stat-icon bg-primary bg-opacity-10 text-primary" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-journal-album"></i>
                    </div>
                </div>
            </div>

            <!-- Total Usuarios -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Usuarios</small>
                        <div class="stat-number text-dark mt-1" style="font-size: 1.8rem;">${stats.totalUsuarios}</div>
                        <a href="${pageContext.request.contextPath}/admin/usuarios" class="small text-decoration-none text-primary" style="font-size: 0.75rem;">Gestionar</a>
                    </div>
                    <div class="stat-icon bg-info bg-opacity-10 text-info" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-people-fill"></i>
                    </div>
                </div>
            </div>

            <!-- Préstamos Activos -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Préstamos Activos</small>
                        <div class="stat-number text-warning mt-1" style="font-size: 1.8rem;">${stats.prestamosActivos}</div>
                        <a href="${pageContext.request.contextPath}/admin/prestamos" class="small text-decoration-none text-warning" style="font-size: 0.75rem;">En curso</a>
                    </div>
                    <div class="stat-icon bg-warning bg-opacity-10 text-warning" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                </div>
            </div>

            <!-- Reservas Pendientes -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Reservas</small>
                        <div class="stat-number text-danger mt-1" style="font-size: 1.8rem;">${stats.reservasPendientes}</div>
                        <a href="${pageContext.request.contextPath}/admin/reservas" class="small text-decoration-none text-danger" style="font-size: 0.75rem;">Por entregar</a>
                    </div>
                    <div class="stat-icon bg-danger bg-opacity-10 text-danger" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-calendar-event"></i>
                    </div>
                </div>
            </div>

            <!-- Libros Disponibles -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Ejemplares Disp.</small>
                        <div class="stat-number text-success mt-1" style="font-size: 1.8rem;">${stats.librosDisponibles}</div>
                        <span class="small text-muted" style="font-size: 0.75rem;">En estantería</span>
                    </div>
                    <div class="stat-icon bg-success bg-opacity-10 text-success" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                </div>
            </div>

            <!-- Total Devoluciones -->
            <div class="col-xl-2 col-lg-4 col-md-4 col-sm-6">
                <div class="card card-stat p-3">
                    <div>
                        <small class="text-muted text-uppercase fw-bold" style="font-size: 0.68rem;">Devoluciones</small>
                        <div class="stat-number text-secondary mt-1" style="font-size: 1.8rem;">${stats.totalDevoluciones}</div>
                        <a href="${pageContext.request.contextPath}/admin/prestamos" class="small text-decoration-none text-secondary" style="font-size: 0.75rem;">Histórico</a>
                    </div>
                    <div class="stat-icon bg-secondary bg-opacity-10 text-secondary" style="width: 2.8rem; height: 2.8rem; font-size: 1.2rem;">
                        <i class="bi bi-arrow-return-left"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tablas de Actividad Reciente -->
        <div class="row g-4">
            <!-- Préstamos Recientes -->
            <div class="col-lg-6">
                <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="font-serif fw-bold text-dark mb-0">Préstamos en Circulación</h5>
                        <a href="${pageContext.request.contextPath}/admin/prestamos" class="small text-decoration-none text-primary fw-semibold">Ver todos</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0" style="font-size: 0.82rem;">
                            <thead>
                                <tr>
                                    <th>Usuario</th>
                                    <th>Libro</th>
                                    <th>Límite</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${prestamosRecientes}">
                                    <tr>
                                        <td>
                                            <span class="fw-bold text-dark">${p.nombreUsuario}</span>
                                        </td>
                                        <td class="text-truncate" style="max-width: 150px;" title="${p.tituloLibro}">
                                            ${p.tituloLibro}
                                        </td>
                                        <td>${p.fechaDevolucionEsperada}</td>
                                        <td>
                                            <span class="badge ${p.estado eq 'ACTIVO' ? 'bg-warning text-dark' : 'bg-success'}">
                                                ${p.estado}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Reservas Recientes -->
            <div class="col-lg-6">
                <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs h-100">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="font-serif fw-bold text-dark mb-0">Reservas Recientes</h5>
                        <a href="${pageContext.request.contextPath}/admin/reservas" class="small text-decoration-none text-primary fw-semibold">Ver todas</a>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0" style="font-size: 0.82rem;">
                            <thead>
                                <tr>
                                    <th>Usuario</th>
                                    <th>Libro</th>
                                    <th>Válida Hasta</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reservasRecientes}">
                                    <tr>
                                        <td>
                                            <span class="fw-bold text-dark">${r.nombreUsuario}</span>
                                        </td>
                                        <td class="text-truncate" style="max-width: 150px;" title="${r.tituloLibro}">
                                            ${r.tituloLibro}
                                        </td>
                                        <td>${r.fechaVencimiento}</td>
                                        <td>
                                            <span class="badge ${r.estado eq 'PENDIENTE' ? 'bg-warning text-dark' : 'bg-secondary'}">
                                                ${r.estado}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
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
