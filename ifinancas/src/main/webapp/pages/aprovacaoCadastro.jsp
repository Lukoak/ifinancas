<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }
    if (usuarioLogado.getPerfilId() != 2) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    projetoDAO pDao = new projetoDAO();
    List<Projeto> todos = pDao.listarTodos();
    
    List<Projeto> pendentes = new ArrayList<Projeto>();
    List<Projeto> respondidos = new ArrayList<Projeto>();
    
    for (Projeto p : todos) {
        // Cai nos pendentes tanto novos cadastros, quanto os que pediram finalização!
        if (p.getStatusProjeto() == StatusProjeto.PENDENTE || (p.isSolicitacaoFinalizacao() && p.getStatusProjeto() == StatusProjeto.APROVADO)) {
            pendentes.add(p);
        } else {
            respondidos.add(p);
        }
    }

    int idSelecionado = -1;
    if (request.getParameter("id") != null) {
        idSelecionado = Integer.parseInt(request.getParameter("id"));
    } else if (!pendentes.isEmpty()) {
        idSelecionado = pendentes.get(0).getId();
    }

    Projeto selecionado = null;
    if (idSelecionado != -1) {
        for (Projeto p : todos) {
            if (p.getId() == idSelecionado) {
                selecionado = p;
                break;
            }
        }
    }

    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aprovação de Projetos - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/ifinance-base.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; }
        .sidebar-top { padding: 0 20px; }
        .logo-box { display: flex; align-items: center; gap: 10px; margin-bottom: 35px; }
        .logo-box img { max-width: 40px; height: auto; }
        .logo-box h2 { font-size: 20px; font-weight: 700; letter-spacing: 1px; }
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
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-bar { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); z-index: 10; }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .approval-container { display: flex; flex: 1; overflow: hidden; }
        .list-pane { width: 350px; background: white; border-right: 1px solid #e2e8f0; display: flex; flex-direction: column; }
        .list-header { padding: 20px; border-bottom: 1px solid #e2e8f0; }
        .list-header h3 { font-size: 16px; color: #1d3c25; margin-bottom: 15px; }
        .tabs { display: flex; gap: 10px; }
        .tab-btn { flex: 1; padding: 8px; text-align: center; font-size: 13px; font-weight: 600; color: #6c757d; background: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 6px; cursor: pointer; transition: all 0.2s; }
        .tab-btn.active { background: #1d3c25; color: white; border-color: #1d3c25; }
        .items-list { flex: 1; overflow-y: auto; padding: 10px; }
        .list-item { display: block; padding: 15px; border: 1px solid #e2e8f0; border-radius: 8px; margin-bottom: 10px; text-decoration: none; color: inherit; transition: all 0.2s; }
        .list-item:hover { border-color: #1d3c25; background-color: #f8fafc; }
        .list-item.selected { border-color: #1d3c25; background-color: #f0fdf4; box-shadow: 0 2px 4px rgba(29, 60, 37, 0.1); }
        .item-title { font-size: 14px; font-weight: 700; color: #1d3c25; margin-bottom: 5px; }
        .item-meta { font-size: 12px; color: #6c757d; }
        .inbox-pane { flex: 1; background: #f8fafc; display: flex; flex-direction: column; overflow-y: auto; }
        .pane-vazio { flex: 1; display: flex; justify-content: center; align-items: center; color: #a0aec0; font-size: 16px; font-weight: 500; }
        .pane-header { padding: 30px; background: white; border-bottom: 1px solid #e2e8f0; }
        .pane-header h2 { font-size: 24px; color: #1d3c25; margin-bottom: 10px; }
        .pane-header p { font-size: 15px; color: #4a5568; line-height: 1.6; }
        .pane-content { padding: 30px; flex: 1; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-group { background: white; padding: 20px; border-radius: 8px; border: 1px solid #e2e8f0; }
        .info-label { display: block; font-size: 12px; font-weight: 600; color: #a0aec0; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { font-size: 16px; font-weight: 600; color: #2d3748; }
        .pane-footer { padding: 20px 30px; background: white; border-top: 1px solid #e2e8f0; }
        .btn { padding: 12px 24px; font-size: 14px; font-weight: 700; border-radius: 6px; border: none; cursor: pointer; transition: all 0.2s; }
        .btn-approve { background-color: #1d3c25; color: white; }
        .btn-approve:hover { background-color: #275232; }
        .btn-reject { background-color: #fff; color: #e53e3e; border: 2px solid #e53e3e; }
        .btn-reject:hover { background-color: #fff5f5; }
        .tag-status { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; margin-top: 5px; }
        .status-pendente { background-color: #fff3cd; color: #856404; }
        .status-aprovado { background-color: #d1ecf1; color: #0c5460; }
        .status-reprovado { background-color: #f8d7da; color: #721c24; }
        .status-finalizado { background-color: #d4edda; color: #155724; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
    </style>
    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            event.currentTarget.classList.add('active');
        }
    </script>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-top">
            <div class="logo-box">
                <img src="${pageContext.request.contextPath}/images/logo-dashboard.png" alt="Ifinance Logo">
                <h2>Ifinance</h2>
            </div>
            <span class="menu-label">Painel</span>
            <ul class="nav-menu">
                <li class="nav-item"><a href="listaProjetosAdmin.jsp" class="nav-link">Projetos</a></li>
                <li class="nav-item"><a href="aprovacaoCadastro.jsp" class="nav-link active">Aprovações</a></li>
            </ul>
        </div>
        <a href="perfil.jsp" class="sidebar-footer">
            <div class="avatar"><%= inicial %></div>
            <div class="user-info">
                <div class="user-name" title="<%= usuarioLogado.getEmail() %>"><%= usuarioLogado.getNome() %></div>
                <div class="user-role">ADMIN</div>
            </div>
        </a>
    </div>

    <div class="main-content">
        <div class="top-bar">
            <h1>Caixa de Entrada - Solicitações</h1>
            <a href="../UsuarioController?acao=logout" class="logout-btn">Sair</a>
        </div>

        <div class="approval-container">
            <div class="list-pane">
                <div class="list-header">
                    <h3>Fila de Análise</h3>
                    <div class="tabs">
                        <button class="tab-btn active" onclick="showTab('tab-pendentes')">Pendentes (<%= pendentes.size() %>)</button>
                        <button class="tab-btn" onclick="showTab('tab-historico')">Histórico</button>
                    </div>
                </div>

                <div class="items-list">
                    <div id="tab-pendentes" class="tab-content active">
                        <% if (pendentes.isEmpty()) { %>
                            <p style="text-align: center; color: #a0aec0; font-size: 13px; margin-top: 20px;">Nenhuma solicitação pendente.</p>
                        <% } else {
                            for (Projeto p : pendentes) { %>
                                <a href="aprovacaoCadastro.jsp?id=<%= p.getId() %>" class="list-item <%= (selecionado != null && p.getId() == selecionado.getId()) ? "selected" : "" %>">
                                    <div class="item-title"><%= p.getTitulo() %></div>
                                    <div class="item-meta">ID: <%= p.getId() %></div>
                                    <% if(p.isSolicitacaoFinalizacao()) { %>
                                        <span class="tag-status" style="background-color: #feebc8; color: #c05621;">Solicitação Finalização</span>
                                    <% } else { %>
                                        <span class="tag-status status-pendente">Novo Cadastro</span>
                                    <% } %>
                                </a>
                        <% } } %>
                    </div>

                    <div id="tab-historico" class="tab-content">
                        <% if (respondidos.isEmpty()) { %>
                            <p style="text-align: center; color: #a0aec0; font-size: 13px; margin-top: 20px;">O histórico está vazio.</p>
                        <% } else {
                            for (Projeto p : respondidos) { 
                                String classeStatus = "status-aprovado";
                                if (p.getStatusProjeto() == StatusProjeto.REPROVADO) classeStatus = "status-reprovado";
                                if (p.getStatusProjeto() == StatusProjeto.FINALIZADO) classeStatus = "status-finalizado";
                        %>
                                <a href="aprovacaoCadastro.jsp?id=<%= p.getId() %>" class="list-item <%= (selecionado != null && p.getId() == selecionado.getId()) ? "selected" : "" %>">
                                    <div class="item-title"><%= p.getTitulo() %></div>
                                    <div class="item-meta">ID: <%= p.getId() %></div>
                                    <span class="tag-status <%= classeStatus %>"><%= p.getStatusProjeto() %></span>
                                </a>
                        <% } } %>
                    </div>
                </div>
            </div>

            <div class="inbox-pane">
                <% if (selecionado == null) { %>
                    <div class="pane-vazio">Selecione uma solicitação ao lado para ver os detalhes.</div>
                <% } else { 
                    boolean isCadastroPendente = selecionado.getStatusProjeto() == StatusProjeto.PENDENTE;
                    boolean isFinalizacaoPendente = selecionado.isSolicitacaoFinalizacao() && selecionado.getStatusProjeto() == StatusProjeto.APROVADO;
                %>
                    <div class="pane-header">
                        <h2><%= selecionado.getTitulo() %></h2>
                        <p><%= selecionado.getDescricao() %></p>
                    </div>

                    <div class="pane-content">
                        <div class="info-grid">
                            <div class="info-group">
                                <span class="info-label">ID do Coordenador</span>
                                <span class="info-value"><%= selecionado.getCoordenadorId() %></span>
                            </div>
                            <div class="info-group">
                                <span class="info-label">Status Atual</span>
                                <span class="info-value"><%= selecionado.getStatusProjeto() %></span>
                            </div>
                            
                            <% if (isFinalizacaoPendente) { %>
                                <div class="info-group" style="grid-column: 1 / -1; background: #fff8e6; padding: 15px; border-left: 4px solid #f6ad55; border-radius: 4px;">
                                    <span class="info-label" style="color: #c05621; font-weight: bold; margin-bottom: 5px;">Motivo da Solicitação de Finalização:</span>
                                    <span class="info-value" style="font-size: 14px;"><%= selecionado.getJustificativaFinalizacao() %></span>
                                </div>
                            <% } %>
                        </div>
                    </div>

                    <% if (isCadastroPendente) { %>
                        <div class="pane-footer">
                            <form action="../ProjetoController" method="POST" style="display:flex; gap:15px; margin:0;">
                                <input type="hidden" name="acao" value="processarAprovacao">
                                <input type="hidden" name="idProjeto" value="<%= selecionado.getId() %>">
                                
                                <button type="submit" name="decisao" value="rejeitar" class="btn btn-reject">Rejeitar</button>
                                <button type="submit" name="decisao" value="aprovar" class="btn btn-approve">Aprovar Cadastro</button>
                            </form>
                        </div>
                        
                    <% } else if (isFinalizacaoPendente) { %>
                        <div class="pane-footer">
                            <form action="../ProjetoController" method="POST" style="display:flex; margin:0;">
                                <input type="hidden" name="acao" value="processarFinalizacao">
                                <input type="hidden" name="idProjeto" value="<%= selecionado.getId() %>">
                                
                                <button type="submit" class="btn btn-approve" style="background-color: #de532b; color: white;" onclick="return confirm('Confirmar a finalização definitiva deste projeto? O orçamento será travado.');">
                                    Aprovar e Finalizar Projeto
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
