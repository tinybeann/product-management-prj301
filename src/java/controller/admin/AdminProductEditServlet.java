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

@WebServlet(name = "AdminProductEditServlet", urlPatterns = {"/admin/products/edit"})
public class AdminProductEditServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        try {
            int id = Integer.parseInt(idStr.trim());
            Product product = productDAO.getProductById(id);
            if (product == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products?msg=notfound");
                return;
            }
            request.setAttribute("product", product);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String productIdStr = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String categoryIdStr = request.getParameter("categoryId");
        String priceStr = request.getParameter("price");
        String stockStr = request.getParameter("stockQuantity");
        String imageUrl = request.getParameter("imageUrl");
        String description = request.getParameter("description");
        String statusStr = request.getParameter("status");

        Product formProduct = new Product();
        String error = null;

        try {
            formProduct.setProductId(Integer.parseInt(productIdStr));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }

        formProduct.setProductName(productName != null ? productName.trim() : "");
        formProduct.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
        formProduct.setDescription(description != null ? description.trim() : "");
        formProduct.setStatus("1".equals(statusStr) || "true".equalsIgnoreCase(statusStr));

        try {
            formProduct.setCategoryId(Integer.parseInt(categoryIdStr));
        } catch (NumberFormatException e) {
            error = "Vui lòng chọn danh mục hợp lệ.";
        }

        if (error == null) {
            try {
                BigDecimal price = new BigDecimal(priceStr);
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
                int stockQuantity = Integer.parseInt(stockStr);
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
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
            return;
        }

        boolean updated = productDAO.updateProduct(formProduct);
        if (updated) {
            response.sendRedirect(request.getContextPath() + "/admin/products?msg=updated");
        } else {
            request.setAttribute("error", "Cập nhật sản phẩm thất bại. Vui lòng thử lại!");
            request.setAttribute("product", formProduct);
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.setAttribute("isEdit", true);
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);
        }
    }
}
