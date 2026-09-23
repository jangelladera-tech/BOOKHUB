<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<nav class="navbar navbar-expand-lg navbar-bh sticky-top">
    <div class="container">
        <!-- Logo -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/index">
            <i class="bi bi-book-half text-primary fs-3"></i>
            <span>BOOKHUB</span>
        </a>

        <button class="navbar-toggler border-0 shadow-none" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Menú central -->
            <ul class="navbar-nav mx-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index">
                        <i class="bi bi-house me-1"></i> Inicio
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/catalogo">
                        <i class="bi bi-grid me-1"></i> Catálogo
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index#seccion-categorias">
                        <i class="bi bi-bookmarks me-1"></i> Categorías
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/index#seccion-autores">
                        <i class="bi bi-person-lines-fill me-1"></i> Autores
                    </a>
                </li>
            </ul>

            <!-- Sección derecha: Usuario / Auth -->
            <div class="d-flex align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.usuarioLogueado}">
                        <!-- Usuario Autenticado -->
                        <div class="dropdown">
                            <button class="btn btn-bh-outline dropdown-toggle d-flex align-items-center gap-2" type="button" id="userMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-center" style="width: 28px; height: 28px; font-size: 0.8rem; font-weight: bold; line-height: 28px; text-align: center;">
                                    ${sessionScope.usuarioLogueado.nombre.substring(0,1)}
                                </div>
                                <span>${sessionScope.usuarioLogueado.nombre}</span>
                                <c:if test="${sessionScope.usuarioLogueado.esAdmin()}">
                                    <span class="badge bg-danger ms-1" style="font-size: 0.65rem;">ADMIN</span>
                                </c:if>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2" aria-labelledby="userMenu">
                                <li class="px-3 py-1">
                                    <small class="text-muted d-block" style="font-size: 0.72rem;">CONECTADO COMO</small>
                                    <span class="fw-bold text-dark" style="font-size: 0.85rem;">${sessionScope.usuarioLogueado.email}</span>
                                </li>
                                <li><hr class="dropdown-divider"></li>

                                <c:choose>
                                    <c:when test="${sessionScope.usuarioLogueado.esAdmin()}">
                                        <!-- Menú Administrador -->
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2 text-primary"></i>Panel de Control</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/libros"><i class="bi bi-journal-text me-2 text-primary"></i>Gestión de Libros</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/prestamos"><i class="bi bi-arrow-left-right me-2 text-primary"></i>Préstamos y Devoluciones</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/reservas"><i class="bi bi-calendar-check me-2 text-primary"></i>Gestión de Reservas</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/usuarios"><i class="bi bi-people me-2 text-primary"></i>Gestión de Usuarios</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/autores"><i class="bi bi-person-badge me-2 text-primary"></i>Autores</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categorias"><i class="bi bi-tag me-2 text-primary"></i>Categorías</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Menú Usuario Regular -->
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/usuario/dashboard"><i class="bi bi-speedometer2 me-2 text-primary"></i>Mi Panel</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/usuario/prestamos"><i class="bi bi-journal-bookmark me-2 text-primary"></i>Mis Préstamos</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/usuario/reservas"><i class="bi bi-calendar-heart me-2 text-primary"></i>Mis Reservas</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/usuario/devoluciones"><i class="bi bi-clock-history me-2 text-primary"></i>Mis Devoluciones</a></li>
                                    </c:otherwise>
                                </c:choose>

                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>Cerrar Sesión
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Invitado -->
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-bh-outline">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Iniciar Sesión
                        </a>
                        <a href="${pageContext.request.contextPath}/registro" class="btn btn-bh-primary">
                            <i class="bi bi-person-plus me-1"></i> Registrarse
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</nav>
