package model;

public enum categoria_rubrica {
	RH("RH"),
	SERVICO_TERCEIRO_PJ("SERVICO TERCEIRO PJ"),
	SERVICO_TERCEIRO_PF("SERVICO TERCEIRO PF"),
	MATERIAIS("MATERIAIS"),
	DIARIAS("DIARIAS"),
	PASSAGENS("PASSAGENS"),
	SUPORTE_OPERACIONAL("SUPORTE OPERACIONAL"),
	CONTRAPARTIDA("CONTRAPARTIDA");
	
	private String valorBanco;
	
	categoria_rubrica(String valorBanco) {
		// TODO Auto-generated constructor stub
		this.valorBanco = valorBanco;
	}
	
	public String getValorBanco()
	{
		return this.valorBanco;
	}

	public static categoria_rubrica deString(String textoDoBanco) {
        for (categoria_rubrica categoria : categoria_rubrica.values()) {
            if (categoria.valorBanco.equals(textoDoBanco)) {
                return categoria;
            }
        }
        throw new IllegalArgumentException("Categoria nao reconhecida no banco: " + textoDoBanco);
    }
}
