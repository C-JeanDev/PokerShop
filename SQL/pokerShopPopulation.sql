USE pokerShop;

-- ============================================================================
-- 1. CATEGORIE
-- ============================================================================
INSERT INTO categoria (nome) VALUES 
('arredamento'),
('fiches'),
('mazzi di carte');


-- ============================================================================
-- 2. PRODOTTI
-- ============================================================================

-- Arredamento
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

-- Fiches
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

-- Mazzi di carte
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


-- ============================================================================
-- 3. FOTO DEI PRODOTTI (2 foto per ciascun prodotto)
-- ============================================================================

-- Foto: Tavolo da Poker Pro
INSERT INTO foto (nome, _path, prodotto) VALUES 
('tavolo_pro_1.jpg', 'img/products/tavolo_pro_1.jpg', (SELECT id FROM prodotto WHERE nome='Tavolo da Poker Pro')),
('tavolo_pro_2.jpg', 'img/products/tavolo_pro_2.jpg', (SELECT id FROM prodotto WHERE nome='Tavolo da Poker Pro'));

-- Foto: Tavolo da Poker Foldable
INSERT INTO foto (nome, _path, prodotto) VALUES 
('tavolo_fold_1.jpg', 'img/products/tavolo_fold_1.jpg', (SELECT id FROM prodotto WHERE nome='Tavolo da Poker Foldable')),
('tavolo_fold_2.jpg', 'img/products/tavolo_fold_2.jpg', (SELECT id FROM prodotto WHERE nome='Tavolo da Poker Foldable'));

-- Foto: Tappetino da Poker Green
INSERT INTO foto (nome, _path, prodotto) VALUES 
('tappeto_gr_1.jpg', 'img/products/tappeto_gr_1.jpg', (SELECT id FROM prodotto WHERE nome='Tappetino da Poker Green')),
('tappeto_gr_2.jpg', 'img/products/tappeto_gr_2.jpg', (SELECT id FROM prodotto WHERE nome='Tappetino da Poker Green'));

-- Foto: Tappetino da Poker Deluxe
INSERT INTO foto (nome, _path, prodotto) VALUES 
('tappeto_dlx_1.jpg', 'img/products/tappeto_dlx_1.jpg', (SELECT id FROM prodotto WHERE nome='Tappetino da Poker Deluxe')),
('tappeto_dlx_2.jpg', 'img/products/tappeto_dlx_2.jpg', (SELECT id FROM prodotto WHERE nome='Tappetino da Poker Deluxe'));

-- Foto: Sedia da Poker Comfort
INSERT INTO foto (nome, _path, prodotto) VALUES 
('sedia_comf_1.jpg', 'img/products/sedia_comf_1.jpg', (SELECT id FROM prodotto WHERE nome='Sedia da Poker Comfort')),
('sedia_comf_2.jpg', 'img/products/sedia_comf_2.jpg', (SELECT id FROM prodotto WHERE nome='Sedia da Poker Comfort'));

-- Foto: Set Fiches 300 pezzi
INSERT INTO foto (nome, _path, prodotto) VALUES 
('fiches_300_1.jpg', 'img/products/fiches_300_1.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches 300 pezzi')),
('fiches_300_2.jpg', 'img/products/fiches_300_2.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches 300 pezzi'));

-- Foto: Set Fiches 500 pezzi Pro
INSERT INTO foto (nome, _path, prodotto) VALUES 
('fiches_500_1.jpg', 'img/products/fiches_500_1.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches 500 pezzi Pro')),
('fiches_500_2.jpg', 'img/products/fiches_500_2.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches 500 pezzi Pro'));

-- Foto: Fiches Clay Composite
INSERT INTO foto (nome, _path, prodotto) VALUES 
('fiches_clay_1.jpg', 'img/products/fiches_clay_1.jpg', (SELECT id FROM prodotto WHERE nome='Fiches Clay Composite')),
('fiches_clay_2.jpg', 'img/products/fiches_clay_2.jpg', (SELECT id FROM prodotto WHERE nome='Fiches Clay Composite'));

-- Foto: Valigetta Fiches Alluminio
INSERT INTO foto (nome, _path, prodotto) VALUES 
('valig_all_1.jpg', 'img/products/valig_all_1.jpg', (SELECT id FROM prodotto WHERE nome='Valigetta Fiches Alluminio')),
('valig_all_2.jpg', 'img/products/valig_all_2.jpg', (SELECT id FROM prodotto WHERE nome='Valigetta Fiches Alluminio'));

-- Foto: Set Fiches High Stakes
INSERT INTO foto (nome, _path, prodotto) VALUES 
('fiches_high_1.jpg', 'img/products/fiches_high_1.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches High Stakes')),
('fiches_high_2.jpg', 'img/products/fiches_high_2.jpg', (SELECT id FROM prodotto WHERE nome='Set Fiches High Stakes'));

-- Foto: Mazzo Carte Poker Standard
INSERT INTO foto (nome, _path, prodotto) VALUES 
('carte_std_1.jpg', 'img/products/carte_std_1.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Poker Standard')),
('carte_std_2.jpg', 'img/products/carte_std_2.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Poker Standard'));

-- Foto: Mazzo Carte Bicycle
INSERT INTO foto (nome, _path, prodotto) VALUES 
('carte_bicy_1.jpg', 'img/products/carte_bicy_1.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Bicycle')),
('carte_bicy_2.jpg', 'img/products/carte_bicy_2.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Bicycle'));

-- Foto: Mazzo Carte Pro Plastic
INSERT INTO foto (nome, _path, prodotto) VALUES 
('carte_plast_1.jpg', 'img/products/carte_plast_1.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Pro Plastic')),
('carte_plast_2.jpg', 'img/products/carte_plast_2.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Pro Plastic'));

-- Foto: Mazzo Carte Copag 1546
INSERT INTO foto (nome, _path, prodotto) VALUES 
('carte_copag_1.jpg', 'img/products/carte_copag_1.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Copag 1546')),
('carte_copag_2.jpg', 'img/products/carte_copag_2.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Copag 1546'));

-- Foto: Mazzo Carte Premium Index
INSERT INTO foto (nome, _path, prodotto) VALUES 
('carte_prem_1.jpg', 'img/products/carte_prem_1.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Premium Index')),
('carte_prem_2.jpg', 'img/products/carte_prem_2.jpg', (SELECT id FROM prodotto WHERE nome='Mazzo Carte Premium Index'));