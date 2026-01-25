-- Tabela de Intenções (Respostas e Opções)
-- Criação da tabela de interações do Chatbot (Modelo Otimizado com Arrays)
-- Substitui o modelo anterior para facilitar a manutenção e busca

DROP TABLE IF EXISTS chatbot_keywords;
DROP TABLE IF EXISTS chatbot_intents;

CREATE TABLE IF NOT EXISTS chatbot_interactions (
    id SERIAL PRIMARY KEY,
    intent_id VARCHAR(50) UNIQUE NOT NULL,
    keys TEXT[] NOT NULL, -- Array de palavras-chave/frases
    response TEXT NOT NULL, -- Resposta em HTML
    options TEXT[] -- Array de botões (opcional)
);

-- Índice GIN para busca rápida dentro do array de chaves
CREATE INDEX IF NOT EXISTS idx_chatbot_interactions_keys ON chatbot_interactions USING GIN(keys);

-- Limpeza inicial para garantir dados atualizados
TRUNCATE chatbot_interactions RESTART IDENTITY;

-- Inserção dos dados (Base Original + 30% de Novos Conteúdos)
INSERT INTO chatbot_interactions (intent_id, keys, response, options) VALUES
-- DADOS ORIGINAIS (Corrigidos HTML entities)
('saudacao', ARRAY['ola', 'oi', 'bom dia', 'boa tarde', 'boa noite', 'gostaria de falar com alguem', 'iniciar atendimento', 'oi tudo bem', 'opa', 'eai', 'preciso de ajuda', 'alo'], 'Olá! Sou a IA da ESF Thamara. 🏥<br>Estou aqui para te ajudar.<br><br>Posso te explicar sobre **horários**, **vacinas** ou te ajudar a saber **onde ir se estiver sentindo dor**.<br><br>Como posso ajudar?', ARRAY['Horários', 'Estou com dor', 'Telefone do Posto', 'Alô Saúde']),

('horarios', ARRAY['qual o horario de atendimento', 'que horas o posto abre', 'ate que horas funciona', 'horario de funcionamento', 'está aberto agora', 'agenda da unidade', 'que horas fecha', 'tem gente no posto agora', 'expediente', 'dias de funcionamento', 'quando abre', 'que horas abre', 'horario de abertura'], '🕒 **Dinâmica de Atendimento:**<br>• **Seg, Ter e Qui:** Manhã (intercorrências/agendamentos), Tarde (consultas/enfermagem).<br>• **Quarta:** Manhã (intercorrências), Tarde (visitas domiciliares).<br>• **Sexta:** Manhã (intercorrências), Tarde (formação equipe).<br>🚫 **Almoço:** 12h às 13h (fechado).<br>⚠️ Fora desses horários, procure o AG Garcia ou Hospitais.', ARRAY['Como agendar consulta?', 'Onde fica o AG Garcia?']),

('endereco', ARRAY['qual o endereço', 'onde fica o posto', 'localização da unidade', 'como chegar no posto', 'mapa da unidade', 'rua do posto', 'bairro progresso', 'perto de onde'], '📍 **Endereço:**<br>Rua Santa Maria, 2082 – Bairro Progresso, Blumenau (SC).<br>CEP: 89027-202.', ARRAY['Ver no Mapa', 'Horários']),

('contato', ARRAY['qual o telefone', 'numero para contato', 'como ligar para o posto', 'tem whatsapp', 'numero do zap', 'telefone fixo', 'contato da recepcao', 'falar com humano', 'falar com atendente', 'falar com pessoa', 'atendimento humano'], '📞 **Telefones do Posto:**<br>Para falar com a gente, clique nos números abaixo:<br><br>☎️ <a href="tel:4733817064" style="font-weight:bold; color:#0084ff;">(47) 3381-7064</a><br>☎️ <a href="tel:4733816751" style="font-weight:bold; color:#0084ff;">(47) 3381-6751</a><br><br>Atendemos das 07h às 12h e das 13h às 16h.<br>Ainda não temos WhatsApp.', ARRAY['Voltar ao início', 'Horários']),

