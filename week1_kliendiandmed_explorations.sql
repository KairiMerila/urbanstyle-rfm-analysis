-- Nädal1 gupitöö, BALAÜLESANDE KAART B: Kliendiandmed

/*Mina uurisin customers tabelit. Leidsin, et seal on 3150 rida ja veerud nagu customer_id, first_name, last_name, email, phone, city, registration_date, loyalty_tier ja birth_year. Andmetes on esindatud erinevad Eesti linnad ning klientide registreerimine jääb vahemikku 2020-01-02 kuni 2025-02-27. Samuti leidsin, et eesnimed ei ole puudu, kuid 380 kliendil puudub e-maili aadress. See tähendab UrbanStyle'ile, et kliendiandmed on üldiselt terviklikud ja sobivad analüüsiks, kuid e-mailide puudumine võib piirata turundustegevusi./*


--1. Uuri klientide koguarvu:
-- Mitu klienti on kokku? 3150
SELECT COUNT(*) AS klientide_arv 
FROM customers;
-- Mitu klienti on kokku? 3150


--2. Vaata tabeli sisu. Too välja esimesed 10 rida, et näha veergude struktuuri:
-- Millised veerud ja andmed tabelis on? Select taga oli tärn puudu ning saadud veerud on - customer_id,first_name,last_name,email,phone,city,registration_date,loyalty_tier,birth_year

SELECT* 
FROM customers LIMIT 10; 


--3. Uuri linnade jaotust. Millistest linnadest kliendid tulevad?
-- Millised linnad on esindatud? Haapsalu, Jõhvi, Kuressaare, Narva, Paida, Rakvere, Tallinn, Tartu, Viljandi, Võru (54 rida, tahaks puhastada aga pole sinnani veel jõudnud)
SELECT
DISTINCT city 
FROM customers;


--4. 1. Filtreeri kindla linna kliendid. Kasuta WHERE tingimust:
-- Tallinna kliendid, sorteeritud nime järgi (SELECT taga puudus tärn ning ei andnud tulemust, soovisin ise lisada ka veel eesnime filtri)
SELECT *
FROM customers
WHERE city = 'Tallinn'
ORDER BY last_name ASC, first_name ASC
LIMIT 15;


--5. Kontrolli registreerimise kuupäevi. Millal esimesed ja viimased kliendid registreerusid?
-- Vanim ja uusim registreerimine (vanim 2020-01-02, uusim 2025-02-27) 
SELECT MIN(registration_date) AS vanim, MAX(registration_date) AS uusim    
FROM customers; 


--6. Kontrolli puuduvaid väärtusi:
-- Mitu klienti, kus eesnimi on puudu? 0 
SELECT COUNT(*) - COUNT(first_name) AS puuduvad_eesnimed    
FROM customers;


-- Mitu klienti, kus e-mail on puudu? 380   
SELECT COUNT(*) - COUNT(email) AS puuduvad_emailid
FROM customers;