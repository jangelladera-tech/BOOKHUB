<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión | BOOKHUB</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/styles.css" rel="stylesheet">
</head>
<body class="d-flex flex-column justify-content-between min-vh-100">

    <jsp:include page="/WEB-INF/views/components/navbar.jsp" />

    <div class="container my-5">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card border border-slate-200 rounded-4 shadow-sm bg-white p-4 p-sm-5">
                    <div class="text-center mb-4">
                        <div class="bg-primary text-white rounded-3 d-inline-flex p-3 mb-2 shadow-xs">
                            <i class="bi bi-book-half fs-3"></i>
                        </div>
                        <h2 class="h4 font-serif fw-bold text-dark">Acceder a BOOKHUB</h2>
                        <p class="text-muted small">Ingresa con tus credenciales de lector o administrador.</p>
                    </div>

                    <!-- Mensajes de error -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 small" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <c:if test="${param.error eq 'debeIniciarSesion'}">
                        <div class="alert alert-warning alert-dismissible fade show rounded-3 small" role="alert">
                            <i class="bi bi-info-circle-fill me-1"></i> Debes iniciar sesión para continuar.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="mb-3">
                            <label for="email" class="form-label small fw-bold text-muted">Correo Institucional / Electrónico</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-envelope text-muted"></i></span>
                                <input type="email" class="form-control bg-light" id="email" name="email" value="${emailIngresado}" placeholder="tu.correo@universidad.edu" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label for="password" class="form-label small fw-bold text-muted">Contraseña</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light"><i class="bi bi-lock text-muted"></i></span>
                                <input type="password" class="form-control bg-light" id="password" name="password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-bh-primary w-100 py-2.5 fw-bold shadow-xs">
                            Iniciar Sesión <i class="bi bi-arrow-right ms-1"></i>
                        </button>
                    </form>

                    <div class="text-center mt-4 pt-3 border-top">
                        <span class="text-muted small">¿No tienes cuenta aún?</span>
                        <a href="${pageContext.request.contextPath}/registro" class="text-decoration-none fw-bold text-primary small ms-1">
                            Regístrate aquí
                        </a>
                    </div>

                    <!-- Credenciales de prueba demostrativas -->
                    <div class="mt-4 p-3 bg-light rounded-3 border small">
                        <div class="fw-bold text-dark mb-1"><i class="bi bi-key-fill text-warning me-1"></i> Usuarios de Prueba:</div>
                        <div class="text-muted" style="font-size: 0.78rem;">
                            <strong>Admin:</strong> admin@bookhub.com / <code>admin123</code><br>
                            <strong>Lector:</strong> juan.perez@universidad.edu / <code>usuario123</code>
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
