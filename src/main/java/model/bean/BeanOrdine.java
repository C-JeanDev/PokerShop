package model.bean;

import java.sql.Date;

public class BeanOrdine {

    private int    id;
    private double costoTot;
    private Date   data;
    private String stato;
    private String utenteEmail;

    public BeanOrdine() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public double getCostoTot() {
        return costoTot;
    }
    public void setCostoTot(double costoTot) {
        this.costoTot = costoTot;
    }

    public Date getData() {
        return data;
    }
    public void setData(Date data) {
        this.data = data;
    }

    public String getStato() {
        return stato;
    }
    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getUtenteEmail() {
        return utenteEmail;
    }
    public void setUtenteEmail(String utenteEmail) {
        this.utenteEmail = utenteEmail;
    }
}