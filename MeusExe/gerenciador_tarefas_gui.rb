require 'gtk3'
require 'libnotify'
require 'date'

class GerenciadorTarefas
  ARQUIVO_TAREFAS = "tarefas.txt"
  CATEGORIAS = ["Pessoal", "Trabalho", "Estudo", "Compras", "Outro"]
  PRIORIDADES = ["Alta", "Média", "Baixa"]

  def self.carregar_tarefas
    return [] unless File.exist?(ARQUIVO_TAREFAS)
    File.readlines(ARQUIVO_TAREFAS, chomp: true).map do |linha|
      concluida, texto, data, categoria, prioridade = linha.split("|")
      {
        concluida: concluida == "true",
        texto: texto,
        data: data,
        categoria: categoria || "Outro",
        prioridade: prioridade || "Média"
      }
    rescue => e
      puts "Erro ao carregar tarefas: #{e.message}"
      []
    end
  end

  def self.salvar_tarefas(tarefas)
    File.open(ARQUIVO_TAREFAS, "w") do |file|
      tarefas.each do |tarefa|
        file.puts("#{tarefa[:concluida]}|#{tarefa[:texto]}|#{tarefa[:data]}|#{tarefa[:categoria]}|#{tarefa[:prioridade]}")
      end
    end
  rescue => e
    puts "Erro ao salvar tarefas: #{e.message}"
  end

  def self.verificar_tarefas_proximas(tarefas)
    hoje = Date.today
    tarefas.each do |tarefa|
      next unless tarefa[:data]
      data_tarefa = Date.parse(tarefa[:data]) rescue next
      if (data_tarefa - hoje).to_i <= 2
        Libnotify.show(
          summary: "Tarefa Próxima: #{tarefa[:texto]}",
          body: "Data: #{tarefa[:data]}\nCategoria: #{tarefa[:categoria]}\nPrioridade: #{tarefa[:prioridade]}",
          timeout: 5
        )
      end
    end
  end
end

