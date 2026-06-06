package model.bean;

public class BeanProdottoCarrello {

    private int carrelloId;
    private int prodottoId;
    private int quantita;

    public BeanProdottoCarrello() {}

    public int getCarrelloId() {
        return carrelloId;
    }
    public void setCarrelloId(int carrelloId) {
        this.carrelloId = carrelloId;
    }

    public int getProdottoId() {
        return prodottoId;
    }
    public void setProdottoId(int prodottoId) {
        this.prodottoId = prodottoId;
    }

    public int getQuantita() {
        return quantita;
    }
    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }
}