class Cachorro
  def latir
    puts "au au"
  end
end

class Gato
  def miar
    puts "miau"
  end
end

cachorro = Cachorro.new
cachorro.latir

Gato.new.miar 

