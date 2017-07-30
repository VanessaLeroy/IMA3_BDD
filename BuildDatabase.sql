DROP TABLE "Institut" CASCADE;
DROP TABLE "Personne" CASCADE;
DROP TABLE "Appartient" CASCADE;
DROP TABLE "Association" CASCADE;
DROP TABLE "Envoie" CASCADE;
DROP TABLE "Etudiant" CASCADE;
DROP TABLE "Evenement" CASCADE;
DROP TABLE "Membre" CASCADE;
DROP TABLE "Professeur" CASCADE;
DROP TABLE "Publication" CASCADE;
DROP TABLE "Relation" CASCADE;
DROP TABLE "Visite" CASCADE;
DROP DOMAIN "GRADE" CASCADE;
DROP DOMAIN "QUARTIER" CASCADE;
DROP DOMAIN "ROLE" CASCADE;

CREATE TABLE "Institut"(
	"Nom" CHAR(10),
	"Password" CHAR(10),
	PRIMARY KEY ("Nom")
);

CREATE TABLE "Personne"(
	"Mail" CHAR(30),
	"Nom" CHAR(50) NOT NULL,
	"Prénom" CHAR(50) NOT NULL,
	"NomInstitut" CHAR(10) NOT NULL,
	"Password" CHAR(10) NOT NULL,
	"Type" CHAR(10),
	PRIMARY KEY ("Mail"),
	FOREIGN KEY ("NomInstitut") REFERENCES "Institut" ("Nom") ON DELETE CASCADE, 
	CHECK ("Type" IN ('Professeur','Etudiant'))
);

CREATE TABLE "Professeur"(
	"Mail" CHAR(30),
	PRIMARY KEY ("Mail"),
	FOREIGN KEY ("Mail") REFERENCES "Personne" ("Mail") ON DELETE CASCADE
);

CREATE DOMAIN "GRADE" CHAR(6)
	CHECK (VALUE IN ('L1','L2','L3','M1','M2','D'));

CREATE DOMAIN "QUARTIER" CHAR(20)
	CHECK (VALUE IN ('Belle Beille', 'Verneau', 'Centre', 'Madeleine', 'Justices', 'Roseraie', 'Monplaisir', 'Doutre', 'HorsAngers', 'Autres'));

CREATE DOMAIN "ROLE" CHAR (9)
	CHECK (VALUE IN ('Président','Membre'));
	
CREATE TABLE "Etudiant"(
	"Mail" CHAR(30),
	"DateDeNaissance" CHAR(10) NOT NULL,
	"Grade" "GRADE",
	"Quartier" "QUARTIER",
	"DateDernièreCo" CHAR (8),
	"HeureDernièreCo" Char (8),
	"Connecté" BOOLEAN,
	PRIMARY KEY ("Mail"),
	FOREIGN KEY ("Mail") REFERENCES "Personne" ("Mail") ON DELETE CASCADE 
);

CREATE TABLE "Relation"(
	"Suiveur" CHAR(30) NOT NULL,
	"Suivi" CHAR(30) NOT NULL,
	PRIMARY KEY ("Suiveur", "Suivi"),
	FOREIGN KEY ("Suiveur") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE,
	FOREIGN KEY ("Suivi") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE
);

CREATE TABLE "Envoie"(
	"Date" CHAR(8),
	"Heure" CHAR(8),
	"Texte" CHAR(1000) NOT NULL,
	"Destinataire" CHAR(30),
	"Emetteur" CHAR(30),
	PRIMARY KEY ("Date", "Heure", "Destinataire", "Emetteur"),
	FOREIGN KEY ("Destinataire") REFERENCES "Personne" ("Mail") ON DELETE CASCADE,
	FOREIGN KEY ("Emetteur") REFERENCES "Personne" ("Mail") ON DELETE CASCADE
);

CREATE TABLE "Association"(
	"Nom" CHAR(30),
	"Description" CHAR(100) NOT NULL,
	PRIMARY KEY ("Nom")
);

CREATE TABLE "Membre"(
	"Role" "ROLE" NOT NULL,
	"MailEtudiant" CHAR(30),
	"NomAssociation" CHAR(30),
	PRIMARY KEY ("NomAssociation", "MailEtudiant"),
	FOREIGN KEY ("NomAssociation") REFERENCES "Association" ("Nom") ON DELETE CASCADE,
	FOREIGN KEY ("MailEtudiant") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE
);

CREATE TABLE "Appartient"(
	"NomInstitut" CHAR(10),
	"NomAssociation" CHAR(30),
	PRIMARY KEY ("NomAssociation", "NomInstitut"),
	FOREIGN KEY ("NomAssociation") REFERENCES "Association" ("Nom") ON DELETE CASCADE,
	FOREIGN KEY ("NomInstitut") REFERENCES "Institut" ("Nom") ON DELETE CASCADE
);

CREATE TABLE "Evenement"(
	"Date" CHAR(8),
	"Nom" CHAR(30),
	"Lieu" CHAR(30) NOT NULL,
	"NomAssociation" CHAR(30),
	"Description" CHAR(1000) NOT NULL,
	PRIMARY KEY ("Nom", "Date"),
	FOREIGN KEY ("NomAssociation") REFERENCES "Association" ("Nom") ON DELETE CASCADE
);

CREATE TABLE "Publication"(
	"Date" CHAR(8),
	"Heure" CHAR(8),
	"MailEtudiant" CHAR(30),
	"Contenu" CHAR(1000),
	PRIMARY KEY ("Date", "Heure", "MailEtudiant"),
	FOREIGN KEY ("MailEtudiant") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE
);

CREATE TABLE "Visite"(
	"Date" CHAR(8),
	"Heure" CHAR(8),
	"Visiteur" CHAR(30),
	"Visite" CHAR(30),
	PRIMARY KEY ("Date", "Heure", "Visiteur", "Visite"),
	FOREIGN KEY ("Visiteur") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE,
	FOREIGN KEY ("Visite") REFERENCES "Etudiant" ("Mail") ON DELETE CASCADE
)