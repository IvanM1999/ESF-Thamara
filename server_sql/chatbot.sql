-- Criação da tabela de interações do Chatbot
CREATE TABLE IF NOT EXISTS chatbot_interactions (
    id SERIAL PRIMARY KEY,
    intent_id VARCHAR(50) UNIQUE NOT NULL,
    keys TEXT[] NOT NULL, -- Array de palavras-chave/frases
    response TEXT NOT NULL, -- Resposta em HTML
    options TEXT[] -- Array de botões (opcional)
);

-- Inserção dos dados iniciais (Baseado na sua inteligência atual)
INSERT INTO chatbot_interactions (intent_id, keys, response, options) VALUES
('saudacao', ARRAY['ola', 'oi', 'bom dia', 'boa tarde', 'boa noite', 'gostaria de falar com alguem', 'iniciar atendimento', 'oi tudo bem', 'opa', 'eai', 'preciso de ajuda'], 'Olá! Sou a IA da ESF Thamara. 🏥<br>Posso ajudar com informações administrativas ou fazer uma **pré-triagem** de sintomas.<br>Como posso ajudar?', ARRAY['Horários de Atendimento', 'Estou com dor', 'Vacinas', 'Endereço']),

('horarios', ARRAY['qual o horario de atendimento', 'que horas o posto abre', 'ate que horas funciona', 'horario de funcionamento', 'está aberto agora', 'agenda da unidade', 'que horas fecha', 'tem gente no posto agora', 'expediente'], '🕒 **Dinâmica de Atendimento:**<br>• **Seg, Ter e Qui:** Manhã (intercorrências/agendamentos), Tarde (consultas/enfermagem).<br>• **Quarta:** Manhã (intercorrências), Tarde (visitas domiciliares).<br>• **Sexta:** Manhã (intercorrências), Tarde (formação equipe).<br>🚫 **Almoço:** 12h às 13h (fechado).<br>⚠️ Fora desses horários, procure o AG Garcia ou Hospitais.', ARRAY['Como agendar consulta?', 'Onde fica o AG Garcia?']),

('endereco', ARRAY['qual o endereço', 'onde fica o posto', 'localização da unidade', 'como chegar no posto', 'mapa da unidade', 'rua do posto', 'bairro progresso', 'perto de onde'], '📍 **Endereço:**<br>Rua Santa Maria, 2082 – Bairro Progresso, Blumenau (SC).<br>CEP: 89027-202.', ARRAY['Ver no Mapa', 'Horários']),

('contato', ARRAY['qual o telefone', 'numero para contato', 'como ligar para o posto', 'tem whatsapp', 'numero do zap', 'telefone fixo', 'contato da recepcao'], '📞 **Telefones:**<br>(47) 3381-7064<br>(47) 3381-6751<br>No momento não temos WhatsApp oficial para agendamento.', ARRAY['Voltar ao início']),

('vacinas', ARRAY['horario de vacinacao', 'quero tomar vacina', 'tem vacina da gripe', 'campanha de vacinacao', 'preciso me vacinar', 'vacina covid', 'vacina bcg', 'gotinha', 'atualizar carteirinha'], '💉 **Sala de Vacinas:**<br>Segunda a Quinta: 09h às 11h30 e 13h às 15h.<br>Sexta: 09h às 11h30 (somente matutino).<br>Lembre-se de trazer a carteirinha de vacinação e o cartão do SUS!', ARRAY['Quais documentos levar?', 'Tem vacina da gripe?']),

('consultas', ARRAY['como marcar consulta', 'agendar medico', 'preciso de um clinico geral', 'quero marcar uma consulta', 'tem medico hoje', 'consulta de rotina', 'mostrar exames', 'agendamento'], '👨‍⚕️ **Consultas:**<br>O agendamento é feito preferencialmente presencialmente na unidade. Para casos agudos, venha para a triagem (Acolhimento).', ARRAY['Estou com dor aguda', 'É apenas rotina']),

('odonto', ARRAY['tem dentista', 'estou com dor de dente', 'agendar dentista', 'atendimento odontologico', 'arrancar dente', 'limpeza nos dentes', 'canal', 'dentista sus'], '🦷 **Odontologia:**<br>Temos atendimento odontológico. É necessário passar pela recepção para verificar a disponibilidade de agendamento.', ARRAY['Estou com muita dor de dente', 'Quero agendar limpeza']),

