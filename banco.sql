# --creo la base de datos

CREATE DATABASE banco;

USE banco;

#--creacion de tablas para entidades

CREATE TABLE ciudad(
    cod_postal  INT(4) NOT NULL,
    nombre  VARCHAR(45) NOT NULL,

    constraint pk_ciudad
    PRIMARY KEY(cod_postal)
)ENGINE=InnoDB;

CREATE TABLE sucursal(
    nro_sucursal  INT(3) NOT NULL,
    nombre  VARCHAR(45),
    direccion  VARCHAR(45),
    telefono  VARCHAR(45),
    horario  VARCHAR(45),

    constraint pk_Sucursal
    PRIMARY KEY  (nro_sucursal)
)ENGINE=InnoDB;

CREATE TABLE sucur_ubic(
    nro_sucursal INT(3) NOT NULL,
    cod_postal INT(4) NOT NULL,
    
    constraint pk_sucur_ubic_sucursal
    PRIMARY KEY(nro_sucursal),
    Foreign Key (nro_sucursal) REFERENCES Sucursal (nro_sucursal)
    on delete RESTRICT on update CASCADE

    #--constraint pk_sucur_ubic_ciudad
    #--Foreign Key (cod_postal) REFERENCES ciudad (cod_postal)
    #--ON DELETE RESTRICT on UPDATE RESTRICT
)ENGINE=InnoDB;
CREATE TABLE empleado(
	legajo smallint(4) not NULL,
    apellido varchar(45),
    nombre varchar(45),
	tipo_doc varchar(45),
    nro_doc int(8) ,
	direccion varchar(45),
    telefono varchar(45),
    cargo varchar(45),
    clave varchar(32),

    CONSTRAINT pk_empleado
    PRIMARY KEY(legajo)
    
)ENGINE = INNODB;
CREATE TABLE trabaja_en(
    legajo INT(4) not NULL,

    CONSTRAINT pk_tranaja_en_empleado
    PRIMARY KEY(legajo),
    FOREIGN KEY(legajo) REFERENCES empleado (legajo)
    ON DELETE RESTRICT on UPDATE CASCADE
)ENGINE = INNODB;
CREATE TABLE plazo_fijo(
    nro_plazo INT UNSIGNED not NULL,
    capital DECIMAL(10,2),
    tasa_interes DECIMAL(10,2),
    interes DECIMAL(10,2),

    CONSTRAINT pk_plazo_fijo
    PRIMARY KEY(nro_plazo)
)ENGINE = INNODB;
CREATE TABLE plazo_suc(
    nro_plazo int UNSIGNED not null,

    CONSTRAINT pk_plazo_suc_plazo_fijo
    PRIMARY KEY(nro_plazo),
    FOREIGN KEY(nro_plazo) REFERENCES plazo_fijo(nro_plazo)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = INNODB;
CREATE TABLE tasa_plazo_fijo(
    periodo int(3) UNSIGNED not NULL,
    monto_inf DECIMAL(10,2) not null,
    monto_sup DECIMAL(10,2)NOT NULL,
    tasa DECIMAL(10,2),

    CONSTRAINT pk_tasa_plazo_fijo
    PRIMARY KEY(periodo,monto_inf,monto_sup)
)ENGINE = INNODB;
CREATE TABLE plazo_cliente(
    nro_plazo int UNSIGNED NOT NULL,
    nro_cliente int(5) UNSIGNED not NULL,

    CONSTRAINT pk_plazo_cliente_cliente
    PRIMARY KEY(nro_cliente,nro_plazo),
    FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_plazo_cliente_plaz_fijo
    FOREIGN KEY(nro_plazo) REFERENCES plazo_fijo(nro_plazo)
    ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE = INNODB;

CREATE TABLE cliente(
    nro_cliente int(5) NOT NULL,
    apellido varchar(30),
    nombre varchar(30),
    tipo_doc varchar(30),
    nro_doc int(8),
    direccion varchar(30),
    telefono varchar(30),
    fecha_nac date,

    CONSTRAINT pk_cliente
    PRIMARY KEY(nro_cliente)
)ENGINE = INNODB;

CREATE TABLE caja_Ahorro(
    nro_ca int(8) UNSIGNED NOT NULL,
    CBU int(18) UNSIGNED,
    saldo decimal(10,2), 

    CONSTRAINT pk_caja_Ahorro
    PRIMARY KEY(nro_ca)
)ENGINE = INNODB;

CREATE TABLE cliente_CA(
    nro_cliente int UNSIGNED NOT NULL,
    nro_ca int UNSIGNED NOT NULL, 
    
    PRIMARY KEY(nro_ca,nro_cliente),

    CONSTRAINT pk_cliente_ca_cliente
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT pk_cliente_ca_caja_Ahorro
    FOREIGN KEY(nro_ca) REFERENCES caja_Ahorro(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE = INNODB;

CREATE TABLE tarjeta(  #que hacer con el md5
    nro_tarjeta int(16) UNSIGNED NOT NULL,
    PIN varchar(32),
    CVT varchar(32),
    fecha_venc date,
    nro_cliente int,
    nro_ca int,
    
    
    CONSTRAINT pk_tarjeta
    PRIMARY KEY(nro_tarjeta),
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    
    FOREIGN KEY(nro_ca) REFERENCES cliente_CA(nro_ca)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE Prestamo(
    nro_prestamo int(8) UNSIGNED NOT NULL,
    fecha date,
    cant_meses int(2) UNSIGNED,
    monto decimal(10,2),
    tasa_interes decimal(10,2),
    interes decimal(10,2),
    valor_cuota decimal(10,2),
    legajo int,
    nro_cliente int,
    
    CONSTRAINT pk_prestamo
    PRIMARY KEY(nro_prestamo),
    FOREIGN KEY(legajo) REFERENCES Empleado(legajo)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE    
)ENGINE = INNODB;

CREATE TABLE Pago(
    nro_prestamo int NOT NULL,
    nro_pago int(2) UNSIGNED NOT NULL,
    fecha_venc date,
    fecha_pago date,
    
    CONSTRAINT pk_pago
    PRIMARY KEY(nro_prestamo,nro_pago),
    FOREIGN KEY(nro_prestamo) REFERENCES Prestamo(nro_prestamo)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE Tasa_Prestamo(
    periodo int(3) UNSIGNED NOT NULL,
    monto_inf decimal(10,2) UNSIGNED NOT NULL,
    monto_sup decimal(10,2) UNSIGNED NOT NULL,
    tasa decimal(10,2) UNSIGNED,

    CONSTRAINT pk_tasa_prestamo
    PRIMARY KEY(periodo, monto_inf, monto_sup)
)ENGINE = INNODB;

CREATE TABLE Caja(
    caja int(5) UNSIGNED NOT NULL,

CONSTRAINT pk_caja
    PRIMARY KEY(caja)
)ENGINE = INNODB;

CREATE TABLE Ventanilla(
    cod_caja int UNSIGNED NOT NULL,
    nro_suc int UNSIGNED NOT NULL,


    CONSTRAINT pk_ventanilla
    PRIMARY KEY(cod_caja),

    CONSTRAINT pk_ventanilla_cod_caja
    FOREIGN KEY(cod_caja) REFERENCES Caja(caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_ventanilla_nro_suc
    FOREIGN KEY(nro_suc) REFERENCES Sucursal(nro_suc)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE atm(
    cod_caja int UNSIGNED NOT NULL,
    cod_postal int UNSIGNED NOT NULL,
    direccion varchar(30),

    PRIMARY KEY(cod_caja),
    FOREIGN KEY(cod_caja) REFERENCES Caja(caja)
    ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY(cod_postal) REFERENCES Ciudad(cod_postal)
    ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE transaccion(
    nro_trans int(10) UNSIGNED not NULL,
    fecha DATE,
    hora TIME,
    monto DECIMAL(10,2),

    CONSTRAINT pk_transaccion
    PRIMARY KEY(nro_trans)
)ENGINE=INNODB;

CREATE TABLE debito(
    nro_trans int(10) UNSIGNED not NULL,
    descripcion VARCHAR(200),
    nro_cliente INT,
    nro_ca INT,

    CONSTRAINT pk_debito
    PRIMARY KEY(nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES transaccion(nro_trans)
    ON DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY(nro_cliente) REFERENCES cliente_CA(nro_cliente)
    ON DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY(nro_ca) REFERENCES cliente_CA(nro_ca)
    ON DELETE RESTRICT on UPDATE CASCADE



)ENGINE=INNODB;

CREATE TABLE transaccion_por_caja(
    nro_trans int NOT NULL,
    cod_caja INT,


    CONSTRAINT pk_transaccion_por_caja
    PRIMARY KEY(nro_trans),
    FOREIGN KEY(nro_trans) REFERENCES transaccion(nro_trans)
    on DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY(nro_ca) REFERENCES cara_Ahorro(nro_ca)
    ON DELETE RESTRICT on UPDATE CASCADE

)ENGINE = INNODB;

CREATE TABLE deposito(
    nro_trans INT NOT NULL,
    nro_ca INT,

    CONSTRAINT pk_deposito
    PRIMARY KEY(nro_trans),

    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY(nro_ca) REFERENCES caja_Ahorro(nro_ca)
    on DELETE RESTRICT on UPDATE CASCADE

)ENGINE=INNODB;

CREATE TABLE extraccion(
    nro_trans INT NOT NULL,
    nro_cliente INT,
    nro_ca int,

    CONSTRAINT pk_extraccion
    PRIMARY KEY(nro_trans),

    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
    on DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY(nro_ca) REFERENCES caja_Ahorro(nro_ca)
    on DELETE RESTRICT on UPDATE CASCADE
)ENGINE = INNODB;

CREATE TABLE transferencia(  #????
    nro_trans INT not NULL,
    nro_cliente INT,
    origen INT,
    destino INT,

    CONSTRAINT pk_transferencia
    PRIMARY KEY(nro_trans),

    FOREIGN KEY (nro_trans) REFERENCES transaccion_por_caja(nro_trans)
    on DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY (nro_cliente) REFERENCES cliente_CA(nro_cliente)
    on DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY (origen) REFERENCES cliente_ca(nro_ca)
    on DELETE RESTRICT on UPDATE CASCADE,

    FOREIGN KEY (destino) REFERENCES cliente_ca(nro_ca)
    ON DELETE RESTRICT on UPDATE CASCADE

)ENGINE = INNODB;

CREATE TABLE depos_CA(
    nro_trans int NOT NULL



)ENGINE = INNODB;

CREATE TABLE extrac_CL(
    nro_trans int NOT NULL



)ENGINE = INNODB;

CREATE TABLE transf_CL(
    nro_trans int NOT NULL



)ENGINE = INNODB;

CREATE TABLE debit_CL(
    nro_trans int NOT NULL



)ENGINE = INNODB;

CREATE TABLE trans_Caja(
    nro_trans int NOT NULL



)ENGINE = INNODB;
CREATE TABLE tarjeta_CL(
    



)ENGINE = INNODB;

CREATE TABLE pago_PR(
    



)ENGINE = INNODB;

CREATE TABLE prestamo_Cliente(
    



)ENGINE = INNODB;
CREATE TABLE sucur_vent(
    



)ENGINE = INNODB;





#vistas
CREATE VIEW trans_cajas_ahorro AS
SELECT
    ca.nro_ca,
    ca.saldo,
    t.nro_trans,
    t.fecha,
    t.hora,
    t.tipo,
    t.monto,
    t.destino,
    t.cod_caja,
    c.nro_cliente,
    c.tipo_doc,
    c.nro_doc,
    c.nombre,
    c.apellido
FROM transaccion t
JOIN caja_Ahorro ca ON t.nro_ca = ca.nro_ca
JOIN cliente c ON t.nro_cliente = c.nro_cliente
WHERE t.tipo IN ('debito', 'extraccion', 'transferencia');



CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

GRANT SELECT ON banco.empleado TO 'empleado'@'%';
GRANT SELECT ON banco.sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_plazo_fijo TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_prestamo TO 'empleado'@'%';

GRANT SELECT, INSERT ON banco.prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.caja_Ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.tarjeta TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_cliente TO 'empleado'@'%';

GRANT SELECT, INSERT, UPDATE ON banco.cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.pago TO 'empleado'@'%';


CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

-- Permiso de solo lectura sobre la vista:
GRANT SELECT ON banco.caja_Ahorro TO 'atm'@'%';

-- lectura y actualización sobre la tabla tarjeta:
GRANT SELECT, UPDATE ON banco.tarjeta TO 'atm'@'%';

DROP USER ''@'localhost';