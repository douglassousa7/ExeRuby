class Tempo
  def self.agora
    Time.now
  end

#podemos misturar métodos de class e métodos de instancia 
# na mesma classe, sem problemas

  def alguma_coisa
    puts "funcionando"
  end
end

puts Tempo.agora

Tempo.new.alguma_coisa