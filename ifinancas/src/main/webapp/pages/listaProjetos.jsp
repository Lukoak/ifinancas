<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }
    // Se for ADMIN (Perfil 2), manda pra tela dele
    if (usuarioLogado.getPerfilId() == 2) {
        response.sendRedirect("listaProjetosAdmin.jsp");
        return;
    }

    projetoDAO pDao = new projetoDAO();
    List<Projeto> meusProjetos = pDao.listarPorCoordenador(usuarioLogado.getId());
    boolean mostrarSucesso = "1".equals(request.getParameter("sucesso"));
    
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meus Projetos - Ifinance</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; }
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
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-bar { background-color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .container { padding: 30px; max-width: 1200px; width: 100%; margin: 0 auto; }
        .dashboard-widgets { display: flex; gap: 20px; margin-bottom: 30px; }
        .widget-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); flex: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .widget-title { font-size: 13px; color: #6c757d; font-weight: 600; text-transform: uppercase; }
        .widget-value { font-size: 28px; font-weight: 700; color: #1d3c25; margin: 10px 0; }
        .btn-primary { display: inline-flex; align-items: center; justify-content: center; padding: 12px 20px; background-color: #1d3c25; color: white; text-decoration: none; border-radius: 6px; font-size: 14px; font-weight: bold; transition: all 0.2s ease; border: none; cursor: pointer; }
        .btn-primary:hover { background-color: #3e863e; transform: translateY(-1px); }
        .btn-table-action { display: inline-block; padding: 6px 12px; background-color: transparent; color: #3e863e; border: 1px solid #3e863e; text-decoration: none; border-radius: 4px; font-size: 13px; font-weight: 600; transition: all 0.2s ease; }
        .btn-table-action:hover { background-color: #3e863e; color: white; }
        .tabs { display: flex; gap: 5px; margin-bottom: -1px; }
        .tab-btn { padding: 10px 20px; background: #e9edf0; border: none; border-radius: 8px 8px 0 0; font-size: 14px; font-weight: 600; color: #6c757d; cursor: pointer; }
        .tab-btn.active { background: white; color: #1d3c25; }
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        .table-container { background: white; border-radius: 0 10px 10px 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); padding: 20px; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 14px 16px; border-bottom: 1px solid #edf2f7; font-size: 15px; }
        th { background-color: #f8f9fa; color: #4a5568; font-weight: 600; }
        tr:hover { background-color: #fcfdfc; }
        .acoes-cell { text-align: center; display: flex; gap: 8px; align-items: center; justify-content: center; }
        .sem-projetos { padding: 30px; text-align: center; color: #a0aec0; font-style: italic; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .status-pendente { background-color: #feebc8; color: #c05621; }
        .status-aprovado { background-color: #c6f6d5; color: #22543d; }
        .status-reprovado { background-color: #fed7d7; color: #822727; }
        .status-finalizado { background-color: #e2e8f0; color: #4a5568; }
        .logout-btn { color: #dc3545; text-decoration: none; font-size: 14px; font-weight: bold; }
        .logout-btn:hover { text-decoration: underline; }
        .toast-sucesso { display: flex; align-items: center; gap: 10px; background-color: #22543d; color: white; font-weight: 600; font-size: 14px; padding: 14px 20px; border-radius: 8px; margin-bottom: 20px; animation: entraEsaiToast 4s ease forwards; }
        @keyframes entraEsaiToast { 0% { opacity: 0; transform: translateY(-10px); } 10% { opacity: 1; transform: translateY(0); } 85% { opacity: 1; transform: translateY(0); } 100% { opacity: 0; transform: translateY(-10px); display: none; } }
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
            <h1>Meus Projetos</h1>
            <a href="../UsuarioController?acao=logout" class="logout-btn">Sair</a>
        </div>

        <div class="container">
            <% if (mostrarSucesso) { %>
                <div class="toast-sucesso">✅ Projeto solicitado com sucesso! Aguarde a aprovação do ADMIN.</div>
            <% } %>
            <div class="dashboard-widgets">
                <div class="widget-card">
                    <span class="widget-title">Meus Projetos</span>
                    <span class="widget-value"><%= meusProjetos.size() %></span>
                </div>
                <div class="widget-card">
                    <span class="widget-title">Orçamento Total (meus projetos)</span>
                    <span class="widget-value">R$ 0,00</span> </div>
                <div class="widget-card" style="justify-content: center; align-items: flex-start; background: transparent; box-shadow: none; padding: 0;">
                    <a href="cadastroProjeto.jsp" class="btn-primary" style="width: 100%; height: 55px;">+ Solicitar Novo Projeto</a>
                </div>
            </div>

            <div class="tabs">
                <button class="tab-btn active" onclick="mostrarAba('aprovados', this)">Aprovados</button>
                <button class="tab-btn" onclick="mostrarAba('pendentesReprovados', this)">Pendentes e Reprovados</button>
                <button class="tab-btn" onclick="mostrarAba('finalizados', this)">Finalizados</button>
            </div>

            <div class="table-container">
                <div id="aprovados" class="tab-content active">
                    <%
                        boolean temAprovado = false;
                        for (Projeto p : meusProjetos) {
                            if (p.getStatusProjeto() == StatusProjeto.APROVADO) { temAprovado = true; break; }
                        }
                        if (!temAprovado) {
                    %>
                        <div class="sem-projetos">Nenhum projeto aprovado ainda.</div>
                    <% } else { %>
                        <table>
                            <thead><tr><th style="width:60px;">ID</th><th>Título</th><th>Descrição</th><th style="width:130px;">Status</th><th style="width:220px; text-align:center;">Ações</th></tr></thead>
                            <tbody>
                                <% for (Projeto p : meusProjetos) { if (p.getStatusProjeto() != StatusProjeto.APROVADO) continue; %>
                                    <tr>
                                        <td><strong><%= p.getId() %></strong></td>
                                        <td><%= p.getTitulo() %></td>
                                        <td><%= p.getDescricao() %></td>
                                        <td><span class="badge status-aprovado">APROVADO</span></td>
                                        <td class="acoes-cell">
                                            <a href="gerenciarOrcamento.jsp?id=<%= p.getId() %>" class="btn-table-action">Gerenciar Orçamento</a>
                                        </td>
                                     </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>

                <div id="pendentesReprovados" class="tab-content">
                    <%
                        boolean temPendReprov = false;
                        for (Projeto p : meusProjetos) {
                            if (p.getStatusProjeto() == StatusProjeto.PENDENTE || p.getStatusProjeto() == StatusProjeto.REPROVADO) { temPendReprov = true; break; }
                        }
                        if (!temPendReprov) {
                    %>
                        <div class="sem-projetos">Nenhuma solicitação pendente ou reprovada.</div>
                    <% } else { %>
                        <table>
                            <thead><tr><th style="width:60px;">ID</th><th>Título</th><th>Descrição</th><th style="width:130px;">Status</th><th style="width:220px; text-align:center;">Ações</th></tr></thead>
                            <tbody>
                                <% for (Projeto p : meusProjetos) {
                                       if (p.getStatusProjeto() != StatusProjeto.PENDENTE && p.getStatusProjeto() != StatusProjeto.REPROVADO) continue;
                                       String classeBadge = p.getStatusProjeto() == StatusProjeto.PENDENTE ? "status-pendente" : "status-reprovado";
                                %>
                                    <tr>
                                        <td><strong><%= p.getId() %></strong></td>
                                        <td><%= p.getTitulo() %></td>
                                        <td><%= p.getDescricao() %></td>
                                        <td><span class="badge <%= classeBadge %>"><%= p.getStatusProjeto() %></span></td>
                                        <td class="acoes-cell">
                                            <% if (p.getStatusProjeto() == StatusProjeto.PENDENTE) { %>
                                                <span style="color:#a0aec0; font-size: 13px;">Aguardando aprovação</span>
                                            <% } else { %>
                                                <span style="color:#822727; font-size: 13px;">Solicitação reprovada</span>
                                            <% } %>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>

                <div id="finalizados" class="tab-content">
                    <%
                        boolean temFinalizado = false;
                        for (Projeto p : meusProjetos) {
                            if (p.getStatusProjeto() == StatusProjeto.FINALIZADO) { temFinalizado = true; break; }
                        }
                        if (!temFinalizado) {
                    %>
                        <div class="sem-projetos">Nenhum projeto finalizado ainda.</div>
                    <% } else { %>
                        <table>
                            <thead><tr><th style="width:60px;">ID</th><th>Título</th><th>Descrição</th><th style="width:130px;">Status</th><th style="width:220px; text-align:center;">Ações</th></tr></thead>
                            <tbody>
                                <% for (Projeto p : meusProjetos) { if (p.getStatusProjeto() != StatusProjeto.FINALIZADO) continue; %>
                                    <tr>
                                        <td><strong><%= p.getId() %></strong></td>
                                        <td><%= p.getTitulo() %></td>
                                        <td><%= p.getDescricao() %></td>
                                        <td><span class="badge status-finalizado">FINALIZADO</span></td>
                                        <td class="acoes-cell">
                                            <a href="gerenciarOrcamento.jsp?id=<%= p.getId() %>" class="btn-table-action">Ver Orçamento</a>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script>
        function mostrarAba(id, botao) {
            document.querySelectorAll('.tab-content').forEach(function(el) { el.classList.remove('active'); });
            document.querySelectorAll('.tab-btn').forEach(function(el) { el.classList.remove('active'); });
            document.getElementById(id).classList.add('active');
            botao.classList.add('active');
        }
    </script>
</body>
</html>