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

    // MÉTODO NOVO PARA INSERIR A RUBRICA COM O ESPAÇAMENTO CORRETO PRO BANCO
    public boolean inserir(Rubrica r) {
        String sql = "INSERT INTO rubrica (categoria, fk_item) VALUES (?, ?)";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            // Substitui os underscores (_) por espaços ( ) para bater com o ENUM do MySQL
            stmt.setString(1, r.getCategoria().name().replace("_", " "));
            stmt.setInt(2, r.getFkItem());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { 
            e.printStackTrace(); 
            return false; 
        }
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