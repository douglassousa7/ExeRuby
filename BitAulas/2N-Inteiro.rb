# Solicita o primeiro número do usuário 
print "Digite o primeiro número inteiro: "
num1 = gets.chomp.to_i

# Solicita o segundo número do usuário 
print "Digite o primeirosegundo número inteiro: "
num2 = gets.chomp.to_i

# realiza operações matematicas 
soma  = num1 + num2
substracao = num1 - num2
multiplicacao = num1 * num2
divisao = num1.to_f / num2 # Convertendo para float para divisão precisa

# exibi resultados
puts "A soma de #{num1} e #{num2} é #{soma}."
puts "A substração de #{num1} e #{num2} é #{substracao}. "
puts "A multiplicacao de #{num1} e #{num2} é #{multiplicacao} "
puts "A divisão de #{num1} e #{num2} é #{divisao} " 
