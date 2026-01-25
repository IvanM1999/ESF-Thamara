-- Tabela de Intenções (Respostas e Opções)
-- Unificação do Banco de Dados do Chatbot
-- Substitui tabelas antigas (chatbot_intents, chatbot_keywords) pela nova estrutura otimizada

-- 1. Limpeza das tabelas antigas (Evita duplicidade de estrutura)
DROP TABLE IF EXISTS chatbot_keywords;
DROP TABLE IF EXISTS chatbot_intents;
DROP TABLE IF EXISTS ai_feedback; -- Limpando tabela antiga de admin.sql

-- 2. Criação da nova tabela de interações (Modelo com Arrays)
CREATE TABLE IF NOT EXISTS chatbot_interactions (
    id SERIAL PRIMARY KEY,
    intent_id VARCHAR(50) UNIQUE NOT NULL,
    keys TEXT[] NOT NULL, -- Array de palavras-chave/frases
    response TEXT NOT NULL, -- Resposta em HTML
    options TEXT[] -- Array de botões (opcional)
);

-- 3. Índice GIN para busca rápida dentro do array de chaves
CREATE INDEX IF NOT EXISTS idx_chatbot_interactions_keys ON chatbot_interactions USING GIN(keys);

-- Tabela de Logs de Interação para Treinamento e Análise
-- Esta tabela armazena cada interação e o feedback do usuário,
-- servindo como base para futuro aprendizado de máquina (fine-tuning).
DROP TABLE IF EXISTS ai_logs;

CREATE TABLE IF NOT EXISTS ai_logs (
    id SERIAL PRIMARY KEY,
    user_query TEXT NOT NULL,
    bot_response TEXT,
    matched_intent_id VARCHAR(100),
    score REAL,
    was_context_used BOOLEAN DEFAULT FALSE,
    feedback VARCHAR(10), -- 'positive', 'neutral', 'negative'
    created_at TIMESTAMPTZ DEFAULT NOW()
);


-- 4. Limpeza e Inserção de Dados (Base Original + Novos Conteúdos)
TRUNCATE chatbot_interactions RESTART IDENTITY;

