--2 inimest Roll A: müük + tooted

--ALAÜLESANDE KAART A: Müügiandmete Puhastamine

--Samm 1. Loo test koopia (ära tööta production tabelil!):
drop table sales_test;  ---enne pean olemasoleva tabeli kustutama, sest oli juba varasemalt olemas
CREATE TABLE sales_test AS SELECT * FROM sales;  --see oli mul juba loodud

-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test;  --15234


--Samm 2. Leia duplikaadid — millised tellimused korduvad? Kirjuta üles: duplikaatset sale_id. Üle 100 rea, seega ei hakka kõiki kirjutama – 2706 (6tk), 4256 (6tk)
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;


--Samm 3. Loe kokku duplikaatsete ridade arv:
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY sale_id
);
Kirjuta üles: 5116 rida on duplikaadid.


--Samm 4. Leia NULL väärtused kriitilistes väljades:
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;
Kirjuta üles: 1487 NULL customer_id, 0 NULL sale_date, 0 NULL total_price.

--Samm 5. Kontrolli kuupäevade formaati — kas on tuleviku kuupäevi?
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;
Kirjuta üles: 8 tuleviku kuupäeva.


SELECT COUNT(*) FROM sales_test
WHERE column_name IS NULL;


--ALAÜLESANDE KAART C: Tooteandmete Puhastamine

CREATE TABLE products_test AS SELECT * FROM products;
SELECT COUNT(*) AS ridade_arv FROM products_test;
--Kirjuta üles: 362 rida.

--Samm 2. Leia duplikaadid — kas on korduvaid tootenimesid?
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;
--Kirjuta üles: 12 duplikaatset tootenime.
--product_name,koopiate_arv
--Moodne keraamiline sall,2
--Luksuslik teksane polo särk,2
--Stiilne puust müts,2
--Moodne villane nahk sandaalid,2
--Luksuslik keraamiline elastne vöö,2
--Minimalistlik kashmiir bleiser,2
--Klassikaline kashmiir pusa,2
--Stiilne orgaaniline pidžaama,2
--Praktiline trikoo sukkpüksid,2
--Kerge siidine nahkkindad,2
--Elegantne keraamiline rahakott,2
--Vintage nahkne tossud,2


-Samm 3. Leia NULL väärtused kriitilistes väljades:
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;
Kirjuta üles: 0 NULL nimi, 0 NULL kategooria, 0 NULL jaehind, 0 NULL omahind.
-- järeldus, tühjad väljad puuduvad

--Samm 4. Kontrolli loogilisi vigu — kas on ebareaalseid hindu?
-- Kas on negatiivseid hindu? 362
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE retail_price < 0;

-- Kas on äärmuslikke hindu (> 1000€)?
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;
Kirjuta üles: 0 negatiivset jaehinda, ei ole äärmuslikku jaehinda.


--Samm 5. Kontrolli kategooriate järjekindlust:
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;
Vaata: kas on "Shoes", "shoes", "SHOES", "Jalanõud" jne? Ei ole. Kirjuta üles: 5 erinevat kategooria väärtust.

--category,arv
--aksessuaarid,67
--jalanõusid,73
--laste_riided,70
--meeste_riided,82
--naiste_riided,70


SELECT category, COUNT(*)
FROM products_test
GROUP BY category;


--lisab tulemuse veerule nime (product_count) ja sorteerib kategooriad suurimast väikseimani
SELECT 
    category,
    COUNT(*) AS product_count
FROM products_test
GROUP BY category
ORDER BY product_count DESC;

category,product_count
meeste_riided,82
jalanõusid,73
laste_riided,70
naiste_riided,70
aksessuaarid,67

-- Ühtlusta kategooriate nimed
UPDATE products_test
SET category = INITCAP(TRIM(category))
WHERE category != INITCAP(TRIM(category));

-- Kontrolli tulemust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category ORDER BY category;

--Lisa CASE WHEN kategooriate standardiseerimiseks:
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;
