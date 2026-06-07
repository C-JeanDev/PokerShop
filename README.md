# ♠ PokerShop

E-commerce dedicato alla vendita di prodotti per il poker, sviluppato in Java EE seguendo il pattern architetturale **MVC** con **DAO** e **Bean**.

---

## Tecnologie utilizzate

- **Java EE** (Servlet, JSP, Filter)
- **Apache Tomcat 9**
- **MySQL** con connessione JNDI (connection pool)
- **Pattern MVC** — Controller (Servlet), Model (DAO + Bean), View (JSP)
- **Eclipse IDE** (Dynamic Web Project)

---

## Struttura del progetto

```
PokerShop/
├── SQL/
│   ├── pokerShopCreation.sql       # Schema del database
│   └── pokerShopPopulation.sql     # Dati di esempio
│
└── src/
    ├── main/java/
    │   ├── controller/             # Servlet e filtri (layer C)
    │   │   ├── LoginServlet.java
    │   │   ├── LogoutServlet.java
    │   │   ├── RegistrazioneServlet.java
    │   │   └── AuthFilter.java
    │   │
    │   └── model/
    │       ├── bean/               # Oggetti di dominio (layer M)
    │       │   ├── BeanUtente.java
    │       │   ├── BeanProdotto.java
    │       │   ├── BeanCarrello.java
    │       │   ├── BeanOrdine.java
    │       │   ├── BeanCategoria.java
    │       │   ├── BeanRecensione.java
    │       │   └── BeanFoto.java
    │       │
    │       └── DAO/                # Accesso al database
    │           ├── DBConnect.java
    │           ├── UtenteDAO.java
    │           ├── ProdottoDAO.java
    │           ├── CarrelloDAO.java
    │           ├── OrdineDAO.java
    │           ├── CategoriaDAO.java
    │           ├── RecensioneDAO.java
    │           └── FotoDAO.java
    │
    └── webapp/
        ├── index.jsp               # Home page
        ├── registrazione.jsp       # Form di registrazione
        ├── admin/
        │   └── dashboard.jsp       # Area admin (protetta)
        └── WEB-INF/
            ├── web.xml
            ├── views/
            │   └── login.jsp       # Form di login
            └── lib/
                └── mysql-connector-j-9.7.0.jar
```

---

## Schema database

Il database `pokerShop` è composto da 8 tabelle:

| Tabella | Descrizione |
|---|---|
| `utente` | Utenti registrati (clienti e admin) |
| `prodotto` | Catalogo prodotti con prezzo, IVA e quantità |
| `categoria` | Categorie dei prodotti |
| `foto` | Immagini associate ai prodotti |
| `carrello` | Carrello di ogni utente |
| `prodottiCarrello` | Prodotti nel carrello con quantità |
| `ordine` | Ordini effettuati |
| `prodottiOrdine` | Dettaglio prodotti per ordine |
| `recensione` | Recensioni degli utenti sui prodotti |

---

## Funzionalità implementate

- **Registrazione** — form completo con nome, cognome, email, password, indirizzo, n° civico, CAP, città
- **Login / Logout** — autenticazione tramite email e password con gestione sessione
- **Ruoli** — distinzione tra utente normale e amministratore (`isAdmin`)
- **Protezione pagine admin** — filtro `AuthFilter` su `/admin/*`

---

## Configurazione e avvio

### 1. Database

Esegui i due script SQL in ordine:

```sql
source SQL/pokerShopCreation.sql
source SQL/pokerShopPopulation.sql
```

### 2. Datasource JNDI

Nel file `context.xml` (già presente in `META-INF/`) configura le credenziali del tuo MySQL:

```xml
<Resource name="jdbc/pokerShop"
          auth="Container"
          type="javax.sql.DataSource"
          username="root"
          password="TUA_PASSWORD"
          driverClassName="com.mysql.cj.jdbc.Driver"
          url="jdbc:mysql://localhost:3306/pokerShop"
          maxActive="10" maxIdle="5" />
```

### 3. Avvio in Eclipse

1. Importa il progetto come **Dynamic Web Project**
2. Tasto destro → **Run As → Run on Server** → seleziona Tomcat 9
3. Apri il browser su `http://localhost:8080/PokerShop`

---

## URL disponibili

| URL | Descrizione |
|---|---|
| `/` | Home page |
| `/login` | Pagina di login |
| `/logout` | Logout e invalidazione sessione |
| `/registrazione` | Form di registrazione |
| `/admin/dashboard.jsp` | Dashboard admin (solo admin) |

---

