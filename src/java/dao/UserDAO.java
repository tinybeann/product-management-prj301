package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.User;
import util.PasswordUtil;

public class UserDAO {

    /**
     * Dang nhap nguoi dung bang username va mat khau goc (rawPassword).
     * Chi cho phep user dang hoat dong (is_active = 1).
     */
    public User login(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return null;
        }
        String hashedPassword = PasswordUtil.hashPassword(rawPassword);
        String sql = "SELECT u.user_id, u.username, u.password, u.full_name, u.email, "
                + "u.phone, u.address, u.role_id, u.is_active, u.created_at, r.role_name "
                + "FROM Users u "
                + "INNER JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.username = ? AND u.password = ? AND u.is_active = 1";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, hashedPassword);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                            rs.getInt("user_id"),
                            rs.getString("username"),
                            rs.getString("password"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("address"),
                            rs.getInt("role_id"),
                            rs.getBoolean("is_active"),
                            rs.getTimestamp("created_at")
                    );
                    user.setRoleName(rs.getString("role_name"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiem tra xem username da ton tai trong bang Users chua.
     */
    public boolean checkUsernameExists(String username) {
        String sql = "SELECT 1 FROM Users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiem tra xem email da ton tai trong bang Users chua.
     */
    public boolean checkEmailExists(String email) {
        String sql = "SELECT 1 FROM Users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Dang ky tai khoan khach hang moi (vai tro CUSTOMER, is_active = 1, created_at = GETDATE()).
     */
    public boolean register(User user) {
        if (user == null || user.getPasswordHash() == null) {
            return false;
        }
        String hashedPassword = PasswordUtil.hashPassword(user.getPasswordHash());
        String sql = "INSERT INTO Users (username, password, full_name, email, phone, address, role_id, is_active, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, "
                + "COALESCE((SELECT role_id FROM Roles WHERE role_name = N'CUSTOMER'), 2), "
                + "1, GETDATE())";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername().trim());
            ps.setString(2, hashedPassword);
            ps.setString(3, user.getFullName().trim());
            ps.setString(4, user.getEmail().trim());
            ps.setString(5, user.getPhone() != null ? user.getPhone().trim() : null);
            ps.setString(6, user.getAddress() != null ? user.getAddress().trim() : null);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
