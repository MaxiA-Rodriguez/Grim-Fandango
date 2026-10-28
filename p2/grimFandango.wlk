class Alma{
    const dinero
    const buenasAcciones
    method buenasAcciones() = buenasAcciones

    method capital() = dinero + buenasAcciones
}

class Agente{
    var deuda
    var paquetesVendidos = 0
    var dineroGanado = 0
    var estrategia

    method cambiarEstrategia(nuevaEstrategia){
        estrategia = nuevaEstrategia
    }

    method atender(alma){
        const paqueteParaOfrecer = estrategia.armarPaquete(alma)
        self.venderPaquete(paqueteParaOfrecer, alma)
    }

    method venderPaquete(paquete, alma){
        const costoPaquete = paquete.costo(alma)
        if(alma.capital() <= costoPaquete){
            self.error("El alma no tiene suficiente capital para comprar el paquete")
        }

        paquetesVendidos += 1
        dineroGanado = dineroGanado + costoPaquete

        deuda = (deuda - costoPaquete).max(0)
    }

    method dineroGanado() = dineroGanado
    method paquetesVendidos() = paquetesVendidos
    method deuda() = deuda

    method reducirDeuda(monto){
        deuda = (deuda - monto).max(0)
    }

    method aumentarDeuda(monto){
        deuda = deuda + monto
    }

}

object estrategiaClasica{
    const paquetesPredefinidos = []

    method armarPaquete(alma){
        const pagables = paquetesPredefinidos.filter({paquete => alma.capital() >= paquete.costo(alma)})

        if(pagables.isEmpty()){
            self.error("El alma no puede pagar el viaje")
        }
        return pagables.max({paquete => paquete.costo(alma)})
    }
}

object estrategiaNavegante{
    method armarPaquete(alma){
        const acciones = alma.buenasAcciones()

        if(acciones >= 50){
            return new PaqueteCrucero(valorBasico = acciones)
        }else
        {
            return new PaqueteBote(valorBasico = acciones)
        }
    }
}

object estrategiaIndiferente{
    method armarPaquete(alma){
        const valorRandom = (1..300).anyOne()
        return new PaloBrujula(valorBasico = valorRandom)
    }
}

object departamento{
    var agentes = []

    method mejorAgente(){
        if(agentes.isEmpty()){
            self.error("No hay agentes en el departamento")
        }
        return agentes.max({agente => agente.paquetesVendidos()})
    }
    
    method pasarDiaDeLosMuertos(){
        self.mejorAgente().reducirDeuda(50)

        const deudores = agentes.filter({agente => agente.deuda() > 0   })
        deudores.forEach({agente => agente.aumentarDeuda(100)})

        agentes.removeAllSuchThat({agente => agente.deuda() == 0})
    }
}

class Paquete{
    const valorBasico
    method valorBasico() = valorBasico

    method costo(alma) = (valorBasico * self.aniosReducidos(alma)).min(350)
    method aniosReducidos(alma)
}

class PaqueteTren inherits Paquete{
    override method aniosReducidos(alma) = 4
}

class PaqueteBote inherits Paquete{
    override method aniosReducidos(alma) = (alma.buenasAcciones() / 50).min(2)
}

class PaqueteCrucero inherits PaqueteBote{
    override method aniosReducidos(alma) = super(alma) * 2
}

class PaloBrujula inherits Paquete{
    override method aniosReducidos(alma) = 0.05
    override method costo(alma) = valorBasico
}