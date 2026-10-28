class Estudiante{
    var felicidad
    var varitasMagicas = []

    method felicidad() = felicidad

    method mejorVarita(){
       return varitasMagicas.max({varita => varita.potencia()})
    }

    method disminuirFelicidad(cantidad){
        felicidad = (felicidad - cantidad).max(0)
    }

    method lanzarHechizo(nube) {
    self.mejorVarita().hechizarNube(nube)
}
}

class Nube{
    var tristeza = 100
    method tristeza() = tristeza
    method estaDespejada() = tristeza == 0

    method disminuirTristeza(cantidad){
        tristeza = (tristeza - cantidad).max(0)

    }

    method entristecerEstudiante(estudiante){
        estudiante.disminuirFelicidad(tristeza)
    }

    
}

class NubeGris inherits Nube{
}

class NubeTormenta inherits Nube{
    const resistencia
    method resistencia() = resistencia

    override method disminuirTristeza(cantidad)
    { 
        const impacto = (cantidad - resistencia).max(0)
        super(impacto) 
    }
}

class Varita{
    var brillo
    const potencia

    method brillo() = brillo
    method potencia() = potencia

    method hechizarNube(nube){
        if(brillo == 0){
            self.error("No se puede hechizar")
        }
        nube.disminuirTristeza(self.potencia())
        brillo = (brillo - 20).max(0)
    }
}

class VaritaEstrella inherits Varita{
    override method potencia() = 100 - brillo
    override method hechizarNube(nube){
        const aplicaEfecto = brillo > 80
        super(nube)
        if(aplicaEfecto){
            brillo = brillo * 2
        }
    }
}
class VaritaJuguete inherits Varita{
    override method potencia() = 50

    override method hechizarNube(nube){
        nube.disminuirTristeza(self.potencia())
    }
}

class VaritaCorazon inherits Varita{
    const nivelAmor
    override method potencia() = nivelAmor * 2
    override method hechizarNube(nube){
        const aplicaEfecto = brillo > 80 && nivelAmor > 50
        nube.disminuirTristeza(self.potencia())
        brillo = (brillo - 20).max(0)

        if(aplicaEfecto){
            nube.disminuirTristeza(1000)
        }
    }
}