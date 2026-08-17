package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Financiador;
import model.NomeFinanciador;
import util.conexao;

public class financiadorDAO {

    public List<Financiador> listarTodos() {
        List<Financiador> lista = new ArrayList<>();
        String sql = "SELECT * FROM financiador ORDER BY nome";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
             
            while (rs.next()) {
                Financiador f = new Financiador();
                f.setId(rs.getInt("id"));
                
                String nomeBanco = rs.getString("nome");
                if (nomeBanco != null) {
                    // Tratamento para evitar o erro do parênteses e espaços
                    if (nomeBanco.contains("FOMENTO")) {
                        f.setNome(NomeFinanciador.FOMENTO);
                    } else {
                        f.setNome(NomeFinanciador.valueOf(nomeBanco.toUpperCase()));
                    }
                }
                
                lista.add(f);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Financiador buscarPorId(int id) {
        String sql = "SELECT * FROM financiador WHERE id = ?";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Financiador f = new Financiador();
                    f.setId(rs.getInt("id"));
                    
                    String nomeBanco = rs.getString("nome");
                    if (nomeBanco != null) {
                        // Tratamento para evitar o erro do parênteses e espaços
                        if (nomeBanco.contains("FOMENTO")) {
                            f.setNome(NomeFinanciador.FOMENTO);
                        } else {
                            f.setNome(NomeFinanciador.valueOf(nomeBanco.toUpperCase()));
                        }
                    }
                    
                    return f;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}