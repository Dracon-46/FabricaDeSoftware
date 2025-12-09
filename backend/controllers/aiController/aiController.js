// controllers/aiController.js
const OpenAI = require("openai");

// Certifique-se de que a chave está no seu arquivo .env do Node.js
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY, 
});

// 1. Gerar Requisitos (Lógica migrada do Dart para JS)
exports.gerarRequisitos = async (req, res) => {
  try {
    const { escopo, nomeProjeto } = req.body;

    const prompt = `
      Você é um analista de requisitos sênior.
      Com base no seguinte projeto: "${nomeProjeto}" e escopo: "${escopo}".
      Gere uma lista de requisitos (misture funcionais e não funcionais).
      
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
      messages: [
        { role: "system", content: "Você é um assistente que responde estritamente em JSON." },
        { role: "user", content: prompt }
      ],
      temperature: 0.7,
    });

    let content = completion.choices[0].message.content;
    // Limpeza de Markdown caso a IA envie
    content = content.replace(/```json/g, '').replace(/```/g, '').trim();

    const listaJson = JSON.parse(content);
    res.json(listaJson);

  } catch (error) {
    console.error("Erro ao gerar requisitos:", error);
    res.status(500).json({ error: "Falha ao gerar requisitos na IA." });
  }
};

// 2. Estimar Orçamento
exports.estimarOrcamento = async (req, res) => {
  try {
    const { nome, descricao, equipe, recursos, duracao_dias } = req.body;

    const prompt = `
      Atue como um Gerente de Projetos Sênior.
      Estime o orçamento total para o seguinte projeto:
      
      Projeto: ${nome}
      Descrição: ${descricao}
      Duração Estimada: ${duracao_dias} dias.
      Equipe: ${equipe.length} pessoas (${equipe.map(e => e.papel).join(', ')}).
      Recursos: ${recursos.length} itens (${recursos.map(r => r.nome).join(', ')}).
      
      Responda APENAS com um número float puro (ex: 25000.00), sem texto, sem R$. 
      Considere custos de mercado de TI no Brasil.
    `;

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.3,
    });

    const valorTexto = completion.choices[0].message.content.replace(/[^0-9.]/g, '');
    const valor = parseFloat(valorTexto);

    res.json({ orcamento_estimado: valor || 0.0 });
  } catch (error) {
    console.error("Erro ao estimar orçamento:", error);
    res.status(500).json({ error: "Falha ao estimar orçamento." });
  }
};