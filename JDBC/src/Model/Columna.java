package Model;

import java.util.LinkedList;

public class Columna {

    private String nom_columna;
    private LinkedList<String> info = new LinkedList();

    public void setNom_columna(String nom_columna) {
        this.nom_columna = nom_columna;
    }

    public void addInfo(String info) {
        this.info.add(info);
    }

    public LinkedList<String> getInfo() {
        return info;
    }

    public String getNom_columna() {
        return nom_columna;
    }
}


