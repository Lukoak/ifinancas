<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="dao.projetoDAO" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }

    // Supondo que getPerfilId() == 2 seja ADMIN e 1 seja COORDENADOR
    boolean isAdmin = (usuarioLogado.getPerfilId() == 2);
    String tipoUsuarioStr = isAdmin ? "ADMIN" : "COORDENADOR";
    String voltarPara = isAdmin ? "listaProjetosAdmin.jsp" : "listaProjetos.jsp";
    
    // Pega a primeira letra do nome para o Avatar
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() 
                     : "?";

    // Instancia o DAO para contar os projetos rapidamente
    projetoDAO pDao = new projetoDAO();
    int totalProjetos = 0;
    try {
        if (isAdmin) {
            totalProjetos = pDao.listarTodos().size(); // Certifique-se de ter esse método no projetoDAO
        } else {
            totalProjetos = pDao.listarPorCoordenador(usuarioLogado.getId()).size();
        }
    } catch(Exception e) {
        totalProjetos = 0; // Fallback caso dê erro na contagem
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Meu Perfil - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; min-height: 100vh; padding: 40px 20px; display: flex; justify-content: center; }
        .container { width: 100%; max-width: 480px; }
        .topo { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .topo h1 { font-size: 20px; color: #1d3c25; font-weight: 700; }
        .btn-voltar { padding: 8px 16px; background: none; color: #1d3c25; border: 1px solid #dbe2e5; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 13px; }
        .btn-voltar:hover { border-color: #1d3c25; }
        .perfil-card { background: white; border-radius: 10px; padding: 30px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); text-align: center; }
        .avatar-grande {
            width: 80px; height: 80px; border-radius: 50%; background-color: #3e863e; color: white;
            display: flex; align-items: center; justify-content: center; font-size: 32px; font-weight: 700; margin: 0 auto 15px;
        }
        .perfil-nome { font-size: 20px; font-weight: 700; color: #1d3c25; }
        .perfil-tipo { display: inline-block; margin-top: 8px; padding: 4px 12px; border-radius: 20px; background-color: #e1f2e5; color: #1d3c25; font-size: 12px; font-weight: 700; text-transform: uppercase; }
        .dados-lista { text-align: left; margin-top: 30px; display: flex; flex-direction: column; gap: 18px; }
        .dado-item { padding-bottom: 14px; border-bottom: 1px solid #f1f5f9; }
        .dado-label { font-size: 11px; text-transform: uppercase; color: #a0aec0; font-weight: 700; letter-spacing: 0.4px; }
        .dado-valor { font-size: 15px; color: #1d3c25; font-weight: 500; margin-top: 4px; }
        .resumo-projetos { margin-top: 20px; padding: 14px; background-color: #f8fafc; border-radius: 8px; font-size: 13px; color: #4a5568; text-align: center; }
        .resumo-projetos strong { color: #1d3c25; }
    </style>
</head>
<body>
<div class="container">

    <div class="topo">
        <h1>Meu Perfil</h1>
        <a href="<%= voltarPara %>" class="btn-voltar">Voltar</a>
    </div>

    <div class="perfil-card">
        <div class="avatar-grande"><%= inicial %></div>
        <div class="perfil-nome"><%= usuarioLogado.getNome() %></div>
        <span class="perfil-tipo"><%= tipoUsuarioStr %></span>

        <div class="dados-lista">
            <div class="dado-item">
                <div class="dado-label">Nome Completo</div>
                <div class="dado-valor"><%= usuarioLogado.getNome() %></div>
            </div>
            <div class="dado-item">
                <div class="dado-label">E-mail Institucional</div>
                <div class="dado-valor"><%= usuarioLogado.getEmail() %></div>
            </div>
            <div class="dado-item" style="border-bottom: none; padding-bottom: 0;">
                <div class="dado-label">Perfil de Acesso</div>
                <div class="dado-valor"><%= tipoUsuarioStr %></div>
            </div>
        </div>

        <div class="resumo-projetos">
            <% if (isAdmin) { %>
                Responsável por acompanhar <strong><%= totalProjetos %></strong> projeto(s) cadastrados no sistema.
            <% } else { %>
                Coordenador de <strong><%= totalProjetos %></strong> projeto(s).
            <% } %>
        </div>
    </div>

</div>
</body>
</html>