('triagem', ARRAY['estou passando mal', 'muita dor', 'emergencia', 'sintomas de dengue', 'febre alta', 'preciso de atendimento urgente', 'tontura forte', 'desmaio', 'sangramento', 'pressao baixa'], '⚠️ **Acolhimento/Triagem:**<br>Se você está se sentindo mal, venha à unidade. A enfermeira fará a classificação de risco.<br><br>🚨 **Em caso de:** Dor no peito forte, falta de ar intensa ou desmaio, **LIGUE 192 (SAMU)**.', ARRAY['Ligar 192', 'Ir para o posto']),

('visitas', ARRAY['visita domiciliar', 'atendimento em casa', 'paciente acamado', 'agente de saude visita', 'medico vai em casa', 'minha mae nao anda', 'visita do acs'], '🏠 **Visitas Domiciliares:**<br>Ocorrem geralmente nas quartas-feiras à tarde. São destinadas a pacientes acamados ou com dificuldade de locomoção. Converse com seu Agente de Saúde (ACS) para solicitar.', ARRAY['Como falar com ACS?', 'Voltar']),

('dor_cotovelo_membros', ARRAY['dor no cotovelo', 'dor no braço', 'machuquei o joelho', 'torci o pé', 'dor na perna', 'dor nas juntas', 'cotovelo doendo', 'pulso aberto', 'dor nas costas', 'travei a coluna'], '⚠️ **Triagem Ortopédica (Membros/Coluna):**<br>Para melhor orientação, analise:<br>1. Houve trauma (batida/queda) recente?<br>2. Há inchaço ou deformidade visível?<br>3. A dor impede o movimento?<br><br>🔴 **Vá ao Pronto Socorro se:** Houver deformidade evidente ou dor insuportável.<br>🟢 **Cuidados em casa:** Se for leve, aplique gelo e repouso.', ARRAY['Onde fica o PS?', 'Vou aplicar gelo', 'Quero ver um médico']),

('dor_cabeca', ARRAY['dor de cabeça', 'enxaqueca', 'cabeça doendo muito', 'pontada na cabeça', 'cefaleia', 'visao turva', 'cabeca explodindo'], '🧠 **Triagem: Dor de Cabeça**<br>Responda mentalmente:<br>• A dor é a pior da sua vida?<br>• Tem alterações na visão ou fala?<br>• Teve febre junto?<br><br>Se respondeu **SIM** para algo, procure atendimento imediato. Se for uma dor conhecida (enxaqueca comum), tome sua medicação de costume e repouse em local escuro.', ARRAY['É uma dor muito forte', 'É uma dor comum', 'Preciso de atestado']),

('dor_peito_cardio', ARRAY['dor no peito', 'aperto no coração', 'pontada no peito', 'infarto', 'dor toracica', 'queimação no peito', 'formigamento no braco', 'coracao acelerado'], '🚨 **ATENÇÃO - POSSÍVEL EMERGÊNCIA** 🚨<br>Dor no peito pode ser grave. Se a dor for forte, irradiar para o braço esquerdo ou vier acompanhada de falta de ar/suor frio:<br><br>📞 **LIGUE 192 (SAMU) IMEDIATAMENTE** ou vá à emergência hospitalar mais próxima (H. Santa Isabel).<br>Não espere por agendamento no posto.', ARRAY['Ligar 192', 'Onde fica o Hospital?', 'É só uma pontada leve']),

('febre', ARRAY['estou com febre', 'meu filho tem febre', 'temperatura alta', 'corpo quente', 'calafrios', '39 graus', 'crianca fervendo'], '🌡️ **Triagem: Febre**<br>• **Adultos:** Febre acima de 39°C ou por mais de 48h requer avaliação.<br>• **Crianças:** Se houver manchas na pele, vômitos ou prostração, venha imediatamente.<br><br>Beba bastante líquido e monitore a temperatura.', ARRAY['É criança', 'É adulto', 'Tem manchas na pele']),

