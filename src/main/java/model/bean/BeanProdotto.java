package model.bean;

public class BeanProdotto {

    private int     id;
    private String  nome;
    private double  prezzoListino;
    private double  prezzoFinale;
    private String  descrizione;
    private int     iva;
    private boolean isActive;
    private int     quantita;
    private int     categoriaId;

    public BeanProdotto() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }

    public double getPrezzoListino() {
        return prezzoListino;
    }
    public void setPrezzoListino(double prezzoListino) {
        this.prezzoListino = prezzoListino;
    }

    public double getPrezzoFinale() {
        return prezzoFinale;
    }
    public void setPrezzoFinale(double prezzoFinale) {
        this.prezzoFinale = prezzoFinale;
    }

    public String getDescrizione() {
        return descrizione;
    }
    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public int getIva() {
        return iva;
    }
    public void setIva(int iva) {
        this.iva = iva;
    }

    public boolean isActive() {
        return isActive;
    }
    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public int getQuantita() {
        return quantita;
    }
    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public int getCategoriaId() {
        return categoriaId;
    }
    public void setCategoriaId(int categoriaId) {
        this.categoriaId = categoriaId;
    }
}