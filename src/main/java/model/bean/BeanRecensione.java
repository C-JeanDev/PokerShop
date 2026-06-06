package model.bean;

import java.sql.Date;

public class BeanRecensione {

    private int    id;
    private String descrizione;
    private Date   data;
    private String utenteEmail;
    private int    prodottoId;

    public BeanRecensione() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getDescrizione() {
        return descrizione;
    }
    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public Date getData() {
        return data;
    }
    public void setData(Date data) {
        this.data = data;
    }

    public String getUtenteEmail() {
        return utenteEmail;
    }
    public void setUtenteEmail(String utenteEmail) {
        this.utenteEmail = utenteEmail;
    }

    public int getProdottoId() {
        return prodottoId;
    }
    public void setProdottoId(int prodottoId) {
        this.prodottoId = prodottoId;
    }
}