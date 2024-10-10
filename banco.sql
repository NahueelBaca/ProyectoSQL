# --creo la base de datos

CREATE DATABASE banco;

USE banco;

#--creacion de tablas para entidades

CREATE TABLE ciudad(
    cod_postal  INT(4) UNSIGNED NOT NULL,
    nombre  VARCHAR(45) NOT NULL,

    constraint pk_ciudad
    PRIMARY KEY(cod_postal)
)ENGINE=INNODB;

CREATE TABLE sucursal(
    nro_suc INT(3) UNSIGNED NOT NULL AUTO_INCREMENT,
    cod_postal INT(4) UNSIGNED NOT NULL,
    nombre  VARCHAR(45) NOT NULL,
    direccion  VARCHAR(45) not NULL,
    telefono  VARCHAR(45) NOT NULL,
    horario  VARCHAR(45) NOT NULL,
    

    constraint pk_sucursal
    PRIMARY KEY  (nro_suc),

    FOREIGN KEY(cod_postal) REFERENCES ciudad(cod_postal)


) ENGINE=INNODB;


CREATE TABLE empleado(
	legajo INT(4) UNSIGNED not NULL AUTO_INCREMENT,
    apellido varchar(45) NOT NULL,
    nombre varchar(45) NOT NULL,
	tipo_doc varchar(20) not NULL,
    nro_doc int(8) UNSIGNED NOT NULL,
	direccion varchar(45) NOT NULL,
    telefono varchar(45) NOT NULL,
    cargo varchar(45) NOT NULL,
    password varchar(32) NOT NULL,
    nro_suc int(3)UNSIGNED NOT NULL,

    CONSTRAINT pk_empleado
    PRIMARY KEY(legajo),

    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
    
)ENGINE = INNODB;

CREATE TABLE plazo_fijo(
    nro_plazo INT(8) UNSIGNED not NULL AUTO_INCREMENT,
    capital DECIMAL(16,2) UNSIGNED NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    tasa_interes DECIMAL(4,2) UNSIGNED NOT NULL,
    interes DECIMAL(16,2) UNSIGNED NOT NULL,
    nro_suc INT(3) UNSIGNED NOT NULL,

    CONSTRAINT pk_plazo_fijo
    PRIMARY KEY(nro_plazo),

    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
)ENGINE = INNODB;

CREATE TABLE tasa_plazo_fijo(
    periodo int(3) UNSIGNED not NULL,
    monto_inf DECIMAL(16,2) UNSIGNED not null,
    monto_sup DECIMAL(16,2) UNSIGNED NOT NULL,
    tasa DECIMAL(4,2) UNSIGNED NOT NULL,

    CONSTRAINT pk_tasa_plazo_fijo
    PRIMARY KEY(periodo,monto_inf,monto_sup)
)ENGINE = INNODB;

CREATE TABLE cliente(
    nro_cliente int(5) UNSIGNED NOT NULL AUTO_INCREMENT,
    apellido varchar(30) NOT NULL,
    nombre varchar(30) NOT NULL,
    tipo_doc varchar(20) NOT NULL,
    nro_doc int(8) UNSIGNED NOT NULL,
    direccion varchar(30) NOT NULL,
    telefono varchar(30) NOT NULL,
    fecha_nac date NOT NULL,

    CONSTRAINT pk_cliente
    PRIMARY KEY(nro_cliente)
)ENGINE = INNODB;


CREATE TABLE plazo_cliente(
    nro_plazo int UNSIGNED NOT NULL,
    nro_cliente int(5) UNSIGNED not NULL,

    CONSTRAINT pk_plazo_cliente_cliente
    PRIMARY KEY(nro_cliente,nro_plazo),
    FOREIGN KEY (nro_cliente) REFERENCES cliente(nro_cliente),
    

    CONSTRAINT pk_plazo_cliente_plazo_fijo
    FOREIGN KEY(nro_plazo) REFERENCES plazo_fijo(nro_plazo)
    

)ENGINE = INNODB;