('identidade', ARRAY['quem é voce', 'voce é um robo', 'falar com atendente humano', 'quem criou esse bot', 'falar com pessoa', 'atendente real'], 'Eu sou o assistente virtual da ESF Thamara! Fui criado para facilitar o acesso às informações da unidade. 🤖', ARRAY['O que você sabe fazer?']),

('agradecimento', ARRAY['obrigado', 'valeu', 'muito obrigado', 'ajudou muito', 'tchau', 'ate logo', 'grato', 'beleza'], 'Por nada! Cuide-se bem. 💙', NULL),

-- NOVAS INTENÇÕES ADICIONADAS --

('renovacao_receita', ARRAY['renovar receita', 'acabou o remedio', 'preciso de losartana', 'pegar remedio de pressao', 'receita venceu', 'receita azul', 'receita controlada', 'renovar medicacao'], '💊 **Renovação de Receitas:**<br>• **Uso Contínuo (Hipertensão/Diabetes):** Venha à recepção com a receita antiga e documentos.<br>• **Controlados (Psicotrópicos):** Necessitam de avaliação médica. Verifique na recepção se há vaga para renovação ou se precisa de consulta.', ARRAY['É remédio de pressão', 'É controlado', 'Horário da farmácia']),

('saude_mulher', ARRAY['fazer preventivo', 'papanicolau', 'estou gravida', 'teste de gravidez', 'pré natal', 'consulta ginecologica', 'saude da mulher', 'atraso menstrual', 'pilula anticoncepcional'], '🌸 **Saúde da Mulher:**<br>• **Preventivo:** Agendado com a enfermeira da sua equipe.<br>• **Suspeita de Gravidez:** Venha fazer o teste rápido (TIG) pela manhã.<br>• **Pré-Natal:** Se confirmado, iniciamos o acompanhamento imediatamente.', ARRAY['Quero agendar preventivo', 'Acho que estou grávida']),

('dengue_zika', ARRAY['dor no corpo todo', 'manchas vermelhas', 'dor atras dos olhos', 'acho que estou com dengue', 'picada de mosquito', 'zika', 'chikungunya', 'dor nas juntas forte'], '🦟 **Suspeita de Dengue:**<br>Se você tem febre alta, dor atrás dos olhos e dores no corpo:<br>1. **Hidrate-se muito** (água, soro).<br>2. **NÃO tome remédios com Ácido Acetilsalicílico** (Aspirina, AAS).<br>3. Venha à unidade para avaliação e notificação.', ARRAY['Quais os sintomas?', 'Como prevenir?']),

('saude_mental', ARRAY['estou muito triste', 'ansiedade', 'depressao', 'quero morrer', 'preciso de psicologo', 'crise de ansiedade', 'panico', 'nao aguento mais', 'tristeza profunda'], '🧠 **Saúde Mental:**<br>Você não está sozinho(a). 💙<br>Venha conversar com nossa equipe de acolhimento. Temos grupos de apoio e suporte médico.<br><br>🆘 **Em crise aguda ou pensamentos urgentes:** Ligue 188 (CVV) ou vá ao CAPS/Hospital mais próximo.', ARRAY['Ligar 188 (CVV)', 'Ir ao posto conversar']),

('curativos', ARRAY['fazer curativo', 'trocar curativo', 'tirar pontos', 'ferida na perna', 'machucado feio', 'ponto cirurgico'], '🩹 **Sala de Curativos:**<br>Funciona durante o horário da unidade. Traga o encaminhamento (se houver) ou venha para avaliação da enfermeira caso seja uma ferida nova.', ARRAY['Horários', 'Documentos necessários']),

('documentos_cadastro', ARRAY['o que precisa para cadastro', 'fazer cartao sus', 'me mudar para o bairro', 'documentos necessarios', 'comprovante de residencia', 'como me cadastrar'], 'guia **Cadastro na Unidade:**<br>Para se cadastrar na ESF Thamara, traga:<br>• RG e CPF<br>• Cartão do SUS (se tiver)<br>• Comprovante de residência atualizado em seu nome (ou declaração).<br>Atendemos apenas moradores da área de abrangência.', ARRAY['Verificar área', 'Horário de cadastro'])

ON CONFLICT (intent_id) DO NOTHING;