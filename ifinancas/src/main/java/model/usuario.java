package model;

public class usuario {
	private Integer id;
	private String nome;
	private String email;
	private String senha_hash;
	private StatusUsuario status_usuario;
	
	
    public usuario() {}

    public usuario(Integer id, String nome, String email, String senha_hash, StatusUsuario status_usuario) {
        this.id = id;
        this.nome = nome;
        this.email = email;
        this.senha_hash = senha_hash;
        this.status_usuario = status_usuario;
    }
	
	//=============================================getter e setter de id
	public int getid()
	{
		return this.id;
	}
	public void setid(Integer id)
	{
		this.id = id;
	}
	//==============================================getter e setter de "nome"
	public String getnome()
	{
		return this.nome;
	}
	public void setnome(String nome)
	{
		this.nome = nome;
	}
	//==============================================getter e setter de email
	public String getemail()
	{
		return this.email;
	}
	public void setemail(String email)
	{
		this.email = email;
	}
	//==============================================getter e setter de senha_hash
	public String getsenha_hash()
	{
		return this.senha_hash;
	}
	public void setsenha_hash(String senha_hash)
	{
		this.senha_hash = senha_hash;
	}
	//==============================================getter e setter de status_usuario
	public StatusUsuario getStatusUsuario() {
        return this.status_usuario;
    }

    // Setter
    public void setStatusUsuario(StatusUsuario status_usuario) {
        this.status_usuario = status_usuario;
    }

}
