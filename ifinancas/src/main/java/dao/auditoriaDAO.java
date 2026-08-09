package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import util.conexao;

public class auditoriaDAO {

    public boolean registrar(Integer usuarioId, String acao, String tabelaNome, int registroId, String valorAntigoJson, String valorNovoJson) {
        String sql = "INSERT INTO auditoria (usuario_id, acao, tabela_nome, registro_id, valor_antigo, valor_novo) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            if (usuarioId != null) {
                stmt.setInt(1, usuarioId);
            } else {
                stmt.setNull(1, java.sql.Types.INTEGER);
            }
            
            stmt.setString(2, acao);
            stmt.setString(3, tabelaNome);
            stmt.setInt(4, registroId);
            stmt.setString(5, valorAntigoJson);
            stmt.setString(6, valorNovoJson);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}