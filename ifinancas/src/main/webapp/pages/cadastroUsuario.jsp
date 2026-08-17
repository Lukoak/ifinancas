<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Criar Conta - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; }
        body { margin: 0; padding: 20px; min-height: 100vh; background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; }
        .register-card { width: 100%; max-width: 480px; padding: 40px; background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08); }
        .logo-box { text-align: center; margin-bottom: 20px; }
        .logo-box img { max-width: 220px; height: auto; filter: drop-shadow(0px 4px 10px rgba(0, 0, 0, 0.10)); }
        .register-card h2 { margin: 0 0 8px 0; font-size: 26px; font-weight: 700; text-align: center; color: #1d3c25; }
        .register-card .subtitle { margin-bottom: 25px; font-size: 15px; text-align: center; color: #6c757d; }
        .badge-container { text-align: center; }
        .profile-badge { display: inline-block; margin-bottom: 20px; padding: 4px 10px; border-radius: 20px; background-color: #e1f2e5; color: #1d3c25; font-size: 12px; font-weight: 700; }
        .form-group { margin-bottom: 18px; }
        label { display: block; margin-bottom: 6px; font-size: 14px; font-weight: 600; color: #333; }
        input[type="text"], input[type="email"], input[type="password"] { width: 100%; padding: 14px; border: 1px solid #ced4da; border-radius: 8px; font-size: 15px; background-color: #f8f9fa; transition: all 0.3s ease; }
        input:focus { border-color: #3e863e; background-color: #ffffff; outline: none; box-shadow: 0 0 0 4px rgba(62, 134, 62, 0.15); }
        .btn-primary { width: 100%; margin-top: 15px; padding: 16px; border: none; border-radius: 8px; background-color: #1d3c25; color: white; font-size: 16px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 10px rgba(29, 60, 37, 0.2); transition: all 0.3s ease; }
        .btn-primary:hover { background-color: #3e863e; transform: translateY(-2px); box-shadow: 0 6px 15px rgba(29, 60, 37, 0.3); }
        .footer-box { margin-top: 25px; padding-top: 20px; border-top: 1px solid #eee; text-align: center; font-size: 14px; color: #495057; }
        .login-link { color: #3e863e; font-weight: 700; text-decoration: none; }
        .login-link:hover { text-decoration: underline; }
        .erro-msg { margin-bottom: 20px; padding: 12px 16px; border-radius: 8px; background-color: #ac1412; color: white; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>
<div class="register-card">
    <div class="logo-box">
        <img src="${pageContext.request.contextPath}/images/IFINANCE%20color%20png.png?v=1" alt="Logo IFINANCE">
    </div>
    <h2>Criar Nova Conta</h2>
    <div class="subtitle">Cadastre seus dados para solicitar o perfil de acesso comum.</div>

    <% if ("email_duplicado".equals(request.getParameter("erro"))) { %>
        <div class="erro-msg">Já existe uma conta cadastrada com esse e-mail.</div>
    <% } else if ("1".equals(request.getParameter("erro"))) { %>
        <div class="erro-msg">Erro ao realizar cadastro. Tente novamente mais tarde.</div>
    <% } %>

    <div class="badge-container">
        <span class="profile-badge">Tipo de Conta: Usuário Padrão</span>
    </div>

    <form action="../UsuarioController" method="POST">
        <input type="hidden" name="acao" value="cadastrar">
        <div class="form-group">
            <label for="nome">Nome Completo:</label>
            <input type="text" id="nome" name="nome" placeholder="Seu nome completo" required>
        </div>
        <div class="form-group">
            <label for="email">E-mail Institucional:</label>
            <input type="email" id="email" name="email" placeholder="nome@institucional.com" required>
        </div>
        <div class="form-group">
            <label for="senha">Crie uma Senha:</label>
            <input type="password" id="senha" name="senha" placeholder="No mínimo 6 caracteres" required>
        </div>
        <button type="submit" class="btn-primary">Finalizar Cadastro</button>
    </form>
    <div class="footer-box">
        Já possui uma conta? <a href="../Tela_Login.jsp" class="login-link">Fazer Login</a>
    </div>
</div>
</body>
</html>