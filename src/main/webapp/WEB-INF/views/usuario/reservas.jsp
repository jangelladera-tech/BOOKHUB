<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Reservas | BOOKHUB</title>
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
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/usuario/dashboard" class="text-decoration-none">Mi Panel</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Mis Reservas</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Mis Reservas Activas</h1>
                <p class="text-muted small mb-0">Consulta tus apartados de libros y fechas de vencimiento para recogerlos en sala.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-bh-primary btn-sm">
                    <i class="bi bi-bookmark-plus me-1"></i> Nueva Reserva
                </a>
            </div>
        </div>

        <c:if test="${param.msg eq 'reservaExitosa'}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ¡Tu reserva ha sido registrada con éxito! Tienes 3 días hábiles para recoger el libro.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.msg eq 'cancelada'}">
            <div class="alert alert-info alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-info-circle-fill me-2"></i> La reserva ha sido cancelada correctamente.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <c:choose>
                <c:when test="${empty reservas}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-calendar-x fs-1 mb-2 d-block"></i>
                        <h5>No tienes reservas pendientes</h5>
                        <p class="small">Cuando reserves un libro del catálogo, aparecerá aquí con su fecha límite de retiro.</p>
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill px-4">
                            Explorar Catálogo
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0">
                            <thead>
                                <tr>
                                    <th># Reserva</th>
                                    <th>Libro</th>
                                    <th>Fecha Registro</th>
                                    <th>Válida Hasta</th>
                                    <th>Estado</th>
                                    <th class="text-end">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${reservas}">
                                    <tr>
                                        <td><span class="text-muted fw-bold">#RES-${r.idReserva}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${r.portadaLibro}" alt="${r.tituloLibro}" class="rounded shadow-xs object-fit-cover" style="width: 45px; height: 60px;" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                                                <div>
                                                    <span class="fw-bold text-dark d-block">${r.tituloLibro}</span>
                                                    <a href="${pageContext.request.contextPath}/libro?id=${r.idLibro}" class="text-decoration-none small text-primary">
                                                        Ver ficha &rarr;
                                                    </a>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${r.fechaReserva}</td>
                                        <td>
                                            <span class="fw-bold ${r.estado eq 'PENDIENTE' ? 'text-primary' : 'text-muted'}">
                                                ${r.fechaVencimiento}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.estado eq 'PENDIENTE'}">
                                                    <span class="badge bg-warning text-dark"><i class="bi bi-clock"></i> Pendiente Retiro</span>
                                                </c:when>
                                                <c:when test="${r.estado eq 'COMPLETADA'}">
                                                    <span class="badge bg-success"><i class="bi bi-check-all"></i> Entregada</span>
                                                </c:when>
                                                <c:when test="${r.estado eq 'CANCELADA'}">
                                                    <span class="badge bg-secondary"><i class="bi bi-x-circle"></i> Cancelada</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger">${r.estado}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <c:if test="${r.estado eq 'PENDIENTE'}">
                                                <form action="${pageContext.request.contextPath}/usuario/reservar" method="POST" onsubmit="return confirm('¿Seguro que deseas cancelar esta reserva?');">
                                                    <input type="hidden" name="action" value="cancelar">
                                                    <input type="hidden" name="idReserva" value="${r.idReserva}">
                                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-pill px-3">
                                                        <i class="bi bi-trash"></i> Cancelar
                                                    </button>
                                                </form>
                                            </c:if>
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

    <jsp:include page="/WEB-INF/views/components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
