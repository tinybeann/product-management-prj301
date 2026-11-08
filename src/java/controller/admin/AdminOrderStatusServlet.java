package controller.admin;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AdminOrderStatusServlet", urlPatterns = {"/admin/orders/status"})
public class AdminOrderStatusServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String orderIdParam = request.getParameter("orderId");
        String status = request.getParameter("status");

        int orderId = 0;
        if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            try {
                orderId = Integer.parseInt(orderIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        if (orderId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?msg=invalid");
            return;
        }

        boolean updated = orderDAO.updateOrderStatus(orderId, status);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/orders/detail?id=" + orderId + "&msg=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/orders/detail?id=" + orderId + "&msg=status_failed");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
