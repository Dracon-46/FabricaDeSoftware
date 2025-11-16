const pool = require("../../db");
const jwt = require("jsonwebtoken");

// --- CORREÇÃO: Trocamos o 'google-auth-library' pelo 'firebase-admin' ---
const admin = require('../../firebaseAdmin'); // Ajuste o caminho se necessário

const SECRET_KEY = process.env.JWT_SECRET || "sua_chave_secreta_aqui";

// Login (Seu código existente - sem alteração)
exports.login = async (req, res) => {
  try {
    console.log('Dados recebidos:', req.body);
    const { email, senha } = req.body;
    console.log('Email:', email);
    console.log('Senha:', senha);

    console.log('Executando query com:', { email, senha });
    const result = await pool.query(
      "SELECT * FROM usuarios WHERE email = $1 AND senha = $2",
      [email, senha]
    );
    console.log('Resultado da query:', result.rows);

    const usuario = result.rows[0];
    console.log('Usuário encontrado:', usuario);

    if (!usuario) {
      return res.status(401).json({
        message: "Credenciais inválidas"
      });
    }

    const token = jwt.sign(
      {
        id: usuario.id,
        email: usuario.email,
        nivel: usuario.nivel
      },
      SECRET_KEY,
      { expiresIn: "24h" }
    );

    console.log('Token gerado:', token);

    const resposta = {
      token,
      usuario: {
        id: parseInt(usuario.id),
        nome: usuario.nome,
        email: usuario.email,
        nivel: usuario.nivel
      }
    };

    console.log('Resposta sendo enviada:', resposta);
    res.json(resposta);

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// --- FUNÇÃO GOOGLE LOGIN (CORRIGIDA) ---
exports.googleLogin = async (req, res) => {
  // O 'googleIdToken' aqui é na verdade o Token de ID do FIREBASE
  const { googleIdToken } = req.body;

  try {
    // 1. Verificar o idToken com o FIREBASE ADMIN
    const decodedToken = await admin.auth().verifyIdToken(googleIdToken);

    const email = decodedToken.email;
    const nome = decodedToken.name;

    if (!email) {
      return res.status(400).json({ message: "Não foi possível obter e-mail do Google." });
    }

    // 2. Procurar usuário no SEU banco de dados
    let result = await pool.query("SELECT * FROM usuarios WHERE email = $1", [email]);
    let usuario = result.rows[0];

    // 3. Se usuário não existe, crie-o (com senha nula)
    if (!usuario) {
      console.log(`Criando novo usuário para: ${email}`);
      const nivelPadrao = 'colaborador';
      const insertQuery = `
        INSERT INTO usuarios (nome, email, senha, nivel, telefone) 
        VALUES ($1, $2, $3, $4, $5) 
        RETURNING *
      `;
      
      const insertResult = await pool.query(insertQuery, [
        nome, 
        email, 
        null, // Senha nula
        nivelPadrao, 
        decodedToken.phone_number || null // Pega o telefone se o firebase tiver
      ]);
      
      usuario = insertResult.rows[0];
    }

    // 4. Gerar o SEU token JWT
    const token = jwt.sign(
      {
        id: usuario.id,
        email: usuario.email,
        nivel: usuario.nivel
      },
      SECRET_KEY,
      { expiresIn: "24h" }
    );

    // 5. Retornar a MESMA resposta do login normal
    const resposta = {
      token,
      usuario: {
        id: parseInt(usuario.id),
        nome: usuario.nome,
        email: usuario.email,
        nivel: usuario.nivel
      }
    };

    res.json(resposta);

  } catch (error) {
    // Se o token for inválido, o 'admin.auth().verifyIdToken' vai falhar
    console.error("Erro no login com Google (backend):", error);
    res.status(401).json({ message: "Falha na autenticação com Google.", error: error.message });
  }
};
// --- FIM DA FUNÇÃO GOOGLE LOGIN ---


// Refresh Token (Seu código existente - sem alteração)
exports.refresh = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ message: "Token não fornecido" });
    }

    const token = authHeader.split(" ")[1];
    
    try {
      const decoded = jwt.verify(token, SECRET_KEY);
      
      const result = await pool.query(
        "SELECT id, nome, email, cargo FROM usuarios WHERE id = $1",
        [decoded.id]
      );

      const usuario = result.rows[0];
      if (!usuario) {
        return res.status(401).json({ message: "Usuário não encontrado" });
      }

      const newToken = jwt.sign(
        { 
          id: usuario.id,
          email: usuario.email,
          cargo: usuario.cargo
        },
        SECRET_KEY,
        { expiresIn: "24h" }
      );

      res.json({
        token: newToken,
        usuario: {
          id: usuario.id,
          nome: usuario.nome,
          email: usuario.email,
          cargo: usuario.cargo
        }
      });

    } catch (err) {
      return res.status(401).json({ message: "Token inválido ou expirado" });
    }

  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Middleware de autenticação (Seu código existente - sem alteração)
exports.authenticateToken = (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (!authHeader) {
    return res.status(401).json({ message: "Token não fornecido" });
  }

  const token = authHeader.split(" ")[1];

  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Token inválido ou expirado" });
    }
    req.user = user;
    next();
  });
};