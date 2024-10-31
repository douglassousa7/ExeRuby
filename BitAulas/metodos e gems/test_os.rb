require 'os'

puts OS.cpu_count   # Exibe o número de CPUs
puts OS.bits        # Exibe a arquitetura (ex.: 64 ou 32 bits)
puts OS.host_os     # Exibe o nome do sistema operacional
