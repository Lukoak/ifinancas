package model;

public class item {
	private int id;
	private String nome;
	private boolean ativo;
	
	//======================getter e setter id===========================
	public int getId() {
		return id;
	}
	public void setId(int id) {
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
