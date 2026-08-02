package model;

public class rubrica {
	private Integer id;
	private categoria_rubrica categoria;
	private int fk_item;
	
	public rubrica() {}
	
	public rubrica(Integer id, categoria_rubrica categoria, int fk_item)
	{
		this.id = id;
		this.categoria = categoria;
		this.fk_item = fk_item;
	}
	
	
	//======================getter e setter id===========================
	public int getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}

	
	//======================getter e setter fk_item===========================
	public int getFk_item() {
		return fk_item;
	}
	public void setFk_item(int fk_item) {
		this.fk_item = fk_item;
	}
	//=======================getters e setters categoria==================================
	public categoria_rubrica getCategoria() {
		return categoria;
	}
	public void setCategoria(categoria_rubrica categoria) {
		this.categoria = categoria;
	}
	
}