INSERT INTO chatbot_interactions (intent_id, keys, response, options) VALUES
('saudacao', ARRAY['ola', 'oi', 'bom dia', 'boa tarde', 'boa noite', 'gostaria de falar com alguem', 'iniciar atendimento', 'oi tudo bem'], 'Olá! Sou a IA da ESF Thamara. 🏥<br>Posso ajudar com informações administrativas ou fazer uma **pré-triagem** de sintomas.<br>Como posso ajudar?', ARRAY['Horários de Atendimento', 'Estou com dor', 'Vacinas', 'Endereço']),
('horarios', ARRAY['qual o horario de atendimento', 'que horas o posto abre', 'ate que horas funciona', 'horario de funcionamento', 'está aberto agora', 'agenda da unidade', 'quando abre', 'que horas abre', 'horario de abertura'], '🕒 **Dinâmica de Atendimento:**<br>• **Seg, Ter e Qui:** Manhã (intercorrências/agendamentos), Tarde (consultas/enfermagem).<br>• **Quarta:** Manhã (intercorrências), Tarde (visitas domiciliares).<br>• **Sexta:** Manhã (intercorrências), Tarde (formação equipe).<br>🚫 **Almoço:** 12h às 13h (fechado).<br>⚠️ Fora desses horários, procure o AG Garcia ou Hospitais.', ARRAY['Como agendar consulta?', 'Onde fica o AG Garcia?']),
('endereco', ARRAY['qual o endereço', 'onde fica o posto', 'localização da unidade', 'como chegar no posto', 'mapa da unidade', 'rua do posto'], '📍 **Endereço:**<br>Rua Santa Maria, 2082 – Bairro Progresso, Blumenau (SC).<br>CEP: 89027-202.', ARRAY['Ver no Mapa', 'Horários']),
('contato', ARRAY['qual o telefone', 'numero para contato', 'como ligar para o posto', 'tem whatsapp', 'numero do zap'], '📞 **Telefones:**<br>(47) 3381-7064<br>(47) 3381-6751<br>No momento não temos WhatsApp oficial para agendamento.', ARRAY['Voltar ao início']),
('vacinas', ARRAY['horario de vacinacao', 'quero tomar vacina', 'tem vacina da gripe', 'campanha de vacinacao', 'preciso me vacinar'], '💉 **Sala de Vacinas:**<br>Segunda a Quinta: 09h às 11h30 e 13h às 15h.<br>Sexta: 09h às 11h30 (somente matutino).<br>Lembre-se de trazer a carteirinha de vacinação e o cartão do SUS!', ARRAY['Quais documentos levar?', 'Tem vacina da gripe?']),
('consultas', ARRAY['como marcar consulta', 'agendar medico', 'preciso de um clinico geral', 'quero marcar uma consulta', 'tem medico hoje', 'quero ver um medico', 'preciso passar no medico', 'consulta medica'], '👨‍⚕️ **Consultas:**<br>O agendamento é feito preferencialmente presencialmente na unidade. Para casos agudos, venha para a triagem (Acolhimento).', ARRAY['Estou com dor aguda', 'É apenas rotina']),
('odonto', ARRAY['dentista', 'consulta dentista', 'dor no dente', 'dente doendo', 'gengiva doendo', 'arrancar dente', 'canal no dente', 'limpeza nos dentes', 'odontologia', 'saude bucal', 'dente quebrado', 'estou com muita dor de dente', 'dor de dente forte'], '🦷 **Odontologia:**<br>Temos atendimento odontológico. É necessário passar pela recepção para verificar a disponibilidade de agendamento.', ARRAY['Estou com muita dor de dente', 'Quero agendar limpeza']),
('dor_abdominal', ARRAY['dor de barriga', 'dor no estomago', 'dor abdominal', 'enjoo', 'vomito', 'diarreia', 'azia', 'queimação no estomago', 'colica', 'minha barriga doi', 'estou com dor de barriga'], '⚠️ **Dor Abdominal/Estômago:**<br>• **Leve/Moderada:** Venha ao Posto (ESF) para avaliação médica.<br>• **Grave (dor insuportável):** Vá ao Hospital.<br>• **Dúvida:** Ligue 156 (Alô Saúde).', ARRAY['Ir ao Posto', 'Ligar 156']),
('dor_garganta_ouvido', ARRAY['dor de garganta', 'dor de ouvido', 'ouvido doendo', 'garganta inflamada', 'dificuldade para engolir', 'dor ao engolir', 'zumbido no ouvido'], '⚠️ **Garganta ou Ouvido:**<br>Geralmente são infecções que precisam de avaliação clínica.<br>Venha ao Posto (ESF) no horário de acolhimento (07h-11h ou 13h-15h).', ARRAY['Ver Horários', 'Endereço']),
('triagem_geral', ARRAY['estou passando mal', 'tontura forte', 'desmaio', 'sangramento', 'pressao baixa', 'mal estar', 'corpo ruim', 'fraqueza'], '⚠️ **Acolhimento/Triagem:**<br>Se você está se sentindo mal de forma geral, venha à unidade para aferir pressão e passar pela triagem.<br><br>🚨 **Desmaio ou Sangramento forte:** Ligue 192 (SAMU).', ARRAY['Ligar 192', 'Ir para o posto']),
('visitas', ARRAY['visita domiciliar', 'atendimento em casa', 'paciente acamado', 'agente de saude visita', 'medico vai em casa'], '🏠 **Visitas Domiciliares:**<br>Ocorrem geralmente nas quartas-feiras à tarde. São destinadas a pacientes acamados ou com dificuldade de locomoção. Converse com seu Agente de Saúde (ACS) para solicitar.', ARRAY['Como falar com ACS?', 'Voltar']),
('identidade', ARRAY['quem é voce', 'voce é um robo', 'falar com atendente humano', 'quem criou esse bot'], 'Eu sou o assistente virtual da ESF Thamara! Fui criado para facilitar o acesso às informações da unidade. 🤖', ARRAY['O que você sabe fazer?']),
('agradecimento', ARRAY['obrigado', 'valeu', 'muito obrigado', 'ajudou muito', 'tchau', 'ate logo'], 'Por nada! Cuide-se bem. 💙', NULL),
('dor_cotovelo_membros', ARRAY['dor no cotovelo', 'dor de cotovelo', 'dor no braço', 'machuquei o joelho', 'torci o pé', 'dor na perna', 'dor nas juntas', 'cotovelo doendo', 'dor no ombro', 'pancada', 'dor nas costas', 'dor na coluna', 'dor no quadril', 'dor no pe'], '⚠️ **Triagem Ortopédica (Membros):**<br>Para melhor orientação, analise:<br>1. Houve trauma (batida/queda) recente?<br>2. Há inchaço ou deformidade visível?<br>3. A dor impede o movimento?<br><br>🔴 **Vá ao Pronto Socorro se:** Houver deformidade evidente ou dor insuportável.<br>🟢 **Cuidados em casa:** Se for leve, aplique gelo e repouso.', ARRAY['Onde fica o PS?', 'Vou aplicar gelo', 'Quero ver um médico']),
('dor_cabeca', ARRAY['dor de cabeça', 'enxaqueca', 'cabeça doendo muito', 'pontada na cabeça', 'cefaleia'], '🧠 **Triagem: Dor de Cabeça**<br>Responda mentalmente:<br>• A dor é a pior da sua vida?<br>• Tem alterações na visão ou fala?<br>• Teve febre junto?<br><br>Se respondeu **SIM** para algo, procure atendimento imediato. Se for uma dor conhecida (enxaqueca comum), tome sua medicação de costume e repouse em local escuro.', ARRAY['É uma dor muito forte', 'É uma dor comum', 'Preciso de atestado']),
('dor_peito_cardio', ARRAY['dor no peito', 'aperto no coração', 'pontada no peito', 'infarto', 'dor toracica', 'queimação no peito'], '🚨 **ATENÇÃO - POSSÍVEL EMERGÊNCIA** 🚨<br>Dor no peito pode ser grave. Se a dor for forte, irradiar para o braço esquerdo ou vier acompanhada de falta de ar/suor frio:<br><br>📞 **LIGUE 192 (SAMU) IMEDIATAMENTE** ou vá à emergência hospitalar mais próxima (H. Santa Isabel).<br>Não espere por agendamento no posto.', ARRAY['Ligar 192', 'Onde fica o Hospital?', 'É só uma pontada leve']),
('febre', ARRAY['estou com febre', 'meu filho tem febre', 'temperatura alta', 'corpo quente', 'calafrios'], '🌡️ **Triagem: Febre**<br>• **Adultos:** Febre acima de 39°C ou por mais de 48h requer avaliação.<br>• **Crianças:** Se houver manchas na pele, vômitos ou prostração, venha imediatamente.<br><br>Beba bastante líquido e monitore a temperatura.', ARRAY['É criança', 'É adulto', 'Tem manchas na pele']),
('tabela_decisao', ARRAY['tabela de sintomas', 'onde devo ir', 'classificacao de risco', 'estou em duvida', 'guia de atendimento', 'para onde eu vou'], '🏥 **Guia Rápido de Decisão:**<br><table style=''width:100%; border-collapse:collapse; font-size:13px; margin-top:5px;''><tr><th style=''border:1px solid #ccc; padding:5px; background:#f0f0f0;''>Sintoma / Situação</th><th style=''border:1px solid #ccc; padding:5px; background:#f0f0f0;''>Onde Ir?</th></tr><tr><td style=''border:1px solid #ccc; padding:5px;''>Risco de Vida / Acidentes Graves</td><td style=''border:1px solid #ccc; padding:5px; color:red; font-weight:bold;''>SAMU (192) / Hospital</td></tr><tr><td style=''border:1px solid #ccc; padding:5px;''>Dores Agudas / Febre / Curativos</td><td style=''border:1px solid #ccc; padding:5px; color:blue; font-weight:bold;''>ESF (Posto)</td></tr><tr><td style=''border:1px solid #ccc; padding:5px;''>Dúvidas / Sintomas Leves</td><td style=''border:1px solid #ccc; padding:5px; color:green; font-weight:bold;''>Alô Saúde (156)</td></tr><tr><td style=''border:1px solid #ccc; padding:5px;''>Gripe Leve (sem falta de ar)</td><td style=''border:1px solid #ccc; padding:5px;''>Isolamento (Casa)</td></tr></table>', ARRAY['Entendi', 'Emergência']),
('alo_saude', ARRAY['alo saude', 'atendimento por telefone', 'consulta online', 'telemedicina', 'duvida simples', 'preciso sair de casa'], '📞 **Alô Saúde Blumenau (156 opção 2):**<br>Para orientações médicas sem sair de casa, ligue 156.<br>Ideal para: Sintomas leves, dúvidas sobre medicamentos e orientações gerais.<br>Evite filas desnecessárias e riscos de contágio!', ARRAY['Ligar 156', 'Voltar']),
('sindrome_gripal', ARRAY['tosse', 'coriza', 'dor de garganta leve', 'gripe', 'resfriado', 'nariz escorrendo', 'espirrando'], '😷 **Sintomas Gripais Leves:**<br>Se você tem apenas tosse, coriza e febre baixa:<br>1. **Use máscara** e evite contato social (Isolamento).<br>2. Hidrate-se e repouse.<br>3. Se piorar (falta de ar), procure o Ambulatório Geral (AG) ou Hospital.<br>⚠️ **Não venha ao ESF sem máscara!**', ARRAY['Tenho falta de ar', 'É só gripe leve']),
('emergencia_gestante', ARRAY['estou gravida e com dor', 'sangramento na gravidez', 'perdi liquido', 'bebe nao mexe', 'gestante com dor', 'gravida sangrando'], '🚨 **Atenção Gestante:**<br>Vá imediatamente à **Maternidade ou Hospital** se tiver:<br>• Sangramento vaginal.<br>• Perda de líquido.<br>• Dor abdominal forte.<br>• Ausência de movimentos do bebê.<br>Não espere pelo ESF, isso é uma emergência.', ARRAY['Onde fica a maternidade?', 'Ligar SAMU']),
('emergencia_idoso', ARRAY['idoso caiu', 'minha avo caiu', 'fala enrolada', 'boca torta', 'fraqueza de um lado', 'idoso confuso', 'avc', 'derrame'], '🚨 **Emergência com Idoso:**<br>Se houver **queda com dor/imobilidade** ou sinais de AVC (boca torta, fala enrolada, perda de força):<br>📞 **LIGUE 192 (SAMU) IMEDIATAMENTE.**<br>Não tente mover o paciente se houver suspeita de fratura no quadril/fêmur.', ARRAY['Ligar 192']),
('emergencia_crianca', ARRAY['meu filho nao respira bem', 'bebe com febre alta', 'crianca prostrada', 'bebe roxo', 'convulsao infantil'], '🚨 **Emergência Pediátrica:**<br>Procure o **Hospital** imediatamente se a criança apresentar:<br>• Dificuldade para respirar (peito afundando).<br>• Lábios roxos.<br>• Convulsão.<br>• Sonolência excessiva (não acorda).<br>Para febre controlada, procure o ESF ou Alô Saúde.', ARRAY['Hospital Infantil', 'Ligar 192']),
('atendimento_inclusivo', ARRAY['sou autista', 'tenho autismo', 'atendimento prioritario', 'tea', 'sensibilidade sensorial', 'paciente autista'], '💙 **Atendimento Inclusivo (TEA):**<br>Pessoas com TEA têm direito a atendimento prioritário e humanizado.<br>Informe na recepção sobre suas necessidades (ambiente calmo, menos barulho).<br>Em caso de crise sensorial aguda, nossa equipe está preparada para acolher.', ARRAY['Tenho carteirinha TEA', 'Preciso de prioridade']),
('dor_generica', ARRAY['estou com dor', 'sinto dor', 'dor no corpo', 'doi tudo', 'estou doendo', 'tenho dor', 'dor', 'alguma dor', 'pico de dor', 'dor muito forte', 'dor intensa', 'estou com muita dor', 'dor insuportavel', 'estou com dor aguda'], '⚠️ **Onde é a sua dor?**<br>Para te orientar melhor, preciso saber onde dói.<br><br>Exemplos: "Dor de cabeça", "Dor no peito", "Dor nas costas", "Dor de dente".', ARRAY['Cabeça', 'Peito', 'Barriga', 'Dente', 'Costas']),
('hospital_ps', ARRAY['onde fica o ps', 'onde fica o hospital', 'pronto socorro', 'emergencia hospital', 'endereco do hospital', 'hospital santa isabel', 'hospital santo antonio', 'upa', 'onde e a emergencia'], '🏥 **Hospitais / Pronto Socorro:**<br>Para emergências, procure:<br>• **Hospital Santa Isabel:** R. Floriano Peixoto, 300.<br>• **Hospital Santo Antônio:** R. Itajaí, 545.<br>• **Hospital Misericórdia (Vila Itoupava).**<br><br>🚑 Em risco de vida, ligue **192**.', ARRAY['Ligar 192', 'Voltar']),
('feedback_negativo', ARRAY['ta uma porcaria', 'nao funciona', 'bot burro', 'que lixo', 'nao ajuda', 'pessimo', 'horrivel', 'idiota', 'ruim'], '😔 Sinto muito que você não esteja satisfeito. Sou uma inteligência artificial em aprendizado.<br>Por favor, ligue para **(47) 3381-7064** para falar com um atendente humano.', ARRAY['Ligar para o posto']);

