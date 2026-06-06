package model.bean;

public class BeanFoto {

    private String nome;
    private String path;
    private int    prodottoId;

    public BeanFoto() {}

    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getPath() {
        return path;
    }
    public void setPath(String path) {
        this.path = path;
    }

    public int getProdottoId() {
        return prodottoId;
    }
    public void setProdottoId(int prodottoId) {
        this.prodottoId = prodottoId;
    }
}