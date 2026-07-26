package model;

public class auditoria {
	private int id;
	private int usuario_id;
	private Acao_auditoria acao;
	private String tabela_nome;
	private int registro_id;
	private String valor_antigo;
	private String valor_novo;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	
	
	public int getUsuario_id() {
		return usuario_id;
	}
	public void setUsuario_id(int usuario_id) {
		this.usuario_id = usuario_id;
	}
	
	
	public Acao_auditoria getAcao() {
		return acao;
	}
	public void setAcao(Acao_auditoria acao) {
		this.acao = acao;
	}
	
	
	public String getTabela_nome() {
		return tabela_nome;
	}
	public void setTabela_nome(String tabela_nome) {
		this.tabela_nome = tabela_nome;
	}
	
	
	public int getRegistro_id() {
		return registro_id;
	}
	public void setRegistro_id(int registro_id) {
		this.registro_id = registro_id;
	}
	
	
	public String getValor_antigo() {
		return valor_antigo;
	}
	public void setValor_antigo(String valor_antigo) {
		this.valor_antigo = valor_antigo;
	}
	
	
	public String getValor_novo() {
		return valor_novo;
	}
	public void setValor_novo(String valor_novo) {
		this.valor_novo = valor_novo;
	}
	
	
}
