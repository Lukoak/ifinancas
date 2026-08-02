package model;

public class item {
	private Integer id;
	private String nome;
	private boolean ativo;
	
	
	public item() {}
	
	public item(Integer id, String nome, boolean ativo)
	{
		this.id = id;
		this.nome = nome;
		this.ativo = ativo;
	}
	
	//======================getter e setter id===========================
	public int getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	//=======================getter e setter nome=========================
	public String getNome() {
		return nome;
	}
	public void setNome(String nome) {
		this.nome = nome;
	}
	//======================getter e setter ativo=========================
	public boolean estaAtivo()
	{
		return this.ativo;
	}
	public void setAtivo(boolean ativo)
	{
		this.ativo = ativo;
	}

}
