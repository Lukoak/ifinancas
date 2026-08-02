package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.StatusUsuario;
import model.usuario;
import util.conexao;


public class usuarioDAO {

    public usuario autenticar(String identifier, String password) {
        String consulta = "SELECT u.* " +
                     "FROM usuario u " +
                     "WHERE u.email = ? AND u.senha_hash = ? AND u.status_usuario = 'Ativo'";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            
            stmt.setString(1, identifier);
            stmt.setString(2, password);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new usuario(
                        rs.getInt("id"),
                        rs.getString("nome"),
                        rs.getString("email"),
                        rs.getString("senha_hash"),
                        StatusUsuario.valueOf(rs.getString("status_usuario"))
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
	
    public boolean cadastrar(String nome, String email, String senha_hash) {
        String sql = "INSERT INTO usuario (nome, email, senha_hash) VALUES (?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, nome);
            stmt.setString(2, email);
            stmt.setString(3, senha_hash);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    
    
    
}
