package dao;

import context.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Product;

public class ProductDAO {

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product(
                rs.getInt("product_id"),
                rs.getInt("category_id"),
                rs.getString("product_name"),
                rs.getString("description"),
                rs.getBigDecimal("price"),
                rs.getInt("stock"),
                rs.getString("image_url"),
                rs.getBoolean("is_active"),
                rs.getTimestamp("created_at")
        );
        p.setCategoryName(rs.getString("category_name"));
        return p;
    }

    /**
     * Lay danh sach toan bo san pham (sap xep theo product_id giam dan).
     */
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.product_id, p.category_id, p.product_name, p.description, "
                + "p.price, p.stock, p.image_url, p.is_active, p.created_at, c.category_name "
                + "FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "ORDER BY p.product_id DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay chi tiet san pham theo product_id.
     */
    public Product getProductById(int id) {
        String sql = "SELECT p.product_id, p.category_id, p.product_name, p.description, "
                + "p.price, p.stock, p.image_url, p.is_active, p.created_at, c.category_name "
                + "FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.product_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Them moi san pham (is_active mac dinh = 1 hoac theo p.isStatus(), created_at = GETDATE()).
     */
    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO Products (product_name, description, price, stock, image_url, category_id, is_active, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductName().trim());
            ps.setString(2, p.getDescription());
            ps.setBigDecimal(3, p.getPrice());
            ps.setInt(4, p.getStockQuantity());
            ps.setString(5, p.getImageUrl());
            ps.setInt(6, p.getCategoryId());
            ps.setBoolean(7, p.isStatus());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Cap nhat thong tin san pham.
     */
    public boolean updateProduct(Product p) {
        String sql = "UPDATE Products "
                + "SET product_name = ?, category_id = ?, price = ?, stock = ?, "
                + "description = ?, image_url = ?, is_active = ? "
                + "WHERE product_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, p.getProductName().trim());
            ps.setInt(2, p.getCategoryId());
            ps.setBigDecimal(3, p.getPrice());
            ps.setInt(4, p.getStockQuantity());
            ps.setString(5, p.getDescription());
            ps.setString(6, p.getImageUrl());
            ps.setBoolean(7, p.isStatus());
            ps.setInt(8, p.getProductId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Xoa san pham: uu tien xoa vat ly neu chua phat sinh trong OrderDetails,
     * neu vướng khoa ngoai thi chuyen sang soft delete (is_active = 0).
     */
    public boolean deleteProduct(int id) {
        String hardDeleteSql = "DELETE FROM Products WHERE product_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(hardDeleteSql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception ex) {
            // Neu san pham da co trong OrderDetails (FK constraint), thuc hien soft delete
            String softDeleteSql = "UPDATE Products SET is_active = 0 WHERE product_id = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(softDeleteSql)) {
                ps.setInt(1, id);
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return false;
    }

    /**
     * Tim kiem tuong doi theo ten san pham (keyword) va loc theo danh muc (categoryId).
     */
    public List<Product> searchAndFilter(String keyword, Integer categoryId) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.product_id, p.category_id, p.product_name, p.description, "
                + "p.price, p.stock, p.image_url, p.is_active, p.created_at, c.category_name "
                + "FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.product_name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ? ");
            params.add(categoryId);
        }

        sql.append(" ORDER BY p.product_id DESC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setNString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else {
                    ps.setObject(i + 1, param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay danh sach cac san pham dang kinh doanh (is_active = 1) cho trang khach hang.
     */
    public List<Product> getActiveProducts() {
        return searchAndFilterActiveProducts(null, null);
    }

    /**
     * Tim kiem theo tu khoa va loc theo danh muc chi danh cho san pham dang active (is_active = 1).
     */
    public List<Product> searchAndFilterActiveProducts(String keyword, Integer categoryId) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.product_id, p.category_id, p.product_name, p.description, "
                + "p.price, p.stock, p.image_url, p.is_active, p.created_at, c.category_name "
                + "FROM Products p "
                + "LEFT JOIN Categories c ON p.category_id = c.category_id "
                + "WHERE p.is_active = 1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND p.product_name LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ? ");
            params.add(categoryId);
        }

        sql.append(" ORDER BY p.product_id DESC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setNString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else {
                    ps.setObject(i + 1, param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
