<?php 
require_once '../Models/Conexion.php';

class Usuarios extends Conexion{
    private $conexion;
    public function __CONSTRUCT(){
        $this->conexion = parent::getConexion();
    }

    public function listarUsuarios(){
        try {
            $consulta = $this->conexion->prepare("call spu_usuario_listarUsuarios()");
            $consulta->execute();
            return $consulta->fetchAll(PDO::FETCH_ASSOC);
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function registrarUsuario($datos){
        try {
            $consulta = $this->conexion->prepare("call spu_usuario_registrarUsuario(?,?,?,?,?)");
            $consulta->execute(
                array(
                    $datos['usuario'],
                    $datos['clave'],
                    $datos['nombres'],
                    $datos['apellidos'],
                    $datos['rol']
                )
            );
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function eliminarUsuario($datos){
        try {
            $consulta = $this->conexion->prepare("call spu_usuario_eliminarUsuario(?)");
            $consulta->execute(
                array(
                    $datos['idusuario']
                )
            );
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }

    public function actualizarClave($datos){
        try {
            $consulta = $this->conexion->prepare("call spu_usuario_editarClave(?,?)");
            $consulta->execute(
                array(
                    $datos['idusuario'],
                    $datos['clave']
                )
            );
        } catch (Exception $e) {
            die($e->getMessage());
        }
    }
}