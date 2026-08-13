package model;

import java.math.BigDecimal;

public class Financiador {
    private Integer id;
    private NomeFinanciador nome;
    private BigDecimal investimento;

    public Financiador() {}

    public Financiador(Integer id, NomeFinanciador nome, BigDecimal investimento) {
        this.id = id;
        this.nome = nome;
        this.investimento = investimento;
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

    public BigDecimal getInvestimento() {
        return investimento;
    }

    public void setInvestimento(BigDecimal investimento) {
        this.investimento = investimento;
    }
}