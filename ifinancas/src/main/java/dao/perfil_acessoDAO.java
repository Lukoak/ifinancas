package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.PerfilAcesso;
import model.PerfilNome;
import util.conexao;

public class perfil_acessoDAO {

    public boolean inserir(PerfilAcesso perfil) {
        String inserir = "INSERT INTO perfil_acesso (nome) VALUES (?)";

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(inserir)) {

            stmt.setString(1, perfil.getNome().name());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public PerfilAcesso buscarPorId(int id) {
        String sql = "SELECT * FROM perfil_acesso WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    PerfilAcesso p = new PerfilAcesso();
                    p.setId(rs.getInt("id"));
                    
                    String nomeBanco = rs.getString("nome");
                    if (nomeBanco != null) {
                        p.setNome(PerfilNome.valueOf(nomeBanco.toUpperCase()));
                    }
                    
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PerfilAcesso> listarTodos() {
        List<PerfilAcesso> lista = new ArrayList<>();
        String sql = "SELECT * FROM perfil_acesso";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                PerfilAcesso p = new PerfilAcesso();
                p.setId(rs.getInt("id"));
                
                String nomeBanco = rs.getString("nome");
                if (nomeBanco != null) {
                    p.setNome(PerfilNome.valueOf(nomeBanco.toUpperCase()));
                }
                
                lista.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}