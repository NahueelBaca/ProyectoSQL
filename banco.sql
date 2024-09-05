#--crea la base de datos

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
    FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente)
    ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT pk_plazo_cliente_plaz_fijo
    FOREIGN KEY(nro_plazo) REFERENCES plazo_fijo(nro_plazo)
    ON DELETE RESTRICT ON UPDATE CASCADE

)ENGINE = INNODB;













CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON banco.* TO 'admin'@'localhost' WITH GRANT OPTION;

CREATE USER 'empleado'@'%' IDENTIFIED BY 'empleado';

GRANT SELECT ON banco.empleado TO 'empleado'@'%';
GRANT SELECT ON banco.sucursal TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_plazo_fijo TO 'empleado'@'%';
GRANT SELECT ON banco.tasa_prestamo TO 'empleado'@'%';

GRANT SELECT, INSERT ON banco.prestamo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_fijo TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.caja_ahorro TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.tarjeta TO 'empleado'@'%';
GRANT SELECT, INSERT ON banco.plazo_cliente TO 'empleado'@'%';

GRANT SELECT, INSERT, UPDATE ON banco.cliente TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.cliente_CA TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.pago TO 'empleado'@'%';