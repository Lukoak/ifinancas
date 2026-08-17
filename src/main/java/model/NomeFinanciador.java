package model;

public enum NomeFinanciador {
    EMPRESA("EMPRESA"),
    EMBRAPII("EMBRAPII"),
    FOMENTO("FOMENTO (LC/SEBRAE/ETC)"),
    IFBA("IFBA");

    private final String descricao;

    NomeFinanciador(String descricao) {
        this.descricao = descricao;
    }

    public String getDescricao() {
        return descricao;
    }
}