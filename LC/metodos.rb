def numero_impares(min, max)
  (min..max).each do |numero|
    puts "O numero #{numero} é impar" if numero.odd?  
  end
end 

numero_impares(80,90)
