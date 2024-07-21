use proyecto_falcot;
-- Roles
insert into roles (rol) values('admin');
insert into roles (rol) values('asistente');

-- Usuario
insert into usuarios (usuario,clave,nombres,apellidos,idrol) values
('mcardenas','$2y$10$VVFGk54QwS/WpQ3mYReNqOagujHL4RrK8Y3.9T8quw71AXXZsuHK6','Miguel', 'Cardenas',1);

-- Empresa
insert into empresa (razonSocial,ruc,direccion,iddistrito) values
('SOLUCIONES TECNOLOGICAS INDUSTRIALES FALCOT S.A.C.','20610562176','CAL. LUIS GALVEZ RONCEROS 230 C. P.  SANTA ROSA',1010);

-- Detalle usuarioo
insert into detalle_usuarios (idusuario, idempresa) values(1,1);
