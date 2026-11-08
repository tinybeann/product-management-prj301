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
import model.OrderDetailDTO;

@WebServlet(name = "AdminOrderDetailServlet", urlPatterns = {"/admin/orders/detail"})
public class AdminOrderDetailServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        int orderId = 0;
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                orderId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        if (orderId <= 0) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?msg=notfound");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/admin/orders?msg=notfound");
            return;
        }

        List<OrderDetailDTO> orderDetails = orderDAO.getOrderDetailWithProduct(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("/views/admin/order-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
