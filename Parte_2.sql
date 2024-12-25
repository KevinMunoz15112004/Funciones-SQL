CREATE DATABASE Parte2;

USE Parte2;

CREATE TABLE Productos(
	ProductoID INT AUTO_INCREMENT PRIMARY KEY,
    Existencia INT,
    Precio DECIMAL(10, 2)
);

CREATE TABLE Ordenes(
	OrdenID INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT,
    cantidad INT,
    FOREIGN KEY (producto_id) REFERENCES Productos(ProductoID)
);

CREATE TABLE Transacciones(
    cuenta_id INT AUTO_INCREMENT PRIMARY KEY,
    tipo_transacción ENUM("deposito", "retiro"),
    monto DECIMAL(10, 2)
);

-- EJERCICIO 1:

DELIMITER $$

CREATE FUNCTION CalcularTotalOrden(id_orden INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE total DECIMAL(10, 2);
    DECLARE iva DECIMAL(10, 2);
    
    SET iva = 0.15;
    
    SELECT SUM(P.precio * O.cantidad) INTO total
    FROM Ordenes O
    JOIN Productos P ON  O.producto_id = P.ProductoID
    WHERE O.OrdenID = id_orden;
    
    SET total = total + (total + iva);
    
    RETURN total;
END $$

DELIMITER ;

-- EJERCICIO 2:

DELIMITER $$

CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE)
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE edad INT;
    SET edad = TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
    RETURN edad;
END $$

DELIMITER ;

-- EJERCICIO 3:

DELIMITER $$

CREATE FUNCTION VerificarStock(producto_id INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE stock INT;
    SELECT Existencia INTO stock
    FROM Productos 
    WHERE ProductoID = producto_id;
    
    IF stock > 0 THEN
		RETURN TRUE;
	ELSE 
		RETURN FALSE;
	END IF;
END $$

DELIMITER ;
    
-- EJERCICIO 4:

DELIMITER $$

CREATE FUNCTION CalcularSaldo(id_cuenta INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE saldo DECIMAL(10, 2);
    
    SELECT SUM(CASE
    WHEN tipo_transacción = 'deposito' THEN monto
    WHEN tipo_transacción = 'retiro' THEN -monto
    ELSE 0
    END) INTO saldo
    FROM Transacciones 
    WHERE cuenta_id = id_cuenta;
    
    RETURN saldo;
END $$

DELIMITER ;

-- EJECUCIÓN:

-- Ejercicio 1:
SELECT CalcularTotalOrden(1) AS TotalOrden;

-- Ejercicio 2:
SELECT CalcularEdad('2000-03-15') AS Edad;

-- Ejercicio 3:
SELECT VerificarStock(1) AS StockDisponible;

-- Ejercicio 4:
SELECT CalcularSaldo(1) AS SaldoTotal;



