package model;

import java.math.BigDecimal;

public class ItemOrcamento {
    private Integer id;
    private int macroetapaId;
    private int fkItemId;
    private int financiadorId;
    private BigDecimal quantidade;
    private BigDecimal valorUnitario;
    private BigDecimal valorTotal;

    public ItemOrcamento() {}

    public ItemOrcamento(Integer id, int macroetapaId, int fkItemId, int financiadorId, 
                         BigDecimal quantidade, BigDecimal valorUnitario, BigDecimal valorTotal) {
        this.id = id;
        this.macroetapaId = macroetapaId;
        this.fkItemId = fkItemId;
        this.financiadorId = financiadorId;
        this.quantidade = quantidade;
        this.valorUnitario = valorUnitario;
        this.valorTotal = valorTotal;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getMacroetapaId() {
        return macroetapaId;
    }

    public void setMacroetapaId(int macroetapaId) {
        this.macroetapaId = macroetapaId;
    }

    public int getFkItemId() {
        return fkItemId;
    }

    public void setFkItemId(int fkItemId) {
        this.fkItemId = fkItemId;
    }

    public int getFinanciadorId() {
        return financiadorId;
    }

    public void setFinanciadorId(int financiadorId) {
        this.financiadorId = financiadorId;
    }

    public BigDecimal getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(BigDecimal quantidade) {
        this.quantidade = quantidade;
        recalcularValorTotal();
    }

    public BigDecimal getValorUnitario() {
        return valorUnitario;
    }

    public void setValorUnitario(BigDecimal valorUnitario) {
        this.valorUnitario = valorUnitario;
        recalcularValorTotal();
    }

    public BigDecimal getValorTotal() {
        return valorTotal;
    }

    public void setValorTotal(BigDecimal valorTotal) {
        this.valorTotal = valorTotal;
    }

    private void recalcularValorTotal() {
        if (this.quantidade != null && this.valorUnitario != null) {
            this.valorTotal = this.quantidade.multiply(this.valorUnitario);
        }
    }
}