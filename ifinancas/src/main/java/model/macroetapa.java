package model;

public class macroetapa {
	private Integer id;
	private int projeto_id;
	private String numero;
	private String descricao;
	
	
	public macroetapa() {}
	
	public macroetapa(Integer id, int projeto_id, String numero, String descricao)
	{
		this.id = id;
		this.projeto_id = projeto_id;
		this.numero = numero;
		this.descricao = descricao;
	}
	
	
	//======================getter e setter id===========================
	public int getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	
	//======================getter e setter projeto_id===========================
	public int getProjeto_id() {
		return projeto_id;
	}
	public void setProjeto_id(int projeto_id) {
		this.projeto_id = projeto_id;
	}
	
	//======================getter e setter numero===========================
	public String getNumero() {
		return numero;
	}
	public void setNumero(String numero) {
		this.numero = numero;
	}
	//======================getter e setter descricao===========================
	public String getDescricao() {
		return descricao;
	}
	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}
	
}
