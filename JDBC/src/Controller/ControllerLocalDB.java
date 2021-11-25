package Controller;

import Model.Settings;
import Model.Taula;


import java.sql.*;
import java.util.LinkedList;
import com.mysql.jdbc.Connection;

public class ControllerLocalDB {

    private Connection conn;
    private LinkedList<Taula> taula;

    public ControllerLocalDB(LinkedList<Taula> taula) {
        this.taula = taula;
    }

    public boolean startRemoteConnection(){
        try{
            Class.forName("com.mysql.jdbc.Connection");
            conn = (Connection) DriverManager.getConnection("jdbc:mysql://localhost:3306/F1?verifyServerCertificate=false&useSSL=true","root",Settings.LOCALPASSWORD);
            return true;
        }catch(Exception e){
            e.printStackTrace();
            return false;
        }
    }
    /*
    public boolean startRemoteConnection() {

        conn = new ConectorDB("daniel.vm", Settings.LOCALPASSWORD, "F1", 3306);
        boolean connected = conn.connect();

        return connected;
    }
    */
    public void loadRemoteInfo() throws SQLException {
        String camps;
        String campsSenseTipus = "";
        String info;
        int numRows = 0;
        Statement stmt;

        stmt = conn.createStatement();
        stmt.executeQuery("USE F1;");

        for (int i = 0; i < 13; i++) {

            //if (taula.get(i).getNom().equals("driverStandings")) {
                System.out.println(taula.get(i).getNom());
                camps = "";

                System.out.println("-----");
                for (int j = 0; j < taula.get(i).getColumnes().size(); j++) {
                    if (j == taula.get(i).getColumnes().size() - 1) {
                        camps = camps.concat(taula.get(i).getColumnes().get(j).getNom_columna() + " VARCHAR(255)\n");
                        campsSenseTipus = campsSenseTipus.concat(taula.get(i).getColumnes().get(j).getNom_columna() + " VARCHAR(255)\n");
                    } else {
                        camps = camps.concat(taula.get(i).getColumnes().get(j).getNom_columna() + " VARCHAR(255), \n");
                        campsSenseTipus = campsSenseTipus.concat(taula.get(i).getColumnes().get(j).getNom_columna() + " VARCHAR(255), \n");
                    }
                }
                stmt = conn.createStatement();
                //stmt.executeUpdate("DROP TABLE IF EXISTS " + taula.get(i).getNom() +" CASCADE;");
                //stmt.executeUpdate("CREATE TABLE IF NOT EXISTS " + taula.get(i).getNom() + "( \n" + camps + "); ");


                for (int k = 0; k < taula.get(i).getColumnes().get(0).getInfo().size(); k++) {
                    info = "";
                    for (int m = 0; m < taula.get(i).getColumnes().size(); m++) {
                        if (taula.get(i).getColumnes().get(m).getInfo().get(k) == null || taula.get(i).getColumnes().get(m).getInfo().get(k).isEmpty()) {
                            if (m == taula.get(i).getColumnes().size() - 1) {
                                info = info.concat("null");
                            } else {
                                info = info.concat(null + ", ");
                            }
                        } else {
                            if (m == taula.get(i).getColumnes().size() - 1) {
                                if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("d'Orey")) { //O'Connor
                                    info = info.concat("'d''Orey'");
                                }
                                else {
                                    if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("O'Connor")) { //O'Connor
                                        info = info.concat("'O''Connor'");
                                    } else {
                                        if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("O'Brien")) { //O'Connor
                                            info = info.concat("'O''Brien'");
                                        }
                                        else {
                                            if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("d'Ambrosio")) { //O'Connor
                                                info = info.concat("'d''Ambrosio'");
                                            }
                                            else {
                                                info = info.concat("'" + taula.get(i).getColumnes().get(m).getInfo().get(k) + "'");
                                            }
                                        }
                                    }
                                }

                            } else {
                                if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("d'Orey")) {
                                    info = info.concat("'d''Orey', ");
                                } else {
                                    if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("O'Connor")) { //O'Connor
                                        info = info.concat("'O''Connor', ");
                                    }
                                    else{
                                        if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("O'Brien")) { //O'Connor
                                            info = info.concat("'O''Brien', ");
                                        }
                                        else {
                                            if (taula.get(i).getColumnes().get(m).getInfo().get(k).equals("d'Ambrosio")) { //O'Connor
                                                info = info.concat("'d''Ambrosio', ");
                                            }
                                            else {
                                                info = info.concat("'" + taula.get(i).getColumnes().get(m).getInfo().get(k) + "', ");
                                            }
                                        }

                                    }
                                }
                            }
                        }
                    }
                    stmt = conn.createStatement();
                    stmt.executeUpdate("INSERT INTO " + taula.get(i).getNom() + " VALUES(" + info + "); ");

                }
                stmt.close();
            //}

        }

        conn.close();
    }

}
