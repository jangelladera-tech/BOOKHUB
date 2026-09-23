/**
 * BOOKHUB - Scripts de Interactividad del Cliente
 */
document.addEventListener('DOMContentLoaded', () => {

    // Auto-ocultar alertas temporales
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        setTimeout(() => {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(alert);
            if (bsAlert) bsAlert.close();
        }, 4500);
    });

    // Tooltips de Bootstrap
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Rellenar modal de edición de libro
    const modalEditarLibro = document.getElementById('modalEditarLibro');
    if (modalEditarLibro) {
        modalEditarLibro.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            modalEditarLibro.querySelector('#edit_idLibro').value = button.getAttribute('data-id') || '';
            modalEditarLibro.querySelector('#edit_titulo').value = button.getAttribute('data-titulo') || '';
            modalEditarLibro.querySelector('#edit_isbn').value = button.getAttribute('data-isbn') || '';
            modalEditarLibro.querySelector('#edit_idAutor').value = button.getAttribute('data-autor') || '';
            modalEditarLibro.querySelector('#edit_idCategoria').value = button.getAttribute('data-categoria') || '';
            modalEditarLibro.querySelector('#edit_editorial').value = button.getAttribute('data-editorial') || '';
            modalEditarLibro.querySelector('#edit_anioPublicacion').value = button.getAttribute('data-anio') || '';
            modalEditarLibro.querySelector('#edit_paginas').value = button.getAttribute('data-paginas') || '';
            modalEditarLibro.querySelector('#edit_ejemplaresTotales').value = button.getAttribute('data-ejemplares') || '';
            modalEditarLibro.querySelector('#edit_portadaUrl').value = button.getAttribute('data-portada') || '';
            modalEditarLibro.querySelector('#edit_descripcion').value = button.getAttribute('data-descripcion') || '';
            modalEditarLibro.querySelector('#edit_destacado').checked = button.getAttribute('data-destacado') === 'true';
        });
    }

    // Rellenar modal de devolución de préstamo
    const modalDevolver = document.getElementById('modalDevolver');
    if (modalDevolver) {
        modalDevolver.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            if (!button) return;

            modalDevolver.querySelector('#dev_idPrestamo').value = button.getAttribute('data-id') || '';
            modalDevolver.querySelector('#dev_libroTitulo').innerText = button.getAttribute('data-libro') || '';
            modalDevolver.querySelector('#dev_usuarioNombre').innerText = button.getAttribute('data-usuario') || '';
        });
    }
});
