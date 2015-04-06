DROP DATABASE IF EXISTS market;
CREATE DATABASE market;
USE market;

CREATE TABLE IF NOT EXISTS toimipaikka (  toimipaikkaid INT(8) AUTO_INCREMENT PRIMARY KEY,
                            henkilokunta INT(16),
                            palkkamaksu INT(32),
                            varastotunnus INT(8)
                        )ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS henkilokunta ( hetu INT(16) NOT NULL,
                            toimipaikka INT(8),
                            palkkamaksu INT(32),
                            etunimi VARCHAR(16) NOT NULL,
                            sukunimi VARCHAR(32) NOT NULL,
                            veroprosentti FLOAT(8) NOT NULL,
                            tilinumero VARCHAR(32) NOT NULL,
                            puhelinnumero INT(32) NOT NULL,
                            CONSTRAINT PK_HenkilokuntaMyyja PRIMARY KEY (hetu, etunimi),
                            FOREIGN KEY (toimipaikka) REFERENCES toimipaikka(toimipaikkaid)
                        )ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS hkTunnus ( tunnus VARCHAR(16) PRIMARY KEY,
                        salasana VARCHAR(32) NOT NULL
                    )ENGINE=InnoDB;

/* Luodaan ylläolevaan hkTunnus-tauluun salasanatiiviste ja käyttäjätunnus */
CREATE TRIGGER salasana AFTER INSERT ON henkilokunta
    FOR EACH ROW
        INSERT INTO hkTunnus VALUES (CONCAT(LEFT(NEW.etunimi,3), RIGHT(NEW.sukunimi,3)),SHA1(CONCAT(MID(NEW.puhelinnumero,3))));
                        
CREATE TABLE IF NOT EXISTS palkkamaksu (  palkkamaksuid INT(32) AUTO_INCREMENT PRIMARY KEY,
                            toimipaikka INT(8),
                            FOREIGN KEY (toimipaikka) REFERENCES toimipaikka(toimipaikkaid),
                            paivays TIMESTAMP,
                            tilinumero INT(32) NOT NULL,
                            veroprosentti FLOAT(8) NOT NULL,
                            palkka FLOAT(32) NULL,
                            tuntimaara FLOAT(32) NULL
                        )ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS varasto (      toimipaikka INT(8),
                            FOREIGN KEY (toimipaikka) REFERENCES toimipaikka(toimipaikkaid),
                            tuote INT(8),
                            CONSTRAINT PK_Varasto PRIMARY KEY (toimipaikka, tuote),
                            saldo INT(8) NULL
                    )ENGINE=InnoDB;
                    
CREATE TABLE IF NOT EXISTS tuote (        tuotenumero INT(8) PRIMARY KEY,
                            varasto INT(8),
                            FOREIGN KEY (varasto) REFERENCES toimipaikka(toimipaikkaid),
                            tuotenimi VARCHAR(16) NOT NULL,
                            tuoteseloste VARCHAR(32) NOT NULL
                )ENGINE=InnoDB;

/*Luodaan tuotteita lisättäessä herätin, joka lisää tuotteen tiedon varastoon, myöhemmin voidaan poistaa */
CREATE TRIGGER varastoSaldo AFTER INSERT ON tuote
    FOR EACH ROW
        INSERT INTO varasto VALUES (NEW.varasto,NEW.tuotenumero,200);
                            
CREATE TABLE IF NOT EXISTS tuotelista (   ostotapahtumaid INT(8),
                            tuote INT(8),
                            FOREIGN KEY (tuote) REFERENCES tuote(tuotenumero),
                            asiakas INT(8),
                            CONSTRAINT PK_Ostotuote PRIMARY KEY (ostotapahtumaid, asiakas),
                            kappalemaara INT(32) NOT NULL
                        )ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ostotapahtuma (    tapahtumanumero INT(8) AUTO_INCREMENT PRIMARY KEY,
                                asiakas INT(8) NOT NULL,
                                tuotelista INT(8) NOT NULL,
                                toimipaikka INT(8) NOT NULL,
                                aikaleima TIMESTAMP NOT NULL
                        )ENGINE=InnoDB;
                        
CREATE TABLE IF NOT EXISTS asiakas (      asiakasid INT(8) AUTO_INCREMENT PRIMARY KEY,
                            nimi VARCHAR(16) NULL,
                            sukunimi VARCHAR(32) NULL,
                            maksuvaline VARCHAR(8) NOT NULL
                    )ENGINE=InnoDB;


