package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.categoria_rubrica;
import util.conexao;

public class rubricaDAO {

    public boolean insere_rubrica(categoria_rubrica categoria, int fk_item) {

        String inserir = "INSERT INTO rubrica(categoria, fk_item) VALUES (?, ?)";

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(inserir)) {

            stmt.setString(1, categoria.getValorBanco());
            stmt.setInt(2, fk_item);

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}