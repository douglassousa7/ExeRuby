require 'gtk3'

ARQUIVO_TAREFAS = "tarefas.txt"
CATEGORIAS = ["Pessoal", "Trabalho", "Estudo", "Compras", "Outro"]

# Função para carregar as tarefas do arquivo
def carregar_tarefas
  begin
    if File.exist?(ARQUIVO_TAREFAS)
      File.readlines(ARQUIVO_TAREFAS).map do |linha|
        concluida, texto, data, categoria, prioridade = linha.chomp.split("|")
        { 
          concluida: concluida == "true", 
          texto: texto, 
          data: data, 
          categoria: categoria || "Outro",
          prioridade: prioridade || "Média"
        }
      end
    else
      []
    end
  rescue => e
    puts "Erro ao carregar tarefas: #{e.message}"
    []
  end
end

# Função para salvar as tarefas no arquivo
def salvar_tarefas(tarefas)
  begin
    File.open(ARQUIVO_TAREFAS, "w") do |file|
      tarefas.each do |tarefa|
        file.puts("#{tarefa[:concluida]}|#{tarefa[:texto]}|#{tarefa[:data]}|#{tarefa[:categoria]}|#{tarefa[:prioridade]}")
      end
    end
  rescue => e
    puts "Erro ao salvar tarefas: #{e.message}"
  end
end

# Criar janela principal
janela = Gtk::Window.new("Gerenciador de Tarefas")
janela.set_size_request(700, 500)
janela.signal_connect("destroy") { Gtk.main_quit }

# Layout vertical
caixa = Gtk::Box.new(:vertical, 10)
caixa.set_border_width(10)

# Barra de status
barra_status = Gtk::Statusbar.new
contexto_id = barra_status.get_context_id("info")

# Função para atualizar a barra de status
def atualizar_status(tarefas, barra_status, contexto_id)
  total = tarefas.size
  concluidas = tarefas.count { |t| t[:concluida] }
  barra_status.push(contexto_id, "Total: #{total} | Concluídas: #{concluidas} | Pendentes: #{total - concluidas}")
end

# Campo de entrada de texto
entrada = Gtk::Entry.new
entrada.placeholder_text = "Digite a nova tarefa"

# Campo de entrada para data e hora
entrada_data = Gtk::Entry.new
entrada_data.placeholder_text = "Data e Hora (opcional)"

# Combobox para categorias
combo_categoria = Gtk::ComboBoxText.new
CATEGORIAS.each { |cat| combo_categoria.append_text(cat) }
combo_categoria.active = 0

# Combobox para prioridade
combo_prioridade = Gtk::ComboBoxText.new
["Alta", "Média", "Baixa"].each { |p| combo_prioridade.append_text(p) }
combo_prioridade.active = 1

# Layout horizontal para o formulário de entrada
form_box = Gtk::Box.new(:horizontal, 5)
form_box.pack_start(entrada, expand: true, fill: true, padding: 5)
form_box.pack_start(entrada_data, expand: false, fill: false, padding: 5)
form_box.pack_start(Gtk::Label.new("Categoria:"), expand: false, fill: false, padding: 5)
form_box.pack_start(combo_categoria, expand: false, fill: false, padding: 5)
form_box.pack_start(Gtk::Label.new("Prioridade:"), expand: false, fill: false, padding: 5)
form_box.pack_start(combo_prioridade, expand: false, fill: false, padding: 5)

# Botão para adicionar tarefa
botao_adicionar = Gtk::Button.new(label: "Adicionar Tarefa")

# Lista de tarefas (com Scroll)
modelo_lista = Gtk::ListStore.new(TrueClass, String, String, String, String)
lista_tarefas = Gtk::TreeView.new(modelo_lista)

# Coluna para checkboxes (tarefas concluídas)
renderer_concluida = Gtk::CellRendererToggle.new
coluna_concluida = Gtk::TreeViewColumn.new("Concluída", renderer_concluida, active: 0)
lista_tarefas.append_column(coluna_concluida)

