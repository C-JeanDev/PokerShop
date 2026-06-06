package model.bean;

public class BeanUtente {

    private String  email;
    private String  nome;
    private String  cognome;
    private String  password;
    private boolean isAdmin;
    private String  indirizzo;
    private int     nCivico;
    private String  cap;
    private String  citta;

    public BeanUtente() {}

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getNome() {
        return nome;
    }
    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }
    public void setCognome(String cognome) {
        this.cognome = cognome;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isAdmin() {
        return isAdmin;
    }
    public void setAdmin(boolean isAdmin) {
        this.isAdmin = isAdmin;
    }

    public String getIndirizzo() {
        return indirizzo;
    }
    public void setIndirizzo(String indirizzo) {
        this.indirizzo = indirizzo;
    }

    public int getNCivico() {
        return nCivico;
    }
    public void setNCivico(int nCivico) {
        this.nCivico = nCivico;
    }

    public String getCap() {
        return cap;
    }
    public void setCap(String cap) {
        this.cap = cap;
    }

    public String getCitta() {
        return citta;
    }
    public void setCitta(String citta) {
        this.citta = citta;
    }
}