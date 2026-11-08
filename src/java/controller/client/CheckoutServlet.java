package controller.client;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import model.Cart;
import model.Order;
import model.User;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout", "/order-success"})
public class CheckoutServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        if ("/order-success".equalsIgnoreCase(servletPath)) {
            request.getRequestDispatcher("/views/client/order-success.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItemsList().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.getRequestDispatcher("/views/client/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=checkout");
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null || cart.getItemsList().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String shippingAddress = request.getParameter("shippingAddress");
        String notes = request.getParameter("notes");

        if (phone == null || phone.trim().isEmpty()
                || shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ số điện thoại và địa chỉ giao hàng!");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("notes", notes);
            request.getRequestDispatcher("/views/client/checkout.jsp").forward(request, response);
            return;
        }

        Order order = new Order();
        order.setUserId(currentUser.getUserId());
        order.setTotalAmount(BigDecimal.valueOf(cart.getTotalMoney()));
        order.setStatus("Pending");
        order.setShippingAddress(shippingAddress.trim());
        order.setPhone(phone.trim());
        order.setNotes(notes != null ? notes.trim() : "");

        boolean success = orderDAO.createOrder(order, cart);

        if (success) {
            session.setAttribute("lastOrderId", order.getOrderId());
            session.setAttribute("lastOrderTotal", order.getTotalAmount());
            session.setAttribute("lastOrderFullName",
                    (fullName != null && !fullName.trim().isEmpty()) ? fullName.trim() : currentUser.getFullName());
            session.removeAttribute("cart");
            response.sendRedirect(request.getContextPath() + "/order-success");
        } else {
            request.setAttribute("error", "Đặt hàng không thành công! Vui lòng kiểm tra lại số lượng tồn kho sản phẩm hoặc thử lại sau.");
            request.setAttribute("fullName", fullName);
            request.setAttribute("phone", phone);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("notes", notes);
            request.getRequestDispatcher("/views/client/checkout.jsp").forward(request, response);
        }
    }
}
