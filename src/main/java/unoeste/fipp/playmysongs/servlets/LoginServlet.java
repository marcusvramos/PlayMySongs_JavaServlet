package unoeste.fipp.playmysongs.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import unoeste.fipp.playmysongs.security.User;

import java.io.IOException;

@WebServlet(name = "loginServlet", value = "/login-servlet")
public class LoginServlet extends HttpServlet {

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("username");
        String password = request.getParameter("password");

        if (email != null && email.contains("@")) {
            String usernamePart = email.substring(0, email.indexOf('@'));

            if (password.equals(usernamePart)) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", new User(email, password));

                String contextPath = request.getContextPath();
                response.sendRedirect(contextPath + "/index.jsp");
            } else {
                erroLogin(request, response, "Senha inválida.");
            }
        } else {
            erroLogin(request, response, "Formato de e-mail inválido.");
        }
    }

    private void erroLogin(HttpServletRequest request, HttpServletResponse response, String mensagemErro) throws ServletException, IOException {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", mensagemErro);
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }


    public void destroy() {}
}
