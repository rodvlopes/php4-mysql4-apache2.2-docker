CREATE TABLE contacts (
  id INTEGER PRIMARY KEY,
  name VARCHAR(40) NOT NULL,
  email VARCHAR(60),
  since DATE
);
INSERT INTO contacts (name, email, since) VALUES ('Alice Silva', 'alice@example.com', '2003-05-12');
INSERT INTO contacts (name, email, since) VALUES ('Bruno Costa', 'bruno@example.com', '2004-08-25');
INSERT INTO contacts (name, email, since) VALUES ('Carla Souza', 'carla@example.com', '2005-06-08');
