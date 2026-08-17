<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; }
        body { margin: 0; padding: 0; height: 100vh; overflow: hidden; background-color: #f8fafc; display: flex; }
        .split-container { display: flex; width: 100%; height: 100%; }
        .brand-side {
            flex: 1.2; background: linear-gradient(135deg, #f4f6f9 0%, #e2e8f0 100%); color: #1d3c25;
            padding: 50px; text-align: center; position: relative; z-index: 2; display: flex;
            flex-direction: column; justify-content: center; align-items: center; box-shadow: 5px 0 25px rgba(0,0,0,0.05);
        }
        .brand-side img {
            max-width: 525px; height: auto; margin-bottom: 15px; filter: drop-shadow(0px 8px 15px rgba(0,0,0,0.12));
            transition: transform 0.5s ease;
        }
        .brand-side img:hover { transform: scale(1.02); }
        .brand-side p { margin-top: 15px; max-width: 420px; font-size: 16px; font-weight: 500; line-height: 1.6; color: #1d3c25; }
        .form-side { flex: 1; background-color: #ffffff; padding: 40px; position: relative; z-index: 1; display: flex; justify-content: center; align-items: center; }
        .login-box { width: 100%; max-width: 380px; }
        .login-box h2 { margin-bottom: 6px; font-size: 30px; font-weight: 700; text-align: left; color: #1d3c25; }
        .login-box .subtitle { margin-bottom: 35px; font-size: 14px; font-weight: 500; text-align: left; color: #64748b; }
        .input-group { position: relative; margin-bottom: 18px; }
        input[name="email"], input[name="senha"] {
            width: 100%; padding: 16px 18px; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 15px; font-weight: 500; color: #1e293b; background-color: #f8fafc; transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }
        input:focus { border-color: #3e863e; background-color: #ffffff; outline: none; box-shadow: 0 0 0 4px rgba(62, 134, 62, 0.12), 0 1px 2px rgba(0,0,0,0.05); }
        .btn-primary {
            width: 100%; margin-top: 15px; padding: 16px; border: none; border-radius: 10px; background-color: #1d3c25; color: white; font-size: 16px; font-weight: 700; letter-spacing: 0.5px; cursor: pointer; box-shadow: 0 4px 12px rgba(29, 60, 37, 0.2); transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .btn-primary:hover { background-color: #275232; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(29, 60, 37, 0.3); }
        .btn-secondary {
            display: block; width: 100%; margin-top: 15px; padding: 14px; border: 2px solid #1d3c25; border-radius: 10px; background-color: transparent; color: #1d3c25; font-weight: 700; text-decoration: none; text-align: center; transition: all 0.2s ease;
        }
        .btn-secondary:hover { background-color: #1d3c25; color: white; box-shadow: 0 4px 12px rgba(29, 60, 37, 0.15); }
        .utilities-container { display: flex; justify-content: flex-end; margin-top: -4px; margin-bottom: 20px; }
        .forgot-link { font-size: 13px; font-weight: 600; color: #de532b; text-decoration: none; transition: color 0.2s; }
        .forgot-link:hover { color: #ac1412; text-decoration: underline; }
        .create-account-box { margin-top: 35px; padding-top: 25px; border-top: 1px solid #f1f5f9; text-align: center; font-size: 14px; font-weight: 500; color: #64748b; }
        .error-msg { margin-bottom: 25px; padding: 14px 18px; border: none; border-radius: 10px; background-color: #ac1412; color: #ffffff; font-size: 13px; font-weight: 600; text-align: left; box-shadow: 0 4px 12px rgba(172, 20, 18, 0.2); animation: shake 0.4s ease-in-out; }
        @keyframes shake { 0%, 100% { transform: translateX(0); } 25% { transform: translateX(-4px); } 75% { transform: translateX(4px); } }
    </style>
</head>
<body>
<div class="split-container">
    <div class="brand-side">
        <img src="${pageContext.request.contextPath}/images/IFINANCE%20color%20png.png?v=1" alt="Logo IFINANCAS">
        <p>Sistema digital de planejamento e controle orçamentário institucional.</p>
    </div>
    <div class="form-side">
        <div class="login-box">
            <h2>Acessar Sistema</h2>
            <div class="subtitle">Insira seus dados institucionais para continuar.</div>

            <% if ("1".equals(request.getParameter("erro"))) { %>
                <div class="error-msg">Ops! E-mail ou senha incorretos. Tente novamente.</div>
            <% } else if ("1".equals(request.getParameter("sucesso"))) { %>
                <div class="error-msg" style="background-color: #22543d;">Cadastro realizado com sucesso! Faça login.</div>
            <% } %>

            <form action="UsuarioController" method="POST">
                <input type="hidden" name="acao" value="login">
                <div class="input-group">
                    <input type="email" name="email" placeholder="E-mail" required>
                </div>
                <div class="input-group">
                    <input type="password" name="senha" placeholder="Senha" required>
                </div>
                <div class="utilities-container">
                    <a href="pages/esqueceuSenha.jsp" class="forgot-link">Esqueceu a senha?</a>
                </div>
                <button type="submit" class="btn-primary">Entrar no Painel</button>
            </form>

            <div class="create-account-box">
                Ainda não possui acesso? <a href="pages/cadastroUsuario.jsp" class="btn-secondary">Criar Conta</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>