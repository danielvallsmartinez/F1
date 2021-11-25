package Controller;

import Model.Columna;
import Model.ModelExample;
import Model.Settings;
import Model.Taula;
import db.ConectorDB;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Scanner;

public class ControllerServerDB {

    private Connection remoteConnection;
    private LinkedList<Taula> taula;

    public boolean startRemoteConnection(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            remoteConnection = DriverManager.getConnection("jdbc:mysql://puigpedros.salleurl.edu/?user=" + Settings.REMOTEUSER + "&password=" + Settings.REMOTEPASSWORD + "&serverTimezone=UTC");
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }


    public void loadRemoteInfo() throws SQLException {
        ResultSet rs;
        Statement stmt;
        int num_columnes;
        Columna columna;
        taula = new LinkedList<>();

        LinkedList<String> tables = new LinkedList<>();
        LinkedList<String> column_names;

        System.out.println("Reading remote info");

        stmt = remoteConnection.createStatement();
        stmt.executeQuery("USE F1;");

        stmt = remoteConnection.createStatement();
        rs = stmt.executeQuery("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA = 'F1';");

        //ResultSetMetaData metadata = rs.getMetaData();
        //int columnCount = metadata.getColumnCount();

        while (rs.next()) {

            tables.add(rs.getString("TABLE_NAME"));
        }

        for (int i = 0; i < tables.size(); i++) {

            stmt = remoteConnection.createStatement();
            stmt.executeQuery("USE F1;");

            stmt = remoteConnection.createStatement();

            taula.add(new Taula());
            taula.get(i).setNom(tables.get(i));
            rs = stmt.executeQuery("SELECT COUNT(COLUMN_NAME) AS num_columns FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '" + tables.get(i) + "' AND table_schema = 'F1';");
            rs.next();
            num_columnes = rs.getInt(1);

            rs = stmt.executeQuery("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = '" + tables.get(i) + "' AND table_schema = 'F1';");
            column_names = new LinkedList<>();
            while (rs.next()) {
                column_names.add(rs.getString(1));
            }

            rs = stmt.executeQuery("SELECT * FROM " + taula.get(i).getNom() + ";");


            for (int j = 0; j < num_columnes; j++) {

                columna = new Columna();
                columna.setNom_columna(column_names.get(j));
                rs.next();
                columna.addInfo(rs.getString(j+1));
                while (rs.next()) {
                    columna.addInfo(rs.getString(j+1));
                }

                rs.absolute(0);
                taula.get(i).addColumna(columna);
            }

            stmt.close();

        }

        rs.close();

    }

    public LinkedList<Taula> getTaula() {
        return taula;
    }
}
