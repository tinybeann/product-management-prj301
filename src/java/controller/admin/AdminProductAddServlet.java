package controller.admin;

import dao.CategoryDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import model.Product;

@WebServlet(name = "AdminProductAddServlet", urlPatterns = {"/admin/products/add"})
public class AdminProductAddServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("categories", categoryDAO.getAllCategories());
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String productName = request.getParameter("productName");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");
        String statusStr = request.getParameter("status");

        Product formProduct = new Product();
        formProduct.setProductName(productName != null ? productName.trim() : "");
        formProduct.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        formProduct.setDescription(description != null ? description.trim() : "");
        formProduct.setStatus(statusStr == null || "1".equals(statusStr) || "true".equalsIgnoreCase(statusStr));

        String error = null;
        int categoryId = 0;
        BigDecimal price = BigDecimal.ZERO;
        int stockQuantity = 0;

        try {
            categoryId = Integer.parseInt(categoryIdStr);
            formProduct.setCategoryId(categoryId);
        } catch (NumberFormatException e) {
            error = "Vui lòng chọn danh mục hợp lệ.";
        }

        if (error == null) {
            try {
                price = new BigDecimal(priceStr);
                formProduct.setPrice(price);
                if (price.compareTo(BigDecimal.ZERO) <= 0) {
                    error = "Đơn giá sản phẩm phải lớn hơn 0.";
                }
            } catch (Exception e) {
                error = "Đơn giá sản phẩm không hợp lệ.";
            }
        }

        if (error == null) {
            try {
                stockQuantity = Integer.parseInt(stockStr);
                formProduct.setStockQuantity(stockQuantity);
                if (stockQuantity < 0) {
                    error = "Số lượng tồn kho phải lớn hơn hoặc bằng 0.";
                }
            } catch (NumberFormatException e) {
                error = "Số lượng tồn kho không hợp lệ.";
            }
        }

        if (productName == null || productName.trim().isEmpty()) {
            error = "Tên sản phẩm không được để trống.";
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.setAttribute("product", formProduct);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
            return;
        }

        boolean inserted = productDAO.insertProduct(formProduct);
        if (inserted) {
            response.sendRedirect(request.getContextPath() + "/admin/products?msg=added");
        } else {
            request.setAttribute("error", "Không thể thêm sản phẩm. Vui lòng kiểm tra lại dữ liệu!");
            request.setAttribute("product", formProduct);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("isEdit", false);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
        }
    }
}
