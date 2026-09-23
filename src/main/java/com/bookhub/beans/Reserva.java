package com.bookhub.beans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Timestamp;

public class Reserva implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idReserva;
    private int idUsuario;
    private String nombreUsuario;
    private String emailUsuario;
    private int idLibro;
    private String tituloLibro;
    private String portadaLibro;
    private Timestamp fechaReserva;
    private Date fechaVencimiento;
    private String estado;

    public Reserva() {}

    public int getIdReserva() { return idReserva; }
    public void setIdReserva(int idReserva) { this.idReserva = idReserva; }

    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }

    public String getNombreUsuario() { return nombreUsuario; }
    public void setNombreUsuario(String nombreUsuario) { this.nombreUsuario = nombreUsuario; }

    public String getEmailUsuario() { return emailUsuario; }
    public void setEmailUsuario(String emailUsuario) { this.emailUsuario = emailUsuario; }

    public int getIdLibro() { return idLibro; }
    public void setIdLibro(int idLibro) { this.idLibro = idLibro; }

    public String getTituloLibro() { return tituloLibro; }
    public void setTituloLibro(String tituloLibro) { this.tituloLibro = tituloLibro; }

    public String getPortadaLibro() { return portadaLibro; }
    public void setPortadaLibro(String portadaLibro) { this.portadaLibro = portadaLibro; }

    public Timestamp getFechaReserva() { return fechaReserva; }
    public void setFechaReserva(Timestamp fechaReserva) { this.fechaReserva = fechaReserva; }

    public Date getFechaVencimiento() { return fechaVencimiento; }
    public void setFechaVencimiento(Date fechaVencimiento) { this.fechaVencimiento = fechaVencimiento; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
