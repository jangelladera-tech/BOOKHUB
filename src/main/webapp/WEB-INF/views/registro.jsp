<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Crear Cuenta | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body class="d-flex flex-column justify-content-between min-vh-100">

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card border border-slate-200 rounded-4 shadow-sm bg-white p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="bg-primary bg-opacity-10 text-primary rounded-3 d-inline-flex p-3 mb-2">
                            <i class="bi bi-person-plus-fill fs-3"></i>
                        </div>
                        <h2 class="h4 font-serif fw-bold text-dark">Registro de Lector</h2>
                        <p class="text-muted small">Crea tu cuenta universitaria para solicitar préstamos y reservar libros.</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/registro" method="POST">
                        <div class="row g-3 mb-3">
                            <div class="col-sm-6">
                                <label for="nombre" class="form-label small fw-bold text-muted">Nombre *</label>
                                <input type="text" class="form-control bg-light" id="nombre" name="nombre" value="${nombre}" placeholder="Ej. Juan" required>
                            </div>
                            <div class="col-sm-6">
                                <label for="apellido" class="form-label small fw-bold text-muted">Apellido *</label>
                                <input type="text" class="form-control bg-light" id="apellido" name="apellido" value="${apellido}" placeholder="Ej. Pérez" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="email" class="form-label small fw-bold text-muted">Correo Institucional / Personal *</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                                <input type="email" class="form-control bg-light" id="email" name="email" value="${email}" placeholder="usuario@universidad.edu" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="telefono" class="form-label small fw-bold text-muted">Teléfono de Contacto</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-telephone text-muted"></i></span>
                                <input type="tel" class="form-control bg-light" id="telefono" name="telefono" value="${telefono}" placeholder="+51 987654321">
                            </div>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-sm-6">
                                <label for="password" class="form-label small fw-bold text-muted">Contraseña *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-lock text-muted"></i></span>
                                    <input type="password" class="form-control bg-light" id="password" name="password" placeholder="Mínimo 6 caracteres" required>
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <label for="confirmPassword" class="form-label small fw-bold text-muted">Confirmar Contraseña *</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-shield-lock text-muted"></i></span>
                                    <input type="password" class="form-control bg-light" id="confirmPassword" name="confirmPassword" placeholder="Repite contraseña" required>
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-bh-primary w-100 py-2.5 fw-bold shadow-xs">
                            Registrarme en BOOKHUB <i class="bi bi-check-circle ms-1"></i>
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <span class="text-muted small">¿Ya tienes una cuenta registrada?</span>
                        <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-bold text-primary small ms-1">
                            Inicia sesión aquí
                        </a>
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
