package model;

public class PerfilAcesso {
    private Integer id;
    private PerfilNome nome;

    public PerfilAcesso() {}

    public PerfilAcesso(Integer id, PerfilNome nome) {
        this.id = id;
        this.nome = nome;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public PerfilNome getNome() {
        return nome;
    }

    public void setNome(PerfilNome nome) {
        this.nome = nome;
    }
}