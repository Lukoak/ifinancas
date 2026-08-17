package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import dao.projetoDAO;
import dao.macroetapaDAO;
import model.Projeto;
import model.Macroetapa;
import model.StatusProjeto;
import model.Usuario;

@WebServlet("/ProjetoController")
public class ProjetoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private projetoDAO pDao;
    private macroetapaDAO mDao;

    public void init() {
        pDao = new projetoDAO();
        mDao = new macroetapaDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");

        if ("salvar".equals(acao)) {
            salvarProjeto(request, response);
        } else if ("processarAprovacao".equals(acao)) {
            processarAprovacao(request, response);
        } else if ("excluir".equals(acao)) {
            int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));
            pDao.deletar(idProjeto);
            response.sendRedirect("pages/listaProjetosAdmin.jsp");
        } else if ("finalizarProjeto".equals(acao)) {
	        int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));
	        pDao.atualizarStatus(idProjeto, StatusProjeto.FINALIZADO);
	        response.sendRedirect("pages/gerenciarOrcamento.jsp?id=" + idProjeto);
	    }
    }

    private void salvarProjeto(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession();
        Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");

        if (usuarioLogado == null) {
            response.sendRedirect(request.getContextPath() + "/Tela_Login.jsp");
            return;
        }

        String titulo = request.getParameter("titulo");
        String descricao = request.getParameter("descricao");
        int numMacroetapas = Integer.parseInt(request.getParameter("macroetapas"));

        Projeto p = new Projeto();
        p.setCoordenadorId(usuarioLogado.getId());
        p.setTitulo(titulo);
        p.setDescricao(descricao);
        p.setStatusProjeto(StatusProjeto.PENDENTE);

        boolean projetoSalvo = pDao.inserir(p);

        if (projetoSalvo) {
            List<Projeto> projetos = pDao.listarPorCoordenador(usuarioLogado.getId());
            Projeto projetoCriado = projetos.get(projetos.size() - 1);

            List<Macroetapa> macroetapasList = new ArrayList<>();
            for (int i = 1; i <= numMacroetapas; i++) {
                Macroetapa m = new Macroetapa();
                m.setProjetoId(projetoCriado.getId());
                m.setNumero("ME-" + i);
                m.setDescricao("Macroetapa " + i);
                m.setDuracao(1); 
                macroetapasList.add(m);
            }
            mDao.inserirEmLote(macroetapasList);

            response.sendRedirect("pages/listaProjetos.jsp?sucesso=1");
        } else {
            response.sendRedirect("pages/cadastroProjeto.jsp?erro=1");
        }
    }

    private void processarAprovacao(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));
        String decisao = request.getParameter("decisao");

        StatusProjeto novoStatus = "aprovar".equalsIgnoreCase(decisao) ? StatusProjeto.APROVADO : StatusProjeto.REPROVADO;
        pDao.atualizarStatus(idProjeto, novoStatus);

        response.sendRedirect("pages/aprovacaoCadastro.jsp");
    }
    
    

    
    
}