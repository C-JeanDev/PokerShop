USE pokerShop;

-- =========================
-- CATEGORIE
-- =========================
INSERT INTO categoria (nome) VALUES 
('arredamento'),
('fiches'),
('mazzi di carte');

-- =========================
-- PRODOTTI - ARREDAMENTO
-- =========================
INSERT INTO prodotto (nome, prezzoListino, prezzoFinale, descrizione, iva, isActive, qt, categoria)
VALUES
('Tavolo da Poker Pro', 499.99, 449.99, 'Tavolo professionale da poker con panno verde', 22, TRUE, 10,
 (SELECT id FROM categoria WHERE nome='arredamento')),

('Tavolo da Poker Foldable', 299.99, 269.99, 'Tavolo pieghevole per uso domestico', 22, TRUE, 15,
 (SELECT id FROM categoria WHERE nome='arredamento')),

('Tappetino da Poker Green', 39.99, 34.99, 'Tappetino in neoprene antiscivolo', 22, TRUE, 50,
 (SELECT id FROM categoria WHERE nome='arredamento')),

('Tappetino da Poker Deluxe', 59.99, 49.99, 'Tappetino professionale con bordi cuciti', 22, TRUE, 30,
 (SELECT id FROM categoria WHERE nome='arredamento')),

('Sedia da Poker Comfort', 129.99, 109.99, 'Sedia ergonomica per lunghe sessioni', 22, TRUE, 20,
 (SELECT id FROM categoria WHERE nome='arredamento'));

-- =========================
-- PRODOTTI - FICHES
-- =========================
INSERT INTO prodotto (nome, prezzoListino, prezzoFinale, descrizione, iva, isActive, qt, categoria)
VALUES
('Set Fiches 300 pezzi', 29.99, 24.99, 'Set base per home game', 22, TRUE, 100,
 (SELECT id FROM categoria WHERE nome='fiches')),

('Set Fiches 500 pezzi Pro', 49.99, 44.99, 'Fiches professionali con valigetta', 22, TRUE, 80,
 (SELECT id FROM categoria WHERE nome='fiches')),

('Fiches Clay Composite', 79.99, 69.99, 'Fiches da torneo qualità casinò', 22, TRUE, 60,
 (SELECT id FROM categoria WHERE nome='fiches')),

('Valigetta Fiches Alluminio', 39.99, 35.99, 'Valigetta resistente con chiusura sicura', 22, TRUE, 70,
 (SELECT id FROM categoria WHERE nome='fiches')),

('Set Fiches High Stakes', 99.99, 89.99, 'Fiches premium per giochi ad alto livello', 22, TRUE, 40,
 (SELECT id FROM categoria WHERE nome='fiches'));

-- =========================
-- PRODOTTI - MAZZI DI CARTE
-- =========================
INSERT INTO prodotto (nome, prezzoListino, prezzoFinale, descrizione, iva, isActive, qt, categoria)
VALUES
('Mazzo Carte Poker Standard', 4.99, 3.99, 'Mazzo plastificato resistente', 22, TRUE, 200,
 (SELECT id FROM categoria WHERE nome='mazzi di carte')),

('Mazzo Carte Bicycle', 6.99, 5.99, 'Carte Bicycle originali da torneo', 22, TRUE, 150,
 (SELECT id FROM categoria WHERE nome='mazzi di carte')),

('Mazzo Carte Pro Plastic', 9.99, 8.99, 'Carte 100% plastica professionali', 22, TRUE, 120,
 (SELECT id FROM categoria WHERE nome='mazzi di carte')),

('Mazzo Carte Copag 1546', 12.99, 11.49, 'Carte da casinò ultra resistenti', 22, TRUE, 90,
 (SELECT id FROM categoria WHERE nome='mazzi di carte')),

('Mazzo Carte Premium Index', 14.99, 12.99, 'Carte con indice jumbo per visibilità', 22, TRUE, 80,
 (SELECT id FROM categoria WHERE nome='mazzi di carte'));