CREATE DATABASE IF NOT EXISTS dbPizzeriaCampus CHARACTER SET = 'utf8mb4' COLLATE = 'utf8mb4_unicode_ci';
USE dbPizzeriaCampus;
-- Tabla Tipo de producto 
CREATE TABLE IF NOT EXISTS TipoProducto (
    idTipoProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombreTipoProducto VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabla Productos
CREATE TABLE IF NOT EXISTS Productos (
    idProducto INT AUTO_INCREMENT PRIMARY KEY,
    nombreProducto VARCHAR(50) NOT NULL UNIQUE,
    idTipoProducto INT NOT NULL,
    precioProducto INT NOT NULL,
    FOREIGN KEY (idTipoProducto) REFERENCES TipoProducto(idTipoProducto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla Combos
CREATE TABLE IF NOT EXISTS Combos (
    idCombo INT AUTO_INCREMENT PRIMARY KEY,
    nombreCombo VARCHAR(50) NOT NULL UNIQUE,
    precioCombo INT NOT NULL,
    cantidadStockCombo INT NOT NULL
) ENGINE=InnoDB;

-- Tabla ProductosCombos
CREATE TABLE IF NOT EXISTS ProductosCombos (
    idProductoCombo INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT NOT NULL,
    idCombo INT NOT NULL,
    cantidadProductoCombo INT NOT NULL,
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idCombo) REFERENCES Combos(idCombo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla Ingredientes
CREATE TABLE IF NOT EXISTS Ingredientes (
    idIngrediente INT AUTO_INCREMENT PRIMARY KEY,
    nombreIngrediente VARCHAR(50) NOT NULL UNIQUE,
    cantidadStockIngrediente INT NOT NULL
) ENGINE=InnoDB;

-- Tabla Adiciones
CREATE TABLE IF NOT EXISTS Adiciones (
    idAdicion INT AUTO_INCREMENT PRIMARY KEY,
    nombreAdicion VARCHAR(50) NOT NULL UNIQUE,
    precioAdicion INT NOT NULL
) ENGINE=InnoDB;

-- Tabla IngredientesAdiciones
CREATE TABLE IF NOT EXISTS IngredientesAdiciones (
    idIngredienteAdicion INT AUTO_INCREMENT PRIMARY KEY,
    idIngrediente INT NOT NULL,
    idAdicion INT NOT NULL,
    FOREIGN KEY (idIngrediente) REFERENCES Ingredientes(idIngrediente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idAdicion) REFERENCES Adiciones(idAdicion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla ProductosIngredientes
CREATE TABLE IF NOT EXISTS ProductosIngredientes (
    idProductoIngrediente INT AUTO_INCREMENT PRIMARY KEY,
    idIngrediente INT NOT NULL,
    idProducto INT NOT NULL,
    FOREIGN KEY (idIngrediente) REFERENCES Ingredientes(idIngrediente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla MetodoPago
CREATE TABLE IF NOT EXISTS MetodoPago (
    idMetodoPago INT AUTO_INCREMENT PRIMARY KEY,
    nombreMetodoPago VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- Tabla Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nombresClientes VARCHAR(100) NOT NULL,
    apellidosClientes VARCHAR(100) NOT NULL,
    telefonoCliente INT NOT NULL,
    correoCliente VARCHAR(100) NOT NULL,
    direccionCliente VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Tabla Pedidos
CREATE TABLE IF NOT EXISTS Pedidos (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    idMetodoPago INT NOT NULL,
    precioPedidoTotal INT NOT NULL,
    isRecoger BOOLEAN  NOT NULL,
    FOREIGN KEY (idCliente) REFERENCES Clientes(idCliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idMetodoPago) REFERENCES MetodoPago(idMetodoPago)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla PedidosAdiciones
CREATE TABLE IF NOT EXISTS PedidosAdiciones (
    idPedidoAdicion INT AUTO_INCREMENT PRIMARY KEY,
    idAdicion INT NOT NULL,
    idPedido INT NOT NULL,
    cantidadPedidoAdicion INT NOT NULL,
    FOREIGN KEY (idAdicion) REFERENCES Adiciones(idAdicion)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idPedido) REFERENCES Pedidos(idPedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla PedidosProductos
CREATE TABLE IF NOT EXISTS PedidosProductos (
    idPedidoProducto INT AUTO_INCREMENT PRIMARY KEY,
    idProducto INT NOT NULL,
    idPedido INT NOT NULL,
    cantidadPedidoProducto INT NOT NULL,
    FOREIGN KEY (idProducto) REFERENCES Productos(idProducto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idPedido) REFERENCES Pedidos(idPedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Tabla PedidosCombos
CREATE TABLE IF NOT EXISTS PedidosCombos (
    idPedidoCombo INT AUTO_INCREMENT PRIMARY KEY,
    idCombo INT NOT NULL,
    idPedido INT NOT NULL,
    cantidadPedidoCombo INT NOT NULL,
    FOREIGN KEY (idPedido) REFERENCES Pedidos(idPedido)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    FOREIGN KEY (idCombo) REFERENCES Combos(idCombo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- TipoProducto
INSERT INTO TipoProducto (idTipoProducto, nombreTipoProducto) VALUES
(1,'Pizzas'),
(2,'Panzarottis'),
(3,'Bebidas'),
(4,'Postres'),
(5,'Otros productos no elaborados');

-- Productos
INSERT INTO Productos (idProducto,nombreProducto,idTipoProducto,precioProducto) VALUES
(1,'Pizza napolitana',1,11000),
(2,'Pizza carbonara',1,12000),
(3,'Panzarotti hawaiano',2,15000),
(4,'Panzarotti pollo queso',2,14000),
(5,'Granizado maracuya',3,9000),
(6,'Soda frutos rojos',3,12000),
(7,'Postre de limon',4,15000),
(8,'Tiramisú',4,17000);

-- Combos 
INSERT INTO Combos (idCombo,nombreCombo,precioCombo,cantidadStockCombo) VALUES
(1,'Combo pareja',25000,50),
(2,'Combo familiar 3 personas',35000,50),
(3,'Combo familiar 5 personas',50000,50),
(4,'Combo Freaky Friday',20000,50);

-- ProductosCombos 
INSERT INTO ProductosCombos (idProductoCombo,idProducto,idCombo,cantidadProductoCombo) VALUES
(1,1,1,2),
(2,1,2,1),
(3,2,2,2),
(4,2,3,2),
(5,3,3,2),
(6,1,3,1),
(7,2,4,1),
(8,5,4,1),
(9,8,4,1);

-- Ingredientes
INSERT INTO Ingredientes (idIngrediente,nombreIngrediente,cantidadStockIngrediente) VALUES
(1,'Masa para pizza',10),
(2,'Tomate',15),
(3,'Peperoni',20),
(4,'Champiñones',10),
(5,'Salsa carbonara',10),
(6,'Sal',20),
(7,'Pollo',20),
(8,'Maracuya',15),
(9,'Frutos rojos',20),
(10,'Queso parmesano',20),
(11,'Salsa picante',10),
(12,'Carne para moler',50),
(13,'Limon',50),
(14,'Cafe',50);

-- Adiciones
INSERT INTO Adiciones (idAdicion,nombreAdicion,precioAdicion) VALUES
(1,'Queso parmesano grande',12000),
(2,'Pollo extra',10000),
(3,'Queso parmesano pequeño',8000),
(4,'Picante',4000),
(5,'Carne molida',10000);

-- IngredientesAdiciones
INSERT INTO IngredientesAdiciones (idIngredienteAdicion,idIngrediente,idAdicion) VALUES
(1,10,1),
(2,7,2),
(3,10,3),
(4,11,4),
(5,6,4),
(6,12,5),
(7,6,5),
(8,2,5);

-- ProductosIngredientes
INSERT INTO ProductosIngredientes (idProductoIngrediente,idIngrediente,idProducto) VALUES
(1,1,1),
(2,5,2),
(3,10,3),
(4,7,4),
(5,8,5),
(6,9,6),
(7,13,7),
(8,14,8);

-- MetodoPago
INSERT INTO MetodoPago (idMetodoPago,nombreMetodoPago) VALUES
(1,'Tarjeta Debito'),
(2,'Tarjeta Credito'),
(3,'Efectivo'),
(4,'Transferencia'),
(5,'Otro');

-- Clientes
INSERT INTO Clientes (idCliente,nombresClientes,apellidosClientes,telefonoCliente,correoCliente,direccionCliente) VALUES
(1,'Paula','Viviescas',11,'paula@gmail.com','Carrera 27'),
(2,'Sebastian','Mora',12,'sebas@gmail.com','Calle 20'),
(3,'Genny','Jaimes',13,'genny@gmail.com','Carrera 3'),
(4,'Wilson','Viviescas',14,'wilson@gmail.com','Calle 5'),
(5,'Juan','Perez',15,'juan@gmail.com','Carrera 15');

-- Pedidos
INSERT INTO Pedidos (idPedido,idCliente,idMetodoPago,precioPedidoTotal,isRecoger) VALUES
(1,1,1,25000,1),
(2,2,2,30000,0),
(3,3,3,45000,1),
(4,4,4,40000,0),
(5,5,5,20000,1);

-- PedidosAdiciones
INSERT INTO PedidosAdiciones (idPedidoAdicion,idAdicion,idPedido,cantidadPedidoAdicion) VALUES
(1,1,1,2),
(2,2,2,1),
(3,3,3,3),
(4,4,4,4),
(5,5,5,5);

-- PedidosProductos
INSERT INTO PedidosProductos (idPedidoProducto,idProducto,idPedido,cantidadPedidoProducto) VALUES
(1,1,1,2),
(2,2,2,1),
(3,3,3,3),
(4,4,4,4),
(5,5,5,5);

-- PedidosCombos
INSERT INTO PedidosCombos (idPedidoCombo,idCombo,idPedido,cantidadPedidoCombo) VALUES
(1,1,1,2),
(2,2,2,1),
(3,3,3,3),
(4,4,4,4),
(5,1,5,5);