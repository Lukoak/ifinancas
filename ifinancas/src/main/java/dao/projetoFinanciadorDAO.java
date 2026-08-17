package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ProjetoFinanciador;
import model.NomeFinanciador;
import util.conexao;

public class projetoFinanciadorDAO {

    public List<ProjetoFinanciador> listarPorProjeto(int projetoId) {
        List<ProjetoFinanciador> lista = new ArrayList<>();
        String sql = "SELECT pf.projeto_id, pf.financiador_id, pf.investimento, f.nome as nome_financiador " +
                     "FROM projeto_financiador pf " +
                     "JOIN financiador f ON pf.financiador_id = f.id " +
                     "WHERE pf.projeto_id = ?";
                     
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, projetoId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    ProjetoFinanciador pf = new ProjetoFinanciador();
                    pf.setProjetoId(rs.getInt("projeto_id"));
                    pf.setFinanciadorId(rs.getInt("financiador_id"));
                    pf.setInvestimento(rs.getBigDecimal("investimento"));
                    
                    String nomeBanco = rs.getString("nome_financiador");
                    if (nomeBanco != null) {
                        // Tratamento para evitar o erro do parênteses e espaços
                        if (nomeBanco.contains("FOMENTO")) {
                            pf.setNomeFinanciador(NomeFinanciador.FOMENTO);
                        } else {
                            pf.setNomeFinanciador(NomeFinanciador.valueOf(nomeBanco.toUpperCase()));
                        }
                    }
                    lista.add(pf);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
    
    public boolean inserir(ProjetoFinanciador pf) {
        String sql = "INSERT INTO projeto_financiador (projeto_id, financiador_id, investimento) VALUES (?, ?, ?)";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, pf.getProjetoId());
            stmt.setInt(2, pf.getFinanciadorId());
            stmt.setBigDecimal(3, pf.getInvestimento());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}