('vacinas', ARRAY['horario de vacinacao', 'quero tomar vacina', 'tem vacina da gripe', 'campanha de vacinacao', 'preciso me vacinar', 'vacina covid', 'vacina bcg', 'gotinha', 'atualizar carteirinha'], '💉 **Sala de Vacinas:**<br>Segunda a Quinta: 09h às 11h30 e 13h às 15h.<br>Sexta: 09h às 11h30 (somente matutino).<br>Lembre-se de trazer a carteirinha de vacinação e o cartão do SUS!', ARRAY['Quais documentos levar?', 'Tem vacina da gripe?']),

('consultas', ARRAY['como marcar consulta', 'agendar medico', 'preciso de um clinico geral', 'quero marcar uma consulta', 'tem medico hoje', 'consulta de rotina', 'mostrar exames', 'agendamento', 'quero ver um medico', 'preciso passar no medico', 'consulta medica'], '👨‍⚕️ **Consultas:**<br>O agendamento é feito preferencialmente presencialmente na unidade. Para casos agudos, venha para a triagem (Acolhimento).', ARRAY['Estou com dor aguda', 'É apenas rotina']),

('odonto', ARRAY['dentista', 'consulta dentista', 'dor no dente', 'dente doendo', 'gengiva doendo', 'arrancar dente', 'canal no dente', 'limpeza nos dentes', 'odontologia', 'saude bucal', 'dente quebrado', 'restauracao', 'estou com muita dor de dente', 'dor de dente forte'], '🦷 **Odontologia:**<br>Temos atendimento odontológico. É necessário passar pela recepção para verificar a disponibilidade de agendamento.', ARRAY['Estou com muita dor de dente', 'Quero agendar limpeza']),

('dor_abdominal', ARRAY['dor de barriga', 'dor no estomago', 'dor abdominal', 'enjoo', 'vomito', 'diarreia', 'azia', 'queimação no estomago', 'minha barriga doi', 'estou com dor de barriga'], '⚠️ **Dor Abdominal/Estômago:**<br>• **Leve/Moderada:** Venha ao Posto (ESF) para avaliação médica.<br>• **Grave (dor insuportável):** Vá ao Hospital.<br>• **Dúvida:** Ligue 156 (Alô Saúde).', ARRAY['Ir ao Posto', 'Ligar 156']),

('dor_garganta_ouvido', ARRAY['dor de garganta', 'dor de ouvido', 'ouvido doendo', 'garganta inflamada', 'dificuldade para engolir', 'dor ao engolir', 'zumbido no ouvido'], '⚠️ **Garganta ou Ouvido:**<br>Geralmente são infecções que precisam de avaliação clínica.<br>Venha ao Posto (ESF) no horário de acolhimento (07h-11h ou 13h-15h).', ARRAY['Ver Horários', 'Endereço']),

('triagem_geral', ARRAY['estou passando mal', 'tontura forte', 'desmaio', 'sangramento', 'pressao baixa', 'mal estar', 'corpo ruim', 'fraqueza'], '⚠️ **Acolhimento/Triagem:**<br>Se você está se sentindo mal de forma geral, venha à unidade para aferir pressão e passar pela triagem.<br><br>🚨 **Desmaio ou Sangramento forte:** Ligue 192 (SAMU).', ARRAY['Ligar 192', 'Ir para o posto']),

('visitas', ARRAY['visita domiciliar', 'atendimento em casa', 'paciente acamado', 'agente de saude visita', 'medico vai em casa', 'minha mae nao anda', 'visita do acs'], '🏠 **Visitas Domiciliares:**<br>Ocorrem geralmente nas quartas-feiras à tarde. São destinadas a pacientes acamados ou com dificuldade de locomoção. Converse com seu Agente de Saúde (ACS) para solicitar.', ARRAY['Como falar com ACS?', 'Voltar']),