# Coluna para o texto da tarefa
renderer_texto = Gtk::CellRendererText.new
coluna_texto = Gtk::TreeViewColumn.new("Tarefa", renderer_texto)
# Usar uma função para definir o texto (com possibilidade de estilizar)
coluna_texto.set_cell_data_func(renderer_texto) do |column, cell, model, iter|
  cell.text = iter[1]
  # Aplicar estilo de riscado para tarefas concluídas
  if iter[0] # Se a tarefa estiver concluída
    cell.strikethrough = true
  else
    cell.strikethrough = false
  end
end
lista_tarefas.append_column(coluna_texto)

# Coluna para a data e hora
renderer_data = Gtk::CellRendererText.new
coluna_data = Gtk::TreeViewColumn.new("Data/Hora", renderer_data, text: 2)
lista_tarefas.append_column(coluna_data)

# Coluna para a categoria
renderer_categoria = Gtk::CellRendererText.new
coluna_categoria = Gtk::TreeViewColumn.new("Categoria", renderer_categoria, text: 3)
lista_tarefas.append_column(coluna_categoria)

# Coluna para a prioridade
renderer_prioridade = Gtk::CellRendererText.new
coluna_prioridade = Gtk::TreeViewColumn.new("Prioridade", renderer_prioridade)
# Usar uma função para definir o texto com cores diferentes por prioridade
coluna_prioridade.set_cell_data_func(renderer_prioridade) do |column, cell, model, iter|
  prioridade = iter[4]
  cell.text = prioridade
  
  case prioridade
  when "Alta"
    cell.foreground = "red"
  when "Média"
    cell.foreground = "blue"
  when "Baixa"
    cell.foreground = "green"
  else
    cell.foreground = "black"
  end
end
lista_tarefas.append_column(coluna_prioridade)

# Box para os controles de filtragem
filtro_box = Gtk::Box.new(:horizontal, 5)

# Combobox para filtrar por categoria
label_filtro_categoria = Gtk::Label.new("Filtrar por Categoria:")
combo_filtro_categoria = Gtk::ComboBoxText.new
combo_filtro_categoria.append_text("Todas")
CATEGORIAS.each { |cat| combo_filtro_categoria.append_text(cat) }
combo_filtro_categoria.active = 0

# Combobox para filtrar por status
label_filtro_status = Gtk::Label.new("Filtrar por Status:")
combo_filtro_status = Gtk::ComboBoxText.new
["Todas", "Concluídas", "Pendentes"].each { |s| combo_filtro_status.append_text(s) }
combo_filtro_status.active = 0

# Campo de pesquisa
entrada_pesquisa = Gtk::Entry.new
entrada_pesquisa.placeholder_text = "Pesquisar tarefas..."

# Botão para aplicar filtros
botao_filtrar = Gtk::Button.new(label: "Aplicar Filtros")

# Adicionar controles de filtragem ao box
filtro_box.pack_start(label_filtro_categoria, expand: false, fill: false, padding: 5)
filtro_box.pack_start(combo_filtro_categoria, expand: false, fill: false, padding: 5)
filtro_box.pack_start(label_filtro_status, expand: false, fill: false, padding: 5)
filtro_box.pack_start(combo_filtro_status, expand: false, fill: false, padding: 5)
filtro_box.pack_start(entrada_pesquisa, expand: true, fill: true, padding: 5)
filtro_box.pack_start(botao_filtrar, expand: false, fill: false, padding: 5)

# Adicionar Scroll à lista de tarefas
scrolled_window = Gtk::ScrolledWindow.new
scrolled_window.set_policy(:automatic, :automatic) # Barras de rolagem automáticas
scrolled_window.add(lista_tarefas)

# Box horizontal para botões de ação
botoes_box = Gtk::Box.new(:horizontal, 5)

# Botão para remover tarefa
botao_remover = Gtk::Button.new(label: "Remover Selecionada")

# Botão para editar tarefa
botao_editar = Gtk::Button.new(label: "Editar Tarefa")

# Botão para gerar relatório
botao_relatorio = Gtk::Button.new(label: "Gerar Relatório")

