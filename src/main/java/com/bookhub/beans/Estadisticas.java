package com.bookhub.beans;

import java.io.Serializable;

public class Estadisticas implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalLibros;
    private int totalUsuarios;
    private int prestamosActivos;
    private int reservasPendientes;
    private int librosDisponibles;
    private int totalDevoluciones;

    public Estadisticas() {}

    public int getTotalLibros() { return totalLibros; }
    public void setTotalLibros(int totalLibros) { this.totalLibros = totalLibros; }

    public int getTotalUsuarios() { return totalUsuarios; }
    public void setTotalUsuarios(int totalUsuarios) { this.totalUsuarios = totalUsuarios; }

    public int getPrestamosActivos() { return prestamosActivos; }
    public void setPrestamosActivos(int prestamosActivos) { this.prestamosActivos = prestamosActivos; }

    public int getReservasPendientes() { return reservasPendientes; }
    public void setReservasPendientes(int reservasPendientes) { this.reservasPendientes = reservasPendientes; }

    public int getLibrosDisponibles() { return librosDisponibles; }
    public void setLibrosDisponibles(int librosDisponibles) { this.librosDisponibles = librosDisponibles; }

    public int getTotalDevoluciones() { return totalDevoluciones; }
    public void setTotalDevoluciones(int totalDevoluciones) { this.totalDevoluciones = totalDevoluciones; }
}
