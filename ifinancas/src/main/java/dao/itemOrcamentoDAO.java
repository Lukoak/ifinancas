package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.ItemOrcamento;
import util.conexao;

public class itemOrcamentoDAO {

    public boolean inserir(ItemOrcamento item) {
        String sql = "INSERT INTO item_orcamento (macroetapa_id, fk_item_id, financiador_id, quantidade, valor_unitario) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, item.getMacroetapaId());
            stmt.setInt(2, item.getFkItemId());
            stmt.setInt(3, item.getFinanciadorId());
            stmt.setBigDecimal(4, item.getQuantidade());
            stmt.setBigDecimal(5, item.getValorUnitario());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM item_orcamento WHERE id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ItemOrcamento> listarPorMacroetapa(int macroetapaId) {
        List<ItemOrcamento> lista = new ArrayList<>();
        String sql = "SELECT * FROM view_item_orcamento WHERE macroetapa_id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, macroetapaId);
            try (ResultSet rs = stmt.executeQuery()) {
                while(rs.next()) {
                    ItemOrcamento io = new ItemOrcamento();
                    io.setId(rs.getInt("id"));
                    io.setMacroetapaId(rs.getInt("macroetapa_id"));
                    io.setFkItemId(rs.getInt("fk_item_id"));
                    io.setFinanciadorId(rs.getInt("financiador_id"));
                    io.setQuantidade(rs.getBigDecimal("quantidade"));
                    io.setValorUnitario(rs.getBigDecimal("valor_unitario"));
                    io.setValorTotal(rs.getBigDecimal("valor_total"));
                    lista.add(io);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public BigDecimal calcularTotalProjeto(int projetoId) {
        String sql = "SELECT COALESCE(SUM(quantidade * valor_unitario), 0) AS total FROM item_orcamento io JOIN macroetapa m ON io.macroetapa_id = m.id WHERE m.projeto_id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projetoId);
            try(ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }

    public BigDecimal calcularTotalPorFinanciador(int projetoId, int financiadorId) {
        String sql = "SELECT COALESCE(SUM(io.quantidade * io.valor_unitario), 0) AS total FROM item_orcamento io JOIN macroetapa m ON io.macroetapa_id = m.id WHERE m.projeto_id = ? AND io.financiador_id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projetoId);
            stmt.setInt(2, financiadorId);
            try(ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return BigDecimal.ZERO;
    }
}