# Adicionar botões ao box
botoes_box.pack_start(botao_remover, expand: true, fill: true, padding: 5)
botoes_box.pack_start(botao_editar, expand: true, fill: true, padding: 5)
botoes_box.pack_start(botao_relatorio, expand: true, fill: true, padding: 5)

# Variável para armazenar todas as tarefas
tarefas = carregar_tarefas

# Função para atualizar a lista na interface
def atualizar_lista(modelo_lista, tarefas, filtro_categoria = "Todas", filtro_status = "Todas", termo_pesquisa = "")
  modelo_lista.clear
  
  tarefas_filtradas = tarefas.select do |tarefa|
    categoria_ok = filtro_categoria == "Todas" || tarefa[:categoria] == filtro_categoria
    status_ok = case filtro_status
                when "Concluídas"
                  tarefa[:concluida]
                when "Pendentes"
                  !tarefa[:concluida]
                else
                  true
                end
    pesquisa_ok = termo_pesquisa.empty? || 
                 tarefa[:texto].downcase.include?(termo_pesquisa.downcase) ||
                 tarefa[:categoria].downcase.include?(termo_pesquisa.downcase)
    
    categoria_ok && status_ok && pesquisa_ok
  end
  
  tarefas_filtradas.each do |tarefa|
    iter = modelo_lista.append
    iter[0] = tarefa[:concluida]
    iter[1] = tarefa[:texto]
    iter[2] = tarefa[:data]
    iter[3] = tarefa[:categoria]
    iter[4] = tarefa[:prioridade]
  end
end

# Carregar tarefas na lista
atualizar_lista(modelo_lista, tarefas)
atualizar_status(tarefas, barra_status, contexto_id)

# Evento para aplicar filtros
botao_filtrar.signal_connect("clicked") do
  filtro_categoria = combo_filtro_categoria.active_text
  filtro_status = combo_filtro_status.active_text
  termo_pesquisa = entrada_pesquisa.text
  
  atualizar_lista(modelo_lista, tarefas, filtro_categoria, filtro_status, termo_pesquisa)
end

# Evento para adicionar tarefa
botao_adicionar.signal_connect("clicked") do
  texto = entrada.text.strip
  data = entrada_data.text.strip
  categoria = combo_categoria.active_text
  prioridade = combo_prioridade.active_text
  
  unless texto.empty?
    nova_tarefa = { 
      concluida: false, 
      texto: texto, 
      data: data.empty? ? "Sem data" : data,
      categoria: categoria,
      prioridade: prioridade
    }
    
    tarefas << nova_tarefa
    salvar_tarefas(tarefas)
    atualizar_lista(modelo_lista, tarefas, combo_filtro_categoria.active_text, 
                    combo_filtro_status.active_text, entrada_pesquisa.text)
    atualizar_status(tarefas, barra_status, contexto_id)
    
    entrada.text = "" # Limpa o campo após adicionar
    entrada_data.text = "" # Limpa o campo de data
  end
end

# Evento para remover tarefa
botao_remover.signal_connect("clicked") do
  selecionado = lista_tarefas.selection.selected
  if selecionado
    tarefa_texto = selecionado[1]
    dialog = Gtk::MessageDialog.new(parent: janela,
                                    flags: :modal,
                                    type: :question,
                                    buttons: :yes_no,
                                    message: "Tem certeza que deseja remover a tarefa: #{tarefa_texto}?")
    resposta = dialog.run
    if resposta == Gtk::ResponseType::YES
      tarefas.delete_if { |t| t[:texto] == tarefa_texto }
      salvar_tarefas(tarefas)
      atualizar_lista(modelo_lista, tarefas, combo_filtro_categoria.active_text, 
                      combo_filtro_status.active_text, entrada_pesquisa.text)
      atualizar_status(tarefas, barra_status, contexto_id)
    end
    dialog.destroy
  end
end

