def caracteres_ausentes_para_pangrama(str)
  # Inicializando um conjunto para armazenar os caracteres presentes
  presentes = Set.new

  # Iterando por cada caractere da string
  str.each_char do |char|
    # Verificando se o caractere é uma letra
    if char =~ /[a-zA-Z]/
      # Convertendo o caractere para minúsculo e adicionando no conjunto
      presentes.add(char.downcase)
    end
  end

  # Inicializando uma string vazia para armazenar os caracteres ausentes
  ausentes = ""

  # Iterando pelas letras de 'a' até 'z'
  ('a'..'z').each do |letra|
    # Se a letra não estiver no conjunto, adiciona à string ausentes
    ausentes += letra unless presentes.include?(letra)
  end

  # Se não houver letras ausentes, significa que a string é um pangrama
  if ausentes.empty?
    puts "A string é um pangrama!"
  else
    # Caso contrário, imprime os caracteres ausentes
    puts "Caracteres ausentes para pangrama: #{ausentes}"
  end
end

# Testando com as entradas
caracteres_ausentes_para_pangrama("welcome to geeksforgeeks")  # Exemplo 1
caracteres_ausentes_para_pangrama("The quick brown fox jumps") # Exemplo 2