('dor_cotovelo_membros', ARRAY['dor no cotovelo', 'dor de cotovelo', 'dor no braço', 'machuquei o joelho', 'torci o pé', 'dor na perna', 'dor nas juntas', 'cotovelo doendo', 'pulso aberto', 'dor nas costas', 'travei a coluna', 'dor no ombro', 'dor muscular', 'pancada', 'dor no tornozelo', 'dor no quadril', 'dor na mao', 'dor no pe', 'dor na coluna', 'lombar doendo'], '⚠️ **Dor no Corpo/Membros:**<br>Responda para você mesmo:<br>1. Bateu ou caiu recentemente?<br>2. Está inchado ou torto?<br>3. Consegue mexer?<br><br>🔴 **Vá ao Hospital:** Se estiver torto ou a dor for insuportável.<br>🔵 **Vá ao Posto:** Se dói mas consegue mexer.<br>🟢 **Em casa:** Se for leve, coloque gelo e descanse.', ARRAY['Onde fica o Hospital?', 'Vou aplicar gelo']),

('dor_cabeca', ARRAY['dor de cabeça', 'enxaqueca', 'cabeça doendo muito', 'pontada na cabeça', 'cefaleia', 'visao turva', 'cabeca explodindo'], '🧠 **Dor de Cabeça:**<br>🚨 **ATENÇÃO:** Se a dor for a **pior da sua vida**, ou se você estiver enxergando embaçado ou falando enrolado:<br>👉 **Vá urgente ao Hospital ou ligue 192.**<br><br>Se for uma dor de cabeça comum, tome seu remédio e descanse no escuro. Se não passar, ligue 156 (Alô Saúde).', ARRAY['É uma dor muito forte', 'É uma dor comum', 'Ligar 156']),

('dor_peito_cardio', ARRAY['dor no peito', 'aperto no coração', 'pontada no peito', 'infarto', 'dor toracica', 'queimação no peito', 'formigamento no braco', 'coracao acelerado'], '🚨 **PERIGO - CORAÇÃO** 🚨<br>Dor no peito é coisa séria.<br>Se a dor for forte, for para o braço esquerdo ou você sentir falta de ar e suor frio:<br><br>📞 <a href="tel:192" style="color:red; font-size:18px; font-weight:bold;">CLIQUE AQUI E LIGUE 192 (SAMU) AGORA</a><br><br>Não venha para o posto andando. Chame ajuda.', ARRAY['Ligar 192', 'Onde fica o Hospital?']),

('febre_adulto', ARRAY['estou com febre', 'temperatura alta', 'corpo quente', 'calafrios', '39 graus', 'febre em adulto'], '🌡️ **Febre em Adulto:**<br>• Se for **acima de 39°C** ou durar mais de 2 dias: Venha ao Posto.<br>• Se for leve: Beba muita água e descanse.<br>• Dúvida? Ligue 156 (Alô Saúde).', ARRAY['Ligar 156', 'Ir ao Posto']),

('identidade', ARRAY['quem é voce', 'voce é um robo', 'quem criou esse bot', 'voce e real'], 'Eu sou o assistente virtual da ESF Thamara! Fui criado para facilitar o acesso às informações da unidade. 🤖', ARRAY['O que você sabe fazer?']),

('agradecimento', ARRAY['obrigado', 'valeu', 'muito obrigado', 'ajudou muito', 'tchau', 'ate logo', 'grato', 'beleza'], 'Por nada! Cuide-se bem. 💙', NULL),

('dor_generica', ARRAY['estou com dor', 'sinto dor', 'dor no corpo', 'doi tudo', 'estou doendo', 'tenho dor', 'dor', 'alguma dor'], '⚠️ **Onde é a sua dor?**<br>Para te orientar melhor, preciso saber onde dói.<br><br>Exemplos: "Dor de cabeça", "Dor no peito", "Dor nas costas", "Dor de dente".', ARRAY['Cabeça', 'Peito', 'Barriga', 'Dente', 'Costas']),

('renovacao_receita', ARRAY['renovar receita', 'acabou o remedio', 'preciso de losartana', 'pegar remedio de pressao', 'receita venceu', 'receita azul', 'receita controlada', 'renovar medicacao'], '💊 **Renovação de Receitas:**<br>• **Uso Contínuo (Hipertensão/Diabetes):** Venha à recepção com a receita antiga e documentos.<br>• **Controlados (Psicotrópicos):** Necessitam de avaliação médica. Verifique na recepção se há vaga para renovação ou se precisa de consulta.', ARRAY['É remédio de pressão', 'É controlado', 'Horário da farmácia']),

