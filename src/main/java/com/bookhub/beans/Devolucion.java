package com.bookhub.beans;

import java.io.Serializable;
import java.sql.Timestamp;

public class Devolucion implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idDevolucion;
    private int idPrestamo;
    private Timestamp fechaDevolucion;
    private String estadoLibro;
    private double multa;
    private String observaciones;
    private String tituloLibro;
    private String nombreUsuario;

    public Devolucion() {}

    public int getIdDevolucion() { return idDevolucion; }
    public void setIdDevolucion(int idDevolucion) { this.idDevolucion = idDevolucion; }

    public int getIdPrestamo() { return idPrestamo; }
    public void setIdPrestamo(int idPrestamo) { this.idPrestamo = idPrestamo; }

    public Timestamp getFechaDevolucion() { return fechaDevolucion; }
    public void setFechaDevolucion(Timestamp fechaDevolucion) { this.fechaDevolucion = fechaDevolucion; }

    public String getEstadoLibro() { return estadoLibro; }
    public void setEstadoLibro(String estadoLibro) { this.estadoLibro = estadoLibro; }

    public double getMulta() { return multa; }
    public void setMulta(double multa) { this.multa = multa; }

    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }

    public String getTituloLibro() { return tituloLibro; }
    public void setTituloLibro(String tituloLibro) { this.tituloLibro = tituloLibro; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }
}
