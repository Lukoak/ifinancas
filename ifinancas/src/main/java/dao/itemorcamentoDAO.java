package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.conexao;

public class itemorcamentoDAO {

    public boolean inserir(int macroetapaId, int fkItemId, int financiadorId, double quantidade, int meses, double valorUnitario) {
        String sql = "INSERT INTO item_orcamento (macroetapa_id, fk_item_id, financiador_id, quantidade, meses, valor_unitario, valor_total) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        double valorTotal = quantidade * meses * valorUnitario;

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, macroetapaId);
            stmt.setInt(2, fkItemId);
            stmt.setInt(3, financiadorId);
            stmt.setDouble(4, quantidade);
            stmt.setInt(5, meses);
            stmt.setDouble(6, valorUnitario);
            stmt.setDouble(7, valorTotal);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizar(int id, double quantidade, int meses, double valorUnitario) {
        String sql = "UPDATE item_orcamento SET quantidade = ?, meses = ?, valor_unitario = ?, valor_total = ? WHERE id = ?";
        double valorTotal = quantidade * meses * valorUnitario;

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setDouble(1, quantidade);
            stmt.setInt(2, meses);
            stmt.setDouble(3, valorUnitario);
            stmt.setDouble(4, valorTotal);
            stmt.setInt(5, id);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM item_orcamento WHERE id = ?";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double calcularTotalProjeto(int projetoId) {
        String sql = "SELECT SUM(io.valor_total) AS total " +
                     "FROM item_orcamento io " +
                     "INNER JOIN macroetapa m ON io.macroetapa_id = m.id " +
                     "WHERE m.projeto_id = ?";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projetoId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }
}