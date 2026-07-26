package model;

public class item_orcamento {
	private int id;
	private int macroetapa_id;
	private int fk_item_id;
	private int financiador_id;
	private float quantidade;
	private int meses;
	private float valor_unitario;
	private float valor_total;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public int getMacroetapa_id() {
		return macroetapa_id;
	}
	public void setMacroetapa_id(int macroetapa_id) {
		this.macroetapa_id = macroetapa_id;
	}
	
	
	public int getFk_item_id() {
		return fk_item_id;
	}
	public void setFk_item_id(int fk_item_id) {
		this.fk_item_id = fk_item_id;
	}
	
	public int getFinanciador_id() {
		return financiador_id;
	}
	public void setFinanciador_id(int financiador_id) {
		this.financiador_id = financiador_id;
	}
	
	
	public float getQuantidade() {
		return quantidade;
	}
	public void setQuantidade(float quantidade) {
		this.quantidade = quantidade;
	}
	
	
	public int getMeses() {
		return meses;
	}
	public void setMeses(int meses) {
		this.meses = meses;
	}
	
	
	public float getValor_unitario() {
		return valor_unitario;
	}
	public void setValor_unitario(float valor_unitario) {
		this.valor_unitario = valor_unitario;
	}
	
	
	public float getValor_total() {
		return valor_total;
	}
	public void setValor_total(float valor_total) {
		this.valor_total = valor_total;
	}
		
}
