package model;

public class Usuario {
    private Integer id;
    private Integer perfilId;
    private String nome;
    private String email;
    private String senhaHash;
    private StatusUsuario statusUsuario;

    public Usuario() {}

    public Usuario(Integer id, Integer perfilId, String nome, String email, String senhaHash, StatusUsuario statusUsuario) {
        this.id = id;
        this.perfilId = perfilId;
        this.nome = nome;
        this.email = email;
        this.senhaHash = senhaHash;
        this.statusUsuario = statusUsuario;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getPerfilId() {
        return perfilId;
    }

    public void setPerfilId(Integer perfilId) {
        this.perfilId = perfilId;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenhaHash() {
        return senhaHash;
    }

    public void setSenhaHash(String senhaHash) {
        this.senhaHash = senhaHash;
    }

    public StatusUsuario getStatusUsuario() {
        return statusUsuario;
    }

    public void setStatusUsuario(StatusUsuario statusUsuario) {
        this.statusUsuario = statusUsuario;
    }
}