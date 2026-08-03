package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import model.perfil_acesso;
import util.conexao;

public class perfil_acessoDAO {

    public boolean insere_perfil_acesso(perfil_acesso perfil) {

        String inserir = "INSERT INTO perfil_acesso(nome) VALUES (?)";

        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(inserir)) {

            stmt.setString(1, perfil.getNome());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}