-- 5. Função de Aprendizado Automático (Auto-Training)
-- Esta função consolida os feedbacks positivos e atualiza as chaves de busca
CREATE OR REPLACE FUNCTION train_ai_from_feedback() RETURNS text AS $$
DECLARE
    rows_updated INT;
BEGIN
    WITH new_keys_agg AS (
        SELECT matched_intent_id, array_agg(DISTINCT user_query) as phrases
        FROM ai_logs
        WHERE feedback = 'positive' AND length(user_query) > 3
        GROUP BY matched_intent_id
    )
    UPDATE chatbot_interactions ci
    SET keys = (SELECT array_agg(DISTINCT x) FROM unnest(ci.keys || nka.phrases) x)
    FROM new_keys_agg nka
    WHERE ci.intent_id = nka.matched_intent_id;

    GET DIAGNOSTICS rows_updated = ROW_COUNT;
    RETURN 'Inteligência atualizada! Intenções aprimoradas: ' || rows_updated;
END;
$$ LANGUAGE plpgsql;

-- 6. View para Visualizar Frases Aprendidas (Feedback Positivo)
-- Mostra as frases que os usuários digitaram e avaliaram positivamente,
-- que servem de base para o treinamento da IA.
CREATE OR REPLACE VIEW ai_learned_phrases_view AS
SELECT 
    user_query AS frase_aprendida,
    matched_intent_id AS intencao,
    COUNT(*) AS frequencia,
    MAX(created_at) AS ultima_ocorrencia
