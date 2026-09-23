<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Reservas | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Reservas</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Gestión de Reservas</h1>
                <p class="text-muted small mb-0">Audita y gestiona las solicitudes de reserva realizadas por los lectores.</p>
            </div>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.msg eq 'reservaCompletada'}">Reserva marcada como completada/entregada.</c:when>
                    <c:when test="${param.msg eq 'reservaCancelada'}">Reserva cancelada correctamente.</c:when>
                    <c:otherwise>Operación procesada con éxito.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <div class="table-responsive">
                <table class="table table-bh align-middle mb-0">
                    <thead>
                        <tr>
                            <th># Reserva</th>
                            <th>Lector / Estudiante</th>
                            <th>Libro Reservado</th>
                            <th>Fecha Registro</th>
                            <th>Vence</th>
                            <th>Estado</th>
                            <th class="text-end">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${reservas}">
                            <tr>
                                <td><span class="text-muted fw-bold">#RES-${r.idReserva}</span></td>
                                <td>
                                    <div class="fw-bold text-dark">${r.nombreUsuario}</div>
                                    <small class="text-muted">${r.emailUsuario}</small>
                                </td>
                                <td>
                                    <span class="fw-semibold text-dark">${r.tituloLibro}</span>
                                </td>
                                <td>${r.fechaReserva}</td>
                                <td>
                                    <span class="${r.estado eq 'PENDIENTE' ? 'fw-bold text-primary' : 'text-muted'}">
                                        ${r.fechaVencimiento}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.estado eq 'PENDIENTE'}">
                                            <span class="badge bg-warning text-dark"><i class="bi bi-clock"></i> Pendiente</span>
                                        </c:when>
                                        <c:when test="${r.estado eq 'COMPLETADA'}">
                                            <span class="badge bg-success"><i class="bi bi-check-all"></i> Completada</span>
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
                                        <div class="btn-group btn-group-sm">
                                            <form action="${pageContext.request.contextPath}/admin/reservas" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="completar">
                                                <input type="hidden" name="idReserva" value="${r.idReserva}">
                                                <button type="submit" class="btn btn-outline-success" title="Marcar como entregada">
                                                    <i class="bi bi-check-lg"></i> Entregar
                                                </button>
                                            </form>
                                            <form action="${pageContext.request.contextPath}/admin/reservas" method="POST" class="d-inline" onsubmit="return confirm('¿Seguro que deseas cancelar esta reserva?');">
                                                <input type="hidden" name="action" value="cancelar">
                                                <input type="hidden" name="idReserva" value="${r.idReserva}">
                                                <button type="submit" class="btn btn-outline-danger" title="Cancelar reserva">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </form>
                                        </div>
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
