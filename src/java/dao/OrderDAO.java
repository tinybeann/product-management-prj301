package dao;

import context.DBContext;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.Cart;
import model.CartItem;
import model.Order;
import model.OrderDetail;
import model.OrderDetailDTO;

public class OrderDAO {

    /**
     * Kiem tra ten cot ton tai trong bang SQL Server de tuong thich giua
     * cac bien the schema (vd: stock_quantity vs stock, notes vs note).
     */
    private boolean hasColumn(Connection conn, String tableName, String columnName) {
        String sql = "SELECT COL_LENGTH(?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getObject(1) != null;
                }
            }
        } catch (SQLException ignored) {
        }
        return false;
    }

    /**
     * Tao don hang moi su dung JDBC Transaction:
     * 1. Insert vao bang Orders va lay order_id vua sinh (RETURN_GENERATED_KEYS).
     * 2. Duyet tung CartItem trong Cart, insert vao bang OrderDetails.
     * 3. Tru so luong ton kho (stock_quantity / stock) trong bang Products.
     * 4. Commit transaction; neu co loi thi rollback va tra ve false.
     */
    public boolean createOrder(Order order, Cart cart) {
        if (order == null || cart == null || cart.getItemsList().isEmpty()) {
            return false;
        }

        Connection connection = null;
        PreparedStatement psOrder = null;
        PreparedStatement psDetail = null;
        PreparedStatement psStock = null;
        ResultSet rsKeys = null;

        try {
            connection = DBContext.getConnection();
            // BAT BUOC DUNG JDBC TRANSACTION
            connection.setAutoCommit(false);

            String noteCol = hasColumn(connection, "Orders", "notes") ? "notes"
                    : (hasColumn(connection, "Orders", "note") ? "note" : "notes");
            String stockCol = hasColumn(connection, "Products", "stock_quantity") ? "stock_quantity"
                    : (hasColumn(connection, "Products", "stock") ? "stock" : "stock_quantity");
            String priceCol = hasColumn(connection, "OrderDetails", "unit_price") ? "unit_price"
                    : (hasColumn(connection, "OrderDetails", "price") ? "price" : "unit_price");

            // Buoc 1: Insert vao bang Orders
            String insertOrderSql = "INSERT INTO Orders (user_id, order_date, total_amount, status, shipping_address, phone, " + noteCol + ") "
                    + "VALUES (?, GETDATE(), ?, N'Pending', ?, ?, ?)";

            psOrder = connection.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            BigDecimal totalAmount = order.getTotalAmount() != null
                    ? order.getTotalAmount()
                    : BigDecimal.valueOf(cart.getTotalMoney());
            psOrder.setBigDecimal(2, totalAmount);
            psOrder.setNString(3, order.getShippingAddress());
            psOrder.setString(4, order.getPhone());
            psOrder.setNString(5, order.getNotes());

            int affectedOrderRows = psOrder.executeUpdate();
            if (affectedOrderRows == 0) {
                connection.rollback();
                return false;
            }

            int orderId = 0;
            rsKeys = psOrder.getGeneratedKeys();
            if (rsKeys.next()) {
                orderId = rsKeys.getInt(1);
                order.setOrderId(orderId);
            } else {
                connection.rollback();
                return false;
            }

            // Buoc 2 & Buoc 3: Insert OrderDetails va tru ton kho trong Products
            String insertDetailSql = "INSERT INTO OrderDetails (order_id, product_id, quantity, " + priceCol + ") "
                    + "VALUES (?, ?, ?, ?)";
            String updateStockSql = "UPDATE Products SET " + stockCol + " = " + stockCol + " - ? "
                    + "WHERE product_id = ? AND " + stockCol + " >= ?";

            psDetail = connection.prepareStatement(insertDetailSql);
            psStock = connection.prepareStatement(updateStockSql);

            for (CartItem item : cart.getItemsList()) {
                int productId = item.getProduct().getProductId();
                int quantity = item.getQuantity();
                BigDecimal unitPrice = item.getProduct().getPrice();

                // Insert chi tiet don hang
                psDetail.setInt(1, orderId);
                psDetail.setInt(2, productId);
                psDetail.setInt(3, quantity);
                psDetail.setBigDecimal(4, unitPrice);
                int detailRows = psDetail.executeUpdate();
                if (detailRows == 0) {
                    connection.rollback();
                    return false;
                }

                // Tru so luong ton kho
                psStock.setInt(1, quantity);
                psStock.setInt(2, productId);
                psStock.setInt(3, quantity);
                int stockRows = psStock.executeUpdate();
                if (stockRows == 0) {
                    // Khong du ton kho hoac san pham khong ton tai -> rollback
                    connection.rollback();
                    return false;
                }
            }

            // Buoc 4: Commit transaction
            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (connection != null) {
                try {
                    connection.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (rsKeys != null) {
                    rsKeys.close();
                }
                if (psStock != null) {
                    psStock.close();
                }
                if (psDetail != null) {
                    psDetail.close();
                }
                if (psOrder != null) {
                    psOrder.close();
                }
                if (connection != null) {
                    connection.setAutoCommit(true);
                    connection.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * Lay danh sach tat ca don hang cho Admin (JOIN voi Users de lay ten khach hang),
     * ho tro loc theo trang thai statusFilter va sap xep theo order_date DESC.
     */
    public List<Order> getAllOrders(String statusFilter) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT o.*, u.full_name AS customer_name, u.email AS customer_email, u.username AS customer_username "
                + "FROM Orders o "
                + "LEFT JOIN Users u ON o.user_id = u.user_id "
        );

        boolean filterByStatus = statusFilter != null
                && !statusFilter.trim().isEmpty()
                && !"ALL".equalsIgnoreCase(statusFilter.trim());

        if (filterByStatus) {
            sql.append("WHERE o.status = ? ");
        }
        sql.append("ORDER BY o.order_date DESC, o.order_id DESC");

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (filterByStatus) {
                ps.setNString(1, statusFilter.trim());
            }

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                boolean hasNotes = hasColumnInResultSet(meta, "notes");
                boolean hasNote = hasColumnInResultSet(meta, "note");

                while (rs.next()) {
                    list.add(mapOrderRow(rs, hasNotes, hasNote));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay thong tin 1 don hang cu the theo orderId (kem thong tin khach hang tu bang Users).
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.full_name AS customer_name, u.email AS customer_email, u.username AS customer_username "
                + "FROM Orders o "
                + "LEFT JOIN Users u ON o.user_id = u.user_id "
                + "WHERE o.order_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                boolean hasNotes = hasColumnInResultSet(meta, "notes");
                boolean hasNote = hasColumnInResultSet(meta, "note");

                if (rs.next()) {
                    return mapOrderRow(rs, hasNotes, hasNote);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cap nhat trang thai don hang (Pending, Processing, Shipping, Completed, Cancelled).
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        if (newStatus == null || newStatus.trim().isEmpty()) {
            return false;
        }
        String sql = "UPDATE Orders SET status = ? WHERE order_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setNString(1, newStatus.trim());
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lay danh sach don hang da mua cua user hien tai, sap xep theo ngay dat moi nhat.
     */
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name AS customer_name, u.email AS customer_email, u.username AS customer_username "
                + "FROM Orders o "
                + "LEFT JOIN Users u ON o.user_id = u.user_id "
                + "WHERE o.user_id = ? "
                + "ORDER BY o.order_date DESC, o.order_id DESC";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                boolean hasNotes = hasColumnInResultSet(meta, "notes");
                boolean hasNote = hasColumnInResultSet(meta, "note");

                while (rs.next()) {
                    list.add(mapOrderRow(rs, hasNotes, hasNote));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay danh sach chi tiet mon hang kem ten san pham va anh (OrderDetailDTO).
     */
    public List<OrderDetailDTO> getOrderDetailWithProduct(int orderId) {
        List<OrderDetailDTO> list = new ArrayList<>();
        String sql = "SELECT od.*, p.product_name, p.image_url "
                + "FROM OrderDetails od "
                + "LEFT JOIN Products p ON od.product_id = p.product_id "
                + "WHERE od.order_id = ?";

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData meta = rs.getMetaData();
                boolean hasOrderDetailId = hasColumnInResultSet(meta, "order_detail_id");
                boolean hasDetailId = hasColumnInResultSet(meta, "detail_id");
                boolean hasUnitPrice = hasColumnInResultSet(meta, "unit_price");
                boolean hasPrice = hasColumnInResultSet(meta, "price");

                while (rs.next()) {
                    int detailId = 0;
                    if (hasOrderDetailId) {
                        detailId = rs.getInt("order_detail_id");
                    } else if (hasDetailId) {
                        detailId = rs.getInt("detail_id");
                    }

                    BigDecimal unitPrice = BigDecimal.ZERO;
                    if (hasUnitPrice) {
                        unitPrice = rs.getBigDecimal("unit_price");
                    } else if (hasPrice) {
                        unitPrice = rs.getBigDecimal("price");
                    }

                    OrderDetailDTO dto = new OrderDetailDTO(
                            detailId,
                            rs.getInt("order_id"),
                            rs.getInt("product_id"),
                            rs.getString("product_name"),
                            rs.getString("image_url"),
                            rs.getInt("quantity"),
                            unitPrice
                    );
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lay chi tiet cac mon hang cua 1 don hang theo orderId.
     */
    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) {
        return new ArrayList<>(getOrderDetailWithProduct(orderId));
    }

    private Order mapOrderRow(ResultSet rs, boolean hasNotes, boolean hasNote) throws SQLException {
        Order order = new Order();
        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getBigDecimal("total_amount"));
        order.setStatus(rs.getString("status"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setPhone(rs.getString("phone"));
        if (hasNotes) {
            order.setNotes(rs.getString("notes"));
        } else if (hasNote) {
            order.setNotes(rs.getString("note"));
        }
        order.setCustomerName(rs.getString("customer_name"));
        order.setCustomerEmail(rs.getString("customer_email"));
        order.setCustomerUsername(rs.getString("customer_username"));
        return order;
    }

    private boolean hasColumnInResultSet(ResultSetMetaData meta, String colName) throws SQLException {
        int count = meta.getColumnCount();
        for (int i = 1; i <= count; i++) {
            if (colName.equalsIgnoreCase(meta.getColumnLabel(i))
                    || colName.equalsIgnoreCase(meta.getColumnName(i))) {
                return true;
            }
        }
        return false;
    }
}