('saude_mulher', ARRAY['fazer preventivo', 'papanicolau', 'estou gravida', 'teste de gravidez', 'pré natal', 'consulta ginecologica', 'saude da mulher', 'atraso menstrual', 'pilula anticoncepcional'], '🌸 **Saúde da Mulher:**<br>• **Preventivo:** Agendado com a enfermeira da sua equipe.<br>• **Suspeita de Gravidez:** Venha fazer o teste rápido (TIG) pela manhã.<br>• **Pré-Natal:** Se confirmado, iniciamos o acompanhamento imediatamente.', ARRAY['Quero agendar preventivo', 'Acho que estou grávida']),

('dengue_zika', ARRAY['dor no corpo todo', 'manchas vermelhas', 'dor atras dos olhos', 'acho que estou com dengue', 'picada de mosquito', 'zika', 'chikungunya', 'dor nas juntas forte'], '🦟 **Suspeita de Dengue:**<br>Sintomas: Febre alta, dor atrás dos olhos e muita dor no corpo.<br><br>1. **Beba muita água** (Soro caseiro é ótimo).<br>2. **NÃO tome Aspirina ou AAS**.<br>3. Venha ao posto para a gente notificar e te examinar.', ARRAY['Quais os sintomas?', 'Como prevenir?']),

('saude_mental', ARRAY['estou muito triste', 'ansiedade', 'depressao', 'quero morrer', 'preciso de psicologo', 'crise de ansiedade', 'panico', 'nao aguento mais', 'tristeza profunda'], '🧠 **Saúde Mental:**<br>Você não está sozinho(a). 💙<br>Venha conversar com nossa equipe de acolhimento. Temos grupos de apoio e suporte médico.<br><br>🆘 **Em crise aguda ou pensamentos urgentes:** Ligue 188 (CVV) ou vá ao CAPS/Hospital mais próximo.', ARRAY['Ligar 188 (CVV)', 'Ir ao posto conversar']),

('curativos', ARRAY['fazer curativo', 'trocar curativo', 'tirar pontos', 'ferida na perna', 'machucado feio', 'ponto cirurgico'], '🩹 **Sala de Curativos:**<br>Funciona durante o horário da unidade. Traga o encaminhamento (se houver) ou venha para avaliação da enfermeira caso seja uma ferida nova.', ARRAY['Horários', 'Documentos necessários']),

('documentos_cadastro', ARRAY['o que precisa para cadastro', 'fazer cartao sus', 'me mudar para o bairro', 'documentos necessarios', 'comprovante de residencia', 'como me cadastrar'], 'guia **Cadastro na Unidade:**<br>Para se cadastrar na ESF Thamara, traga:<br>• RG e CPF<br>• Cartão do SUS (se tiver)<br>• Comprovante de residência atualizado em seu nome (ou declaração).<br>Atendemos apenas moradores da área de abrangência.', ARRAY['Verificar área', 'Horário de cadastro']),

('tabela_decisao', ARRAY['tabela de sintomas', 'onde devo ir', 'classificacao de risco', 'estou em duvida', 'guia de atendimento', 'para onde eu vou'], '🏥 **Guia Rápido de Decisão:**<br><table style="width:100%; border-collapse:collapse; font-size:13px; margin-top:5px;"><tr><th style="border:1px solid #ccc; padding:5px; background:#f0f0f0;">Sintoma / Situação</th><th style="border:1px solid #ccc; padding:5px; background:#f0f0f0;">Onde Ir?</th></tr><tr><td style="border:1px solid #ccc; padding:5px;">Risco de Vida / Acidentes Graves</td><td style="border:1px solid #ccc; padding:5px; color:red; font-weight:bold;">SAMU (192) / Hospital</td></tr><tr><td style="border:1px solid #ccc; padding:5px;">Dores Agudas / Febre / Curativos</td><td style="border:1px solid #ccc; padding:5px; color:blue; font-weight:bold;">ESF (Posto)</td></tr><tr><td style="border:1px solid #ccc; padding:5px;">Dúvidas / Sintomas Leves</td><td style="border:1px solid #ccc; padding:5px; color:green; font-weight:bold;">Alô Saúde (156)</td></tr><tr><td style="border:1px solid #ccc; padding:5px;">Gripe Leve (sem falta de ar)</td><td style="border:1px solid #ccc; padding:5px;">Isolamento (Casa)</td></tr></table>', ARRAY['Entendi', 'Emergência']),

