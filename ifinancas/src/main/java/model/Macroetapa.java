package model;

public class Macroetapa {
    private Integer id;
    private int projetoId;
    private String numero;
    private String descricao;
    private int duracao;

    public Macroetapa() {}

    public Macroetapa(Integer id, int projetoId, String numero, String descricao, int duracao) {
        this.id = id;
        this.projetoId = projetoId;
        this.numero = numero;
        this.descricao = descricao;
        this.duracao = duracao;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getProjetoId() {
        return projetoId;
    }

    public void setProjetoId(int projetoId) {
        this.projetoId = projetoId;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
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