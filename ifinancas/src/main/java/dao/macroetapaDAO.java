package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Macroetapa;
import util.conexao;

public class macroetapaDAO {

     public boolean inserirEmLote(List<Macroetapa> macroetapas) {
        String sql = "INSERT INTO macroetapa (projeto_id, numero, descricao, duracao) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
             conn.setAutoCommit(false);
            
            for (Macroetapa m : macroetapas) {
                stmt.setInt(1, m.getProjetoId());
                stmt.setString(2, m.getNumero());
                stmt.setString(3, m.getDescricao());
                stmt.setInt(4, m.getDuracao());
                stmt.addBatch();
            }
            
            int[] resultados = stmt.executeBatch(); 
            conn.commit(); 
            
            return resultados.length == macroetapas.size();
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

     public boolean inserir(Macroetapa m) {
        String sql = "INSERT INTO macroetapa (projeto_id, numero, descricao, duracao) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, m.getProjetoId());
            stmt.setString(2, m.getNumero());
            stmt.setString(3, m.getDescricao());
            stmt.setInt(4, m.getDuracao());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

     public List<Macroetapa> listarPorProjeto(int projetoId) {
        List<Macroetapa> lista = new ArrayList<>();
         String sql = "SELECT * FROM macroetapa WHERE projeto_id = ? ORDER BY id ASC";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, projetoId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(montarObjeto(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

     public boolean atualizarDuracaoENome(int id, int novaDuracao, String novoNome) {
        String sql = "UPDATE macroetapa SET duracao = ?, descricao = ? WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, novaDuracao);
            stmt.setString(2, novoNome);
            stmt.setInt(3, id);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

     public boolean deletar(int id) {
        String sql = "DELETE FROM macroetapa WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
 
    private Macroetapa montarObjeto(ResultSet rs) throws SQLException {
        Macroetapa m = new Macroetapa();
        m.setId(rs.getInt("id"));
        m.setProjetoId(rs.getInt("projeto_id"));
        m.setNumero(rs.getString("numero"));
        m.setDescricao(rs.getString("descricao"));
        m.setDuracao(rs.getInt("duracao"));
        return m;
    }
}