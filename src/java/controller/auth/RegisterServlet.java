package controller.auth;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.regex.Pattern;
import model.User;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0|\\+84)\\d{9,10}$");
    private static final Pattern USERNAME_PATTERN = Pattern.compile("^[A-Za-z0-9_.]{3,50}$");

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getSession(false) != null && request.getSession(false).getAttribute("currentUser") != null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = trim(request.getParameter("username"));
        String fullName = trim(request.getParameter("fullName"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = trim(request.getParameter("email"));
        String phone = trim(request.getParameter("phone"));
        String address = trim(request.getParameter("address"));

        String error = validate(username, fullName, password, confirmPassword, email, phone);

        if (error == null && userDAO.checkUsernameExists(username)) {
            error = "Tên đăng nhập đã tồn tại, vui lòng chọn tên khác!";
        }
        if (error == null && userDAO.checkEmailExists(email)) {
            error = "Email này đã được sử dụng cho một tài khoản khác!";
        }

        if (error == null) {
            User user = new User();
            user.setUsername(username);
            user.setPasswordHash(password); // DAO se ma hoa truoc khi luu
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPhone(phone.isEmpty() ? null : phone);
            user.setAddress(address.isEmpty() ? null : address);

            if (userDAO.register(user)) {
                response.sendRedirect(request.getContextPath() + "/login?registered=true");
                return;
            }
            error = "Đăng ký thất bại do lỗi hệ thống, vui lòng thử lại sau!";
        }

        request.setAttribute("error", error);
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    private String validate(String username, String fullName, String password,
                            String confirmPassword, String email, String phone) {
        if (username.isEmpty() || fullName.isEmpty() || email.isEmpty()
                || password == null || password.isEmpty()) {
            return "Vui lòng điền đầy đủ các trường bắt buộc (*)!";
        }
        if (!USERNAME_PATTERN.matcher(username).matches()) {
            return "Tên đăng nhập gồm 3-50 ký tự (chữ, số, dấu gạch dưới hoặc dấu chấm)!";
        }
        if (password.length() < 6) {
            return "Mật khẩu phải có tối thiểu 6 ký tự!";
        }
        if (!password.equals(confirmPassword)) {
            return "Mật khẩu xác nhận không khớp!";
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            return "Email không hợp lệ!";
        }
        if (!phone.isEmpty() && !PHONE_PATTERN.matcher(phone).matches()) {
            return "Số điện thoại không hợp lệ (ví dụ: 0901234567)!";
        }
        return null;
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
