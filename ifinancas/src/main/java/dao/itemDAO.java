package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.item;
import util.conexao;

public class itemDAO {

	public boolean insere_item(String nome, Boolean status)
	{
		String inserir = "INSERT INTO item(nome, ativo) VALUES (?,?) ";
		
		try (Connection conn = conexao.getConexao();
			PreparedStatement stmt = conn.prepareStatement(inserir)) {
            
            stmt.setString(1, nome);
            stmt.setBoolean(2, status);
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
		
	}
	
}
