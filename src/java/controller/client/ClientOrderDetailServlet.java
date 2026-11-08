package controller.client;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Order;
import model.OrderDetailDTO;
import model.User;

@WebServlet(name = "ClientOrderDetailServlet", urlPatterns = {"/order-detail"})
public class ClientOrderDetailServlet extends HttpServlet {

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

        String idParam = request.getParameter("id");
        int orderId = 0;
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                orderId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        if (orderId <= 0) {
            response.sendRedirect(request.getContextPath() + "/orders?msg=notfound");
            return;
        }

        Order order = orderDAO.getOrderById(orderId);

        // Bao mat: chi cho phep chu so huu don hang (hoac Admin) xem chi tiet don nay
        boolean isAdmin = "ADMIN".equalsIgnoreCase(currentUser.getRoleName()) || currentUser.getRoleId() == 1;
        if (order == null || (order.getUserId() != currentUser.getUserId() && !isAdmin)) {
            response.sendRedirect(request.getContextPath() + "/orders?msg=forbidden");
            return;
        }

        List<OrderDetailDTO> orderDetails = orderDAO.getOrderDetailWithProduct(orderId);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("/views/client/order-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
