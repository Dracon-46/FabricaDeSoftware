const OpenAI = require("openai");

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY, 
});

// 1. Gerar Requisitos (Mantido igual)
exports.gerarRequisitos = async (req, res) => {
  try {
    const { escopo, nomeProjeto } = req.body;
    const prompt = `
      Você é um analista de requisitos sênior.
      Com base no seguinte projeto: "${nomeProjeto}" e escopo: "${escopo}".
      Gere uma lista de no minimo 10 requisitos (misture funcionais e não funcionais).
      IMPORTANTE: Responda APENAS com um JSON válido no seguinte formato, sem textos adicionais, sem markdown (\`\`\`json):
        [
            {
            "titulo": "Nome curto do requisito",
            "descricao": "Descrição detalhada",
            "tipo": "Funcional" ou "Não Funcional",
            "prioridade": "Alta", "Média" ou "Baixa"
            }
        ]
    `;
    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.7,
    });
    let content = completion.choices[0].message.content.replace(/```json/g, '').replace(/```/g, '').trim();
    res.json(JSON.parse(content));
  } catch (error) {
    console.error("Erro IA Requisitos:", error);
    res.status(500).json({ error: "Falha na IA" });
  }
};

// 2. Estimar Orçamento E Complexidade (ATUALIZADO)
exports.estimarOrcamento = async (req, res) => {
  try {
    const { nome, descricao, escopo, equipe, recursos, duracao_dias } = req.body;

    const prompt = `
      Atue como um Gerente de Projetos Sênior.
      Analise este projeto para estimar Orçamento e Complexidade.
      
      DADOS:
      - Projeto: ${nome}
      - Descrição: ${descricao}
      - Escopo Completo: ${escopo}
      - Duração: ${duracao_dias} dias
      - Equipe: ${equipe.length} pessoas (${equipe.map(e => e.papel).join(', ')})
      - Recursos: ${recursos.length} itens
      
      TAREFA:
      1. Estime o custo total (float) considerando mercado de TI Brasil.
      2. Defina a complexidade técnica entre: 'baixa', 'media', ou 'alta'.
      
      SAÍDA OBRIGATÓRIA (JSON puro):
      {
        "orcamento_estimado": 0.00,
        "complexidade": "string"
      }
    `;

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.3,
    });

    let content = completion.choices[0].message.content.replace(/```json/g, '').replace(/```/g, '').trim();
    const resultado = JSON.parse(content);

    res.json({ 
      orcamento_estimado: resultado.orcamento_estimado || 0.0,
      complexidade: resultado.complexidade || 'media'
    });

  } catch (error) {
    console.error("Erro IA Orçamento:", error);
    res.status(500).json({ error: "Falha na IA" });
  }
};