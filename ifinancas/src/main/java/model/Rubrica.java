package model;

public class Rubrica {
    private Integer id;
    private CategoriaRubrica categoria;
    private int fkItem;

    public Rubrica() {}

    public Rubrica(Integer id, CategoriaRubrica categoria, int fkItem) {
        this.id = id;
        this.categoria = categoria;
        this.fkItem = fkItem;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public CategoriaRubrica getCategoria() {
        return categoria;
    }

    public void setCategoria(CategoriaRubrica categoria) {
        this.categoria = categoria;
    }

    public int getFkItem() {
        return fkItem;
    }

    public void setFkItem(int fkItem) {
        this.fkItem = fkItem;
    }
}