# Evento para editar tarefa
botao_editar.signal_connect("clicked") do
  selecionado = lista_tarefas.selection.selected
  if selecionado
    tarefa_texto = selecionado[1]
    tarefa_data = selecionado[2]
    tarefa_categoria = selecionado[3]
    tarefa_prioridade = selecionado[4]
    
    # Criar dialog para edição
    dialog = Gtk::Dialog.new(
      title: "Editar Tarefa",
      parent: janela,
      flags: :modal,
      buttons: [["Cancelar", Gtk::ResponseType::CANCEL], ["Salvar", Gtk::ResponseType::OK]]
    )
    
    # Criar campos do formulário
    entrada_edicao = Gtk::Entry.new
    entrada_edicao.text = tarefa_texto
    
    entrada_edicao_data = Gtk::Entry.new
    entrada_edicao_data.text = tarefa_data
    
    combo_edicao_categoria = Gtk::ComboBoxText.new
    CATEGORIAS.each_with_index do |cat, i|
      combo_edicao_categoria.append_text(cat)
      combo_edicao_categoria.active = i if cat == tarefa_categoria
    end
    
    combo_edicao_prioridade = Gtk::ComboBoxText.new
    ["Alta", "Média", "Baixa"].each_with_index do |p, i|
      combo_edicao_prioridade.append_text(p)
      combo_edicao_prioridade.active = i if p == tarefa_prioridade
    end
    
    # Criar grid para organizar os campos
    grid = Gtk::Grid.new
    grid.set_column_spacing(10)
    grid.set_row_spacing(10)
    grid.set_margin_top(20)
    grid.set_margin_bottom(20)
    grid.set_margin_start(20)
    grid.set_margin_end(20)
    
    # Adicionar rótulos e campos ao grid
    grid.attach(Gtk::Label.new("Tarefa:"), 0, 0, 1, 1)
    grid.attach(entrada_edicao, 1, 0, 1, 1)
    
    grid.attach(Gtk::Label.new("Data/Hora:"), 0, 1, 1, 1)
    grid.attach(entrada_edicao_data, 1, 1, 1, 1)
    
    grid.attach(Gtk::Label.new("Categoria:"), 0, 2, 1, 1)
    grid.attach(combo_edicao_categoria, 1, 2, 1, 1)
    
    grid.attach(Gtk::Label.new("Prioridade:"), 0, 3, 1, 1)
    grid.attach(combo_edicao_prioridade, 1, 3, 1, 1)
    
    # Adicionar grid ao diálogo
    box = dialog.content_area
    box.add(grid)
    
    dialog.show_all
    resposta = dialog.run
    
    if resposta == Gtk::ResponseType::OK
      novo_texto = entrada_edicao.text.strip
      nova_data = entrada_edicao_data.text.strip
      nova_categoria = combo_edicao_categoria.active_text
      nova_prioridade = combo_edicao_prioridade.active_text
      
      unless novo_texto.empty?
        # Atualizar a tarefa na lista de tarefas
        tarefa_index = tarefas.index { |t| t[:texto] == tarefa_texto }
        if tarefa_index
          tarefas[tarefa_index][:texto] = novo_texto
          tarefas[tarefa_index][:data] = nova_data.empty? ? "Sem data" : nova_data
          tarefas[tarefa_index][:categoria] = nova_categoria
          tarefas[tarefa_index][:prioridade] = nova_prioridade
          
          salvar_tarefas(tarefas)
          atualizar_lista(modelo_lista, tarefas, combo_filtro_categoria.active_text, 
                          combo_filtro_status.active_text, entrada_pesquisa.text)
        end
      end
    end
    
    dialog.destroy
  end
end