('alo_saude', ARRAY['alo saude', 'atendimento por telefone', 'consulta online', 'telemedicina', 'duvida simples', 'preciso sair de casa', 'atendimento remoto', 'falar com medico pelo celular'], '📞 **Alô Saúde Blumenau (156 opção 2):**<br>Para falar com um médico sem sair de casa, clique no número abaixo:<br><br><h2><a href="tel:156" style="color:green; text-decoration:none;">CLIQUE AQUI PARA LIGAR 156</a></h2><br>É de graça e você não pega fila.<br>Ideal para: Gripe leve, dúvidas de remédio e dor de garganta.', ARRAY['Ligar 156', 'Voltar']),

('sindrome_gripal', ARRAY['tosse', 'coriza', 'dor de garganta leve', 'gripe', 'resfriado', 'nariz escorrendo', 'espirrando', 'sintomas de gripe'], '😷 **Gripe Leve:**<br>Se você tem apenas tosse, nariz escorrendo e febre baixa:<br>1. **Use máscara** se sair de casa.<br>2. Beba água e descanse.<br>3. Se sentir **falta de ar**, vá correndo para o Hospital.<br>⚠️ **Não venha ao ESF sem máscara!**', ARRAY['Tenho falta de ar', 'É só gripe leve']),

('emergencia_gestante', ARRAY['estou gravida e com dor', 'sangramento na gravidez', 'perdi liquido', 'bebe nao mexe', 'gestante com dor', 'gravida sangrando', 'dor na barriga gravida'], '🚨 **Atenção Gestante:**<br>Vá imediatamente à **Maternidade ou Hospital** se tiver:<br>• Sangramento (sangue descendo).<br>• Perda de líquido (bolsa estourou).<br>• Dor forte na barriga.<br>• Bebê parou de mexer.<br>Não espere pelo posto, isso é urgente.', ARRAY['Onde fica a maternidade?', 'Ligar SAMU']),

('emergencia_idoso', ARRAY['idoso caiu', 'minha avo caiu', 'fala enrolada', 'boca torta', 'fraqueza de um lado', 'idoso confuso', 'avc', 'derrame', 'idoso nao acorda', 'queda de idoso'], '🚨 **Emergência com Idoso:**<br>Se o idoso **caiu e não levanta** ou está com a **boca torta e fala enrolada**:<br><br>📞 <a href="tel:192" style="color:red; font-weight:bold;">LIGUE 192 (SAMU) AGORA</a><br><br>Não tente mexer nele se achar que quebrou algo.', ARRAY['Ligar 192']),

('emergencia_crianca', ARRAY['meu filho nao respira bem', 'bebe com febre alta', 'crianca prostrada', 'bebe roxo', 'convulsao infantil', 'crianca nao para de chorar', 'bebe engasgado', 'febre em crianca'], '🚨 **Emergência com Criança:**<br>Corra para o **Hospital** se a criança:<br>• Tiver dificuldade para respirar (peito afundando).<br>• Ficar com a boca roxa.<br>• Tiver convulsão (ataque).<br>• Não acordar ou estiver muito "molinha".<br><br>Se for só febre e ela estiver brincando, ligue 156 (Alô Saúde).', ARRAY['Hospital Infantil', 'Ligar 192']),

('atendimento_inclusivo', ARRAY['sou autista', 'tenho autismo', 'atendimento prioritario', 'tea', 'sensibilidade sensorial', 'paciente autista', 'mae de autista', 'crise sensorial'], '💙 **Atendimento Inclusivo (TEA):**<br>Aqui você tem prioridade e respeito.<br>Avise na recepção que você ou seu filho é autista.<br>Se precisar de um lugar mais quieto por causa do barulho, peça para a equipe que nós ajudamos.', ARRAY['Tenho carteirinha TEA', 'Preciso de prioridade']),

('acessibilidade_leitura', ARRAY['nao sei ler', 'nao sei escrever', 'tenho dificuldade de leitura', 'pode mandar audio', 'ajuda para ler', 'sou analfabeto', 'nao entendo letras'], '🗣️ **Ajuda:**<br>Se estiver difícil de ler, você pode pedir para alguém ligar para nós ou vir aqui no posto e falar direto com a recepcionista.<br><br>📞 <a href="tel:4733817064">Ligar (47) 3381-7064</a>', ARRAY['Ligar para o posto']),

