<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="dao.itemOrcamentoDAO" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }
    
    // Se um coordenador cair aqui por engano, redireciona para a tela dele
    if (usuarioLogado.getPerfilId() != 2) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    projetoDAO pDao = new projetoDAO();
    itemOrcamentoDAO ioDao = new itemOrcamentoDAO();
    List<Projeto> todosProjetos = pDao.listarTodos();
    
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
                     
    // Calcula o Orçamento Total apenas dos projetos FINALIZADOS
    BigDecimal orcamentoTotalGlobal = BigDecimal.ZERO;
    for (Projeto p : todosProjetos) {
        if (p.getStatusProjeto() == StatusProjeto.FINALIZADO) {
            BigDecimal totalP = ioDao.calcularTotalProjeto(p.getId());
            if (totalP != null) {
                orcamentoTotalGlobal = orcamentoTotalGlobal.add(totalP);
            }
        }
    }
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Todos os Projetos - Ifinance (Admin)</title>
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
        .widget-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); flex: 1; min-width: 0; }
        .widget-title { font-size: 13px; color: #6c757d; font-weight: 600; text-transform: uppercase; display: block; }
        .widget-value { font-size: 24px; font-weight: 700; color: #1d3c25; margin: 10px 0; display: block; white-space: nowrap; }
        .btn-table-action { display: inline-block; padding: 6px 12px; background-color: transparent; color: #3e863e; border: 1px solid #3e863e; text-decoration: none; border-radius: 4px; font-size: 13px; font-weight: 600; transition: all 0.2s ease; margin: 0 2px;}
        .btn-table-action:hover { background-color: #3e863e; color: white; }
        .btn-delete { border: none; background: none; cursor: pointer; font-size: 16px; padding: 6px; line-height: 1; margin: 0 2px;}
        .table-container { background: white; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); padding: 20px; }
        .table-header-area { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .table-header-area h3 { color: #1d3c25; font-size: 18px; font-weight: 600; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        th, td { padding: 14px 16px; border-bottom: 1px solid #edf2f7; font-size: 15px; }
        th { background-color: #f8f9fa; color: #4a5568; font-weight: 600; }
        tr:hover { background-color: #fcfdfc; }
        .acoes-cell { text-align: center; display: flex; gap: 4px; align-items: center; justify-content: center; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .status-pendente { background-color: #feebc8; color: #c05621; }
        .status-aprovado { background-color: #c6f6d5; color: #22543d; }
        .status-reprovado { background-color: #fed7d7; color: #822727; }
        .status-finalizado { background-color: #e2e8f0; color: #4a5568; }
        .logout-btn { color: #dc3545; text-decoration: none; font-size: 14px; font-weight: bold; }
        .logout-btn:hover { text-decoration: underline; }
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
                <li class="nav-item"><a href="listaProjetosAdmin.jsp" class="nav-link active">Projetos</a></li>
                <li class="nav-item"><a href="aprovacaoCadastro.jsp" class="nav-link">Aprovações</a></li>
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
            <h1>Todos os Projetos</h1>
            <a href="${pageContext.request.contextPath}/UsuarioController?acao=logout" class="logout-btn">Sair</a>
        </div>

        <div class="container">
            <div class="dashboard-widgets">
                <div class="widget-card">
                    <span class="widget-title">Total de Projetos Cadastrados</span>
                    <span class="widget-value"><%= todosProjetos.size() %></span>
                </div>
                <div class="widget-card">
                    <span class="widget-title">Orçamento Total (Finalizados)</span>
                    <span class="widget-value"><%= nf.format(orcamentoTotalGlobal) %></span>
                </div>
            </div>

            <div class="table-container">
                <div class="table-header-area">
                    <h3>Projetos de Todos os Coordenadores</h3>
                </div>

                <table>
                    <thead>
                        <tr>
                            <th style="width: 50px;">ID</th>
                            <th>Título do Projeto</th>
                            <th>Coordenador</th>
                            <th style="width: 130px;">Status</th>
                            <th style="width: 250px; text-align: center;">Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            for (Projeto p : todosProjetos) {
                                String classeBadge;
                                if (p.getStatusProjeto() == StatusProjeto.APROVADO) classeBadge = "status-aprovado";
                                else if (p.getStatusProjeto() == StatusProjeto.REPROVADO) classeBadge = "status-reprovado";
                                else if (p.getStatusProjeto() == StatusProjeto.FINALIZADO) classeBadge = "status-finalizado";
                                else classeBadge = "status-pendente";
                                
                                String nomeCoordenadorExibir = (p.getNomeCoordenador() != null) ? p.getNomeCoordenador() : "ID: " + p.getCoordenadorId();
                        %>
                            <tr>
                                <td><strong><%= p.getId() %></strong></td>
                                <td><%= p.getTitulo() %></td>
                                <td><%= nomeCoordenadorExibir %></td>
                                <td>
                                    <span class="badge <%= classeBadge %>"><%= p.getStatusProjeto() %></span>
                                </td>
                                <td class="acoes-cell">
                                    <a href="aprovacaoCadastro.jsp?id=<%= p.getId() %>" class="btn-table-action" title="Analisar Cadastro e Finalizações">Detalhes</a>
                                    
                                    <a href="gerenciarOrcamento.jsp?id=<%= p.getId() %>" class="btn-table-action" style="color:#1d3c25; border-color:#1d3c25;" title="Gerenciar/Visualizar Orçamento do Projeto">Orçamento</a>
                                    
                                    <form action="../ProjetoController" method="POST" onsubmit="return confirm('ATENÇÃO: Excluir este projeto apagará todo o orçamento vinculado. Continuar?');" style="display:inline;">
                                        <input type="hidden" name="acao" value="excluir">
                                        <input type="hidden" name="idProjeto" value="<%= p.getId() %>">
                                        <button type="submit" class="btn-delete" title="Excluir projeto">🗑️</button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</body>
</html>