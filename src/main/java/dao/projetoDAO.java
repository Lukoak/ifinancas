package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Projeto;
import model.StatusProjeto;
import util.conexao;

public class projetoDAO {

    public boolean inserir(Projeto p) {
        String sql = "INSERT INTO projeto (coordenador_id, titulo, descricao, status_projeto) VALUES (?, ?, ?, 'PENDENTE')";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getCoordenadorId());
            stmt.setString(2, p.getTitulo());
            stmt.setString(3, p.getDescricao());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean atualizarStatus(int id, StatusProjeto status) {
        String sql = "UPDATE projeto SET status_projeto = ? WHERE id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status.name());
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean solicitarFinalizacao(int id, String justificativa) {
        String sql = "UPDATE projeto SET solicitacao_finalizacao = true, justificativa_finalizacao = ? WHERE id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, justificativa);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletar(int id) {
        String sql = "DELETE FROM projeto WHERE id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Projeto> listarTodos() {
        List<Projeto> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.nome AS nome_coordenador FROM projeto p INNER JOIN usuario u ON p.coordenador_id = u.id ORDER BY p.id DESC";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                lista.add(montarObjeto(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Projeto> listarPorCoordenador(int coordenadorId) {
        List<Projeto> lista = new ArrayList<>();
        String sql = "SELECT p.*, u.nome AS nome_coordenador FROM projeto p INNER JOIN usuario u ON p.coordenador_id = u.id WHERE p.coordenador_id = ? ORDER BY p.id DESC";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, coordenadorId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    lista.add(montarObjeto(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Projeto buscarPorId(int id) {
        String sql = "SELECT p.*, u.nome AS nome_coordenador FROM projeto p INNER JOIN usuario u ON p.coordenador_id = u.id WHERE p.id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return montarObjeto(rs);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Projeto montarObjeto(ResultSet rs) throws SQLException {
        Projeto p = new Projeto();
        p.setId(rs.getInt("id"));
        p.setCoordenadorId(rs.getInt("coordenador_id"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescricao(rs.getString("descricao"));
        p.setStatusProjeto(StatusProjeto.valueOf(rs.getString("status_projeto")));
        p.setSolicitacaoFinalizacao(rs.getBoolean("solicitacao_finalizacao"));
        p.setJustificativaFinalizacao(rs.getString("justificativa_finalizacao"));
        
        p.setNomeCoordenador(rs.getString("nome_coordenador"));
        
        return p;
    }
}