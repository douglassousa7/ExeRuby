class Pizza 
  MINUTOS_ESPERANDO_NO_FOGAO = 52 

  def tempo_restante_fogao (minutos_reais_no_fogao)
    MINUTOS_ESPERANDO_NO_FOGAO - minutos_reais_no_fogao
  end

  def tempo_de_preparo_em_minutos (montagem)
  montagem * 4
  end 

  def tempo_total_em_minutos (numero_de_montagem:, minutos_reais_no_fogao:)
  tempo_de_preparo_em_minutos(numero_de_montagem) + minutos_reais_no_fogao
  end
end 

# exemplo de uso

pizza = Pizza.new 
puts pizza.tempo_restante_fogao (50)
puts pizza.tempo_de_preparo_em_minutos (2)
puts pizza.tempo_total_em_minutos(numero_de_montagem: 2, minutos_reais_no_fogao: 50)
