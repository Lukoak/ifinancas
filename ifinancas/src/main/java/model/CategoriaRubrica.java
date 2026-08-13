package model;

public enum CategoriaRubrica {
    RH("RH"),
    SERVICO_TERCEIRO_PJ("SERVICO TERCEIRO PJ"),
    SERVICO_TERCEIRO_PF("SERVICO TERCEIRO PF"),
    MATERIAIS("MATERIAIS"),
    DIARIAS("DIARIAS"),
    PASSAGENS("PASSAGENS"),
    SUPORTE_OPERACIONAL("SUPORTE OPERACIONAL"),
    CONTRAPARTIDA("CONTRAPARTIDA");

    private final String valorBanco;

    CategoriaRubrica(String valorBanco) {
        this.valorBanco = valorBanco;
    }

    public String getValorBanco() {
        return this.valorBanco;
    }

    public static CategoriaRubrica deString(String textoDoBanco) {
        if (textoDoBanco == null) {
            return null;
        }
        for (CategoriaRubrica categoria : CategoriaRubrica.values()) {
            if (categoria.valorBanco.equalsIgnoreCase(textoDoBanco.trim())) {
                return categoria;
            }
        }
        throw new IllegalArgumentException("Categoria não reconhecida no banco: " + textoDoBanco);
    }
}