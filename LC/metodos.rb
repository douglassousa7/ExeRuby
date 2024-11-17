def numero_impares(min = 0, max)
  (min..max).each do |numero|
    puts "O numero #{numero} é impar" if numero.odd?  
  end
end 

def media(elementos)
  elementos.sum / elementos.size 
end

numero_impares(80,90)
puts '-----'
numero_impares(12)
# puts media ([9, 1, 2])
# puts media ([10, 20])
