<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recuperar Senha - IFINANCE</title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', 'Segoe UI', Arial, sans-serif; margin: 0; padding: 0; }
        body { background-color: #f4f6f9; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .card-recovery { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); max-width: 450px; width: 90%; text-align: center; }
        .card-recovery h2 { color: #1d3c25; font-size: 24px; font-weight: 700; margin-bottom: 12px; }
        .card-recovery p { color: #6c757d; font-size: 14px; line-height: 1.5; margin-bottom: 25px; }
        .aviso-sucesso { background-color: #e1f2e5; color: #1d3c25; padding: 14px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; margin-bottom: 25px; text-align: left; }
        .form-group { text-align: left; margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #333; margin-bottom: 8px; }
        .form-control { width: 100%; padding: 12px 16px; border: 1px solid #e2e8f0; border-radius: 8px; font-size: 14px; background-color: #f8f9fa; transition: all 0.2s ease; }
        .form-control:focus { outline: none; border-color: #3e863e; background-color: white; box-shadow: 0 0 0 3px rgba(62, 134, 62, 0.1); }
        .btn-submit { width: 100%; padding: 14px; background-color: #1d3c25; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 700; cursor: pointer; transition: all 0.2s ease; margin-bottom: 20px; }
        .btn-submit:hover { background-color: #3e863e; transform: translateY(-1px); }
        .back-link { display: inline-block; color: #6c757d; text-decoration: none; font-size: 13px; font-weight: 500; transition: color 0.2s ease; }
        .back-link:hover { color: #1d3c25; text-decoration: underline; }
    </style>
</head>
<body>

    <div class="card-recovery">
        <h2>Recuperar Senha</h2>
        <p>Insira o e-mail cadastrado no sistema para receber as instruções de recuperação.</p>

        <% if ("1".equals(request.getParameter("enviado"))) { %>
            <div class="aviso-sucesso">
                Se esse e-mail estiver cadastrado no sistema, enviamos as instruções de recuperação para ele. Confira sua caixa de entrada (e o spam).
            </div>
        <% } %>

        <form action="../UsuarioController" method="POST">
            <input type="hidden" name="acao" value="recuperarSenha">
            <div class="form-group">
                <label for="email">E-mail Institucional</label>
                <input type="email" id="email" name="email" class="form-control" placeholder="coordenador@ifba.edu.br" required>
            </div>

            <button type="submit" class="btn-submit">Enviar Instruções</button>
        </form>

        <a href="${pageContext.request.contextPath}/Tela_Login.jsp" class="back-link">← Voltar para o Login</a>
    </div>

</body>
</html>