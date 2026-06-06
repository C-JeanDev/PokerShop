create schema IF NOT EXISTS pokerShop;

use pokerShop;

-- UTENTE 
create table utente(
	email char(35) primary key,
    nome char(30) not null,
    cognome char(30) not null,
    _password varchar(255) not null,
    isAdmin BOOLEAN not null,
    indirizzo char(30) not null,
    _ncivico int not null,
    cap char(5) not null,
    citta char(20) not null
);

-- CARRELLO
create table carrello(
	id  int auto_increment primary key,
    utente char(35) not null,
    constraint proprietarioCart
		foreign key (utente) references utente(email)
		on delete cascade on update cascade
);

-- CATEGORIA
create table categoria(
	id int auto_increment primary key, 
    nome char(30) not null
);

-- PRODOTTO 
create table prodotto(
	id int auto_increment primary key,
    nome char(30) not null,
    prezzoListino double not null,
    prezzoFinale double not null,
    descrizione char(250) not null,
    iva int not null,
    isActive BOOLEAN not null,
    qt int not null,
    categoria int not null,
    constraint cat 
		foreign key (categoria) references categoria(id)
		on delete restrict on update cascade
    
);

create table foto(
	nome char(20) primary key,
    _path char(150) not null,
    prodotto int not null,
    constraint prd 
		foreign key (prodotto) references prodotto(id)
		on delete cascade on update cascade
);



-- ORDINE 
create table ordine(
	id int auto_increment primary key,
    costoTot double not null,
    _data DATE not null,
    stato char(2) not null,
    utente char(35) not null,
    constraint proprietario 
		foreign key (utente) references utente(email)
		on delete cascade on update cascade
);

-- RECENSIONE 
create table recensione (
	id int auto_increment primary key,
    descrizione char(250) not null,
    _data DATE not null,
    utente char(35) not null,
    prodotto int not null,
    constraint proprietarioRecensione
		foreign key (utente) references utente(email)
		on delete cascade on update cascade,
	constraint prodottoRecensione 
		foreign key (prodotto) references prodotto(id)
		on delete cascade on update cascade
);

-- PRODOTTI CARRELLO 
create table prodottiCarrello (
	carrello int not null,
	prodotto int not null,
    qt int not null,
    primary key (carrello, prodotto),
    constraint carrellock 
		foreign key (carrello) references carrello(id)
		on delete cascade on update cascade,
	constraint prodottock 
		foreign key (prodotto) references prodotto(id)
		on delete cascade on update cascade
);

-- PRODOTTI ORDINE 
create table prodottiOrdine (
	ordine int not null,
	prodotto int not null,
    iva int not null,
    prezzo double not null,
    qt int not null,
    primary key (ordine, prodotto),
    constraint ordineCk 
		foreign key (ordine) references ordine(id)
		on delete cascade on update cascade,
	constraint prodottoOrdine
		foreign key (prodotto) references prodotto(id)
		on delete restrict on update cascade
);

