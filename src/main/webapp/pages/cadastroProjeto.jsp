<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Financiador" %>
<%@ page import="dao.financiadorDAO" %>
<%@ page import="java.util.List" %>
<%
    Usuario usuarioLogado = (Usuario) session.getAttribute("usuarioLogado");
    if (usuarioLogado == null) {
        response.sendRedirect("../Tela_Login.jsp");
        return;
    }
    
    financiadorDAO fDao = new financiadorDAO();
    List<Financiador> listaFinanciadores = fDao.listarTodos();
    
    String inicial = (usuarioLogado.getNome() != null && !usuarioLogado.getNome().isEmpty()) 
                     ? usuarioLogado.getNome().substring(0, 1).toUpperCase() : "?";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Solicitar Novo Projeto - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; height: 100vh; overflow: hidden; }
        .sidebar { width: 260px; background-color: #1d3c25; color: white; display: flex; flex-direction: column; justify-content: space-between; padding: 20px 0; }
        .sidebar-top { padding: 0 20px; }
        .logo-box { display: flex; align-items: center; justify-content: center; gap: 10px; margin-bottom: 35px; padding: 5px 0; }
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
        .main-content { flex: 1; display: flex; flex-direction: column; overflow-y: auto; }
        .top-bar { background-color: white; padding: 15px 30px; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
        .top-bar h1 { font-size: 22px; color: #333; font-weight: 600; }
        .container { padding: 30px; max-width: 900px; width: 100%; margin: 0 auto; }
        .form-card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.03); }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 14px; font-weight: 600; color: #1d3c25; margin-bottom: 8px; }
        .form-row { display: flex; gap: 20px; }
        .form-row .form-group { flex: 1; }
        input[type="text"], input[type="date"], input[type="number"], textarea, select { width: 100%; padding: 12px 15px; border: 1px solid #e2e8f0; border-radius: 6px; font-size: 14px; background-color: #f8fafc; font-weight: 500; transition: all 0.2s; }
        input:focus, textarea:focus, select:focus { border-color: #3e863e; background-color: white; outline: none; box-shadow: 0 0 0 4px rgba(62, 134, 62, 0.1); }
        small { display: block; margin-top: 6px; font-size: 12px; color: #6c757d; }
        .checklist { display: flex; flex-direction: column; gap: 12px; padding: 12px 15px; border: 1px solid #e2e8f0; border-radius: 6px; background-color: #f8fafc; }
        .financiador-linha { display: flex; flex-direction: column; gap: 8px; }
        .checklist label { display: flex; align-items: center; gap: 10px; font-size: 14px; font-weight: 500; color: #333; margin: 0; cursor: pointer; }
        .checklist input[type="checkbox"] { width: auto; }
        .valor-financiador { margin-left: 4px; width: calc(100% - 4px); }
        .valor-financiador:disabled { background-color: #edf1f4; color: #a0aec0; }
        .info-coordenador { background-color: #e1f2e5; color: #1d3c25; padding: 12px 15px; border-radius: 6px; font-size: 13px; font-weight: 600; margin-bottom: 20px; }
        .btn-container { display: flex; gap: 15px; margin-top: 25px; }
        .btn-submit { flex: 1; padding: 14px; background-color: #1d3c25; color: white; border: none; border-radius: 6px; font-weight: 700; cursor: pointer; font-size: 15px; }
        .btn-submit:hover { background-color: #275232; }
        .btn-cancel { padding: 14px 25px; background-color: transparent; border: 1px solid #dc3545; color: #dc3545; border-radius: 6px; font-weight: 600; text-decoration: none; font-size: 14px; text-align: center; }
        .btn-cancel:hover { background-color: #dc3545; color: white; }
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
            <h1>Solicitar Novo Projeto</h1>
        </div>

        <div class="container">
            <div class="form-card">
                <div class="info-coordenador">Coordenador responsável: <%= usuarioLogado.getNome() %></div>

                <% if ("1".equals(request.getParameter("erro"))) { %>
                    <div style="color: #ac1412; margin-bottom:15px; font-weight:bold;">Ocorreu um erro ao salvar o projeto. Tente novamente.</div>
                <% } %>

                <form action="../ProjetoController" method="POST">
                    <input type="hidden" name="acao" value="salvar">

                    <div class="form-group">
                        <label>Título do Projeto</label>
                        <input type="text" name="titulo" placeholder="Digite o nome principal do projeto" required>
                    </div>

                    <div class="form-group">
                        <label>Breve Descrição / Objetivo</label>
                        <textarea name="descricao" rows="3" placeholder="Descreva a finalidade deste projeto" required></textarea>
                    </div>

                    <div class="form-group">
                        <label>Financiadores</label>
                        <div class="checklist">
                            <% 
                            if (listaFinanciadores.isEmpty()) { 
                            %>
                                <span style="font-size:13px; color:#718096;">Nenhum financiador cadastrado no banco.</span>
                            <% 
                            } else {
                                for (Financiador f : listaFinanciadores) { 
                            %>
                                <div class="financiador-linha">
                                    <label>
                                        <input type="checkbox" name="financiadorId" value="<%= f.getId() %>" onchange="alternarValorFinanciador('<%= f.getId() %>', this.checked)">
                                        <%= f.getNome() %>
                                    </label>
                                    <input type="number" step="0.01" name="valorFinanciador_<%= f.getId() %>" id="valor_<%= f.getId() %>" class="valor-financiador" placeholder="Valor fornecido (R$)" disabled>
                                </div>
                            <% 
                                } 
                            } 
                            %>
                        </div>
                        <small>Você pode definir o valor como 0.00 caso ainda não saiba o limite exato, e alterá-lo depois no orçamento.</small>
                    </div>

                    <div class="form-group">
                        <label>Quantidade de Macroetapas</label>
                        <input type="number" name="macroetapas" min="1" max="10" value="1" required>
                        <small>Máximo de 10 macroetapas. As macroetapas serão geradas automaticamente e poderão ser ajustadas em "Gerenciar Orçamento".</small>
                    </div>

                    <div class="btn-container">
                        <a href="listaProjetos.jsp" class="btn-cancel">Voltar para a Lista</a>
                        <button type="submit" class="btn-submit">Solicitar Projeto</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function alternarValorFinanciador(id, marcado) {
            var campo = document.getElementById('valor_' + id);
            if (campo) {
                campo.disabled = !marcado;
                campo.required = marcado;
                if (marcado && campo.value === '') {
                    campo.value = '0.00';
                } else if (!marcado) {
                    campo.value = '';
                }
            }
        }
    </script>
</body>
</html>