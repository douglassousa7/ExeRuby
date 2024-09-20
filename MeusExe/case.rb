#usuario vai entrar com o mes de nascimento dele
#analise diversos casos
#permite que o usuario entre com esse dados
puts "Digite seu mês de nascimento: "
mes = gets.chomp.to_i

#definir casos
case mes
when 1..3 #intervalo 
    puts "Você nasceu no primeiro trimestre do ano"
when 4..6 #intervalo 
    puts "Você nasceu no primeiro semestre do ano"
when 7..9 #intervalo 
    puts "Você nasceu no terceiro trimestre do ano"
when 10..12 #intervalo 
    puts "Você nasceu no segundo semestre,final, do ano"
else
    puts "valor  digitado invalido"   
end 
    