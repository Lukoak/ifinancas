package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.StatusUsuario;
import model.usuario;
import util.conexao;


public class usuarioDAO {

    public usuario autenticar(usuario identifier, usuario password) {
        String consulta = "SELECT u.* " +
                     "FROM usuario u " +
                     "WHERE u.email = ? AND u.senha_hash = ? AND u.status_usuario = 'Ativo'";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(consulta)) {
            
            stmt.setString(1, identifier.getemail());
            stmt.setString(2, password.getsenha_hash());
            
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
	
    public boolean cadastrar(usuario nome, usuario email, usuario senha_hash) {
        String inserir = "INSERT INTO usuario (nome, email, senha_hash) VALUES (?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(inserir)) {
            
            stmt.setString(1, nome.getnome());
            stmt.setString(2, email.getemail());
            stmt.setString(3, senha_hash.getsenha_hash());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
    
    public boolean ajustarpefildeacesso(int id, int perfil_id)
    {
    	String ajusteacesso = "UPDATE usuario SET perfil_id = ? WHERE id = ?";
    	
    	try(Connection conn = conexao.getConexao();
    			PreparedStatement stmt = conn.prepareStatement(ajusteacesso)){
    		stmt.setInt(1, id);
    		stmt.setInt(1, perfil_id);
    		
    		return stmt.executeUpdate() > 0;
    		
    	} catch (SQLException e)
    	{
    		e.printStackTrace();
    		return false;
    	}
    }
    
}
