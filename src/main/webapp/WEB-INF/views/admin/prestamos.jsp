<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Préstamos y Devoluciones | BOOKHUB</title>
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
                        <li class="breadcrumb-item active" aria-current="page">Préstamos y Devoluciones</li>
                    </ol>
                </nav>
                <h1 class="h2 font-serif fw-bold text-dark mb-0">Circulación Bibliotecaria</h1>
                <p class="text-muted small mb-0">Registra entregas de libros en sala y procesa devoluciones físicas.</p>
            </div>
            <div>
                <button type="button" class="btn btn-bh-primary btn-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoPrestamo">
                    <i class="bi bi-arrow-right-circle me-1"></i> Registrar Nuevo Préstamo
                </button>
            </div>
        </div>

        <!-- Alertas -->
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.msg eq 'prestamoCreado'}">Préstamo registrado y ejemplar descontado del stock.</c:when>
                    <c:when test="${param.msg eq 'devolucionRegistrada'}">Devolución procesada y ejemplar reintegrado al inventario.</c:when>
                    <c:otherwise>Operación procesada con éxito.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-xs" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.error eq 'noDisponible'}">El libro seleccionado no cuenta con ejemplares disponibles.</c:when>
                    <c:otherwise>Error al procesar la operación.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Pestañas para Préstamos y Devoluciones -->
        <ul class="nav nav-pills mb-4 gap-2" id="circulationTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active rounded-pill fw-semibold px-4" id="loans-tab" data-bs-toggle="pill" data-bs-target="#loans" type="button" role="tab">
                    <i class="bi bi-journal-arrow-up me-1"></i> Todos los Préstamos (${prestamos.size()})
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link rounded-pill fw-semibold px-4" id="returns-tab" data-bs-toggle="pill" data-bs-target="#returns" type="button" role="tab">
                    <i class="bi bi-journal-arrow-down me-1"></i> Historial de Devoluciones (${devoluciones.size()})
                </button>
            </li>
        </ul>

        <div class="tab-content" id="circulationTabContent">
            <!-- TAB 1: PRÉSTAMOS -->
            <div class="tab-pane fade show active" id="loans" role="tabpanel">
                <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Lector / Usuario</th>
                                    <th>Libro</th>
                                    <th>Fecha Préstamo</th>
                                    <th>Fecha Límite</th>
                                    <th>Estado</th>
                                    <th class="text-end">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${prestamos}">
                                    <tr>
                                        <td><span class="text-muted fw-bold">#${p.idPrestamo}</span></td>
                                        <td>
                                            <div class="fw-bold text-dark">${p.nombreUsuario}</div>
                                            <small class="text-muted">${p.emailUsuario}</small>
                                        </td>
                                        <td>
                                            <span class="fw-semibold text-dark">${p.tituloLibro}</span>
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
                                        <td class="text-end">
                                            <c:if test="${p.estado eq 'ACTIVO'}">
                                                <button type="button" 
                                                        class="btn btn-outline-success btn-sm rounded-pill px-3"
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#modalDevolver"
                                                        data-id="${p.idPrestamo}"
                                                        data-libro="${p.tituloLibro}"
                                                        data-usuario="${p.nombreUsuario}">
                                                    <i class="bi bi-box-arrow-in-down-left"></i> Devolver
                                                </button>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- TAB 2: DEVOLUCIONES -->
            <div class="tab-pane fade" id="returns" role="tabpanel">
                <div class="card border border-slate-200 rounded-4 bg-white p-4 shadow-xs">
                    <div class="table-responsive">
                        <table class="table table-bh align-middle mb-0">
                            <thead>
                                <tr>
                                    <th># Dev.</th>
                                    <th># Préstamo</th>
                                    <th>Usuario</th>
                                    <th>Libro</th>
                                    <th>Fecha Devolución</th>
                                    <th>Estado Libro</th>
                                    <th>Multa</th>
                                    <th>Observaciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="d" items="${devoluciones}">
                                    <tr>
                                        <td><span class="text-muted fw-bold">#DEV-${d.idDevolucion}</span></td>
                                        <td>#${d.idPrestamo}</td>
                                        <td><span class="fw-bold text-dark">${d.nombreUsuario}</span></td>
                                        <td>${d.tituloLibro}</td>
                                        <td>${d.fechaDevolucion}</td>
                                        <td>
                                            <span class="badge ${d.estadoLibro eq 'BUENO' ? 'bg-success' : (d.estadoLibro eq 'REGULAR' ? 'bg-warning text-dark' : 'bg-danger')}">
                                                ${d.estadoLibro}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${d.multa > 0}">
                                                    <span class="text-danger fw-bold">$${d.multa}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">$0.00</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><small class="text-muted">${d.observaciones}</small></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- MODAL NUEVO PRÉSTAMO -->
    <div class="modal fade" id="modalNuevoPrestamo" tabindex="-1" aria-labelledby="modalNuevoPrestamoLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/prestamos" method="POST">
                    <input type="hidden" name="action" value="crear">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold" id="modalNuevoPrestamoLabel">Registrar Préstamo en Sala</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Seleccionar Lector / Usuario *</label>
                            <select name="idUsuario" class="form-select" required>
                                <c:forEach var="u" items="${usuarios}">
                                    <option value="${u.idUsuario}">${u.nombreCompleto} (${u.email})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Seleccionar Libro Disponible *</label>
                            <select name="idLibro" class="form-select" required>
                                <c:forEach var="l" items="${librosDisponibles}">
                                    <option value="${l.idLibro}">${l.titulo} — Disp: ${l.ejemplaresDisponibles}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Días de Préstamo *</label>
                            <input type="number" name="diasPrestamo" class="form-control" value="14" min="1" max="60" required>
                            <small class="text-muted">Estándar: 14 días naturales.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Observaciones / Notas</label>
                            <textarea name="observaciones" class="form-control" rows="2" placeholder="Ej. Ejemplar entregado con forro protector"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-bh-primary">Registrar Préstamo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL PROCESAR DEVOLUCIÓN -->
    <div class="modal fade" id="modalDevolver" tabindex="-1" aria-labelledby="modalDevolverLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content rounded-4 border-0 shadow">
                <form action="${pageContext.request.contextPath}/admin/prestamos" method="POST">
                    <input type="hidden" name="action" value="devolver">
                    <input type="hidden" name="idPrestamo" id="dev_idPrestamo">
                    <div class="modal-header border-bottom">
                        <h5 class="modal-title font-serif fw-bold" id="modalDevolverLabel">Procesar Devolución</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="p-3 bg-light rounded-3 mb-3 border">
                            <div class="small text-muted">Libro a Devolver:</div>
                            <strong class="text-dark d-block mb-1" id="dev_libroTitulo"></strong>
                            <div class="small text-muted">Lector:</div>
                            <span class="text-dark" id="dev_usuarioNombre"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Estado del Ejemplar Físico *</label>
                            <select name="estadoLibro" class="form-select" required>
                                <option value="BUENO">Bueno (Óptimas condiciones)</option>
                                <option value="REGULAR">Regular (Desgaste leve)</option>
                                <option value="DANADO">Dañado / Hojas sueltas</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Multa Aplicada ($)</label>
                            <input type="number" step="0.50" min="0" name="multa" class="form-control" value="0.00">
                            <small class="text-muted">Ingresa $0.00 si se devolvió a tiempo y sin daños.</small>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Observaciones de Recepción</label>
                            <textarea name="observaciones" class="form-control" rows="2" placeholder="Recepción conforme en sala."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-top">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Confirmar Devolución</button>
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
