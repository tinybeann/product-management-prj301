package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.Product;

@WebServlet(name = "AdminProductListServlet", urlPatterns = {"/admin/products"})
public class AdminProductListServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        String categoryIdParam = request.getParameter("categoryId");

        Integer categoryId = null;
        if (categoryIdParam != null && !categoryIdParam.trim().isEmpty()) {
            try {
                categoryId = Integer.parseInt(categoryIdParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        List<Category> categories = categoryDAO.getAllCategories();
        List<Product> products = productDAO.searchAndFilter(keyword, categoryId);

        request.setAttribute("categories", categories);
        request.setAttribute("products", products);
        request.setAttribute("keyword", keyword != null ? keyword.trim() : "");
        request.setAttribute("selectedCatId", categoryId != null ? categoryId : 0);

        request.getRequestDispatcher("/views/admin/product-list.jsp").forward(request, response);
    }
}
