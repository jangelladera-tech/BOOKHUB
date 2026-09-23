<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mis Préstamos | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Mis Préstamos</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Mis Préstamos Bibliotecarios</h1>
                <p class="text-muted small mb-0">Historial completo de libros retirados y fechas límite de entrega.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-bh-primary btn-sm">
                    <i class="bi bi-search me-1"></i> Explorar Más Libros
                </a>
            </div>
        </div>

        <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
            <c:choose>
                <c:when test="${empty prestamos}">
                    <div class="text-center py-5 text-muted">
                        <i class="bi bi-journal-x fs-1 mb-2 d-block"></i>
                        <h5>No tienes préstamos registrados</h5>
                        <p class="small">Solicita un ejemplar en el mostrador de biblioteca o explora el catálogo.</p>
                        <a href="${pageContext.request.contextPath}/catalogo" class="btn btn-outline-primary btn-sm rounded-pill px-4">
                            Ir al Catálogo
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Libro</th>
                                    <th>Fecha Préstamo</th>
                                    <th>Fecha Límite</th>
                                    <th>Fecha Devolución</th>
                                    <th>Estado</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${prestamos}">
                                    <tr>
                                        <td><span class="text-muted fw-bold">#${p.idPrestamo}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${p.portadaLibro}" alt="${p.tituloLibro}" class="rounded shadow-xs object-fit-cover" style="width: 45px; height: 60px;" onerror="this.src='https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?auto=format&fit=crop&q=80&w=600'">
                                                <div>
                                                    <span class="fw-bold text-dark d-block">${p.tituloLibro}</span>
                                                    <a href="${pageContext.request.contextPath}/libro?id=${p.idLibro}" class="text-decoration-none small text-primary">
                                                        Ver ficha &rarr;
                                                    </a>
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
                                            ${p.fechaDevolucionReal != null ? p.fechaDevolucionReal : '<span class="badge bg-light text-muted">Pendiente</span>'}
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
                                        <td>
                                            <small class="text-muted">${p.observaciones != null && !p.observaciones.isEmpty() ? p.observaciones : '-'}</small>
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
