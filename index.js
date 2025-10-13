const express = require('express');
const path = require('path');
const methodOverride = require('method-override');
const usuariosController = require('./controllers/usuarios/usuariosController');

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(methodOverride('_method'));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Rotas de usuários
app.get('/usuarios', usuariosController.index);
app.get('/usuarios/create', usuariosController.create);
app.post('/usuarios', usuariosController.store);
app.get('/usuarios/:id/edit', usuariosController.edit);
app.put('/usuarios/:id', usuariosController.update);
app.delete('/usuarios/:id', usuariosController.delete);

// ...outras rotas...

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});