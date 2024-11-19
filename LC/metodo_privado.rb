class Sorteio
  def initialize (participantes)
    @participantes = participantes
  end

  def sortear 
    return if @participantes.empty?

    sorteado = @participantes.sample
    puts " O participante sorteado foi: #{sorteado}!"

    remover_participante sorteado
  end 

  def remover_participante(participante)
    @participantes.delete(participante)
  end
end 

participantes = ["Ana", "Lucas", "Pedro", "Maria"]
sorteio = Sorteio.new(participantes)

sorteio.sortear # Sorteia um participante e o remove da lista
sleep 5 # segundos 
sorteio.sortear # Sorteia outro participante
sleep 2 # segundos 
sorteio.sortear # Continua sorteando até a lista ficar vazia
sleep 2 # segundos 
sorteio.sortear # Não faz nada, pois a lista está vazia
