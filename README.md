# ♠ PokerShop

E-commerce dedicato alla vendita di prodotti per il poker, sviluppato come progetto d'esame per il corso **Tecnologie Software per il Web (TSW) – a.a. 2025/2026**.

---

## Stack Tecnologico

| Layer | Tecnologia |
|---|---|
| Server-side | Java EE – Servlet, JSP, Filter |
| Application Server | Apache Tomcat 9 |
| Database | MySQL con DataSource JNDI (Connection Pool) |
| Driver DB | mysql-connector-j 9.7.0 |
| Front-end | HTML5, CSS3, JavaScript (ES6+) |
| Comunicazione asincrona | AJAX + Fetch API con JSON |
| Pattern architetturale | MVC (Model–View–Controller) |
| Sicurezza password | SHA-256 (cifratura one-way) |
| IDE | Eclipse (Dynamic Web Project) |

---

## Architettura MVC

```
Controller  →  src/main/java/controller/        (Servlet + Filter)
Model       →  src/main/java/model/bean/        (Bean)
               src/main/java/model/DAO/         (Data Access Object)
               src/main/java/model/utils/       (Utility)
View        →  src/webapp/WEB-INF/views/        (JSP – non accessibili direttamente)
```

L'HTML è generato **esclusivamente dalle JSP**. Le Servlet non producono mai output HTML diretto.

---

## Struttura del Progetto

```
PokerShop/
├── SQL/
│   ├── pokerShopCreation.sql
│   └── pokerShopPopulation.sql
│
└── src/
    ├── main/java/
    │   ├── controller/
    │   │   ├── AuthFilter.java               ← Filtro servlet (protegge /admin/*)
    │   │   ├── LoginServlet.java             ← GET: mostra login / POST: autentica
    │   │   ├── LogoutServlet.java            ← Invalida la sessione
    │   │   ├── RegistrazioneServlet.java     ← GET: mostra form / POST: salva utente
    │   │   └── admin/
    │   │       ├── AdminDashboardServlet.java
    │   │       ├── AdminProdottiServlet.java ← CRUD prodotti
    │   │       ├── AdminUtentiServlet.java   ← Visualizza ed elimina utenti
    │   │       └── AdminOrdiniServlet.java   ← Ordini con filtri data/cliente
    │   │
    │   └── model/
    │       ├── bean/
    │       │   ├── BeanUtente.java
    │       │   ├── BeanProdotto.java
    │       │   ├── BeanCategoria.java
    │       │   ├── BeanCarrello.java
    │       │   ├── BeanProdottoCarrello.java
    │       │   ├── BeanOrdine.java
    │       │   ├── BeanProdottoOrdine.java
    │       │   ├── BeanRecensione.java
    │       │   └── BeanFoto.java
    │       ├── DAO/
    │       │   ├── DBConnect.java            ← Connessione via JNDI DataSource
    │       │   ├── UtenteDAO.java
    │       │   ├── ProdottoDAO.java
    │       │   ├── CategoriaDAO.java
    │       │   ├── CarrelloDAO.java
    │       │   ├── OrdineDAO.java
    │       │   ├── RecensioneDAO.java
    │       │   └── FotoDAO.java
    │       └── utils/
    │           └── PasswordUtils.java        ← Hash SHA-256 + verify
    │
    └── webapp/
        ├── index.jsp
        ├── registrazione.jsp
        ├── META-INF/
        │   └── context.xml                  ← Configurazione DataSource JNDI
        └── WEB-INF/
            ├── web.xml
            ├── lib/
            │   └── mysql-connector-j-9.7.0.jar
            └── views/
                ├── login.jsp
                └── admin/
                    ├── header.jsp            ← Fragment riutilizzabile (sidebar)
                    ├── footer.jsp            ← Fragment riutilizzabile
                    ├── dashboard.jsp
                    ├── prodotti.jsp
                    ├── prodotto-form.jsp
                    ├── utenti.jsp
                    └── ordini.jsp
```

---

## Schema Database

Il database `pokerShop` è composto da 9 tabelle con vincoli di integrità referenziale:

| Tabella | Descrizione | Chiave |
|---|---|---|
| `utente` | Clienti e amministratori | `email` (PK) |
| `prodotto` | Catalogo con prezzo, IVA, quantità, stato attivo | `id` (PK) |
| `categoria` | Categorie dei prodotti | `id` (PK) |
| `foto` | Immagini associate ai prodotti | `nome` (PK) |
| `carrello` | Carrello per utente | `id` (PK) |
| `prodottiCarrello` | Righe carrello con quantità | `(carrello, prodotto)` |
| `ordine` | Ordini effettuati con totale e stato | `id` (PK) |
| `prodottiOrdine` | Righe ordine con **prezzo e IVA storici** | `(ordine, prodotto)` |
| `recensione` | Recensioni degli utenti sui prodotti | `id` (PK) |

