<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Devoluciones | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Mis Devoluciones</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Historial de Devoluciones</h1>
                <p class="text-muted small mb-0">Registro de libros entregados conforme y estado de recepción.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/usuario/prestamos" class="btn btn-bh-outline btn-sm">
                    <i class="bi bi-journal-bookmark me-1"></i> Ver Préstamos Activos
                </a>
            </div>
        </div>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <c:choose>
                <c:when test="${empty devoluciones}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-clock-history fs-1 mb-2 d-block"></i>
                        <h5>No tienes devoluciones registradas</h5>
                        <p class="small">Cuando devuelvas tus préstamos en la biblioteca, aparecerán registrados aquí.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0">
                            <thead>
                                <tr>
                                    <th># Devolución</th>
                                    <th>Libro</th>
                                    <th>Fecha de Devolución</th>
                                    <th>Estado del Ejemplar</th>
                                    <th>Multa</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${devoluciones}">
                                    <tr>
                                        <td><span class="text-muted fw-bold">#DEV-${d.idDevolucion}</span></td>
                                        <td>
                                            <span class="fw-bold text-dark">${d.tituloLibro}</span>
                                            <small class="text-muted d-block">Préstamo asociado #${d.idPrestamo}</small>
                                        </td>
                                        <td>${d.fechaDevolucion}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${d.estadoLibro eq 'BUENO'}">
                                                    <span class="badge bg-success-subtle text-success border border-success border-opacity-25">
                                                        <i class="bi bi-check-circle me-1"></i> Óptimo
                                                    </span>
                                                </c:when>
                                                <c:when test="${d.estadoLibro eq 'REGULAR'}">
                                                    <span class="badge bg-warning-subtle text-warning border border-warning border-opacity-25">
                                                        Regular
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger-subtle text-danger border border-danger border-opacity-25">
                                                        Dañado
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${d.multa > 0}">
                                                    <span class="text-danger fw-bold">$${d.multa}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-success small">$0.00 (Sin multas)</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <small class="text-muted">${d.observaciones != null && !d.observaciones.isEmpty() ? d.observaciones : 'Recepción conforme'}</small>
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
