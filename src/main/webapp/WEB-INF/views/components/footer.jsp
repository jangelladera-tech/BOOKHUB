<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer-bh">
    <div class="container">
        <div class="row g-4 mb-4">
            <div class="col-lg-4 col-md-6">
                <div class="footer-brand mb-2 d-flex align-items-center gap-2">
                    <i class="bi bi-book-half"></i>
                    <span>BOOKHUB</span>
                </div>
                <p class="text-muted small">
                    Plataforma moderna de gestión bibliotecaria universitaria y digital. Facilitamos el acceso al conocimiento, préstamos de material bibliográfico y reservaciones en línea.
                </p>
                <div class="d-flex gap-3 text-secondary">
                    <a href="#" class="text-secondary fs-5"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-secondary fs-5"><i class="bi bi-twitter-x"></i></a>
                    <a href="#" class="text-secondary fs-5"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-secondary fs-5"><i class="bi bi-github"></i></a>
                </div>
            </div>

            <div class="col-lg-2 col-md-6">
                <h6 class="text-dark fw-bold text-uppercase small mb-3">Navegación</h6>
                <ul class="list-unstyled small space-y-2">
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/index" class="text-decoration-none text-muted">Inicio</a></li>
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/catalogo" class="text-decoration-none text-muted">Catálogo Completo</a></li>
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/index#seccion-categorias" class="text-decoration-none text-muted">Categorías</a></li>
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/index#seccion-autores" class="text-decoration-none text-muted">Autores</a></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-dark fw-bold text-uppercase small mb-3">Servicios</h6>
                <ul class="list-unstyled small space-y-2">
                    <li class="mb-1"><span class="text-muted">Préstamo de Libros Físicos</span></li>
                    <li class="mb-1"><span class="text-muted">Reservas Anticipadas</span></li>
                    <li class="mb-1"><span class="text-muted">Control de Devoluciones</span></li>
                    <li class="mb-1"><span class="text-muted">Renovaciones en Línea</span></li>
                </ul>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="text-dark fw-bold text-uppercase small mb-3">Horario y Atención</h6>
                <p class="small text-muted mb-1"><i class="bi bi-clock me-2"></i> Lunes a Viernes: 08:00 - 20:00</p>
                <p class="small text-muted mb-1"><i class="bi bi-clock me-2"></i> Sábados: 09:00 - 13:00</p>
                <p class="small text-muted"><i class="bi bi-envelope me-2"></i> biblioteca@bookhub.edu</p>
            </div>
        </div>

        <hr class="border-secondary opacity-10 my-4">

        <div class="d-flex flex-column flex-sm-row justify-content-between align-items-center text-muted small">
            <div>&copy; <%= java.time.Year.now().getValue() %> BOOKHUB. Todos los derechos reservados.</div>
            <div class="mt-2 mt-sm-0">Arquitectura Java MVC (Servlets, JSP, MySQL, Bootstrap)</div>
        </div>
    </div>
</footer>
