package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.projeto;
import util.conexao;

public class projetoDAO {
	
	public boolean insereprojeto(projeto p) {
		String inserir_projeto = "INSERT INTO projeto (coordenador_id, titulo, status_projeto, descricao) VALUES (?, ?, ?, ?)";
		
		try (Connection conn = conexao.getConexao();
			 PreparedStatement stmt = conn.prepareStatement(inserir_projeto)) {
			
			stmt.setInt(1, p.getcoordenador_id());
			stmt.setString(2, p.gettitulo());
			stmt.setString(3, p.getStatus_projeto().name());
			stmt.setString(4, p.getDescricao());
			
			return stmt.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}		
	}
}