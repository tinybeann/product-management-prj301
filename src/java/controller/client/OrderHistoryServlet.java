package controller.client;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Order;
import model.OrderDetail;
import model.User;

@WebServlet(name = "OrderHistoryServlet", urlPatterns = {"/orders"})
public class OrderHistoryServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        List<Order> orders = orderDAO.getOrdersByUserId(currentUser.getUserId());
        Map<Integer, List<OrderDetail>> orderDetailsMap = new HashMap<>();
        for (Order order : orders) {
            orderDetailsMap.put(order.getOrderId(), orderDAO.getOrderDetailsByOrderId(order.getOrderId()));
        }

        request.setAttribute("orders", orders);
        request.setAttribute("orderDetailsMap", orderDetailsMap);
        request.getRequestDispatcher("/views/client/orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
