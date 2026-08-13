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

    // ===== 1. INSERIR PROJETO (Removida a coluna 'duracao' do INSERT) =====
    public boolean inserir(Projeto p) {
        String sql = "INSERT INTO projeto (coordenador_id, titulo, status_projeto, descricao) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, p.getCoordenadorId());
            stmt.setString(2, p.getTitulo());
            stmt.setString(3, p.getStatusProjeto().name());
            stmt.setString(4, p.getDescricao());
            
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }       
    }

    // ===== 2. LISTAR POR COORDENADOR (Com JOIN na view_duracao_projeto) =====
    public List<Projeto> listarPorCoordenador(int coordenadorId) {
        List<Projeto> lista = new ArrayList<>();
        String sql = "SELECT p.*, v.duracao_total as duracao " +
                     "FROM projeto p " +
                     "LEFT JOIN view_duracao_projeto v ON p.id = v.projeto_id " +
                     "WHERE p.coordenador_id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, coordenadorId);
            
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

    // ===== 3. LISTAR POR STATUS =====
    public List<Projeto> listarPorStatus(StatusProjeto status) {
        List<Projeto> lista = new ArrayList<>();
        String sql = "SELECT p.*, v.duracao_total as duracao " +
                     "FROM projeto p " +
                     "LEFT JOIN view_duracao_projeto v ON p.id = v.projeto_id " +
                     "WHERE p.status_projeto = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status.name());
            
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

    // ===== 4. LISTAR TODOS =====
    public List<Projeto> listarTodos() {
        List<Projeto> lista = new ArrayList<>();
        String sql = "SELECT p.*, v.duracao_total as duracao " +
                     "FROM projeto p " +
                     "LEFT JOIN view_duracao_projeto v ON p.id = v.projeto_id";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                lista.add(montarObjeto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    // ===== 5. BUSCAR POR ID =====
    public Projeto buscarPorId(int id) {
        String sql = "SELECT p.*, v.duracao_total as duracao " +
                     "FROM projeto p " +
                     "LEFT JOIN view_duracao_projeto v ON p.id = v.projeto_id " +
                     "WHERE p.id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return montarObjeto(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===== 6. ATUALIZAR STATUS =====
    public boolean atualizarStatus(int id, StatusProjeto novoStatus) {
        String sql = "UPDATE projeto SET status_projeto = ? WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus.name());
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // MÉTODO AUXILIAR
    // =========================================================
    private Projeto montarObjeto(ResultSet rs) throws SQLException {
        Projeto p = new Projeto();
        p.setId(rs.getInt("id"));
        p.setCoordenadorId(rs.getInt("coordenador_id"));
        p.setTitulo(rs.getString("titulo"));
        p.setDescricao(rs.getString("descricao"));
        p.setDuracao(rs.getInt("duracao")); // Pegando a duração gerada pela View
        
        String statusBanco = rs.getString("status_projeto");
        if (statusBanco != null) {
            p.setStatusProjeto(StatusProjeto.valueOf(statusBanco.toUpperCase()));
        }
        return p;
    }
}