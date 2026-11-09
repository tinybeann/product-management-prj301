package context;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.HashMap;
import java.util.Map;

public class DBContext {

    // Thu tu uu tien: bien moi truong he thong > file .env > gia tri mac dinh.
    private static final Map<String, String> envMap = loadEnvFile();

    private static String env(String key, String def) {
        String v = System.getenv(key);
        if (v == null || v.isEmpty()) {
            v = envMap.get(key);
        }
        return (v == null || v.isEmpty()) ? def : v;
    }

    /**
     * Tim file .env: thu muc lam viec truoc, sau do di nguoc len tu vi tri class
     * (build/web/WEB-INF/classes -> ... -> thu muc goc du an) vi khi chay tren
     * Tomcat thu muc lam viec khong phai thu muc du an.
     */
    private static Map<String, String> loadEnvFile() {
        Map<String, String> map = new HashMap<>();
        try {
            File dir = new File(DBContext.class.getProtectionDomain().getCodeSource().getLocation().toURI());
            File file = new File(".env");
            for (int i = 0; !file.isFile() && i < 8 && dir != null; i++, dir = dir.getParentFile()) {
                file = new File(dir, ".env");
            }
            if (!file.isFile()) {
                System.err.println("[DBContext] Khong tim thay file .env, dung gia tri mac dinh.");
                return map;
            }
            for (String line : Files.readAllLines(file.toPath(), StandardCharsets.UTF_8)) {
                line = line.replace("\uFEFF", "").trim(); // bo BOM neu co
                int idx = line.indexOf('=');
                if (line.startsWith("#") || idx <= 0) {
                    continue;
                }
                String value = line.substring(idx + 1).trim();
                if (value.length() >= 2 && value.startsWith("\"") && value.endsWith("\"")) {
                    value = value.substring(1, value.length() - 1);
                }
                map.put(line.substring(0, idx).trim(), value);
            }
        } catch (Exception e) {
            System.err.println("[DBContext] Khong the doc file .env: " + e.getMessage());
        }
        return map;
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
            System.out.println("Ket noi SQL Server thanh cong!");
        } catch (Exception e) {
            System.err.println("Ket noi SQL Server that bai: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
