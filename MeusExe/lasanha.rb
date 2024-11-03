# class Lasagna
#   # Constante que define o tempo esperado de cozimento em minutos
#   EXPECTED_MINUTES_IN_OVEN = 40

#   # Método para calcular o tempo restante de cozimento
#   def remaining_minutes_in_oven(actual_minutes_in_oven)
#     EXPECTED_MINUTES_IN_OVEN - actual_minutes_in_oven
#   end

#   # Método para calcular o tempo de preparação com base no número de camadas
#   def preparation_time_in_minutes(layers)
#     layers * 2  # Considera 2 minutos por camada
#   end

#   # Método para calcular o tempo total na cozinha
#   def total_time_in_minutes(number_of_layers:, actual_minutes_in_oven:)
#     preparation_time_in_minutes(number_of_layers) + actual_minutes_in_oven
#   end
# end

# # Exemplo de uso:
# lasagna = Lasagna.new
# puts lasagna.remaining_minutes_in_oven(20)  # Deve imprimir 20
# puts lasagna.preparation_time_in_minutes(3)  # Deve imprimir 6
# puts lasagna.total_time_in_minutes(number_of_layers: 3, actual_minutes_in_oven: 20)  # Deve imprimir 26





class Lasanha
  # Constante que define o tempo esperado de cozimento em minutos
  TEMPO_ESPERADO_NO_FORNO = 40

  # Método para calcular o tempo restante de cozimento
  def tempo_restante_no_forno(minutos_reais_no_forno)
    TEMPO_ESPERADO_NO_FORNO - minutos_reais_no_forno
  end

  # Método para calcular o tempo de preparação com base no número de camadas
  def tempo_de_preparacao_em_minutos(camadas)
    camadas * 2  # Considera 2 minutos por camada
  end

  # Método para calcular o tempo total na cozinha
  def tempo_total_em_minutos(numero_de_camadas:, minutos_reais_no_forno:)
    tempo_de_preparacao_em_minutos(numero_de_camadas) + minutos_reais_no_forno
  end
end

# Exemplo de uso:
lasanha = Lasanha.new
puts "tempo restante no forno:", lasanha.tempo_restante_no_forno(20)  # Deve imprimir 20
puts "tempo de preparação:", lasanha.tempo_de_preparacao_em_minutos(3)  # Deve imprimir 6
puts "tempo que ficou no forno:", lasanha.tempo_total_em_minutos(numero_de_camadas: 3, minutos_reais_no_forno: 20)  # Deve imprimir 26