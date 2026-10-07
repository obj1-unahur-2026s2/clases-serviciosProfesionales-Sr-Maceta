class ProfesionalVinculado {
  const property universidad
  method honorarios() = universidad.honorarios()
  method provincias() = universidad.provincia().asList()

  method cobrarImporte(cantidad) {
    universidad.recibirDinero(cantidad/2)
  }
}

class ProfesionalLitoral {
  const property universidad
  method honorarios() = 3000
  method provincias() = [entreRios, santaFe, corrientes]

  method cobrarImporte(cantidad) {
    asociacionDeProfesionalesDelLitoral.recibirDinero(cantidad)
  }
}

class ProfesionalLibre {
  const property universidad
  const property honorarios
  const property provincias 

  var dinero = 0
  method cobrarImporte(cantidad) {
    dinero += cantidad
  }
  method pasarDinero(profesional, cantidad) {
    dinero -= cantidad
    profesional.cobrarImporte(cantidad)
  }
}

class Universidad {
  const property provincia
  const property honorarios
  
  var dinero = 0
  method recibirDinero(cantidad) {
    dinero += cantidad
  }
}

object asociacionDeProfesionalesDelLitoral {
  var dinero = 0
  method recibirDinero(cantidad) {
    dinero += cantidad
  }
}

object entreRios {}
object santaFe {}
object corrientes {}
object buenosAires {}
object cordoba {}
object misiones {}

class Empresa {
  const profesionales = #{}
  const clientes = #{}
  const honorarioDeReferencia

  method contratarProfesionales(profesionalesAContratar) {
    profesionales.addAll(profesionalesAContratar)
  }

  method cuantosProfesionalesSonDe(unaUniversidad) = 
    profesionales.count({p => p.universidad() == unaUniversidad})
  
  method conjuntoDeProfesionalesCaros() = 
    profesionales.filter({p => p.honorarios() > honorarioDeReferencia})
  
  method conjuntoDeUniversidadesFormadoras() = 
    profesionales.map({p => p.universidad()}).asSet()
  
  method profesionalMasBarato() = 
    profesionales.min({p => p.honorarios()})
  
  method esDeGenteAcotada() = 
    profesionales.all({p => p.provincias().size() <= 3 })

  method puedeSatisfacerA(solicitante) = 
    profesionales.any({p => solicitante.puedeSerAtendidoPor(p)})

  method darServicio(solicitante) {
    if(self.puedeSatisfacerA(solicitante)){
      self.profesionalQuePuedeSatisfacerA(solicitante).cobrarImporte
      (self.profesionalQuePuedeSatisfacerA(solicitante).honorarios())
      clientes.add(solicitante)
    }
  }

  method profesionalQuePuedeSatisfacerA(solicitante) = 
    profesionales.find({p => solicitante.puedeSerAtendidoPor(p)})

  method cuantosClientesTiene() = 
    clientes.size()
  
  method tieneComoClienteA(determinadoSolicitante) = 
    clientes.contains(determinadoSolicitante)

  method esPocoAtractivo(profesional) = 
    profesional.provincias().all({p => self.algunProfesionalTrabajaEnYCobraMenorQue(p, profesional)})
    

  method algunProfesionalTrabajaEnYCobraMenorQue(estaProvincia, profesional) = 
    profesionales.any({p => p != profesional && p.provincias().contains(estaProvincia) && p.honorarios()<profesional.honorarios()})
}

object noHay {
  method honorarios() = 0
}

class Persona {
  const provincia

  method puedeSerAtendidoPor(profesional) = 
    profesional.provincias().contains(provincia)
}

class Institucion {
  const universidades

  method puedeSerAtendidoPor(profesional) = 
    universidades.contains(profesional.universidad())
}

class Club {
  const provincias

  method puedeSerAtendidoPor(profesional) =
    provincias.any({p => profesional.provincias().contains(p)})
}