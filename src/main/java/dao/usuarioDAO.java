package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.StatusUsuario;
import model.Usuario;
import util.conexao;

public class usuarioDAO {

    public Usuario autenticar(String email, String senhaHash) {
        String consulta = "SELECT u.* FROM usuario u WHERE u.email = ? AND u.senha_hash = ? AND u.status_usuario = 'ATIVO'";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            
            stmt.setString(1, email);
            stmt.setString(2, senhaHash);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setPerfilId(rs.getInt("perfil_id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setSenhaHash(rs.getString("senha_hash"));
                    
                    String statusBanco = rs.getString("status_usuario");
                    if (statusBanco != null) {
                        u.setStatusUsuario(StatusUsuario.valueOf(statusBanco.toUpperCase()));
                    }
                    return u;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean cadastrar(Usuario usuario) {
        String inserir = "INSERT INTO usuario (nome, email, senha_hash) VALUES (?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(inserir)) {
            
            stmt.setString(1, usuario.getNome());
            stmt.setString(2, usuario.getEmail());
            stmt.setString(3, usuario.getSenhaHash());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existeEmail(String email) {
        String consulta = "SELECT id FROM usuario WHERE email = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next(); 
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean alterarStatus(int id, StatusUsuario novoStatus) {
        String atualizar = "UPDATE usuario SET status_usuario = ? WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(atualizar)) {
            
            stmt.setString(1, novoStatus.name());
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean ajustarPerfilDeAcesso(int id, int perfilId) {
        String ajusteAcesso = "UPDATE usuario SET perfil_id = ? WHERE id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(ajusteAcesso)) {
            
            stmt.setInt(1, perfilId); 
            stmt.setInt(2, id); 
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Usuario> listarPorPerfil(int perfilId) {
        List<Usuario> lista = new ArrayList<>();
        String consulta = "SELECT * FROM usuario WHERE perfil_id = ?";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            
            stmt.setInt(1, perfilId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Usuario u = new Usuario();
                    u.setId(rs.getInt("id"));
                    u.setPerfilId(rs.getInt("perfil_id"));
                    u.setNome(rs.getString("nome"));
                    u.setEmail(rs.getString("email"));
                    u.setSenhaHash(rs.getString("senha_hash"));
                    
                    String statusBanco = rs.getString("status_usuario");
                    if (statusBanco != null) {
                        u.setStatusUsuario(StatusUsuario.valueOf(statusBanco.toUpperCase()));
                    }
                    lista.add(u);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}