('hospital_ps', ARRAY['onde fica o ps', 'onde fica o hospital', 'pronto socorro', 'emergencia hospital', 'endereco do hospital', 'hospital santa isabel', 'hospital santo antonio', 'upa', 'onde e a emergencia'], '🏥 **Hospitais / Pronto Socorro:**<br>Para emergências, procure:<br>• **Hospital Santa Isabel:** R. Floriano Peixoto, 300.<br>• **Hospital Santo Antônio:** R. Itajaí, 545.<br>• **Hospital Misericórdia (Vila Itoupava).**<br><br>🚑 Em risco de vida, ligue **192**.', ARRAY['Ligar 192', 'Voltar']),

('feedback_negativo', ARRAY['ta uma porcaria', 'nao funciona', 'bot burro', 'que lixo', 'nao ajuda', 'pessimo', 'horrivel', 'idiota', 'ruim'], '😔 Sinto muito que você não esteja satisfeito. Sou uma inteligência artificial em aprendizado.<br>Por favor, ligue para **(47) 3381-7064** para falar com um atendente humano.', ARRAY['Ligar para o posto']),

('colica_investigacao', ARRAY['colica', 'estou com colica', 'tenho colica', 'muita colica', 'colica forte', 'dor tipo colica'], '⚠️ **Investigação de Cólica:**<br>Para te orientar melhor, preciso saber a origem da dor.<br>É uma cólica **intestinal** (barriga/diarreia) ou **ginecológica** (menstrual/gravidez)?', ARRAY['É Intestinal', 'É Menstrual/Gravidez']),

('colica_menstrual_gestante', ARRAY['é menstrual', 'é ginecologica', 'dor no utero', 'colica menstrual', 'dor de periodo', 'estou menstruada', 'é gravidez', 'estou gravida', 'sou gestante'], '🌸 **Saúde da Mulher:**<br>• **Menstrual:** Se for suportável, analgésico e calor local ajudam.<br>• **Gestante:** ⚠️ Cólica na gravidez requer atenção! Se houver sangramento ou dor contínua, vá à **Maternidade** imediatamente.', ARRAY['Onde fica a Maternidade?', 'Voltar']),

('atendimento_prioritario', ARRAY['sou idoso', 'tenho prioridade', 'sou deficiente', 'cadeirante', 'tenho deficiencia', 'fila preferencial', 'atendimento para idoso', 'acessibilidade', 'sou pcd'], '💙 **Atendimento Prioritário:**<br>Garantimos prioridade legal para:<br>• **Idosos (60+)**<br>• **Gestantes**<br>• **Pessoas com Deficiência (PCD)**<br>• **Autistas (TEA)**<br><br>Informe sua condição na recepção para agilizar o cadastro e a triagem.', ARRAY['Horários', 'Endereço']),

('ag_garcia', ARRAY['onde fica o ag garcia', 'endereco ag garcia', 'horario ag garcia', 'telefone ag garcia', 'ag garcia', 'ambulatorio geral garcia', 'irma marta elisabetha kunzmann', 'posto do garcia'], '🏥 **AG Garcia (Ambulatório Geral):**<br>📍 **Endereço:** R. Progresso, 141 - Progresso (Intendência).<br>📞 **Telefone:** (47) 3381-7593<br>🕒 **Horário:**<br>• Seg a Sex: 07h às 22h<br>• Sáb e Dom: 08h às 17h', ARRAY['Voltar', 'Ligar para AG Garcia']),

-- NOVAS INTENÇÕES ADICIONADAS (Expansão de ~30%)

('resultados_exames', ARRAY['resultado de exame', 'pegar exame', 'exame de sangue pronto', 'ver exame', 'laudo medico', 'exame de urina'], '📄 **Resultados de Exames:**<br>Os resultados podem ser retirados na recepção das 13h às 16h.<br>Alguns exames estão disponíveis online pelo portal da Prefeitura.', ARRAY['Horários', 'Voltar']),

