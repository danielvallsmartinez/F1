CREATE USER IF NOT EXISTS 'analythic_user'@'localhost';
CREATE USER IF NOT EXISTS 'manager_user'@'localhost';
CREATE USER IF NOT EXISTS 'rrhh_user'@'localhost';

GRANT Create User ON * . * TO 'rrhh_user'@'localhost';
GRANT Update, trigger, insert, event, drop, alter ON * . * TO 'manager_user'@'localhost';
GRANT Select ON F1Olap.* TO 'analythic_user'@'localhost'; -- show view i create view
