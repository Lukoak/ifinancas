package model;

public class Financiador {
    private Integer id;
    private NomeFinanciador nome;

    public Financiador() {}

    public Financiador(Integer id, NomeFinanciador nome) {
        this.id = id;
        this.nome = nome;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public NomeFinanciador getNome() {
        return nome;
    }

    public void setNome(NomeFinanciador nome) {
        this.nome = nome;
    }

}