> **Integrità storica:** prezzo e IVA sono salvati direttamente nella riga d'ordine (`prodottiOrdine`), così le variazioni future del catalogo non alterano gli ordini passati.

---

## Funzionalità

### Area Cliente
- Registrazione con validazione campi (nome, cognome, email, password, indirizzo, CAP, città)
- Verifica in tempo reale disponibilità email tramite AJAX
- Login e logout con gestione sessione (`HttpSession`)
- Cifratura password con SHA-256
- Navigazione catalogo prodotti con barra di ricerca AJAX e suggerimenti dinamici
- Gestione carrello (aggiunta, modifica quantità, rimozione)
- Conferma ordine con svuotamento carrello
- Storico ordini del cliente
- Messaggi di conferma per tutte le azioni eseguite

### Area Amministratore
- Accesso protetto tramite `AuthFilter` + controllo ruolo `isAdmin`
- Dashboard con contatori in tempo reale (prodotti, utenti, ordini)
- **CRUD Prodotti**: inserimento, modifica, visualizzazione, cancellazione con richiesta di conferma
- Visualizzazione elenco utenti ed eliminazione
- Visualizzazione di tutti gli ordini
- **Filtro ordini per intervallo di date** (dal / al)
- **Filtro ordini per cliente** (select popolato dinamicamente)

### Sicurezza
- `PreparedStatement` per tutte le query → prevenzione SQL Injection
- Password cifrate SHA-256 nel database
- `AuthFilter` su `/admin/*` → pagine admin inaccessibili senza sessione admin
- JSP protette in `WEB-INF/views/` → non raggiungibili direttamente via URL
- Pagine di errore personalizzate per codici 404, 500, 403

### Pattern e Architettura
- Pattern MVC rispettato
- Fragment JSP (`header.jsp`, `footer.jsp`) per componenti riutilizzabili
- DataSource JNDI con Connection Pool configurato in `context.xml`
- Package separati: `controller`, `controller.admin`, `model.bean`, `model.DAO`, `model.utils`
- Validazione form lato client con espressioni regolari e JavaScript
- Messaggi di errore inline (nessun `alert()`)
- Sito completamente responsive con media query

---

## Configurazione e Avvio

### 1. Database

```sql
source SQL/pokerShopCreation.sql
source SQL/pokerShopPopulation.sql
```

### 2. DataSource JNDI

Modifica `src/webapp/META-INF/context.xml` con le tue credenziali MySQL:

```xml
<Resource name="jdbc/pokerShop"
          auth="Container"
          type="javax.sql.DataSource"
          driverClassName="com.mysql.cj.jdbc.Driver"
          username="root"
          password="TUA_PASSWORD"
          url="jdbc:mysql://localhost:3306/pokerShop"/>
```

### 3. Crea il primo admin

```sql
INSERT INTO utente (email, nome, cognome, _password, isAdmin, indirizzo, _ncivico, cap, citta)
VALUES (
    'admin@pokershop.it', 'Admin', 'PokerShop',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
    true, 'Via Roma', 1, '00100', 'Roma'
);
```

L'hash corrisponde alla password `admin123`. Sostituiscilo con l'hash della tua password preferita.

### 4. Avvio in Eclipse

1. Importa come **Dynamic Web Project**
2. Tasto destro → **Run As → Run on Server** → Tomcat 9
3. Apri `http://localhost:8080/PokerShop`

---

## URL Principali

| URL | Accesso | Descrizione |
|---|---|---|
| `/` | Pubblica | Home page |
| `/login` | Pubblica | Login utente |
| `/logout` | Autenticato | Logout |
| `/registrazione` | Pubblica | Registrazione nuovo utente |
| `/admin/dashboard` | Admin | Dashboard con statistiche |
| `/admin/prodotti` | Admin | CRUD prodotti |
| `/admin/utenti` | Admin | Gestione utenti |
| `/admin/ordini` | Admin | Ordini con filtri |


## Verifica funzionamento pagine di errore
Errore 404: inserisci nell'url un path che non esiste
Errore 403: Decommenta l'if nel file HomeServlet.java alla riga 33
Errore 500: Decommenta l'if nel file HomeServlet.java alla riga 39
