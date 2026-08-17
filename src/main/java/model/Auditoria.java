package model;

public class Auditoria {
    private Integer id;
    private int usuarioId;
    private AcaoAuditoria acao;
    private String tabelaNome;
    private int registroId;
    private String valorAntigo;
    private String valorNovo;

    public Auditoria() {}

    public Auditoria(Integer id, int usuarioId, AcaoAuditoria acao, String tabelaNome, 
                     int registroId, String valorAntigo, String valorNovo) {
        this.id = id;
        this.usuarioId = usuarioId;
        this.acao = acao;
        this.tabelaNome = tabelaNome;
        this.registroId = registroId;
        this.valorAntigo = valorAntigo;
        this.valorNovo = valorNovo;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public int getUsuarioId() {
        return usuarioId;
    }

    public void setUsuarioId(int usuarioId) {
        this.usuarioId = usuarioId;
    }

    public AcaoAuditoria getAcao() {
        return acao;
    }

    public void setAcao(AcaoAuditoria acao) {
        this.acao = acao;
    }

    public String getTabelaNome() {
        return tabelaNome;
    }

    public void setTabelaNome(String tabelaNome) {
        this.tabelaNome = tabelaNome;
    }

    public int getRegistroId() {
        return registroId;
    }

    public void setRegistroId(int registroId) {
        this.registroId = registroId;
    }

    public String getValorAntigo() {
        return valorAntigo;
    }

    public void setValorAntigo(String valorAntigo) {
        this.valorAntigo = valorAntigo;
    }

    public String getValorNovo() {
        return valorNovo;
    }

    public void setValorNovo(String valorNovo) {
        this.valorNovo = valorNovo;
    }
}