package controller.admin;

import dao.CategoryDAO;
import dao.OrderDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import model.Category;
import model.Order;
import model.Product;

@WebServlet(name = "DashboardServlet", urlPatterns = {"/admin/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductDAO productDAO = new ProductDAO();
        OrderDAO orderDAO = new OrderDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Product> products = productDAO.getAllProducts();
        List<Order> orders = orderDAO.getAllOrders(null);
        List<Category> categories = categoryDAO.getAllCategories();

        int totalProducts = products != null ? products.size() : 0;
        int activeProducts = 0;
        int lowStockProducts = 0;
        if (products != null) {
            for (Product p : products) {
                if (p.isStatus()) {
                    activeProducts++;
                }
                if (p.getStockQuantity() <= 5) {
                    lowStockProducts++;
                }
            }
        }

        int totalOrders = orders != null ? orders.size() : 0;
        int pendingOrders = 0;
        int shippingOrders = 0;
        int completedOrders = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;

        if (orders != null) {
            for (Order o : orders) {
                String st = o.getStatus() != null ? o.getStatus().trim() : "";
                if ("Pending".equalsIgnoreCase(st)) {
                    pendingOrders++;
                } else if ("Shipping".equalsIgnoreCase(st) || "Processing".equalsIgnoreCase(st)) {
                    shippingOrders++;
                } else if ("Completed".equalsIgnoreCase(st)) {
                    completedOrders++;
                }
                if (!"Cancelled".equalsIgnoreCase(st) && o.getTotalAmount() != null) {
                    totalRevenue = totalRevenue.add(o.getTotalAmount());
                }
            }
        }

        List<Order> recentOrders = (orders != null && orders.size() > 6)
                ? orders.subList(0, 6)
                : orders;

        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("activeProducts", activeProducts);
        request.setAttribute("lowStockProducts", lowStockProducts);
        request.setAttribute("totalCategories", categories != null ? categories.size() : 0);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("pendingOrders", pendingOrders);
        request.setAttribute("shippingOrders", shippingOrders);
        request.setAttribute("completedOrders", completedOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentOrders", recentOrders);

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
}
