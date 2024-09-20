def menu
  puts "Escolha uma opção:"
  puts "1. Adicionar"
  puts "2. Subtrair"
  puts "3. Multiplicar"
  puts "4. Dividir"
  puts "5. Sair"
end

def get_number(prompt)
  print prompt
  gets.chomp.to_f
end

loop do
  menu
  option = gets.chomp.to_i

  case option
  when 1
    num1 = get_number("Digite o primeiro número: ")
    num2 = get_number("Digite o segundo número: ")
    puts "Resultado: #{num1 + num2}"
  when 2
    num1 = get_number("Digite o primeiro número: ")
    num2 = get_number("Digite o segundo número: ")
    puts "Resultado: #{num1 - num2}"
  when 3
    num1 = get_number("Digite o primeiro número: ")
    num2 = get_number("Digite o segundo número: ")
    puts "Resultado: #{num1 * num2}"
  when 4
    num1 = get_number("Digite o primeiro número: ")
    num2 = get_number("Digite o segundo número: ")
    if num2 == 0
      puts "Erro: Divisão por zero não é permitida!"
    else
      puts "Resultado: #{num1 / num2}"
    end
  when 5
    puts "Saindo..."
    break
  else
    puts "Opção inválida. Por favor, tente novamente."
  end

  puts # Linha em branco para melhorar a legibilidade
end
