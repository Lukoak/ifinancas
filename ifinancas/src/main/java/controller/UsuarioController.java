package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.usuarioDAO;
import model.Usuario;
import model.StatusUsuario;

@WebServlet("/UsuarioController")
public class UsuarioController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private usuarioDAO dao;

    public void init() {
        dao = new usuarioDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        
        if ("login".equals(acao)) {
            fazerLogin(request, response);
        } else if ("cadastrar".equals(acao)) {
            fazerCadastro(request, response);
        } else if ("recuperarSenha".equals(acao)) {
            response.sendRedirect("pages/esqueceuSenha.jsp?enviado=1");
        } else {
            response.sendRedirect("Tela_Login.jsp");
        }
    }

    private void fazerLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String email = request.getParameter("email");
        String senha = request.getParameter("senha"); 
        
        Usuario usuario = dao.autenticar(email, senha);
        
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogado", usuario);
            
            if (usuario.getPerfilId() == 2) {
                response.sendRedirect("pages/listaProjetosAdmin.jsp");
            } else {
                response.sendRedirect("pages/listaProjetos.jsp");
            }
        } else {
            response.sendRedirect("Tela_Login.jsp?erro=1");
        }
    }

    private void fazerCadastro(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        if (dao.existeEmail(email)) {
            response.sendRedirect("pages/cadastroUsuario.jsp?erro=email_duplicado");
            return;
        }

        Usuario novoUsuario = new Usuario();
        novoUsuario.setPerfilId(1); 
        novoUsuario.setNome(nome);
        novoUsuario.setEmail(email);
        novoUsuario.setSenhaHash(senha); 
        novoUsuario.setStatusUsuario(StatusUsuario.ATIVO);
        
        boolean sucesso = dao.cadastrar(novoUsuario);
        
        if (sucesso) {
            response.sendRedirect("Tela_Login.jsp?sucesso=1");
        } else {
            response.sendRedirect("pages/cadastroUsuario.jsp?erro=1");
        }
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        if ("logout".equals(acao)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate(); 
            }
            response.sendRedirect("Tela_Login.jsp");
        }
    }
}