package controller.admin;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Order;

@WebServlet(name = "AdminOrderListServlet", urlPatterns = {"/admin/orders"})
public class AdminOrderListServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String status = request.getParameter("status");
        List<Order> orders = orderDAO.getAllOrders(status);

        request.setAttribute("orders", orders);
        request.setAttribute("selectedStatus", status != null ? status.trim() : "");
        request.getRequestDispatcher("/views/admin/order-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
