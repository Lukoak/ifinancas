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
                    f.setNome(NomeFinanciador.valueOf(nomeBanco.toUpperCase()));
                }
                
                f.setInvestimento(rs.getBigDecimal("investimento"));
                lista.add(f);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}