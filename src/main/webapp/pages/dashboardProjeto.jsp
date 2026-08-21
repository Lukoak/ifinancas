<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Usuario" %>
<%@ page import="model.Projeto" %>
<%@ page import="model.Macroetapa" %>
<%@ page import="model.ItemOrcamento" %>
<%@ page import="model.StatusProjeto" %>
<%@ page import="model.ProjetoFinanciador" %>
<%@ page import="model.Rubrica" %>
<%@ page import="dao.projetoDAO" %>
<%@ page import="dao.macroetapaDAO" %>
<%@ page import="dao.itemOrcamentoDAO" %>
<%@ page import="dao.projetoFinanciadorDAO" %>
<%@ page import="dao.rubricaDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
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
    projetoFinanciadorDAO pfDao = new projetoFinanciadorDAO();
    rubricaDAO rDao = new rubricaDAO();

    Projeto projeto = pDao.buscarPorId(idProjeto);
    if (projeto == null) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    // Só o próprio coordenador ou o ADMIN podem ver o dashboard do projeto.
    boolean podeVer = (usuarioLogado.getPerfilId() == 2) || (projeto.getCoordenadorId() == usuarioLogado.getId());
    if (!podeVer) {
        response.sendRedirect("listaProjetos.jsp");
        return;
    }

    String voltarPara = (usuarioLogado.getPerfilId() == 2) ? "listaProjetosAdmin.jsp" : "gerenciarOrcamento.jsp?id=" + projeto.getId();

    BigDecimal totalGeral = ioDao.calcularTotalProjeto(idProjeto);
    if (totalGeral == null) totalGeral = BigDecimal.ZERO;

    List<Macroetapa> macroetapas = mDao.listarPorProjeto(idProjeto);
    List<ProjetoFinanciador> financiadores = pfDao.listarPorProjeto(idProjeto);
    
    List<Rubrica> todasRubricas = rDao.listarTodos();
    Map<Integer, String> mapaRubricas = new HashMap<>();
    for (Rubrica r : todasRubricas) {
        mapaRubricas.put(r.getFkItem(), r.getCategoria() != null ? r.getCategoria().name().replace("_", " ") : "-");
    }

    Map<Integer, BigDecimal> totaisPorMacroetapa = new HashMap<>();
    Map<Integer, List<ItemOrcamento>> itensPorMacroetapa = new HashMap<>();
    for (Macroetapa m : macroetapas) {
        List<ItemOrcamento> itens = ioDao.listarPorMacroetapa(m.getId());
        itensPorMacroetapa.put(m.getId(), itens);
        
        BigDecimal totalM = BigDecimal.ZERO;
        for (ItemOrcamento io : itens) {
            if (io.getValorTotal() != null) totalM = totalM.add(io.getValorTotal());
        }
        totaisPorMacroetapa.put(m.getId(), totalM);
    }

    NumberFormat formatoMoeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - <%= projeto.getTitulo() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/ifinance-base.css" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
    <style>
        * { box-sizing: border-box; font-family: 'Montserrat', sans-serif; margin: 0; padding: 0; }
        body { background-color: #f7f8fa; padding: 40px; color: #1f2d24; }
        .container { max-width: 1100px; margin: 0 auto; }
        .topo { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
        .topo h1 { font-size: 19px; font-weight: 600; color: #1d3c25; }
        .topo p { font-size: 13px; color: #8a97a0; margin-top: 3px; }
        .btn-voltar { padding: 8px 16px; background: none; color: #1d3c25; border: 1px solid #dbe2e5; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 13px; }
        .btn-voltar:hover { border-color: #1d3c25; }
        .resumo-cards { display: flex; gap: 16px; margin-bottom: 30px; }
        .resumo-card { flex: 1; background: white; border-radius: 8px; padding: 16px 18px; border: 1px solid #edf0f2; }
        .resumo-card .titulo { font-size: 11px; text-transform: uppercase; color: #a3adb3; font-weight: 600; letter-spacing: 0.4px; }
        .resumo-card .valor { font-size: 19px; font-weight: 700; color: #1d3c25; margin-top: 5px; }
        .secao-titulo { font-size: 13px; font-weight: 700; color: #8a97a0; text-transform: uppercase; letter-spacing: 0.5px; margin: 30px 0 14px; }
        .graficos-gerais { display: flex; gap: 16px; }
        .grafico-card { flex: 1; background: white; border-radius: 8px; padding: 18px 20px; border: 1px solid #edf0f2; }
        .grafico-card h3 { font-size: 13px; font-weight: 600; color: #4a5568; margin-bottom: 14px; }
        .grafico-wrap { max-width: 220px; margin: 0 auto; }
        .grafico-vazio { color: #c2c9cd; font-style: italic; font-size: 12px; text-align: center; padding: 50px 0; }
        .macroetapas-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; }
        .macroetapa-mini-card { background: white; border-radius: 8px; padding: 16px 18px; border: 1px solid #edf0f2; }
        .macroetapa-mini-card h4 { font-size: 13px; font-weight: 600; color: #1d3c25; margin-bottom: 3px; }
        .macroetapa-mini-card .total { font-size: 12px; color: #8a97a0; margin-bottom: 12px; }
        .grafico-mini-wrap { max-width: 150px; margin: 0 auto; }
    </style>
</head>
<body>
<div class="container">

    <div class="topo">
        <div>
            <h1><%= projeto.getTitulo() %></h1>
            <p>Dashboard do projeto</p>
        </div>
        <a href="<%= voltarPara %>" class="btn-voltar">Voltar</a>
    </div>

    <div class="resumo-cards">
        <div class="resumo-card">
            <div class="titulo">Total Geral</div>
            <div class="valor"><%= formatoMoeda.format(totalGeral) %></div>
        </div>
        <div class="resumo-card">
            <div class="titulo">Macroetapas</div>
            <div class="valor"><%= macroetapas.size() %></div>
        </div>
        <div class="resumo-card">
            <div class="titulo">Financiadores</div>
            <div class="valor"><%= financiadores.size() %></div>
        </div>
    </div>

    <div class="secao-titulo">Visão Geral do Projeto</div>
    <div class="graficos-gerais">
        <div class="grafico-card">
            <h3>Gastos por Macroetapa</h3>
            <% if (totalGeral.compareTo(BigDecimal.ZERO) == 0) { %>
                <div class="grafico-vazio">Sem itens cadastrados ainda.</div>
            <% } else { %>
                <div class="grafico-wrap"><canvas id="graficoMacroetapas"></canvas></div>
            <% } %>
        </div>
        <div class="grafico-card">
            <h3>Participação dos Financiadores</h3>
            <% if (financiadores.isEmpty()) { %>
                <div class="grafico-vazio">Nenhum financiador vinculado.</div>
            <% } else { %>
                <div class="grafico-wrap"><canvas id="graficoFinanciadores"></canvas></div>
            <% } %>
        </div>
    </div>

    <div class="secao-titulo">Gastos por Rubrica em Cada Macroetapa</div>
    <div class="macroetapas-grid">
        <% for (Macroetapa m : macroetapas) { 
            BigDecimal totalM = totaisPorMacroetapa.get(m.getId());
            List<ItemOrcamento> itens = itensPorMacroetapa.get(m.getId());
        %>
            <div class="macroetapa-mini-card">
                <h4><%= m.getDescricao() %></h4>
                <div class="total"><%= formatoMoeda.format(totalM) %></div>
                <% if (itens == null || itens.isEmpty()) { %>
                    <div class="grafico-vazio">Sem itens.</div>
                <% } else { %>
                    <div class="grafico-mini-wrap"><canvas id="graficoMacro<%= m.getId() %>"></canvas></div>
                <% } %>
            </div>
        <% } %>
    </div>

</div>

<script>
    var CORES = ['#1d3c25', '#3e863e', '#7da085', '#c9a96e', '#a3adb3', '#6c757d'];
    
    // Objeto Tooltip genérico para formatar Reais (R$) e a Porcentagem (%) no Chart.js
    var tooltipsConfig = {
        callbacks: {
            label: function(context) {
                let label = context.label || '';
                let value = parseFloat(context.raw) || 0;
                let dataset = context.chart.data.datasets[context.datasetIndex];
                let total = dataset.data.reduce((a, b) => parseFloat(a) + parseFloat(b), 0);
                let percentage = total > 0 ? Math.round((value / total) * 100) + '%' : '0%';
                return label + ': R$ ' + value.toLocaleString('pt-BR', {minimumFractionDigits: 2, maximumFractionDigits: 2}) + ' (' + percentage + ')';
            }
        }
    };

    <% if (totalGeral.compareTo(BigDecimal.ZERO) > 0) { %>
    new Chart(document.getElementById('graficoMacroetapas'), {
        type: 'doughnut',
        data: {
            labels: [ <% for (Macroetapa m : macroetapas) { %> "<%= m.getDescricao() %>", <% } %> ],
            datasets: [{
                data: [ <% for (Macroetapa m : macroetapas) { %> <%= totaisPorMacroetapa.get(m.getId()).toString() %>, <% } %> ],
                backgroundColor: CORES,
                borderWidth: 0
            }]
        },
        options: { plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 11 } } }, tooltip: tooltipsConfig } }
    });
    <% } %>

    <% if (!financiadores.isEmpty()) { %>
    new Chart(document.getElementById('graficoFinanciadores'), {
        type: 'doughnut',
        data: {
            labels: [ <% for (ProjetoFinanciador pf : financiadores) { %> "<%= pf.getNomeFinanciador().name() %>", <% } %> ],
            datasets: [{
                data: [ <% for (ProjetoFinanciador pf : financiadores) { %> <%= pf.getInvestimento().toString() %>, <% } %> ],
                backgroundColor: CORES,
                borderWidth: 0
            }]
        },
        options: { plugins: { legend: { position: 'bottom', labels: { boxWidth: 10, font: { size: 11 } } }, tooltip: tooltipsConfig } }
    });
    <% } %>

    <% 
    for (Macroetapa m : macroetapas) {
        List<ItemOrcamento> itens = itensPorMacroetapa.get(m.getId());
        if (itens == null || itens.isEmpty()) continue;
        
        LinkedHashMap<String, BigDecimal> porRubrica = new LinkedHashMap<>();
        for (ItemOrcamento item : itens) {
            String rubricaStr = mapaRubricas.getOrDefault(item.getFkItemId(), "Não definida");
            BigDecimal atual = porRubrica.getOrDefault(rubricaStr, BigDecimal.ZERO);
            if (item.getValorTotal() != null) {
                porRubrica.put(rubricaStr, atual.add(item.getValorTotal()));
            }
        }
    %>
    new Chart(document.getElementById('graficoMacro<%= m.getId() %>'), {
        type: 'doughnut',
        data: {
            labels: [ <% for (String rubrica : porRubrica.keySet()) { %> "<%= rubrica %>", <% } %> ],
            datasets: [{
                data: [ <% for (BigDecimal valor : porRubrica.values()) { %> <%= valor.toString() %>, <% } %> ],
                backgroundColor: CORES,
                borderWidth: 0
            }]
        },
        options: { plugins: { legend: { position: 'bottom', labels: { boxWidth: 8, font: { size: 9 } } }, tooltip: tooltipsConfig } }
    });
    <% } %>
</script>
</body>
</html>