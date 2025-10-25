const pool = require("../../db");
const jwt = require("jsonwebtoken");

const SECRET_KEY = process.env.JWT_SECRET || "sua_chave_secreta_aqui";

// Login
exports.login = async (req, res) => {
  try {
    console.log('Dados recebidos:', req.body);
    const { email, senha } = req.body;
    console.log('Email:', email);
    console.log('Senha:', senha);

    // Buscar usuário pelo email
    console.log('Executando query com:', { email, senha });
    const result = await pool.query(
      "SELECT * FROM usuarios WHERE email = $1 AND senha = $2",
      [email, senha]
    );
    console.log('Resultado da query:', result.rows);

    const usuario = result.rows[0];
    console.log('Usuário encontrado:', usuario);

    // Verificar se o usuário existe
    if (!usuario) {
      return res.status(401).json({ 
        message: "Credenciais inválidas" 
      });
    }

    // Gerar token JWT
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

    // Retornar token e informações do usuário conforme esperado pelo frontend
    const resposta = {
      token,
      usuario: {
        id: parseInt(usuario.id),  // Convertendo para número pois o frontend espera um int
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

// Refresh Token
exports.refresh = async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader) {
      return res.status(401).json({ message: "Token não fornecido" });
    }

    const token = authHeader.split(" ")[1];
    
    try {
      // Verificar token atual
      const decoded = jwt.verify(token, SECRET_KEY);
      
      // Buscar usuário atualizado
      const result = await pool.query(
        "SELECT id, nome, email, cargo FROM usuarios WHERE id = $1",
        [decoded.id]
      );

      const usuario = result.rows[0];
      if (!usuario) {
        return res.status(401).json({ message: "Usuário não encontrado" });
      }

      // Gerar novo token
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

// Middleware de autenticação
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