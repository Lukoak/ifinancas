<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.Macroetapa" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="dao.macroetapaDAO" %>
<%@ page import="dao.itemOrcamentoDAO" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }

    int idProjeto = Integer.parseInt(request.getParameter("id"));
    
    projetoDAO pDao = new projetoDAO();
    macroetapaDAO mDao = new macroetapaDAO();
    itemOrcamentoDAO ioDao = new itemOrcamentoDAO();

    Projeto projeto = pDao.buscarPorId(idProjeto);

    if (projeto == null) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    boolean podeVer = (usuarioLogado.getPerfilId() == 2) || (projeto.getCoordenadorId() == usuarioLogado.getId());
    if (!podeVer) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    String voltarPara = (usuarioLogado.getPerfilId() == 2) ? "listaProjetosAdmin.jsp" : "gerenciarOrcamento.jsp?id=" + projeto.getId();

    BigDecimal totalGeral = ioDao.calcularTotalProjeto(idProjeto);
    if (totalGeral == null) totalGeral = BigDecimal.ZERO;

    List<Macroetapa> macroetapas = mDao.listarPorProjeto(idProjeto);
    int totalMacroetapas = (macroetapas != null) ? macroetapas.size() : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - <%= projeto.getTitulo() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f7f8fa; padding: 40px; color: #1f2d24; }
        .container { max-width: 1100px; margin: 0 auto; }
        .topo { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
        .topo h1 { font-size: 22px; font-weight: 700; color: #1d3c25; }
        .topo p { font-size: 14px; color: #6c757d; margin-top: 4px; }
        .btn-voltar { padding: 8px 16px; background: none; color: #1d3c25; border: 1px solid #dbe2e5; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 13px; transition: all 0.2s; }
        .btn-voltar:hover { border-color: #1d3c25; background-color: #1d3c25; color: white; }
        .resumo-cards { display: flex; gap: 20px; margin-bottom: 30px; }
        .resumo-card { flex: 1; background: white; border-radius: 10px; padding: 20px; border: 1px solid #edf0f2; box-shadow: 0 4px 6px rgba(0,0,0,0.02); }
        .resumo-card .titulo { font-size: 12px; text-transform: uppercase; color: #8a97a0; font-weight: 700; letter-spacing: 0.5px; }
        .resumo-card .valor { font-size: 24px; font-weight: 700; color: #1d3c25; margin-top: 8px; }
        .detalhes-card { background: white; border-radius: 10px; padding: 25px; border: 1px solid #edf0f2; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 30px; }
        .detalhes-card h3 { font-size: 16px; color: #1d3c25; font-weight: 700; margin-bottom: 12px; }
        .detalhes-card p { font-size: 14px; color: #4a5568; line-height: 1.6; }
        .badge-status { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 700; text-transform: uppercase; margin-top: 10px; background-color: #c6f6d5; color: #22543d; }
    </style>
</head>
<body>
<div class="container">
    <div class="topo">
        <div>
            <h1><%= projeto.getTitulo() %></h1>
            <p>Painel de acompanhamento e indicadores orçamentários</p>
        </div>
        <a href="<%= voltarPara %>" class="btn-voltar">← Voltar</a>
    </div>

    <div class="resumo-cards">
        <div class="resumo-card">
            <div class="titulo">Total Geral Orçado</div>
            <div class="valor">R$ <%= String.format("%,.2f", totalGeral) %></div>
        </div>
        <div class="resumo-card">
            <div class="titulo">Macroetapas Cadastradas</div>
            <div class="valor"><%= totalMacroetapas %></div>
        </div>
        <div class="resumo-card">
            <div class="titulo">Duração Prevista</div>
            <div class="valor"><%= projeto.getDuracao() %> mês(es)</div>
        </div>
    </div>

    <div class="detalhes-card">
        <h3>Descrição do Projeto</h3>
        <p><%= projeto.getDescricao() %></p>
        <span class="badge-status"><%= projeto.getStatusProjeto() %></span>
    </div>
</div>
</body>
</html>