FROM ai_logs
WHERE feedback = 'positive'
GROUP BY user_query, matched_intent_id
ORDER BY frequencia DESC, ultima_ocorrencia DESC;

-- 7. View para Análise de Erros (Feedback Negativo)
-- Mostra onde a IA errou, ajudando a identificar ajustes necessários nas chaves ou respostas.
CREATE OR REPLACE VIEW ai_negative_feedback_view AS
SELECT 
    user_query AS frase_usuario,
    matched_intent_id AS intencao_incorreta,
    AVG(score)::NUMERIC(4,3) AS media_confianca,
    COUNT(*) AS frequencia,
    MAX(created_at) AS ultima_ocorrencia
FROM ai_logs
WHERE feedback = 'negative'
GROUP BY user_query, matched_intent_id
ORDER BY frequencia DESC, ultima_ocorrencia DESC;

-- 8. Função de Limpeza de Logs Antigos (Manutenção)
-- Remove registros antigos da tabela ai_logs para evitar crescimento excessivo do banco.
-- Exemplo de uso: SELECT cleanup_ai_logs(90); -- Mantém apenas os últimos 90 dias.
CREATE OR REPLACE FUNCTION cleanup_ai_logs(days_to_keep INT DEFAULT 90) RETURNS text AS $$
DECLARE
    rows_deleted INT;
