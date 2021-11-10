class Empleado {
	var habilidades = []
	var salud
	var rol
	method incapacitadx() = salud < rol.saludCritica()
	method puedeUsar(habilidad)=self.incapacitadx().negate() && self.poseeHabilidad(habilidad)	
	method estaVivo() =  salud>0
	method finalizarMision(mision){
		if(self.estaVivo()){
			rol.completarMision(mision,self)
		}
	}
	method recibeDanio(cantidad){salud-=cantidad}
	method agregarHabilidad(habilidad){
		habilidades.add(habilidad)
	}
	method poseeHabilidad(habilidad)= habilidades.contains(habilidad)
	method cambiarRol(puesto){rol=puesto}
}
class Oficinista{
	var estrellas
	method saludCritica()=40-5*estrellas
	method completoMision(mision,empleado){
		estrellas+=1
		if(estrellas==3){
			empleado.cambiarRol(espia)
		}
	}
}
object espia{
	method saludCritica()=15
	method completarMision(mision,empleado){
		mision.habilidadesQueNoPosee(empleado)
		mision.enseniarHabilidades(empleado)
		}
}
class Jefe inherits Empleado{
	var subordinadxs = []
	override method puedeUsar(habilidad){
		return super(habilidad)||self.algunoDeSusSubordinadosPuedeUsarHabilidad(habilidad)
	}
	method algunoDeSusSubordinadosPuedeUsarHabilidad(habilidad) = subordinadxs.any{subordinadx=>subordinadx.puedeUsar(habilidad)}
}
class Equipo{
	var integrantes = []
	method puedeUsar(habilidad)= integrantes.any{integrante=>integrante.puedeUsar(habilidad)}
	method recibeDanio(peligrosidad) {integrantes.forEach{integrante=>integrante.recibeDanio(peligrosidad/3)}}
}
	
class Mision{
	const property habilidadesRequeridas = []
	const property peligrosidad
	method tieneHabilidadesNecesarias(asignado)=habilidadesRequeridas.all{habilidad => asignado.puedeUsar(habilidad)}
	method serCumplidaPor(asignado){
		if(not self.tieneHabilidadesNecesarias(asignado)){
			self.error("El empleado/equipo asignado no cumple los requerimientos necesarios")	
		}
		asignado.recibeDanio(peligrosidad)
		asignado.sobrevivoMision(self)
	}
	method habilidadesQueNoPosee(empleado)=habilidadesRequeridas.filter{habilidad=>not empleado.poseeHabilidad(habilidad)} 
	method enseniarHabilidades(empleado){self.habilidadesQueNoPosee(empleado).forEach{habilidad=>empleado.enseniarHabilidad(habilidad)}}
}