CREATE TABLE prestamo(
    nro_prestamo int(8) UNSIGNED NOT NULL AUTO_INCREMENT,
    fecha date NOT NULL,
    cant_meses int(2) UNSIGNED NOT NULL,
    monto decimal(10,2) UNSIGNED NOT NULL,
    tasa_interes decimal(4,2)UNSIGNED NOT NULL,
    interes decimal(9,2)UNSIGNED NOT NULL,
    valor_cuota decimal(9,2)UNSIGNED NOT NULL,
    legajo int(4) UNSIGNED NOT NULL,
    nro_cliente int(5) UNSIGNED NOT NULL,
    
    CONSTRAINT pk_prestamo
    PRIMARY KEY(nro_prestamo),
    FOREIGN KEY(legajo) REFERENCES empleado(legajo),

    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente)
        
)ENGINE = INNODB;

CREATE TABLE pago(
    nro_prestamo int(8) UNSIGNED NOT NULL,
    nro_pago int(2) UNSIGNED NOT NULL,
    fecha_venc date NOT NULL,
    fecha_pago date,
    
    CONSTRAINT pk_pago
    PRIMARY KEY(nro_prestamo,nro_pago),
    FOREIGN KEY(nro_prestamo) REFERENCES prestamo(nro_prestamo)
)ENGINE = INNODB;

CREATE TABLE tasa_prestamo(
    periodo int(3) UNSIGNED NOT NULL,
    monto_inf decimal(10,2) UNSIGNED NOT NULL,
    monto_sup decimal(10,2) UNSIGNED NOT NULL,
    tasa decimal(4,2) UNSIGNED not NULL,

    CONSTRAINT pk_tasa_prestamo
    PRIMARY KEY(periodo, monto_inf, monto_sup)
)ENGINE = INNODB;

CREATE TABLE caja_ahorro(
    nro_ca int(8) UNSIGNED NOT NULL AUTO_INCREMENT,
    CBU BIGINT UNSIGNED NOT NULL,
    saldo decimal(16,2) UNSIGNED NOT NULL, 

    CONSTRAINT pk_caja_ahorro
    PRIMARY KEY(nro_ca)
)ENGINE = INNODB;

CREATE TABLE cliente_ca(
    nro_cliente int(5) UNSIGNED NOT NULL,
    nro_ca int(8) UNSIGNED NOT NULL, 
    
    PRIMARY KEY(nro_cliente,nro_ca),

    CONSTRAINT pk_cliente_ca_cliente
    FOREIGN KEY(nro_cliente) REFERENCES cliente(nro_cliente),
    
    CONSTRAINT pk_cliente_ca_caja_Ahorro
    FOREIGN KEY(nro_ca) REFERENCES caja_ahorro(nro_ca)

)ENGINE = INNODB;

CREATE TABLE tarjeta(  #que hacer con el md5
    nro_tarjeta BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    PIN varchar(32) NOT NULL,
    CVT varchar(32) NOT NULL,
    fecha_venc date NOT NULL,
    nro_cliente int(5) UNSIGNED NOT NULL,
    nro_ca int(8) UNSIGNED NOT NULL,
    
    
    CONSTRAINT pk_tarjeta
    PRIMARY KEY(nro_tarjeta),
    FOREIGN KEY(nro_cliente, nro_ca) REFERENCES cliente_ca(nro_cliente, nro_ca)
)ENGINE = INNODB;

CREATE TABLE caja(
    cod_caja int(5) UNSIGNED NOT NULL AUTO_INCREMENT,

CONSTRAINT pk_caja
    PRIMARY KEY(cod_caja)
)ENGINE = INNODB;

CREATE TABLE ventanilla(
    cod_caja int(5) UNSIGNED NOT NULL,
    nro_suc int(3) UNSIGNED NOT NULL,


    CONSTRAINT pk_ventanilla
    PRIMARY KEY(cod_caja),

    CONSTRAINT pk_ventanilla_cod_caja
    FOREIGN KEY(cod_caja) REFERENCES caja(cod_caja),

    CONSTRAINT pk_ventanilla_nro_sucursal
    FOREIGN KEY(nro_suc) REFERENCES sucursal(nro_suc)
)ENGINE = INNODB;

