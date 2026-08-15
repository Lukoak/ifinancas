<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.Macroetapa" %>
<%@ page import="model.ItemOrcamento" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="dao.macroetapaDAO" %>
<%@ page import="dao.itemOrcamentoDAO" %>
<%@ page import="java.util.List" %>
<%
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
    projetoDAO pDao = new projetoDAO();
    macroetapaDAO mDao = new macroetapaDAO();
    itemOrcamentoDAO ioDao = new itemOrcamentoDAO();
    
    Projeto projeto = pDao.buscarPorId(idProjeto);

    if (projeto == null || projeto.getCoordenadorId() != usuarioLogado.getId()) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }
    
    // CORRIGIDO: Chamando da instância mDao e passando o idProjeto!
    List<Macroetapa> macroetapas = mDao.listarPorProjeto(idProjeto); 
    
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gerenciar Orçamento - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; }
        .sidebar-top { padding: 0 20px; }
        .logo-box { display: flex; align-items: center; gap: 10px; margin-bottom: 35px; }
        .logo-box img { max-width: 40px; height: auto; }
        .logo-box h2 { font-size: 20px; font-weight: 700; }
        .menu-label { font-size: 11px; text-transform: uppercase; color: #7da085; font-weight: bold; letter-spacing: 1px; margin-bottom: 10px; display: block; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 5px; }
        .nav-link { display: flex; align-items: center; padding: 12px 15px; color: #cbdbe5; text-decoration: none; border-radius: 8px; font-size: 15px; font-weight: 500; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255,255,255,0.1); color: white; }
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; gap: 12px; text-decoration: none; color: inherit; }
        .avatar { width: 40px; height: 40px; background-color: #3e863e; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; }
        .user-info { min-width: 0; }
        .user-name { font-size: 13px; font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role { font-size: 11px; color: #7da085; text-transform: uppercase; font-weight: bold; }
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-bar { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .container { padding: 30px; max-width: 1150px; width: 100%; margin: 0 auto; }
        
        .project-details-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); margin-bottom: 25px; border-left: 5px solid #1d3c25; }
        .project-details-card h2 { color: #1d3c25; font-size: 20px; margin-bottom: 8px; }
        .project-details-card p { color: #4a5568; font-size: 15px; line-height: 1.5; margin-bottom: 12px; }
        .project-meta { display: flex; gap: 25px; flex-wrap: wrap; font-size: 13px; color: #6c757d; }
        .project-meta strong { color: #1d3c25; }
        .total-geral { margin-top: 15px; font-size: 22px; font-weight: 700; color: #1d3c25; }
        .btn-dashboard { flex-shrink: 0; padding: 10px 18px; background-color: #1d3c25; color: white; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 700; }
        .btn-dashboard:hover { background-color: #275232; }
        .btn-secondary { padding: 10px 20px; color: #1d3c25; border: 2px solid #1d3c25; text-decoration: none; border-radius: 6px; font-weight: 700; }
        
        .macroetapa-card { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); padding: 20px; margin-bottom: 20px; }
        .macroetapa-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .form-renomear { display: flex; align-items: center; gap: 8px; }
        .input-nome-macroetapa { font-size: 16px; font-weight: 600; color: #1d3c25; border: 1px solid transparent; padding: 4px 8px; background: transparent; }
        .input-nome-macroetapa:focus { border-color: #e2e8f0; background-color: #f8fafc; outline: none; }
        .btn-editar { padding: 4px 10px; background-color: #edf2f7; color: #1d3c25; border: none; border-radius: 4px; font-size: 11px; font-weight: 700; cursor: pointer; }
        
        .add-item-form { display: flex; gap: 10px; align-items: flex-end; padding-top: 12px; border-top: 1px dashed #e2e8f0; flex-wrap: wrap; }
        .add-item-form .campo { flex: 1; min-width: 120px; }
        .add-item-form label { display: block; font-size: 12px; font-weight: 600; color: #6c757d; margin-bottom: 5px; }
        .add-item-form input, .add-item-form select { width: 100%; padding: 9px 10px; border: 1px solid #e2e8f0; border-radius: 5px; font-size: 13px; }
        .btn-add { padding: 9px 16px; background-color: #1d3c25; color: white; border: none; border-radius: 5px; font-weight: 700; cursor: pointer; }
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
                    <a href="dashboardProjeto.jsp?id=<%= projeto.getId() %>" class="btn-dashboard">📊 Ver Dashboard</a>
                </div>
                <div class="project-meta">
                    <span>Status: <strong><%= projeto.getStatusProjeto() %></strong></span>
                </div>
                <div class="total-geral">Total Geral: R$ <%= (ioDao.calcularTotalProjeto(projeto.getId()) != null) ? String.format("%,.2f", ioDao.calcularTotalProjeto(projeto.getId())) : "0,00" %></div>
            </div>

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
                            <input type="number" name="duracao" value="<%= m.getDuracao() %>" style="width: 50px;" class="input-nome-macroetapa" title="Duração (meses)">
                            <button type="submit" class="btn-editar">Atualizar Macroetapa</button>
                        </form>
                    </div>

                    <div class="itens-orcamento">
                        <% 
                        List<ItemOrcamento> itens = ioDao.listarPorMacroetapa(m.getId());
                        if(itens.isEmpty()) { 
                        %>
                            <p style="padding: 12px; color: #a0aec0; font-size: 13px;">Nenhum item cadastrado nesta macroetapa.</p>
                        <% } else { %>
                            <table style="width: 100%; border-collapse: collapse; margin-bottom: 15px; font-size: 13px;">
                                <tr style="border-bottom: 1px solid #e2e8f0;">
                                    <th style="text-align: left; padding: 8px;">Item ID</th>
                                    <th style="text-align: left; padding: 8px;">Qtd</th>
                                    <th style="text-align: left; padding: 8px;">V. Unitário</th>
                                    <th style="text-align: left; padding: 8px;">Total</th>
                                    <th>Ações</th>
                                </tr>
                                <% for(ItemOrcamento io : itens) { %>
                                <tr style="border-bottom: 1px solid #edf2f7;">
                                    <td style="padding: 8px;"><%= io.getFkItemId() %></td>
                                    <td style="padding: 8px;"><%= io.getQuantidade() %></td>
                                    <td style="padding: 8px;">R$ <%= io.getValorUnitario() %></td>
                                    <td style="padding: 8px;"><strong>R$ <%= io.getValorTotal() %></strong></td>
                                    <td style="padding: 8px;">
                                         <a href="../OrcamentoController?acao=excluirItem&idItem=<%= io.getId() %>&idProjeto=<%= projeto.getId() %>" style="color: red; text-decoration: none;">Excluir</a>
                                    </td>
                                </tr>
                                <% } %>
                            </table>
                        <% } %>
                    </div>

                    <form class="add-item-form" action="../OrcamentoController" method="POST">
                        <input type="hidden" name="acao" value="adicionarItem">
                        <input type="hidden" name="idProjeto" value="<%= projeto.getId() %>">
                        <input type="hidden" name="macroetapaId" value="<%= m.getId() %>">

                        <div class="campo" style="flex: 2; min-width: 160px;">
                            <label>ID do Item (Rubrica Base)</label>
                            <input type="number" name="fkItemId" placeholder="ID da tabela item" required>
                        </div>
                        <div class="campo">
                            <label>ID do Financiador</label>
                            <input type="number" name="financiadorId" placeholder="ID" required>
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