package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;

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
			stmt.set
		}
		
		
		
		
		
		
	}

}
