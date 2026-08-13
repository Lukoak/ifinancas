package model;

public class Projeto {
    private Integer id;
    private int coordenadorId;
    private String titulo;
    private StatusProjeto statusProjeto;
    private String descricao;
    private int duracao;

    public Projeto() {}

    public Projeto(Integer id, int coordenadorId, String titulo, StatusProjeto statusProjeto, String descricao, int duracao) {
        this.id = id;
        this.coordenadorId = coordenadorId;
        this.titulo = titulo;
        this.statusProjeto = statusProjeto;
        this.descricao = descricao;
        this.duracao = duracao;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getCoordenadorId() {
        return coordenadorId;
    }

    public void setCoordenadorId(int coordenadorId) {
        this.coordenadorId = coordenadorId;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public StatusProjeto getStatusProjeto() {
        return statusProjeto;
    }

    public void setStatusProjeto(StatusProjeto statusProjeto) {
        this.statusProjeto = statusProjeto;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public int getDuracao() {
        return duracao;
    }

    public void setDuracao(int duracao) {
        this.duracao = duracao;
    }
}