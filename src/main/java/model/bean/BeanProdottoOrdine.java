package model.bean;

public class BeanProdottoOrdine {

    private int    ordineId;
    private int    prodottoId;
    private int    iva;
    private double prezzo;
    private int    quantita;

    public BeanProdottoOrdine() {}

    public int getOrdineId() {
        return ordineId;
    }
    public void setOrdineId(int ordineId) {
        this.ordineId = ordineId;
    }

    public int getProdottoId() {
        return prodottoId;
    }
    public void setProdottoId(int prodottoId) {
        this.prodottoId = prodottoId;
    }

    public int getIva() {
        return iva;
    }
    public void setIva(int iva) {
        this.iva = iva;
    }

    public double getPrezzo() {
        return prezzo;
    }
    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public int getQuantita() {
        return quantita;
    }
    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }
}