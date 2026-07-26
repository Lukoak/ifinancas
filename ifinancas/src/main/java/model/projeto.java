package model;

public class projeto {
	private int id;
	private int coordenador_id;
	private String titulo;
	private Status_Projeto status_projeto;
	private String descricao;
	
	//=======================getter e setter id
	public int getid()
	{
		return this.id;
	}
	
	public void setid(int id)
	{
		this.id = id;
	}
	
	//=======================getter e setter coordenador_id
	public int getcoordenador_id()
	{
		return this.coordenador_id;
	}
	public void setcoordenador_id(int coordenador_id)
	{
		this.coordenador_id = coordenador_id;
	}
	//=======================getter e setter titulo
	public String gettitulo()
	{
		return this.titulo;
	}
	public void settitulo(String titulo)
	{
		this.titulo = titulo;
	}
	//=======================getter e setter  status_projeto
	public Status_Projeto getStatus_projeto() {
		return status_projeto;
	}

	public void setStatus_projeto(Status_Projeto status_projeto) {
		this.status_projeto = status_projeto;
	}
	//=======================getter e setter descricao
	public String getDescricao() {
		return descricao;
	}

	public void setDescricao(String descricao) {
		this.descricao = descricao;
	}
}