class InterfaceGrafica
  def initialize
    @tarefas = GerenciadorTarefas.carregar_tarefas
    setup_ui
    carregar_tarefas_na_lista
    configurar_eventos
    iniciar_verificacao_periodica
    @janela.show_all
    Gtk.main
  end

  private

  def setup_ui
    @janela = Gtk::Window.new("Gerenciador de Tarefas")
    @janela.set_size_request(700, 500)
    @janela.signal_connect("destroy") { Gtk.main_quit }

    @caixa = Gtk::Box.new(:vertical, 10)
    @caixa.set_border_width(10)
    @janela.add(@caixa)

    criar_barra_status
    criar_formulario_entrada
    criar_lista_tarefas
    criar_filtros
    criar_botoes_acao
  end

  def criar_barra_status
    @barra_status = Gtk::Statusbar.new
    @contexto_id = @barra_status.get_context_id("info")
    @caixa.pack_start(@barra_status, expand: false, fill: false, padding: 0)
  end

  def criar_formulario_entrada
    @entrada = Gtk::Entry.new
    @entrada.placeholder_text = "Digite a nova tarefa"
    @calendario = Gtk::Calendar.new
    @calendario.mark_day(Time.now.day)

    @combo_categoria = Gtk::ComboBoxText.new
    GerenciadorTarefas::CATEGORIAS.each { |cat| @combo_categoria.append_text(cat) }
    @combo_categoria.active = 0

    @combo_prioridade = Gtk::ComboBoxText.new
    GerenciadorTarefas::PRIORIDADES.each { |p| @combo_prioridade.append_text(p) }
    @combo_prioridade.active = 1

    @botao_adicionar = Gtk::Button.new(label: "Adicionar Tarefa")

    form_box = Gtk::Box.new(:horizontal, 5)
    form_box.pack_start(@entrada, expand: true, fill: true, padding: 5)
    form_box.pack_start(@calendario, expand: false, fill: false, padding: 5)
    form_box.pack_start(Gtk::Label.new("Categoria:"), expand: false, fill: false, padding: 5)
    form_box.pack_start(@combo_categoria, expand: false, fill: false, padding: 5)
    form_box.pack_start(Gtk::Label.new("Prioridade:"), expand: false, fill: false, padding: 5)
    form_box.pack_start(@combo_prioridade, expand: false, fill: false, padding: 5)
    
    @caixa.pack_start(form_box, expand: false, fill: false, padding: 5)
    @caixa.pack_start(@botao_adicionar, expand: false, fill: false, padding: 5)
  end

  def criar_lista_tarefas
    @modelo_lista = Gtk::ListStore.new(TrueClass, String, String, String, String)
    @lista_tarefas = Gtk::TreeView.new(@modelo_lista)

    renderer_concluida = Gtk::CellRendererToggle.new
    renderer_concluida.signal_connect("toggled") do |renderer, path|
      iter = @modelo_lista.get_iter(path)
      iter[0] = !iter[0]
      tarefa_index = @tarefas.index { |t| t[:texto] == iter[1] }
      if tarefa_index
        @tarefas[tarefa_index][:concluida] = iter[0]
        GerenciadorTarefas.salvar_tarefas(@tarefas)
        atualizar_status
      end
    end
    coluna_concluida = Gtk::TreeViewColumn.new("Concluída", renderer_concluida, active: 0)
    @lista_tarefas.append_column(coluna_concluida)

    renderer_texto = Gtk::CellRendererText.new
    coluna_texto = Gtk::TreeViewColumn.new("Tarefa", renderer_texto)
    coluna_texto.set_cell_data_func(renderer_texto) do |column, cell, model, iter|
      cell.text = iter[1]
      cell.strikethrough = iter[0]
    end
    @lista_tarefas.append_column(coluna_texto)

    %w[Data/Hora Categoria Prioridade].each_with_index do |titulo, i|
      renderer = Gtk::CellRendererText.new
      coluna = Gtk::TreeViewColumn.new(titulo, renderer, text: i + 2)
      @lista_tarefas.append_column(coluna)
    end

    scrolled_window = Gtk::ScrolledWindow.new
    scrolled_window.set_policy(:automatic, :automatic)
    scrolled_window.add(@lista_tarefas)
    @caixa.pack_start(scrolled_window, expand: true, fill: true, padding: 5)
  end

  def criar_filtros
    @combo_filtro_categoria = Gtk::ComboBoxText.new
    @combo_filtro_categoria.append_text("Todas")
    GerenciadorTarefas::CATEGORIAS.each { |cat| @combo_filtro_categoria.append_text(cat) }
    @combo_filtro_categoria.active = 0

    @combo_filtro_status = Gtk::ComboBoxText.new
    ["Todas", "Concluídas", "Pendentes"].each { |s| @combo_filtro_status.append_text(s) }
    @combo_filtro_status.active = 0

    @entrada_pesquisa = Gtk::Entry.new
    @entrada_pesquisa.placeholder_text = "Pesquisar tarefas..."
    @botao_filtrar = Gtk::Button.new(label: "Aplicar Filtros")

    filtro_box = Gtk::Box.new(:horizontal, 5)
    filtro_box.pack_start(Gtk::Label.new("Categoria:"), expand: false, fill: false, padding: 5)
    filtro_box.pack_start(@combo_filtro_categoria, expand: false, fill: false, padding: 5)
    filtro_box.pack_start(Gtk::Label.new("Status:"), expand: false, fill: false, padding: 5)
    filtro_box.pack_start(@combo_filtro_status, expand: false, fill: false, padding: 5)
    filtro_box.pack_start(@entrada_pesquisa, expand: true, fill: true, padding: 5)
    filtro_box.pack_start(@botao_filtrar, expand: false, fill: false, padding: 5)
    
    @caixa.pack_start(filtro_box, expand: false, fill: false, padding: 5)
  end

  def criar_botoes_acao
    @botao_remover = Gtk::Button.new(label: "Remover Selecionada")
    @botao_editar = Gtk::Button.new(label: "Editar Tarefa")
    @botao_relatorio = Gtk::Button.new(label: "Gerar Relatório")

    botoes_box = Gtk::Box.new(:horizontal, 5)
    [@botao_remover, @botao_editar, @botao_relatorio].each do |botao|
      botoes_box.pack_start(botao, expand: true, fill: true, padding: 5)
    end
    
    @caixa.pack_start(botoes_box, expand: false, fill: false, padding: 5)
  end

  def carregar_tarefas_na_lista
    @modelo_lista.clear
    @tarefas.each do |tarefa|
      iter = @modelo_lista.append
      iter[0] = tarefa[:concluida]
      iter[1] = tarefa[:texto]
      iter[2] = tarefa[:data]
      iter[3] = tarefa[:categoria]
      iter[4] = tarefa[:prioridade]
    end
    atualizar_status
  end

  def atualizar_status
    total = @tarefas.size
    concluidas = @tarefas.count { |t| t[:concluida] }
    @barra_status.push(@contexto_id, "Total: #{total} | Concluídas: #{concluidas} | Pendentes: #{total - concluidas}")
  end

  def configurar_eventos
    @botao_adicionar.signal_connect("clicked") { adicionar_tarefa }
    @botao_remover.signal_connect("clicked") { remover_tarefa }
    @botao_editar.signal_connect("clicked") { editar_tarefa }
    @botao_relatorio.signal_connect("clicked") { gerar_relatorio }
    @botao_filtrar.signal_connect("clicked") { aplicar_filtros }
  end

  def adicionar_tarefa
    texto = @entrada.text.strip
    return if texto.empty?

    ano, mes, dia = @calendario.date
    data = "#{ano}-#{mes + 1}-#{dia}"
    nova_tarefa = {
      concluida: false,
      texto: texto,
      data: data,
      categoria: @combo_categoria.active_text,
      prioridade: @combo_prioridade.active_text
    }
    
    @tarefas << nova_tarefa
    GerenciadorTarefas.salvar_tarefas(@tarefas)
    carregar_tarefas_na_lista
    @entrada.text = ""
  end

  def remover_tarefa
    selecionado = @lista_tarefas.selection.selected
    return unless selecionado

    dialog = Gtk::MessageDialog.new(
      parent: @janela,
      flags: :modal,
      type: :question,
      buttons: :yes_no,
      message: "Tem certeza que deseja remover a tarefa: #{selecionado[1]}?"
    )
    
    if dialog.run == Gtk::ResponseType::YES
      @tarefas.delete_if { |t| t[:texto] == selecionado[1] }
      GerenciadorTarefas.salvar_tarefas(@tarefas)
      carregar_tarefas_na_lista
    end
    dialog.destroy
  end

  def editar_tarefa
    selecionado = @lista_tarefas.selection.selected
    return unless selecionado
    
    dialog = criar_dialogo_edicao(selecionado)
    return unless dialog.run == Gtk::ResponseType::OK

    atualizar_tarefa_selecionada(selecionado, dialog)
    dialog.destroy
  end

  def criar_dialogo_edicao(selecionado)
    dialog = Gtk::Dialog.new(
      title: "Editar Tarefa",
      parent: @janela,
      flags: :modal,
      buttons: [["Cancelar", Gtk::ResponseType::CANCEL], ["Salvar", Gtk::ResponseType::OK]]
    )
    
    entrada_edicao = Gtk::Entry.new
    entrada_edicao.text = selecionado[1]
    entrada_data = Gtk::Entry.new
    entrada_data.text = selecionado[2]
    
    combo_categoria = Gtk::ComboBoxText.new
    GerenciadorTarefas::CATEGORIAS.each_with_index do |cat, i|
      combo_categoria.append_text(cat)
      combo_categoria.active = i if cat == selecionado[3]
    end
    
    combo_prioridade = Gtk::ComboBoxText.new
    GerenciadorTarefas::PRIORIDADES.each_with_index do |p, i|
      combo_prioridade.append_text(p)
      combo_prioridade.active = i if p == selecionado[4]
    end
    
    grid = Gtk::Grid.new
    grid.set_column_spacing(10)
    grid.set_row_spacing(10)
    grid.set_margin(20)
    
    grid.attach(Gtk::Label.new("Tarefa:"), 0, 0, 1, 1)
    grid.attach(entrada_edicao, 1, 0, 1, 1)
    grid.attach(Gtk::Label.new("Data:"), 0, 1, 1, 1)
    grid.attach(entrada_data, 1, 1, 1, 1)
    grid.attach(Gtk::Label.new("Categoria:"), 0, 2, 1, 1)
    grid.attach(combo_categoria, 1, 2, 1, 1)
    grid.attach(Gtk::Label.new("Prioridade:"), 0, 3, 1, 1)
    grid.attach(combo_prioridade, 1, 3, 1, 1)
    
    dialog.content_area.add(grid)
    dialog.show_all
    dialog
  end

  def atualizar_tarefa_selecionada(selecionado, dialog)
    novo_texto = dialog.children[0].children[0].children[1].text.strip
    return if novo_texto.empty?
    
    tarefa_index = @tarefas.index { |t| t[:texto] == selecionado[1] }
    return unless tarefa_index
    
    @tarefas[tarefa_index][:texto] = novo_texto
    @tarefas[tarefa_index][:data] = dialog.children[0].children[2].children[1].text
    @tarefas[tarefa_index][:categoria] = dialog.children[0].children[4].active_text
    @tarefas[tarefa_index][:prioridade] = dialog.children[0].children[6].active_text
    
    GerenciadorTarefas.salvar_tarefas(@tarefas)
    carregar_tarefas_na_lista
  end

  def gerar_relatorio
    dialog = Gtk::Dialog.new(
      title: "Relatório de Tarefas",
      parent: @janela,
      flags: :modal,
      buttons: [["Fechar", Gtk::ResponseType::CLOSE]]
    )
    dialog.set_size_request(400, 300)
    
    buffer = Gtk::TextBuffer.new
    buffer.text = gerar_texto_relatorio
    
    area_texto = Gtk::TextView.new(buffer: buffer)
    area_texto.editable = false
    
    scrolled = Gtk::ScrolledWindow.new
    scrolled.set_policy(:automatic, :automatic)
    scrolled.add(area_texto)
    
    botao_exportar = Gtk::Button.new(label: "Exportar Relatório")
    botao_exportar.signal_connect("clicked") { exportar_relatorio(buffer.text) }
    
    dialog.content_area.pack_start(scrolled, expand: true, fill: true, padding: 10)
    dialog.content_area.pack_start(botao_exportar, expand: false, fill: false, padding: 10)
    
    dialog.show_all
    dialog.run
    dialog.destroy
  end

  def gerar_texto_relatorio
    total = @tarefas.size
    concluidas = @tarefas.count { |t| t[:concluida] }
    pendentes = total - concluidas
    
    texto = "RELATÓRIO DE TAREFAS\n#{"=" * 50}\n\n"
    return texto + "Não há tarefas cadastradas." if total.zero?
    
    texto += "Total de tarefas: #{total}\n"
    texto += "Tarefas concluídas: #{concluidas} (#{(concluidas.to_f / total * 100).round(1)}%)\n"
    texto += "Tarefas pendentes: #{pendentes} (#{(pendentes.to_f / total * 100).round(1)}%)\n\n"
    
    texto += "TAREFAS POR CATEGORIA\n#{"-" * 50}\n"
    GerenciadorTarefas::CATEGORIAS.each do |cat|
      contagem = @tarefas.count { |t| t[:categoria] == cat }
      next if contagem.zero?
      percentual = (contagem.to_f / total * 100).round(1)
      texto += "#{cat}: #{contagem} (#{percentual}%)\n"
    end
    
    texto += "\nTAREFAS POR PRIORIDADE\n#{"-" * 50}\n"
    GerenciadorTarefas::PRIORIDADES.each do |prio|
      contagem = @tarefas.count { |t| t[:prioridade] == prio }
      next if contagem.zero?
      percentual = (contagem.to_f / total * 100).round(1)
      texto += "#{prio}: #{contagem} (#{percentual}%)\n"
    end
    texto
  end

  def exportar_relatorio(texto)
    arquivo = "relatorio_tarefas_#{Time.now.strftime('%Y%m%d_%H%M%S')}.txt"
    File.write(arquivo, texto)
    
    mensagem = Gtk::MessageDialog.new(
      parent: @janela,
      flags: :modal,
      type: :info,
      buttons: :ok,
      message: "Relatório exportado para #{arquivo}"
    )
    mensagem.run
    mensagem.destroy
  end

  def aplicar_filtros
    filtro_categoria = @combo_filtro_categoria.active_text
    filtro_status = @combo_filtro_status.active_text
    termo_pesquisa = @entrada_pesquisa.text.downcase
    
    @modelo_lista.clear
    @tarefas.each do |tarefa|
      next unless filtro_categoria == "Todas" || tarefa[:categoria] == filtro_categoria
      next if filtro_status == "Concluídas" && !tarefa[:concluida]
      next if filtro_status == "Pendentes" && tarefa[:concluida]
      next unless termo_pesquisa.empty? || 
                 tarefa[:texto].downcase.include?(termo_pesquisa) || 
                 tarefa[:categoria].downcase.include?(termo_pesquisa)
                 
      iter = @modelo_lista.append
      iter[0] = tarefa[:concluida]
      iter[1] = tarefa[:texto]
      iter[2] = tarefa[:data]
      iter[3] = tarefa[:categoria]
      iter[4] = tarefa[:prioridade]
    end
  end

  def iniciar_verificacao_periodica
    GLib::Timeout.add_seconds(3600) do
      GerenciadorTarefas.verificar_tarefas_proximas(@tarefas)
      true
    end
  end
end

InterfaceGrafica.new

#fim de projeto 1