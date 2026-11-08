package context;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBContext {

    // Cau hinh doc tu bien moi truong (xem .env.example), khong hard-code thong tin nhay cam.
    private static String env(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isEmpty()) ? def : v;
    }

    public static final String serverName = env("DB_HOST", "localhost");
    public static final String portNumber = env("DB_PORT", "1433");
    public static final String dbName = env("DB_NAME", "product_mgmt");
    public static final String userID = env("DB_USER", "sa");
    public static final String password = env("DB_PASSWORD", "");

    public static Connection getConnection() throws Exception {
        String url = "jdbc:sqlserver://" + serverName + ":" + portNumber
                + ";databaseName=" + dbName
                + ";encrypt=true;trustServerCertificate=true;";
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, userID, password);
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("Ket noi SQL Server thanh cong!");
            }
        } catch (Exception e) {
            System.err.println("Ket noi SQL Server that bai: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
