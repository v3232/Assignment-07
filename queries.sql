-- Some fraudsters hack a credit card by making several small transactions (generally less than $2.00), which are typically ignored by cardholders.
-- How can you isolate (or group) the transactions of each cardholder?
SELECT c.cardholder_id, c.card, t.id, t.date, t.amount, t.id_merchant
FROM credit_card c
JOIN transaction t ON c.card = t.card
ORDER BY c.cardholder_id;


-- Count the transactions that are less than $2.00 per cardholder.
SELECT COUNT (*) AS transaction_count_less_than_$2
FROM transaction;



-- Take your investigation a step futher by considering the time period in which potentially fraudulent transactions are made.
-- What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT * FROM transaction
WHERE DATE_PART('HOUR', transaction .date) >= 7 AND DATE_PART('HOUR', transaction .date) < 9
ORDER BY amount DESC LIMIT 100; 


-- Do you see any anomalous transactions that could be fraudulent?
SELECT * FROM transaction
WHERE DATE_PART('HOUR', transaction .date) >= 7 AND DATE_PART('HOUR', transaction .date) < 9
		AND amount <= 2.00;

-- Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
SELECT COUNT(*) FROM transaction
WHERE DATE_PART('HOUR', transaction .date) >= 7 AND DATE_PART('HOUR', transaction .date) < 9
		AND amount <= 2.00;

SELECT COUNT(*) FROM transaction
WHERE (DATE_PART('HOUR', transaction .date) BETWEEN 0 AND 6 
		OR
		DATE_PART('HOUR', transaction .date) BETWEEN 9 AND 23) 
		AND amount <= 2.00;


-- What are the top 5 merchants prone to being hacked using small transactions?
SELECT m.id, m.name, COUNT(t.id_merchant) FROM merchant m
JOIN transaction t ON m.id = t.id_merchant
WHERE t.amount <= 2
GROUP BY m.id
ORDER BY COUNT(t.id_merchant) DESC LIMIT 5;