CREATE TABLE atm(
    cod_caja int(5) UNSIGNED NOT NULL,
    cod_postal int(4) UNSIGNED NOT NULL,
    direccion varchar(30) NOT NULL,

    PRIMARY KEY(cod_caja),
    FOREIGN KEY(cod_caja) REFERENCES Caja(cod_caja),

    FOREIGN KEY(cod_postal) REFERENCES Ciudad(cod_postal)
)ENGINE = INNODB;

CREATE TABLE transaccion(
    nro_trans int(10) UNSIGNED not NULL AUTO_INCREMENT,
    fecha DATE NOT NULL,
    hora TIME not NULL,
    monto DECIMAL(16,2) UNSIGNED NOT NULL,

    CONSTRAINT pk_transaccion
    PRIMARY KEY(nro_trans)
)ENGINE=INNODB;

CREATE TABLE debito(
    nro_trans int(10) UNSIGNED not NULL,
    descripcion TEXT,
    nro_cliente INT(5) UNSIGNED NOT NULL,
    nro_ca INT(8) UNSIGNED NOT NULL,

    CONSTRAINT pk_debito
    PRIMARY KEY(nro_trans),
    FOREIGN KEY (nro_trans) REFERENCES transaccion(nro_trans),

    FOREIGN KEY(nro_cliente,nro_ca) REFERENCES cliente_ca(nro_cliente,nro_ca)

)ENGINE=INNODB;

CREATE TABLE transaccion_por_caja(
    nro_trans int(10) UNSIGNED NOT NULL,
    cod_caja INT(5) UNSIGNED NOT NULL,


    CONSTRAINT pk_transaccion_por_caja
    PRIMARY KEY(nro_trans),
    FOREIGN KEY(nro_trans) REFERENCES transaccion(nro_trans),

    FOREIGN KEY(cod_caja) REFERENCES caja(cod_caja)

)ENGINE = INNODB;

CREATE TABLE deposito(
    nro_trans INT(10) UNSIGNED NOT NULL,
    nro_ca INT(8) UNSIGNED NOT NULL,

    CONSTRAINT pk_deposito
    PRIMARY KEY(nro_trans),

    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans),

    FOREIGN KEY(nro_ca) REFERENCES caja_ahorro(nro_ca)

)ENGINE=INNODB;

CREATE TABLE extraccion(
    nro_trans INT(10) UNSIGNED NOT NULL,
    nro_cliente INT(5) UNSIGNED NOT NULL,
    nro_ca int(8) UNSIGNED NOT NULL,

    CONSTRAINT pk_extraccion
    PRIMARY KEY(nro_trans),

    FOREIGN KEY(nro_trans) REFERENCES transaccion_por_caja(nro_trans),

    FOREIGN KEY(nro_cliente,nro_ca) REFERENCES cliente_ca(nro_cliente,nro_ca)

    
    
)ENGINE = INNODB;

CREATE TABLE transferencia(  #?
    nro_trans INT(10) UNSIGNED not NULL,
    nro_cliente INT(5) UNSIGNED NOT NULL,
    origen INT(8) UNSIGNED NOT NULL,
    destino INT(8) UNSIGNED NOT NULL,
    

    CONSTRAINT pk_transferencia
    PRIMARY KEY(nro_trans),

    FOREIGN KEY (nro_trans) REFERENCES transaccion_por_caja(nro_trans),

    FOREIGN KEY (nro_cliente,origen) REFERENCES cliente_ca(nro_cliente,nro_ca),

    FOREIGN KEY (destino) REFERENCES caja_Ahorro(nro_ca)
    

)ENGINE = INNODB;


