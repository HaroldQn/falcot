use proyecto_falcot;
-- Roles
insert into roles (rol) values('admin');

-- Usuario
insert into usuarios (usuario,clave,nombres,apellidos,idrol) values
('admin','$2y$10$B2cV1UgCtPYx6Ja8XunBiO2Ye41sf5mhlV.azRT98COVGwAhZF9Iu','Harold Efrain', 'Quispe Napa',1);

-- Empresa
insert into empresa (razonSocial,ruc,direccion,iddistrito) values
('SOLUCIONES TECNOLOGICAS INDUSTRIALES FALCOT S.A.C.','20610562176','CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA',1010);

-- Detalle usuarioo
insert into detalle_usuarios (idusuario, idempresa) values
(1,1);