/* Lisätään näin aloittelijoina constraint foreign keyt alterin kautta ÄLÄ KÄYTÄ EI TOIMI KAIKKI */            
ALTER TABLE toimipaikka ADD CONSTRAINT FK_tpHenku FOREIGN KEY (henkilokunta) REFERENCES henkilokunta(hetu);
ALTER TABLE toimipaikka ADD CONSTRAINT FK_tpPalkka FOREIGN KEY (palkkamaksu) REFERENCES palkkamaksu(palkkamaksuid);
ALTER TABLE toimipaikka ADD CONSTRAINT FK_tpVaratu FOREIGN KEY(varastotunnus) REFERENCES varasto(toimipaikka);
ALTER TABLE henkilokunta ADD CONSTRAINT FK_hkPalkka FOREIGN KEY (palkkamaksu) REFERENCES palkkamaksu(palkkamaksuid);
ALTER TABLE varasto ADD CONSTRAINT FK_varTuote FOREIGN KEY (tuote) REFERENCES tuote(tuotenumero);
ALTER TABLE tuotelista ADD CONSTRAINT FK_tlOstoid FOREIGN KEY (ostotapahtumaid) REFERENCES ostotapahtuma(tapahtumanumero);
ALTER TABLE ostotapahtuma ADD CONSTRAINT FK_ostAsiakas FOREIGN KEY (asiakas) REFERENCES asiakas(asiakasid);
ALTER TABLE ostotapahtuma ADD CONSTRAINT FK_ostTuoteli FOREIGN KEY (tuotelista) REFERENCES tuotelista(ostotapahtumaid);
ALTER TABLE ostotapahtuma ADD CONSTRAINT FK_ostToimip FOREIGN KEY (toimipaikka) REFERENCES toimipaikka(toimipaikkaid);

/* Tietoa hieman tauluihin */   
INSERT INTO toimipaikka(toimipaikkaid) VALUES (1);

INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (2060251,1,"Nukkisilo","Mustikka",112.3,"FI247844442",202020);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (2068251,1,"Pekka","Puta",172.3,"FI248644442",0290202);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (1206821,1,"Pouko","Jumppanen",112.3,"FI2442684442",0207202);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (120251199,1,"Risto","Kampaaja",126.3,"FI24444444442",0201202);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (102351199,1,"Fiini","Viini",121.3,"FI2444824442",0250202);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (102251199,1,"Mulle","Lompakkonen",121.3,"FI2446444442",0202202);
INSERT INTO henkilokunta(hetu,toimipaikka,etunimi,sukunimi,veroprosentti,tilinumero,puhelinnumero) VALUES (1202513199,1,"Elias","Saunalahti",122.3,"FI24473444442",0220202);

INSERT INTO tuote VALUES (1,1,"Kookos","Egyptistä kookosta");
INSERT INTO tuote VALUES (2,1,"Omena","Egyptistä omenaa");
INSERT INTO tuote VALUES (3,1,"Hunajameloni","Egyptistä hunajamelonia");
INSERT INTO tuote VALUES (4,1,"Kirsikka","Italiasta kirsikkaa");
INSERT INTO tuote VALUES (5,1,"Granaattiomena","Espanjasta granaattia");
INSERT INTO tuote VALUES (6,1,"Banaani","Siperiasta banaani");
INSERT INTO tuote VALUES (7,1,"Basilika","Amurikkalaista basilikaa");
INSERT INTO tuote VALUES (8,1,"Tomaatti","Somaliasta tomaattia");
INSERT INTO tuote VALUES (9,1,"Kurkku","Egyptistä kurkkua");

INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Pekka","Rautanen","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Liisa","Kulkunen","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Toma","CusCus","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("","","kateinen");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Laura","Erkkinen","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("","","kateinen");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Ryti","Risto","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Taavi","Ankka","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Diiva","Rautanen","kortti");
INSERT INTO asiakas (nimi, sukunimi, maksuvaline) VALUES ("Liisa","Lissunen","kortti");

/* LUODAAN NÄKYMÄ henkilökunnan tunnuksille */

DROP VIEW IF EXISTS tunnusTaulu;
CREATE VIEW tunnusTaulu AS SELECT h.hetu, h.etunimi, h.sukunimi, sa.tunnus, sa.salasana FROM henkilokunta h, hkTunnus sa WHERE sa.tunnus=(CONCAT(LEFT(etunimi,3),RIGHT(sukunimi,3)));
SELECT * FROM tunnusTaulu;

/* LUODAAN NÄKYMÄ tuotteille varastossa */

DROP VIEW IF EXISTS varastoTuote;
CREATE VIEW varastoTuote AS SELECT v.toimipaikka, v.tuote, t.tuotenimi, t.tuoteseloste, v.saldo FROM varasto v, tuote t WHERE t.tuotenumero = v.tuote;
SELECT * FROM varastoTuote;