# Evento para gerar relatório
botao_relatorio.signal_connect("clicked") do
  dialog = Gtk::Dialog.new(
    title: "Relatório de Tarefas",
    parent: janela,
    flags: :modal,
    buttons: [["Fechar", Gtk::ResponseType::CLOSE]]
  )
  dialog.set_size_request(400, 300)
  
  # Criar área de texto para o relatório
  area_texto = Gtk::TextView.new
  area_texto.editable = false
  area_texto.cursor_visible = false
  buffer = area_texto.buffer
  
  # Preparar o relatório
  buffer.text = "RELATÓRIO DE TAREFAS\n"
  buffer.text += "=" * 50 + "\n\n"
  
  total = tarefas.size
  concluidas = tarefas.count { |t| t[:concluida] }
  pendentes = total - concluidas
  
  if total > 0
    buffer.text += "Total de tarefas: #{total}\n"
    buffer.text += "Tarefas concluídas: #{concluidas} (#{(concluidas.to_f / total * 100).round(1)}%)\n"
    buffer.text += "Tarefas pendentes: #{pendentes} (#{(pendentes.to_f / total * 100).round(1)}%)\n\n"
    
    # Estatísticas por categoria
    buffer.text += "TAREFAS POR CATEGORIA\n"
    buffer.text += "-" * 50 + "\n"
    
    categorias_contagem = {}
    CATEGORIAS.each { |cat| categorias_contagem[cat] = 0 }
    
    tarefas.each do |tarefa|
      categorias_contagem[tarefa[:categoria]] += 1
    end
    
    categorias_contagem.each do |categoria, contagem|
      next if contagem == 0
      percentual = (contagem.to_f / total * 100).round(1)
      buffer.text += "#{categoria}: #{contagem} (#{percentual}%)\n"
    end
    
    buffer.text += "\nTAREFAS POR PRIORIDADE\n"
    buffer.text += "-" * 50 + "\n"
    
    prioridades_contagem = {"Alta" => 0, "Média" => 0, "Baixa" => 0}
    tarefas.each do |tarefa|
      prioridades_contagem[tarefa[:prioridade]] += 1
    end
    
    prioridades_contagem.each do |prioridade, contagem|
      next if contagem == 0
      percentual = (contagem.to_f / total * 100).round(1)
      buffer.text += "#{prioridade}: #{contagem} (#{percentual}%)\n"
    end
  else
    buffer.text += "Não há tarefas cadastradas."
  end
  
  # Adicionar área de texto com scroll
  scrolled = Gtk::ScrolledWindow.new
  scrolled.set_policy(:automatic, :automatic)
  scrolled.add(area_texto)
  
  # Adicionar botão para exportar relatório
  botao_exportar = Gtk::Button.new(label: "Exportar Relatório")
  botao_exportar.signal_connect("clicked") do
    arquivo_relatorio = "relatorio_tarefas_#{Time.now.strftime('%Y%m%d_%H%M%S')}.txt"
    File.write(arquivo_relatorio, buffer.text)
    mensagem = Gtk::MessageDialog.new(
      parent: dialog,
      flags: :modal,
      type: :info,
      buttons: :ok,
      message: "Relatório exportado para #{arquivo_relatorio}"
    )
    mensagem.run
    mensagem.destroy
  end
  
  # Adicionar widgets ao diálogo
  box = dialog.content_area
  box.pack_start(scrolled, expand: true, fill: true, padding: 10)
  box.pack_start(botao_exportar, expand: false, fill: false, padding: 10)
  
  dialog.show_all
  dialog.run
  dialog.destroy
end

# Evento para marcar/desmarcar tarefa como concluída
renderer_concluida.signal_connect("toggled") do |renderer, path|
  iter = modelo_lista.get_iter(path)
  iter[0] = !iter[0] # Alterna entre true/false
  
  tarefa_texto = iter[1]
  tarefa_index = tarefas.index { |t| t[:texto] == tarefa_texto }
  
  if tarefa_index
    tarefas[tarefa_index][:concluida] = iter[0]
    salvar_tarefas(tarefas)
    atualizar_status(tarefas, barra_status, contexto_id)
  end
end

# Adicionar widgets ao layout
caixa.pack_start(form_box, expand: false, fill: false, padding: 5)
caixa.pack_start(botao_adicionar, expand: false, fill: false, padding: 5)
caixa.pack_start(filtro_box, expand: false, fill: false, padding: 5)
caixa.pack_start(scrolled_window, expand: true, fill: true, padding: 5)
caixa.pack_start(botoes_box, expand: false, fill: false, padding: 5)
caixa.pack_start(barra_status, expand: false, fill: false, padding: 0)

# Adicionar layout à janela e exibir
janela.add(caixa)
janela.show_all
Gtk.main