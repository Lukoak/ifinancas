package model;

public class Projeto {
    private Integer id;
    private int coordenadorId;
    private String nomeCoordenador;
    private String titulo;
    private StatusProjeto statusProjeto;
    private String descricao;
    private int duracao;
    private boolean solicitacaoFinalizacao;
    private String justificativaFinalizacao;

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public int getCoordenadorId() { return coordenadorId; }
    public void setCoordenadorId(int coordenadorId) { this.coordenadorId = coordenadorId; }

    public String getNomeCoordenador() { return nomeCoordenador; }
    public void setNomeCoordenador(String nomeCoordenador) { this.nomeCoordenador = nomeCoordenador; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public StatusProjeto getStatusProjeto() { return statusProjeto; }
    public void setStatusProjeto(StatusProjeto statusProjeto) { this.statusProjeto = statusProjeto; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public int getDuracao() { return duracao; }
    public void setDuracao(int duracao) { this.duracao = duracao; }

    public boolean isSolicitacaoFinalizacao() { return solicitacaoFinalizacao; }
    public void setSolicitacaoFinalizacao(boolean solicitacaoFinalizacao) { this.solicitacaoFinalizacao = solicitacaoFinalizacao; }

    public String getJustificativaFinalizacao() { return justificativaFinalizacao; }
    public void setJustificativaFinalizacao(String justificativaFinalizacao) { this.justificativaFinalizacao = justificativaFinalizacao; }
}