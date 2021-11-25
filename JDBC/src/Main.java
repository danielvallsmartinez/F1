import Controller.ControllerLocalDB;
import Controller.ControllerServerDB;
import Model.Taula;

import java.sql.SQLException;

public class Main {
    public static void main(String[] args) {
        ControllerServerDB controllerServerDB = new ControllerServerDB();
        //ArrayList<ModelExample> modelExamples = new ArrayList<>();


        System.out.println("Connecting to Database...");
        if (!controllerServerDB.startRemoteConnection()) System.exit(1);

        System.out.println("Getting information...");
        try {
            controllerServerDB.loadRemoteInfo();
            //for (ModelExample modelExample : modelExamples) System.out.println(modelExample.toString());
        } catch (SQLException e) {
            e.printStackTrace();
        }

        ControllerLocalDB controllerLocalDB = new ControllerLocalDB(controllerServerDB.getTaula());
        if (!controllerLocalDB.startRemoteConnection()) System.exit(1);

        System.out.println("Sending information...");
        try {
            controllerLocalDB.loadRemoteInfo();
            //for (ModelExample modelExample : modelExamples) System.out.println(modelExample.toString());
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
