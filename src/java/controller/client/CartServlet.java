package controller.client;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Cart;
import model.CartItem;
import model.Product;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(true);
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "view";
        }

        switch (action.trim().toLowerCase()) {
            case "add": {
                int productId = parseIntOrDefault(request.getParameter("productId"), 0);
                int quantity = parseIntOrDefault(request.getParameter("quantity"), 1);
                if (quantity <= 0) {
                    quantity = 1;
                }

                if (productId > 0) {
                    Product product = productDAO.getProductById(productId);
                    if (product != null && product.isStatus() && product.getStockQuantity() > 0) {
                        int currentInCart = 0;
                        CartItem existing = cart.getItems().get(productId);
                        if (existing != null) {
                            currentInCart = existing.getQuantity();
                        }
                        int maxAddable = product.getStockQuantity() - currentInCart;
                        if (maxAddable > 0) {
                            int qtyToAdd = Math.min(quantity, maxAddable);
                            cart.addItem(product, qtyToAdd);
                        }
                    }
                }
                session.setAttribute("cart", cart);

                String redirectUrl = request.getParameter("redirect");
                if ("home".equalsIgnoreCase(redirectUrl)) {
                    response.sendRedirect(request.getContextPath() + "/home?added=true");
                } else {
                    response.sendRedirect(request.getContextPath() + "/cart");
                }
                break;
            }

            case "update": {
                int productId = parseIntOrDefault(request.getParameter("productId"), 0);
                int quantity = parseIntOrDefault(request.getParameter("quantity"), 1);

                if (productId > 0) {
                    if (quantity <= 0) {
                        cart.removeItem(productId);
                    } else {
                        Product product = productDAO.getProductById(productId);
                        if (product != null && product.getStockQuantity() > 0) {
                            int validQty = Math.min(quantity, product.getStockQuantity());
                            cart.updateQuantity(productId, validQty);
                        } else {
                            cart.updateQuantity(productId, quantity);
                        }
                    }
                }
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            }

            case "delete":
            case "remove": {
                int productId = parseIntOrDefault(request.getParameter("productId"), 0);
                if (productId > 0) {
                    cart.removeItem(productId);
                }
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            }

            case "clear": {
                cart.clear();
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;
            }

            case "view":
            default: {
                request.getRequestDispatcher("/views/client/cart.jsp").forward(request, response);
                break;
            }
        }
    }

    private int parseIntOrDefault(String val, int defaultVal) {
        if (val == null || val.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(val.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
