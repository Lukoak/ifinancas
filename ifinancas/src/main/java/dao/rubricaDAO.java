package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.CategoriaRubrica;
import model.Rubrica;
import util.conexao;

public class rubricaDAO {

    public boolean inserir(Rubrica rubrica) {
        String sql = "INSERT INTO rubrica (categoria, fk_item) VALUES (?, ?)";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, rubrica.getCategoria().name());
            stmt.setInt(2, rubrica.getFkItem());
            
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Rubrica> listarTodas() {
        List<Rubrica> lista = new ArrayList<>();
        String sql = "SELECT * FROM rubrica";
        
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Rubrica r = new Rubrica();
                r.setId(rs.getInt("id"));
                
                String catBanco = rs.getString("categoria");
                if (catBanco != null) {
                    r.setCategoria(CategoriaRubrica.valueOf(catBanco.toUpperCase()));
                }
                
                r.setFkItem(rs.getInt("fk_item"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
    
    public List<Rubrica> listarTodos() {
        List<Rubrica> lista = new ArrayList<>();
        String sql = "SELECT * FROM rubrica ORDER BY categoria ASC";

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Rubrica r = new Rubrica();
                r.setId(rs.getInt("id"));
                
                // Converte a string do banco ("SERVICO TERCEIRO PJ") para o formato do Enum ("SERVICO_TERCEIRO_PJ")
                String categoriaDb = rs.getString("categoria");
                if (categoriaDb != null) {
                    r.setCategoria(CategoriaRubrica.valueOf(categoriaDb.replace(" ", "_")));
                }
                
                r.setFkItem(rs.getInt("fk_item"));
                lista.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}