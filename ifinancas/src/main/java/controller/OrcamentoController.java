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
import dao.itemDAO;
import dao.rubricaDAO;
import model.ItemOrcamento;
import model.Item;
import model.Rubrica;
import model.CategoriaRubrica;

@WebServlet("/OrcamentoController")
public class OrcamentoController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private itemOrcamentoDAO ioDao;
    private macroetapaDAO mDao;
    private itemDAO iDao;
    private rubricaDAO rDao;

    public void init() {
        ioDao = new itemOrcamentoDAO();
        mDao = new macroetapaDAO();
        iDao = new itemDAO();
        rDao = new rubricaDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String acao = request.getParameter("acao");
        int idProjeto = Integer.parseInt(request.getParameter("idProjeto"));

        if ("adicionarItem".equals(acao)) {
            int macroetapaId = Integer.parseInt(request.getParameter("macroetapaId"));
            
            // Pega os textos preenchidos pelo coordenador na tela
            String nomeItem = request.getParameter("nomeItem");
            String categoriaRubricaStr = request.getParameter("categoriaRubrica");
            int financiadorId = Integer.parseInt(request.getParameter("financiadorId"));
            BigDecimal quantidade = new BigDecimal(request.getParameter("quantidade"));
            BigDecimal valorUnitario = new BigDecimal(request.getParameter("valorUnitario"));

            // 1. Cria o Item na tabela 'item'
            Item novoItem = new Item();
            novoItem.setNome(nomeItem);
            novoItem.setAtivo(true);
            int fkItemId = iDao.inserirERetornarId(novoItem);

            // 2. Cria a Rubrica vinculada a esse item
            if (fkItemId > 0 && categoriaRubricaStr != null) {
                Rubrica novaRubrica = new Rubrica();
                novaRubrica.setCategoria(CategoriaRubrica.valueOf(categoriaRubricaStr));
                novaRubrica.setFkItem(fkItemId);
                rDao.inserir(novaRubrica);

                // 3. Salva a relação final no 'item_orcamento'
                ItemOrcamento itemOrcamento = new ItemOrcamento();
                itemOrcamento.setMacroetapaId(macroetapaId);
                itemOrcamento.setFkItemId(fkItemId);
                itemOrcamento.setFinanciadorId(financiadorId);
                itemOrcamento.setQuantidade(quantidade);
                itemOrcamento.setValorUnitario(valorUnitario);

                ioDao.inserir(itemOrcamento);
            }

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