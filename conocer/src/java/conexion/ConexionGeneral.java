package conexion;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexionGeneral {

    public static Connection getConexion() {
        throw new UnsupportedOperationException("Not supported yet."); 
    }

    public static CallableStatement prepareCall(String call_sp_REP_CINTILLOS_EC) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    private final String driver = "com.mysql.cj.jdbc.Driver";
    private final String url = "jdbc:mysql://10.1.2.183:3306/DB_SI_06?useSSL=false";
    private final String uss = "appEvaluacion";
    private final String contra = "E74p3!vD364";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Driver MySQL cargado correctamente.");
        } catch (ClassNotFoundException e) {
            System.err.println("No se encontró el driver MySQL: " + e.getMessage());
        }
    }

    public Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, uss, contra);
    }

    public Connection obtenerConexion() {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
}
