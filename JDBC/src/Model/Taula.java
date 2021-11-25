package Model;

import java.util.LinkedList;

public class Taula {
    private String nom;
    private LinkedList<Columna> columnes = new LinkedList<>();

    public void setNom(String nom) {
        this.nom = nom;
    }

    public void addColumna(Columna columna) {
        columnes.add(columna);
    }

    public String getNom() {
        return nom;
    }

    public LinkedList<Columna> getColumnes() {
        return columnes;
    }
}
