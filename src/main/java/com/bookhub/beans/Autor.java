package com.bookhub.beans;

import java.io.Serializable;

public class Autor implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idAutor;
    private String nombre;
    private String nacionalidad;
    private String biografia;
    private String fotoUrl;
    private int totalLibros;

    public Autor() {}

    public Autor(int idAutor, String nombre, String nacionalidad, String biografia, String fotoUrl) {
        this.idAutor = idAutor;
        this.nombre = nombre;
        this.nacionalidad = nacionalidad;
        this.biografia = biografia;
        this.fotoUrl = fotoUrl;
    }

    public int getIdAutor() { return idAutor; }
    public void setIdAutor(int idAutor) { this.idAutor = idAutor; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getNacionalidad() { return nacionalidad; }
    public void setNacionalidad(String nacionalidad) { this.nacionalidad = nacionalidad; }

    public String getBiografia() { return biografia; }
    public void setBiografia(String biografia) { this.biografia = biografia; }

    public String getFotoUrl() { return fotoUrl; }
    public void setFotoUrl(String fotoUrl) { this.fotoUrl = fotoUrl; }

    public int getTotalLibros() { return totalLibros; }
    public void setTotalLibros(int totalLibros) { this.totalLibros = totalLibros; }
}