('farmacia', ARRAY['tem remedio', 'farmacia', 'pegar medicacao', 'horario farmacia', 'farmacia popular', 'remedio gratuito', 'disponibilidade de remedio'], '💊 **Farmácia da Unidade:**<br>A dispensação de medicamentos ocorre durante o horário de funcionamento da sala de enfermagem.<br>Traga seu cartão do SUS e a receita atualizada.', ARRAY['Renovação de Receita', 'Horários']),

('teste_pezinho', ARRAY['teste do pezinho', 'exame do pezinho', 'recem nascido', 'bebe nasceu', 'triagem neonatal'], '👣 **Teste do Pezinho:**<br>Deve ser feito entre o 3º e o 5º dia de vida do bebê.<br>Venha pela manhã (08h às 11h) e traga os documentos do bebê e da mãe.', ARRAY['Vacinas', 'Endereço']),

('planejamento_familiar', ARRAY['diu', 'anticoncepcional', 'pilula', 'laqueadura', 'vasectomia', 'planejamento familiar', 'evitar filhos', 'camisinha'], '👨‍👩‍👧‍👦 **Planejamento Familiar:**<br>Oferecemos métodos contraceptivos e orientações.<br>Para inserção de DIU ou cirurgias (laqueadura/vasectomia), é necessário participar do grupo de planejamento familiar. Informe-se na recepção.', ARRAY['Horários', 'Saúde da Mulher']),

('nutricionista', ARRAY['nutricionista', 'preciso emagrecer', 'dieta', 'encaminhamento nutricionista', 'reeducacao alimentar'], '🍎 **Nutricionista:**<br>O atendimento é realizado mediante encaminhamento médico ou de enfermagem.<br>Passe por uma consulta clínica primeiro para avaliação.', ARRAY['Agendar Consulta', 'Voltar']),

('fisioterapia', ARRAY['fisioterapia', 'fisio', 'reabilitacao', 'dor cronica', 'sessao de fisio'], '🤸 **Fisioterapia:**<br>O encaminhamento é feito pelo médico da unidade.<br>Após ter o encaminhamento, você deve levá-lo à regulação (AG Garcia) para entrar na fila.', ARRAY['Onde fica o AG Garcia?', 'Voltar']),

('ouvidoria', ARRAY['reclamacao', 'denuncia', 'elogio', 'ouvidoria', 'falar com gerente', 'reclamar', 'sugestao'], '📢 **Ouvidoria:**<br>Sua opinião é importante.<br>Você pode registrar elogios ou reclamações na Ouvidoria da Saúde pelo telefone 156 (opção 4) ou pelo site da Prefeitura de Blumenau.', ARRAY['Ligar 156', 'Voltar']),

('violencia_domestica', ARRAY['violencia contra mulher', 'agressao', 'marido bateu', 'medo', 'denunciar', 'lei maria da penha', 'violencia familiar'], '💜 **Você não está sozinha:**<br>Se você está sofrendo violência, procure ajuda.<br>Aqui na unidade podemos te acolher e orientar.<br><br>📞 **Emergência:** Ligue 190 (Polícia).<br>📞 **Denúncia Anônima:** Ligue 180.', ARRAY['Ligar 180', 'Endereço']),

('bolsa_familia', ARRAY['pesagem bolsa familia', 'auxilio brasil', 'pesar crianca', 'condicionalidades', 'acompanhamento bolsa familia'], '⚖️ **Pesagem Bolsa Família:**<br>Acompanhe o calendário de pesagem na recepção.<br>Geralmente ocorre uma vez por semestre. Traga o cartão do benefício e a carteirinha de vacinação.', ARRAY['Horários', 'Voltar']),

('hiperdia', ARRAY['hiperdia', 'grupo de hipertensos', 'grupo de diabeticos', 'pressao alta', 'diabetes', 'insulina'], '💙 **Hiperdia:**<br>Acompanhamento para hipertensos e diabéticos.<br>Verifique com seu Agente de Saúde a data do próximo encontro do seu grupo.', ARRAY['Renovação de Receita', 'Voltar'])

ON CONFLICT (intent_id) DO UPDATE 
SET keys = EXCLUDED.keys, 
    response = EXCLUDED.response, 
    options = EXCLUDED.options;