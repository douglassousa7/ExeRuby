#analise o dia da semana
#SE esse dia for domingo 
#IMPRIMA que nosso dia será especial 
dia  = "feriado"
if dia == "domingo" #== é uma comparação 
    almoco = "especial"
elsif  dia == "feriado"
    almoco = "mais tarde"
else
    almoco = "normal"
end
#imprime --> puts
puts "hoje nosso almoço será #{almoco}"