# Inicializa um array vazio
numeros = []

# Solicita 3 números do usuário
3.times do |i|
  puts "Digite o número #{i+1}:"
  numeros << gets.to_i
end

# Eleva cada número ao quadrado e exibe o resultado
numeros.each do |numero|
  puts "#{numero} elevado ao quadrado é #{numero**2}"
end
