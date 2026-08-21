package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Item;
import util.conexao;

public class itemDAO {

    public boolean inserir(Item item) {
        String sql = "INSERT INTO item (nome, ativo) VALUES (?, ?)";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, item.getNome());
            stmt.setBoolean(2, item.isAtivo());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    
    // MÉTODO NOVO PARA RETORNAR A CHAVE (ID) GERADA PELO BANCO
    public int inserirERetornarId(Item item) {
        String sql = "INSERT INTO item (nome, ativo) VALUES (?, ?)";
        try (Connection conn = conexao.getConexao();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, item.getNome());
            stmt.setBoolean(2, item.isAtivo());
            stmt.executeUpdate();
            
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public List<Item> listarAtivos() {
        List<Item> lista = new ArrayList<>();
        String sql = "SELECT * FROM item WHERE ativo = true ORDER BY nome";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Item i = new Item();
                i.setId(rs.getInt("id"));
                i.setNome(rs.getString("nome"));
                i.setAtivo(rs.getBoolean("ativo"));
                lista.add(i);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
    
    public List<Item> listarTodos() {
        List<Item> lista = new ArrayList<>();
        String sql = "SELECT * FROM item ORDER BY nome ASC";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setNome(rs.getString("nome"));
                item.setAtivo(rs.getBoolean("ativo"));
                lista.add(item);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
    
    public Item buscarPorId(int id) {
        String sql = "SELECT * FROM item WHERE id = ?";
        try (Connection conn = conexao.getConexao(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Item i = new Item();
                    i.setId(rs.getInt("id"));
                    i.setNome(rs.getString("nome"));
                    i.setAtivo(rs.getBoolean("ativo"));
                    return i;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
    
    public boolean atualizarNome(int id, String novoNome) {
        String sql = "UPDATE item SET nome = ? WHERE id = ?";
        try (java.sql.Connection conn = util.conexao.getConexao(); java.sql.PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, novoNome);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (java.sql.SQLException e) { e.printStackTrace(); return false; }
    }
    
    
}