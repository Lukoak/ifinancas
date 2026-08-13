package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.Auditoria;
import util.conexao;

public class auditoriaDAO {

    public boolean registrar(Auditoria auditoria) {
        String sql = "INSERT INTO auditoria (usuario_id, acao, tabela_nome, registro_id, valor_antigo, valor_novo) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, auditoria.getUsuarioId());
            stmt.setString(2, auditoria.getAcao().name());
            stmt.setString(3, auditoria.getTabelaNome());
            stmt.setInt(4, auditoria.getRegistroId());
            stmt.setString(5, auditoria.getValorAntigo());
            stmt.setString(6, auditoria.getValorNovo());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}