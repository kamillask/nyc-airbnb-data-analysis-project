SELECT * FROM reviewsdata;
DESCRIBE reviewsdata;

#setting data types
ALTER TABLE reviewsdata
MODIFY COLUMN date DATE,
MODIFY COLUMN num_reviews INT;