--w3, roll B: Kliendid ilma ostudeta

--1. Leia kliendid, kellel pole ühtegi ostu: Sain 599 rida
-- LEFT JOIN: kõik kliendid, ka need kellel pole oste    
SELECT
  c.first_name,
  c.last_name,
  c.email,
  c.city,
  c.registration_date,
  s.sale_id    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;    -- Kui sale_id on NULL, siis klient pole kunagi ostnud! 


--2. Loe kokku, mitu "kadunud" klienti on: 599
SELECT COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;


--3. Analüüsi kadunud kliente linnade kaupa: 12 rida kadunud kliente. Kõige rohkem Tallinn 231, Tartu 133, Pärnu 70 jne
SELECT c.city, COUNT(*) AS kadunud_kliente
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    
GROUP BY c.city    
ORDER BY kadunud_kliente DESC; 


--4. Uuri registreerimise kuupäeva:
-- Millal kadunud kliendid registreerusid? Vahemikul 2020-01-02 - 2025-02-27
SELECT c.first_name || ' ' || c.last_name AS klient,       
  c.registration_date,
  c.city,
  c.loyalty_tier    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    
ORDER BY c.registration_date DESC;  


--5. Võrdle kadunud vs aktiivsete klientide arvu:
SELECT        
CASE            
WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            
ELSE 'Aktiivne (on ostnud)'        
END AS staatus, COUNT(DISTINCT c.customer_id) AS kliente    
FROM customers c    LEFT JOIN sales s ON c.customer_id = s.customer_id    
GROUP BY        
CASE            
WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            
ELSE 'Aktiivne (on ostnud)' END; 

--staatus,                kliente
--Aktiivne (on ostnud),   2551
--Kadunud (pole ostnud),  599