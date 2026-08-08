package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.projeto;
import util.conexao;

public class projetoDAO {
	
	public boolean insereprojeto(projeto coordenador_id, projeto titulo, projeto status_projeto, projeto descricao)
	{
		String inserir_projeto = "INSERT INTO " +
								"projeto(coordenador_id, titulo, " +
								"status_projeto, descricao " +
								"VALUES (?,?,?,?)";
		
		try (Connection conn = conexao.getConexao();
				PreparedStatement stmt = conn.prepareStatement(inserir_projeto))
		{
			stmt.setInt(1, coordenador_id.getcoordenador_id());
			stmt.setString(2, titulo.gettitulo());
			stmt.setString(3, status_projeto.getStatus_projeto());
			stmt.setString(4, descricao.getDescricao());
			
			return stmt.executeUpdate() > 0;
		}catch (SQLException e) {
			e.printStackTrace();
			return false;
		}		
	}

}