BEGIN
    DELETE FROM ai_logs
    WHERE created_at < NOW() - (days_to_keep || ' days')::INTERVAL;

    GET DIAGNOSTICS rows_deleted = ROW_COUNT;
    RETURN 'Limpeza concluída. Logs removidos: ' || rows_deleted;
END;
$$ LANGUAGE plpgsql;

-- 9. Função de Sincronização via JSON (Manutenção Avançada)
-- Permite o "upsert" (INSERT/UPDATE) em lote da base de conhecimento a partir de um payload JSON.
-- Isso facilita a atualização da IA via API, sem editar o arquivo .sql manualmente.
-- Exemplo de uso: SELECT sync_interactions_from_json('[{"id":"new_intent", "keys":["k1"], "resp":"r1"}]'::jsonb);
CREATE OR REPLACE FUNCTION sync_interactions_from_json(json_data JSONB)
RETURNS TEXT AS $$
DECLARE
    intent_record JSONB;
    upserted_count INT := 0;
    intent_id_text TEXT;
    keys_array TEXT[];
    response_text TEXT;
    options_array TEXT[];
BEGIN
    -- Itera sobre cada objeto no array JSON
    FOR intent_record IN SELECT * FROM jsonb_array_elements(json_data)
    LOOP
        intent_id_text := intent_record->>'id';
        
        -- Extrai o array 'keys'
        SELECT array_agg(value) INTO keys_array FROM jsonb_array_elements_text(intent_record->'keys');
        
        response_text := intent_record->>'resp';
        
        -- Extrai o array 'options', tratando o caso de não existir
        IF intent_record ? 'options' THEN
            SELECT array_agg(value) INTO options_array FROM jsonb_array_elements_text(intent_record->'options');
        ELSE
            options_array := NULL;
        END IF;

        -- Insere um novo registro ou atualiza um existente se o intent_id já existir
        INSERT INTO chatbot_interactions (intent_id, keys, response, options)
        VALUES (intent_id_text, keys_array, response_text, options_array)
        ON CONFLICT (intent_id) DO UPDATE SET
            keys = EXCLUDED.keys,
            response = EXCLUDED.response,
            options = EXCLUDED.options;

        upserted_count := upserted_count + 1;
    END LOOP;

    RETURN 'Sincronização via JSON concluída. ' || upserted_count || ' intenções processadas.';
END;
$$ LANGUAGE plpgsql;