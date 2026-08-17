package model;
import java.math.BigDecimal;

public class ProjetoFinanciador {
    private int projetoId;
    private int financiadorId;
    private NomeFinanciador nomeFinanciador;
    private BigDecimal investimento;

    public int getProjetoId() { 
    	return projetoId; 
    }
    public void setProjetoId(int projetoId) { 
    	this.projetoId = projetoId; 
    }

    public int getFinanciadorId() { 
    	return financiadorId; 
    }
    public void setFinanciadorId(int financiadorId) { 
    	this.financiadorId = financiadorId; 
    }

    public NomeFinanciador getNomeFinanciador() { 
    	return nomeFinanciador; 
    }
    public void setNomeFinanciador(NomeFinanciador nomeFinanciador) { 
    	this.nomeFinanciador = nomeFinanciador; 
    }

    public BigDecimal getInvestimento() { 
    	return investimento; 
    }
    public void setInvestimento(BigDecimal investimento) { 
    	this.investimento = investimento; 
    }
}