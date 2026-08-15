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
        if (p.getStatusProjeto() == StatusProjeto.PENDENTE) {
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
    for (Projeto p : todos) {
        if (p.getId() == idSelecionado) {
            selecionado = p;
            break;
        }
    }
    
    boolean selecionadoEstaPendente = (selecionado != null) && (selecionado.getStatusProjeto() == StatusProjeto.PENDENTE);
    
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Aprovações - Ifinance</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; flex-shrink: 0; }
        .sidebar-top { padding: 0 20px; }
        .logo-box { display: flex; align-items: center; gap: 10px; margin-bottom: 35px; }
        .logo-box img { max-width: 40px; height: auto; }
        .logo-box h2 { font-size: 20px; font-weight: 700; letter-spacing: 1px; }
        .menu-label { font-size: 11px; text-transform: uppercase; color: #7da085; font-weight: bold; letter-spacing: 1px; margin-bottom: 10px; display: block; }
        .nav-menu { list-style: none; }
        .nav-item { margin-bottom: 5px; }
        .nav-link { display: flex; align-items: center; padding: 12px 15px; color: #cbdbe5; text-decoration: none; border-radius: 8px; font-size: 15px; font-weight: 500; transition: all 0.2s ease; }
        .nav-link:hover, .nav-link.active { background-color: rgba(255,255,255,0.1); color: white; }
        .sidebar-footer { padding: 15px 20px; border-top: 1px solid rgba(255,255,255,0.1); display: flex; align-items: center; gap: 12px; text-decoration: none; color: inherit; transition: background-color 0.2s; }
        .sidebar-footer:hover { background-color: rgba(255,255,255,0.06); }
        .avatar { width: 40px; height: 40px; background-color: #3e863e; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-weight: bold; flex-shrink: 0; }
        .user-info { min-width: 0; }
        .user-name { font-size: 13px; font-weight: 600; color: #ffffff; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-role { font-size: 11px; color: #7da085; text-transform: uppercase; font-weight: bold; }
        .main-content { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
        .top-bar { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); z-index: 10; }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .logout-btn { color: #dc3545; text-decoration: none; font-size: 14px; font-weight: bold; }
        .logout-btn:hover { text-decoration: underline; }
        .inbox-wrapper { display: flex; flex: 1; padding: 20px 30px; gap: 20px; overflow: hidden; }
        .inbox-sidebar { width: 380px; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); display: flex; flex-direction: column; overflow: hidden; flex-shrink: 0; }
        .inbox-tabs { display: flex; border-bottom: 1px solid #edf2f7; }
        .inbox-tab-btn { flex: 1; padding: 14px; background: none; border: none; font-size: 13px; font-weight: 700; color: #6c757d; cursor: pointer; border-bottom: 3px solid transparent; }
        .inbox-tab-btn.active { color: #1d3c25; border-bottom-color: #1d3c25; }
        .badge-count { background: #de532b; color: white; padding: 1px 7px; border-radius: 12px; font-size: 11px; margin-left: 6px; }
        .inbox-list { flex: 1; overflow-y: auto; }
        .inbox-panel { display: none; }
        .inbox-panel.active { display: block; }
        .inbox-item { display: block; padding: 15px 20px; border-bottom: 1px solid #edf2f7; text-decoration: none; color: inherit; transition: background-color 0.2s; }
        .inbox-item:hover { background-color: #f8f9fa; }
        .inbox-item.active { background-color: #f0fdf4; border-left: 4px solid #99be30; }
        .inbox-item-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 5px; }
        .item-name { font-size: 14px; font-weight: 700; color: #000000; }
        .item-coord { font-size: 12px; color: #718096; margin-bottom: 5px; }
        .item-tipo { font-size: 11px; color: #de532b; font-weight: 600; text-transform: uppercase; }
        .sem-pendencias { padding: 30px 20px; text-align: center; color: #a0aec0; font-style: italic; font-size: 14px; }
        .inbox-pane { flex: 1; background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); display: flex; flex-direction: column; overflow: hidden; }
        .pane-header { padding: 30px; border-bottom: 1px solid #edf2f7; }
        .pane-header h2 { font-size: 20px; color: #000000; margin-bottom: 5px; }
        .pane-header p { font-size: 13px; color: #718096; }
        .pane-content { padding: 30px; flex: 1; overflow-y: auto; }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px; margin-bottom: 25px; }
        .info-group { display: flex; flex-direction: column; gap: 6px; }
        .info-label { font-size: 11px; color: #a0aec0; text-transform: uppercase; font-weight: 700; letter-spacing: 0.5px; }
        .info-value { font-size: 15px; color: #000000; font-weight: 500; }
        .pane-footer { padding: 20px 30px; border-top: 1px solid #edf2f7; display: flex; justify-content: flex-end; gap: 15px; background-color: #fafbfc; }
        .btn { padding: 10px 24px; border-radius: 6px; font-size: 14px; font-weight: 600; cursor: pointer; border: none; }
        .btn-reject { background-color: white; color: #ac1412; border: 1px solid #ac1412; }
        .btn-reject:hover { background-color: #ac1412; color: white; }
        .btn-approve { background-color: #3e863e; color: white; border: 1px solid #3e863e; }
        .btn-approve:hover { background-color: #1d3c25; border-color: #1d3c25; }
        .pane-vazio { flex: 1; display: flex; align-items: center; justify-content: center; color: #a0aec0; font-size: 14px; font-style: italic; }
    </style>
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
            <h1>Aprovações</h1>
            <a href="../UsuarioController?acao=logout" class="logout-btn">Sair</a>
        </div>

        <div class="inbox-wrapper">
            <div class="inbox-sidebar">
                <div class="inbox-tabs">
                    <button class="inbox-tab-btn active" onclick="mostrarPainel('pendentes', this)">
                        Pendentes <span class="badge-count"><%= pendentes.size() %></span>
                    </button>
                    <button class="inbox-tab-btn" onclick="mostrarPainel('respondidos', this)">
                        Respondidos
                    </button>
                </div>

                <div class="inbox-list">
                    <div id="pendentes" class="inbox-panel active">
                        <% if (pendentes.isEmpty()) { %>
                            <div class="sem-pendencias">Nenhuma solicitação pendente no momento.</div>
                        <% } else {
                            for (Projeto p : pendentes) {
                                boolean ativo = (p.getId() == idSelecionado);
                        %>
                            <a href="aprovacaoCadastro.jsp?id=<%= p.getId() %>" class="inbox-item <%= ativo ? "active" : "" %>">
                                <div class="inbox-item-header">
                                    <span class="item-name"><%= p.getTitulo() %></span>
                                </div>
                                <div class="item-coord">ID Coord: <%= p.getCoordenadorId() %></div>
                                <span class="item-tipo">Aprovação Inicial</span>
                            </a>
                        <% } } %>
                    </div>

                    <div id="respondidos" class="inbox-panel">
                        <% if (respondidos.isEmpty()) { %>
                            <div class="sem-pendencias">Nenhuma solicitação respondida ainda.</div>
                        <% } else {
                            for (Projeto p : respondidos) {
                                boolean ativo = (p.getId() == idSelecionado);
                        %>
                            <a href="aprovacaoCadastro.jsp?id=<%= p.getId() %>" class="inbox-item <%= ativo ? "active" : "" %>">
                                <div class="inbox-item-header">
                                    <span class="item-name"><%= p.getTitulo() %></span>
                                </div>
                                <div class="item-coord">ID Coord: <%= p.getCoordenadorId() %></div>
                                <span class="item-tipo" style="color:#6c757d;"><%= p.getStatusProjeto() %></span>
                            </a>
                        <% } } %>
                    </div>
                </div>
            </div>

            <div class="inbox-pane">
                <% if (selecionado == null) { %>
                    <div class="pane-vazio">Selecione uma solicitação ao lado para ver os detalhes.</div>
                <% } else { %>
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
                        </div>
                    </div>

                    <% if (selecionadoEstaPendente) { %>
                        <div class="pane-footer">
                            <form action="../ProjetoController" method="POST" style="display:flex; gap:15px; margin:0;">
                                <input type="hidden" name="acao" value="processarAprovacao">
                                <input type="hidden" name="idProjeto" value="<%= selecionado.getId() %>">
                                
                                <button type="submit" name="decisao" value="rejeitar" class="btn btn-reject">Rejeitar</button>
                                <button type="submit" name="decisao" value="aprovar" class="btn btn-approve">Aprovar</button>
                            </form>
                        </div>
                    <% } %>
                <% } %>
            </div>
        </div>
    </div>

    <script>
        function mostrarPainel(id, botao) {
            document.querySelectorAll('.inbox-panel').forEach(function(el) { el.classList.remove('active'); });
            document.querySelectorAll('.inbox-tab-btn').forEach(function(el) { el.classList.remove('active'); });
            document.getElementById(id).classList.add('active');
            botao.classList.add('active');
        }
    </script>
</body>
</html>