export const knowledgeBase = [
    {
      id: "saudacao",
      keys: ["ola", "oi", "bom dia", "boa tarde", "boa noite", "gostaria de falar com alguem", "iniciar atendimento", "oi tudo bem", "opa", "eai", "preciso de ajuda", "alo"],
      resp: "Olá! Sou a assistente virtual da ESF Thamara. 🏥<br>Posso te ajudar com informações sobre a unidade ou com uma **pré-triagem de sintomas**.<br><br>Sobre o que você gostaria de falar?",
      options: ["Horários de Atendimento", "Estou com sintomas", "Vacinas", "Endereço"]
    },
    {
      id: "horarios",
      keys: ["qual o horario de atendimento", "que horas o posto abre", "ate que horas funciona", "horario de funcionamento", "está aberto agora", "agenda da unidade", "quando abre", "que horas abre", "horario"],
      resp: "🕒 **Dinâmica de Atendimento:**<br>• **Seg, Ter e Qui:** Manhã (intercorrências/agendamentos), Tarde (consultas/enfermagem).<br>• **Quarta:** Manhã (intercorrências), Tarde (visitas domiciliares).<br>• **Sexta:** Manhã (intercorrências), Tarde (formação equipe).<br>🚫 **Almoço:** 12h às 13h (fechado).",
      options: ["Como agendar consulta?", "Onde fica o AG Garcia?"]
    },
    {
      id: "endereco",
      keys: ["qual o endereço", "onde fica o posto", "localização da unidade", "como chegar no posto", "mapa da unidade", "rua do posto", "bairro progresso"],
      resp: "📍 **Endereço:**<br>Rua Santa Maria, 2082 – Bairro Progresso, Blumenau (SC).<br>CEP: 89027-202.",
      options: ["Ver no Mapa", "Horários"]
    },
    {
      id: "contato",
      keys: ["qual o telefone", "numero para contato", "como ligar para o posto", "tem whatsapp", "numero do zap", "telefone", "falar com atendente"],
      resp: "📞 **Telefones do Posto:**<br>☎️ (47) 3381-7064<br>☎️ (47) 3381-6751<br><br>Atendemos das 07h às 12h e das 13h às 16h.<br>Ainda não temos WhatsApp oficial.",
      options: ["Voltar ao início", "Horários"]
    },
    {
      id: "vacinas",
      keys: ["horario de vacinacao", "quero tomar vacina", "tem vacina da gripe", "campanha de vacinacao", "preciso me vacinar", "vacina covid", "vacina bcg", "gotinha", "atualizar carteirinha"],
      resp: "💉 **Sala de Vacinas:**<br>Segunda a Quinta: 09h às 11h30 e 13h às 15h.<br>Sexta: 09h às 11h30 (somente matutino).<br>Lembre-se de trazer a carteirinha de vacinação e o cartão do SUS!",
      options: ["Quais documentos levar?", "Tem vacina da gripe?"]
    },
    {
      id: "consultas",
      keys: ["como marcar consulta", "agendar medico", "preciso de um clinico geral", "quero marcar uma consulta", "tem medico hoje", "consulta de rotina", "mostrar exames", "agendamento"],
      resp: "👨‍⚕️ **Agendamento de Consultas:**<br>Para agendar uma consulta de rotina ou retorno, o ideal é vir pessoalmente à recepção.<br>Se for um caso de **urgência (dor ou mal-estar)**, venha para o Acolhimento imediatamente.",
      options: ["Estou com dor", "É consulta de rotina"]
    },
    {
      id: "odonto",
      keys: ["dentista", "consulta dentista", "dor no dente", "dente doendo", "gengiva doendo", "arrancar dente", "canal no dente", "limpeza nos dentes", "odontologia"],
      resp: "🦷 **Saúde Bucal (Dentista):**<br>Para agendar uma consulta odontológica, você precisa ir até a recepção para verificar a disponibilidade.<br>Em caso de **dor de dente forte**, informe na recepção para urgência.",
      options: ["É uma urgência", "Quero agendar avaliação"]
    },
    {
      id: "dor_abdominal",
      keys: ["dor de barriga", "dor no estomago", "dor abdominal", "enjoo", "vomito", "diarreia", "azia", "queimação no estomago", "minha barriga doi"],
      resp: "⚠️ **Sintomas Gastrointestinais:**<br>• **Leve/Moderada:** Venha ao Posto (ESF) para avaliação.<br>• **Dor Insuportável:** Procure o Hospital.<br>• **Dúvida:** Ligue 156 (Alô Saúde).",
      options: ["Ir ao Posto", "Ligar 156"]
    },
    {
      id: "dor_garganta_ouvido",
      keys: ["dor de garganta", "dor de ouvido", "ouvido doendo", "garganta inflamada", "dificuldade para engolir", "dor ao engolir", "zumbido no ouvido"],
      resp: "👂 **Dor de Garganta ou Ouvido:**<br>Geralmente indicam infecção. Venha ao Posto (ESF) durante o horário de acolhimento para ser examinado.",
      options: ["Ver Horários", "Endereço"]
    },
    {
      id: "triagem_geral",
      keys: ["estou passando mal", "tontura forte", "desmaio", "sangramento", "pressao baixa", "mal estar", "corpo ruim", "fraqueza"],
      resp: "⚠️ **Acolhimento/Triagem:**<br>Se sente mal, venha à unidade para aferir pressão e passar pela triagem.<br><br>🚨 **Desmaio ou Sangramento forte:** Ligue 192 (SAMU).",
      options: ["Ligar 192", "Ir para o posto"]
    },
    {
      id: "visitas",
      keys: ["visita domiciliar", "atendimento em casa", "paciente acamado", "agente de saude visita", "medico vai em casa"],
      resp: "🏠 **Visitas Domiciliares:**<br>Ocorrem geralmente nas quartas-feiras à tarde para pacientes acamados. Converse com seu Agente de Saúde (ACS).",
      options: ["Como falar com ACS?", "Voltar"]
    },
    {
      id: "dor_peito_cardio",
      keys: ["dor no peito", "aperto no coração", "pontada no peito", "infarto", "dor toracica", "queimação no peito", "formigamento no braco"],
      resp: "🚨 **EMERGÊNCIA CARDÍACA** 🚨<br>Dor no peito pode ser grave. Se a dor for forte, irradiar para o braço ou vier com falta de ar:<br><br>📞 **LIGUE 192 (SAMU) IMEDIATAMENTE** ou vá ao Hospital.",
      options: ["Ligar 192", "Onde fica o Hospital?"]
    },
    {
      id: "febre",
      keys: ["estou com febre", "temperatura alta", "corpo quente", "calafrios", "39 graus", "febre"],
      resp: "🌡️ **Triagem: Febre**<br>• **Adultos:** Febre acima de 39°C ou por mais de 48h requer avaliação.<br>• **Crianças:** Se houver manchas na pele, vômitos ou prostração, venha imediatamente.",
      options: ["É criança", "É adulto"]
    },
    {
      id: "emergencia_crianca",
      keys: ["meu filho nao respira bem", "bebe com febre alta", "crianca prostrada", "bebe roxo", "convulsao infantil", "bebe engasgado"],
      resp: "🚨 **Emergência Pediátrica:**<br>Procure o **Hospital** imediatamente se a criança tiver:<br>• Dificuldade para respirar.<br>• Lábios roxos.<br>• Convulsão.<br>• Sonolência excessiva.",
      options: ["Hospital Infantil", "Ligar 192"]
    },
    {
      id: "identidade",
      keys: ["quem é voce", "voce é um robo", "quem criou esse bot", "voce e real"],
      resp: "Eu sou o assistente virtual da ESF Thamara! Fui criado para facilitar o acesso às informações da unidade. 🤖",
      options: ["O que você sabe fazer?"]
    },
    {
      id: "agradecimento",
      keys: ["obrigado", "valeu", "muito obrigado", "ajudou muito", "tchau", "ate logo", "grato"],
      resp: "Por nada! Cuide-se bem. 💙",
      options: []
    },
    {
      id: "fallback",
      keys: [],
      resp: "Desculpe, não entendi muito bem. 😕<br>Tente usar palavras-chave como 'Horários', 'Vacina', 'Dor de dente' ou 'Endereço'.",
      options: ["Ver Menu Principal", "Emergência"]
    }
  ];