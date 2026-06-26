// const express = require('express');
// const mysql = require('mysql2');
// const path = require('path');

// const app = express();
// app.use(express.json());

// // Permite que o servidor entregue a página HTML
// app.use(express.static(__dirname));

// // Configuração da conexão com o seu MySQL local
// const db = mysql.createConnection({
//     host: 'localhost',
//     user: 'root',          // Seu usuário do MySQL (geralmente root)
//     password: '',  // COLOQUE A SUA SENHA DO MYSQL AQUI!
//     database: 'petvida'
// });

// db.connect(err => {
//     if (err) {
//         console.error('Erro ao conectar no MySQL: ' + err.stack);
//         return;
//     }
//     console.log('Conectado ao banco PetVida com sucesso!');
// });

// // Rota para LISTAR os veterinários
// app.get('/api/veterinarios', (req, res) => {
//     db.query('SELECT * FROM veterinarios', (err, results) => {
//         if (err) return res.status(500).send(err);
//         res.json(results);
//     });
// });

// // Rota para CADASTRAR um novo veterinário
// app.post('/api/veterinarios', (req, res) => {
//     const { nome, crmv, especialidade, telefone } = req.body;
//     const sql = 'INSERT INTO veterinarios (nome, crmv, especialidade, telefone) VALUES (?, ?, ?, ?)';
    
//     db.query(sql, [nome, crmv, especialidade, telefone], (err, result) => {
//         if (err) return res.status(500).send(err);
//         res.json({ id: result.insertId, msg: 'Veterinário cadastrado!' });
//     });
// });

// // Abre o servidor na porta 3000
// app.listen(3000, () => {
//     console.log('Sistema rodando em http://localhost:3000');
// });

const app = require('./src/app');
require('dotenv').config();

const PORT = process.env.PORT || 3001

app.listen(PORT, () => {
    console.log(' 🐾PetVida API rodando na porta')
})