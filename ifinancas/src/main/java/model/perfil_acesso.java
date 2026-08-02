package model;

public class perfil_acesso {
	private Integer id;
	private String nome;
	
	public perfil_acesso() {}
	
	public perfil_acesso(Integer id, String nome)
	{
		this.id = id;
		this.nome = nome;	
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

}