CREATE VIEW trans_cajas_ahorro AS
SELECT DISTINCT
    cca.nro_ca as nro_ca,
    ca.saldo as saldo,
    t.nro_trans as nro_trans,
    t.fecha as fecha,
    t.hora as hora,
    'transferencia' AS tipo,
    t.monto as monto,
    tpc.cod_caja as cod_caja,
    tr.nro_cliente as nro_cliente,
    c.tipo_doc AS tipo_doc,
    c.nro_doc AS nro_doc,
    c.nombre as nombre,
    c.apellido as apellido,
    tr.destino as destino
FROM transaccion t
join transferencia tr on t.nro_trans = tr.nro_trans
join transaccion_por_caja tpc on tpc.nro_trans = t.nro_trans
JOIN cliente_ca cca ON cca.nro_ca = tr.origen           
JOIN cliente c ON c.nro_cliente = tr.nro_cliente      
JOIN caja_Ahorro ca ON ca.nro_ca = cca.nro_ca

UNION 

SELECT DISTINCT
    d.nro_ca as nro_ca,
    ca.saldo as saldo,
    d.nro_trans as nro_trans,
    t.fecha AS fecha,
    t.hora AS hora,
    'debito' AS tipo,
    t.monto AS monto,
    null as cod_caja,
    d.nro_cliente as nro_cliente,
    c.tipo_doc AS tipo_doc,
    c.nro_doc AS nro_doc,
    c.nombre as nombre,
    c.apellido as apellido,
    NULL AS destino
FROM transaccion t 
join debito d on d.nro_trans = t.nro_trans
JOIN cliente c ON c.nro_cliente = d.nro_cliente
JOIN caja_Ahorro ca on ca.nro_ca = d.nro_ca

UNION 

SELECT DISTINCT
    cca.nro_ca as nro_ca,                            
    ca.saldo as saldo,                              
    dep.nro_trans as nro_trans,                       
    t.fecha as fecha,                          
    t.hora as hora,                              
    'deposito' AS tipo,                    
    t.monto as monto,                             
    tpc.cod_caja as cod_caja,                          
    null as nro_cliente,                         
    null as tipo_doc,                            
    null as nro_doc,                             
    null as nombre,                              
    null as apellido,                            
    NULL AS destino                        
FROM transaccion t 
JOIN deposito dep on dep.nro_trans = t.nro_trans
join transaccion_por_caja tpc on tpc.nro_trans = t.nro_trans
JOIN cliente_ca cca ON cca.nro_ca = dep.nro_ca 
JOIN caja_Ahorro ca ON ca.nro_ca = cca.nro_ca            
JOIN cliente c ON c.nro_cliente = cca.nro_cliente

UNION 

SELECT DISTINCT
    cca.nro_ca as nro_ca,
    ca.saldo as saldo,
    t.nro_trans as nro_trans,
    t.fecha AS fecha,
    t.hora AS hora,
    'extraccion' AS tipo,
    t.monto AS monto,
    tpc.cod_caja AS cod_caja,
    e.nro_cliente as nro_cliente,
    c.tipo_doc AS tipo_doc,
    c.nro_doc AS nro_doc,
    c.nombre as nombre,
    c.apellido as apellido,
    NULL AS destino
FROM transaccion t
join extraccion e on e.nro_trans = t.nro_trans
join transaccion_por_caja tpc on tpc.nro_trans = t.nro_trans
JOIN cliente_ca cca ON cca.nro_ca = e.nro_ca 
JOIN caja_Ahorro ca ON ca.nro_ca = cca.nro_ca          
JOIN cliente c ON c.nro_cliente = e.nro_cliente; 










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
GRANT SELECT, INSERT, UPDATE ON banco.cliente_ca TO 'empleado'@'%';
GRANT SELECT, INSERT, UPDATE ON banco.pago TO 'empleado'@'%';


CREATE USER 'atm'@'%' IDENTIFIED BY 'atm';

-- Permiso de solo lectura sobre la vista:
GRANT SELECT ON banco.trans_cajas_ahorro TO 'atm'@'%';

-- lectura y actualización sobre la tabla tarjeta:
GRANT SELECT, UPDATE ON banco.tarjeta TO 'atm'@'%';

DROP USER ''@'localhost';

FLUSH PRIVILEGES;