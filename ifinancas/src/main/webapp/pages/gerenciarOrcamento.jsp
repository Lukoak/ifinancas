<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.Macroetapa" %>
<%@ page import="model.ItemOrcamento" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="model.Financiador" %>
<%@ page import="model.CategoriaRubrica" %>
<%@ page import="model.Rubrica" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="dao.macroetapaDAO" %>
<%@ page import="dao.itemOrcamentoDAO" %>
<%@ page import="dao.financiadorDAO" %>
<%@ page import="dao.itemDAO" %>
<%@ page import="dao.rubricaDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.math.BigDecimal" %>
<%
    // ===== 1. Validação de Sessão =====
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }
    if (usuarioLogado.getPerfilId() == 2) {
        response.sendRedirect("listaProjetosAdmin.jsp");
        return;
    }

    int idProjeto = Integer.parseInt(request.getParameter("id"));
    
    // ===== 2. Instanciando os DAOs reais =====
    projetoDAO pDao = new projetoDAO();
    macroetapaDAO mDao = new macroetapaDAO();
    itemOrcamentoDAO ioDao = new itemOrcamentoDAO();
    financiadorDAO fDao = new financiadorDAO();
    itemDAO iDao = new itemDAO();
    rubricaDAO rDao = new rubricaDAO();

    Projeto projeto = pDao.buscarPorId(idProjeto);

    if (projeto == null || projeto.getCoordenadorId() != usuarioLogado.getId()) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    // ===== 3. Buscando dados complementares =====
    List<Macroetapa> macroetapas = mDao.listarPorProjeto(idProjeto);
    List<Financiador> listaFinanciadores = fDao.listarTodos();
    
    // Mapeando as rubricas na memória para não dar erro na tabela de itens
    List<Rubrica> todasRubricas = rDao.listarTodos();
    Map<Integer, String> mapaRubricas = new HashMap<>();
    for (Rubrica r : todasRubricas) {
        mapaRubricas.put(r.getFkItem(), r.getCategoria() != null ? r.getCategoria().name() : "-");
    }

    // Formatador de Moeda para ficar igual ao seu MockData.formatarMoeda
    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
    String inicial = usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty() ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
    
    // Caso o controller retorne um erro por atributo ou sessão
    String erroItem = (String) session.getAttribute("erroItem");
    session.removeAttribute("erroItem"); // limpa para não ficar mostrando para sempre
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Orçamento - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/ifinance-base.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }

        /* ==== SIDEBAR ==== */
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; }
        .sidebar-top { padding: 0 20px; }
        .logo-box { display: flex; align-items: center; gap: 10px; margin-bottom: 35px; }
        .logo-box img { max-width: 40px; height: auto; }
        .logo-box h2 { font-size: 20px; font-weight: 700; }
        .menu-label { font-size: 11px; text-transform: uppercase; color: #7da085; font-weight: bold; letter-spacing: 1px; margin-bottom: 10px; display: block; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 5px; }
        .nav-link { display: flex; align-items: center; padding: 12px 15px; color: #cbdbe5; text-decoration: none; border-radius: 8px; font-size: 15px; font-weight: 500; transition: all 0.2s; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255,255,255,0.1); color: white; }
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; gap: 12px; text-decoration: none; color: inherit; transition: background-color 0.2s; }
        .sidebar-footer:hover { background-color: rgba(255,255,255,0.06); }
        .avatar { width: 40px; height: 40px; background-color: #3e863e; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; flex-shrink: 0; }
        .user-info { min-width: 0; }
        .user-name { font-size: 13px; font-weight: 600; color: #ffffff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role { font-size: 11px; color: #7da085; text-transform: uppercase; font-weight: bold; }

        /* ==== CONTEÚDO PRINCIPAL ==== */
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-bar { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .container { padding: 30px; max-width: 1150px; width: 100%; margin: 0 auto; }

        /* ==== RESUMO DO PROJETO ==== */
        .project-details-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); margin-bottom: 25px; border-left: 5px solid #1d3c25; }
        .project-details-card h2 { color: #1d3c25; font-size: 20px; margin-bottom: 8px; }
        .project-details-card p { color: #4a5568; font-size: 15px; line-height: 1.5; margin-bottom: 12px; }
        .project-meta { display: flex; gap: 25px; flex-wrap: wrap; font-size: 13px; color: #6c757d; }
        .project-meta strong { color: #1d3c25; }
        .financiadores-lista { margin-top: 10px; display: flex; gap: 8px; flex-wrap: wrap; }
        .tag-financiador { background-color: #e1f2e5; color: #1d3c25; padding: 4px 10px; border-radius: 20px; font-size: 12px; font-weight: 700; }
        .total-geral { margin-top: 15px; font-size: 22px; font-weight: 700; color: #1d3c25; }

        .btn-dashboard { flex-shrink: 0; padding: 10px 18px; background-color: #1d3c25; color: white; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 700; }
        .btn-dashboard:hover { background-color: #275232; }

        .erro-box { padding: 12px 16px; background-color: #fed7d7; color: #822727; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 15px; }

        .form-duracao { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #6c757d; margin: 0; }
        .input-duracao { width: 55px; padding: 4px 6px; border: 1px solid #e2e8f0; border-radius: 4px; font-size: 12px; }
        .btn-editar-duracao { padding: 4px 10px; background-color: #edf2f7; color: #1d3c25; border: none; border-radius: 4px; font-size: 11px; font-weight: 700; cursor: pointer; }
        .btn-editar-duracao:hover { background-color: #cbd5e0; }

        .form-renomear { display: flex; align-items: center; gap: 8px; margin: 0; }
        .input-nome-macroetapa { font-size: 16px; font-weight: 600; color: #1d3c25; border: 1px solid transparent; border-radius: 4px; padding: 4px 8px; background: transparent; }
        .input-nome-macroetapa:hover, .input-nome-macroetapa:focus { border-color: #e2e8f0; background-color: #f8fafc; outline: none; }

        /* ==== SOLICITAR FINALIZAÇÃO ==== */
        .finalizacao-box { margin-top: 20px; padding-top: 20px; border-top: 1px dashed #e2e8f0; }
        .btn-finalizar { padding: 10px 18px; background-color: white; color: #de532b; border: 2px solid #de532b; border-radius: 6px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-finalizar:hover { background-color: #de532b; color: white; }
        .form-finalizacao { display: none; flex-direction: column; gap: 10px; margin-top: 15px; max-width: 500px; }
        .form-finalizacao.aberto { display: flex; }
        .form-finalizacao label { font-size: 13px; font-weight: 600; color: #1d3c25; }
        .form-finalizacao textarea { padding: 10px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 13px; font-family: inherit; resize: vertical; }

        /* ==== BLOCO DE CADA MACROETAPA ==== */
        .macroetapa-card { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); padding: 20px; margin-bottom: 20px; }
        .macroetapa-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .macroetapa-header h3 { color: #1d3c25; font-size: 17px; font-weight: 600; }
        .macroetapa-header .duracao { font-size: 12px; color: #6c757d; font-weight: 600; margin-left: 8px; }
        .macroetapa-total { font-size: 15px; font-weight: 700; color: #1d3c25; }

        table { width: 100%; border-collapse: collapse; text-align: left; margin-bottom: 15px; }
        th, td { padding: 10px 12px; border-bottom: 1px solid #edf2f7; font-size: 14px; }
        th { background-color: #f8f9fa; color: #4a5568; font-weight: 600; }
        .sem-itens { padding: 12px; color: #a0aec0; font-size: 14px; font-style: italic; }

        /* ==== FORM DE ADICIONAR ITEM ==== */
        .add-item-form { display: flex; gap: 10px; align-items: flex-end; padding-top: 12px; border-top: 1px dashed #e2e8f0; flex-wrap: wrap; }
        .add-item-form .campo { flex: 1; min-width: 120px; }
        .add-item-form label { display: block; font-size: 12px; font-weight: 600; color: #6c757d; margin-bottom: 5px; }
        .add-item-form input, .add-item-form select { width: 100%; padding: 9px 10px; border: 1px solid #e2e8f0; border-radius: 5px; font-size: 13px; background-color: white;}
        .btn-add { padding: 9px 16px; background-color: #1d3c25; color: white; border: none; border-radius: 5px; font-size: 13px; font-weight: 700; cursor: pointer; }
        .btn-add:hover { background-color: #275232; }

        .btn-secondary { display: inline-flex; align-items: center; justify-content: center; padding: 10px 20px; color: #1d3c25; background-color: transparent; text-decoration: none; font-weight: 700; border: 2px solid #1d3c25; border-radius: 6px; font-size: 14px; transition: all 0.2s ease; }
        .btn-secondary:hover { background-color: #1d3c25; color: white; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-top">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/images/logo-dashboard.png" alt="Ifinance Logo">
                <h2>Ifinance</h2>
            </div>
            <span class="menu-label">Cadastros</span>
            <ul class="nav-menu">
                <li class="nav-item"><a href="listaProjetos.jsp" class="nav-link active">Projetos</a></li>
            </ul>
        </div>
        <a href="perfil.jsp" class="sidebar-footer">
            <div class="avatar"><%= inicial %></div>
            <div class="user-info">
                <div class="user-name" title="<%= usuarioLogado.getEmail() %>"><%= usuarioLogado.getNome() %></div>
                <div class="user-role">COORDENADOR</div>
            </div>
        </a>
    </div>

    <div class="main-content">
        <div class="top-bar">
            <h1>Gerenciar Orçamento do Projeto</h1>
            <a href="listaProjetos.jsp" class="btn-secondary">Voltar para Lista</a>
        </div>

        <div class="container">

            <div class="project-details-card">
                <div style="display:flex; justify-content: space-between; align-items: flex-start;">
                    <div>
                        <h2><%= projeto.getTitulo() %></h2>
                        <p><%= projeto.getDescricao() %></p>
                    </div>
                    <a href="dashboardProjeto.jsp?id=<%= projeto.getId() %>" class="btn-dashboard">Ver Dashboard</a>
                </div>
                <div class="project-meta">
                    <span>Status: <strong><%= projeto.getStatusProjeto() %></strong></span>
                    <span>Duração do Projeto: <strong><%= projeto.getDuracao() %> meses</strong></span>
                </div>
                
                <div class="financiadores-lista">
                    <% for (Financiador f : listaFinanciadores) {
                        BigDecimal totalGastoFinanciador = ioDao.calcularTotalPorFinanciador(projeto.getId(), f.getId());
                        BigDecimal saldo = f.getInvestimento().subtract(totalGastoFinanciador != null ? totalGastoFinanciador : BigDecimal.ZERO);
                    %>
                        <span class="tag-financiador">
                            <%= f.getNome().name() %> — <%= formatoMoeda.format(f.getInvestimento()) %>
                            (saldo: <%= formatoMoeda.format(saldo) %>)
                        </span>
                    <% } %>
                </div>
                
                <% BigDecimal totalGeral = ioDao.calcularTotalProjeto(projeto.getId()); %>
                <div class="total-geral">Total Geral: <%= totalGeral != null ? formatoMoeda.format(totalGeral) : "R$ 0,00" %></div>

                <% if (projeto.getStatusProjeto() == StatusProjeto.APROVADO) { %>
                    <div class="finalizacao-box">
                        <button type="button" class="btn-finalizar" onclick="document.getElementById('formFinalizacao').classList.toggle('aberto')">
                             Solicitar Finalização do Projeto
                        </button>
                        <form id="formFinalizacao" class="form-finalizacao" action="../OrcamentoController" method="POST">
                            <input type="hidden" name="acao" value="solicitarFinalizacao">
                            <input type="hidden" name="idProjeto" value="<%= projeto.getId() %>">
                            <label>Explique o motivo da solicitação de finalização:</label>
                            <textarea name="justificativa" rows="3" placeholder="Ex: todas as macroetapas foram concluídas e o orçamento foi integralmente executado." required></textarea>
                            <button type="submit" class="btn-add">Enviar Solicitação</button>
                        </form>
                    </div>
                <% } %>
            </div>

            <% if (erroItem != null) { %>
                <div class="erro-box">⚠️ <%= erroItem %></div>
            <% } %>
            
            <%
                if (macroetapas != null) {
                for (Macroetapa m : macroetapas) {
            %>
                <div class="macroetapa-card">
                    <div class="macroetapa-header">
                        <form class="form-renomear" action="../OrcamentoController" method="POST">
                            <input type="hidden" name="acao" value="atualizarMacroetapa">
                            <input type="hidden" name="idProjeto" value="<%= projeto.getId() %>">
                            <input type="hidden" name="macroetapaId" value="<%= m.getId() %>">
                            <input type="text" name="nome" value="<%= m.getDescricao() %>" class="input-nome-macroetapa">
                            <button type="submit" class="btn-editar-duracao">Renomear</button>
                        </form>
                        <div style="display:flex; align-items:center; gap: 15px;">
                            <form class="form-duracao" action="../OrcamentoController" method="POST">
                                <input type="hidden" name="acao" value="atualizarDuracaoMacroetapa">
                                <input type="hidden" name="idProjeto" value="<%= projeto.getId() %>">
                                <input type="hidden" name="macroetapaId" value="<%= m.getId() %>">
                                <input type="number" name="duracao" min="1" value="<%= m.getDuracao() %>" class="input-duracao">
                                <span>meses</span>
                                <button type="submit" class="btn-editar-duracao">Salvar</button>
                            </form>
                            
                            <% 
                            List<ItemOrcamento> itens = ioDao.listarPorMacroetapa(m.getId());
                            BigDecimal totalMacro = BigDecimal.ZERO;
                            for (ItemOrcamento io : itens) {
                                if(io.getValorTotal() != null) totalMacro = totalMacro.add(io.getValorTotal());
                            }
                            %>
                            <span class="macroetapa-total"><%= formatoMoeda.format(totalMacro) %></span>
                        </div>
                    </div>

                    <% if (itens.isEmpty()) { %>
                        <div class="sem-itens">Nenhum item cadastrado nesta macroetapa ainda.</div>
                    <% } else { %>
                        <table>
                            <thead>
                                <tr>
                                    <th>Item / Descrição</th>
                                    <th>Rubrica</th>
                                    <th>Financiador</th>
                                    <th style="width: 60px; text-align: center;">Qtd.</th>
                                    <th style="width: 120px; text-align: right;">Valor Unit.</th>
                                    <th style="width: 140px; text-align: right;">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (ItemOrcamento io : itens) { 
                                    model.Item itemTabela = iDao.buscarPorId(io.getFkItemId());
                                    model.Financiador financTabela = fDao.buscarPorId(io.getFinanciadorId());
                                    
                                    String nomeItemExibir = (itemTabela != null) ? itemTabela.getNome() : "ID " + io.getFkItemId();
                                    String financiadorExibir = (financTabela != null && financTabela.getNome() != null) ? financTabela.getNome().name() : "ID " + io.getFinanciadorId();
                                    String rubricaExibir = mapaRubricas.getOrDefault(io.getFkItemId(), "-").replace("_", " ");
                                %>
                                    <tr>
                                        <td><%= nomeItemExibir %></td>
                                        <td><%= rubricaExibir %></td>
                                        <td><%= financiadorExibir %></td>
                                        <td style="text-align: center;"><%= io.getQuantidade() %></td>
                                        <td style="text-align: right;"><%= formatoMoeda.format(io.getValorUnitario()) %></td>
                                        <td style="text-align: right; font-weight: 600; color: #1d3c25;"><%= formatoMoeda.format(io.getValorTotal()) %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>

                    <form class="add-item-form" action="../OrcamentoController" method="POST">
                        <input type="hidden" name="acao" value="adicionarItem">
                        <input type="hidden" name="idProjeto" value="<%= projeto.getId() %>">
                        <input type="hidden" name="macroetapaId" value="<%= m.getId() %>">

                        <div class="campo" style="flex: 2; min-width: 160px;">
                            <label>Nome do Item</label>
                            <input type="text" name="nomeItem" placeholder="Ex: Notebook Corporativo" required>
                        </div>
                        <div class="campo">
                            <label>Rubrica</label>
                            <select name="categoriaRubrica" required>
                                <option value="" disabled selected>Selecione...</option>
                                <% for (CategoriaRubrica cat : CategoriaRubrica.values()) { %>
                                    <option value="<%= cat.name() %>"><%= cat.name().replace("_", " ") %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="campo">
                            <label>Financiador</label>
                            <select name="financiadorId" required>
                                <option value="" disabled selected>Selecione...</option>
                                <% if(listaFinanciadores != null) { for(Financiador f : listaFinanciadores) { %>
                                    <option value="<%= f.getId() %>"><%= f.getNome().name() %></option>
                                <% } } %>
                            </select>
                        </div>
                        <div class="campo" style="max-width: 80px;">
                            <label>Qtd.</label>
                            <input type="number" step="0.01" name="quantidade" value="1" required>
                        </div>
                        <div class="campo" style="max-width: 130px;">
                            <label>Valor Unit. (R$)</label>
                            <input type="number" step="0.01" name="valorUnitario" placeholder="0.00" required>
                        </div>
                        <button type="submit" class="btn-add">+ Adicionar</button>
                    </form>
                </div>
            <% } } %>

        </div>
    </div>

</body>
</html>