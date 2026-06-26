const express = require('express')
const cors = require('express')
const app = express();

//Middleware
app.use(cors)

//Rota de teste (já funcionando)
app.get('/api/veterinarios', require('.routes/veterina'))
app.get('/api/animais', require('.routes/animais'))
app.get('/api/consultas', require('.routes/consultas'))
app.get('/api/pagamentos', require('.routes/pagamentos'))
app.get('/api/relatorios', require('.routes/relatorios'))

modulo.exports = app;