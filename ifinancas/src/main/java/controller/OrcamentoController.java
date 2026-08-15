package controller;

import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.itemOrcamentoDAO;
import dao.macroetapaDAO;
import model.ItemOrcamento;

@WebServlet("/OrcamentoController")
public class OrcamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private itemOrcamentoDAO ioDao;
    private macroetapaDAO mDao;

    public void init() {
        ioDao = new itemOrcamentoDAO();
        mDao = new macroetapaDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));

        if ("adicionarItem".equals(acao)) {
            int macroetapaId = Integer.parseInt(request.getParameter("macroetapaId"));
            int fkItemId = Integer.parseInt(request.getParameter("fkItemId"));
            int financiadorId = Integer.parseInt(request.getParameter("financiadorId"));
            BigDecimal quantidade = new BigDecimal(request.getParameter("quantidade"));
            BigDecimal valorUnitario = new BigDecimal(request.getParameter("valorUnitario"));

            ItemOrcamento item = new ItemOrcamento();
            item.setMacroetapaId(macroetapaId);
            item.setFkItemId(fkItemId);
            item.setFinanciadorId(financiadorId);
            item.setQuantidade(quantidade);
            item.setValorUnitario(valorUnitario);

            ioDao.inserir(item);

        } else if ("atualizarMacroetapa".equals(acao)) {
            int macroetapaId = Integer.parseInt(request.getParameter("macroetapaId"));
            int novaDuracao = Integer.parseInt(request.getParameter("duracao"));
            String novoNome = request.getParameter("nome");

            mDao.atualizarDuracaoENome(macroetapaId, novaDuracao, novoNome);
        }

        response.sendRedirect("pages/gerenciarOrcamento.jsp?id=" + idProjeto);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String acao = request.getParameter("acao");
        int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));

        if ("excluirItem".equals(acao)) {
            int idItem = Integer.parseInt(request.getParameter("idItem"));
            ioDao.deletar(idItem);
        }

        response.sendRedirect("pages/gerenciarOrcamento.jsp?id=" + idProjeto);
    }
}