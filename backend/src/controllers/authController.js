const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { createUser, findUserByEmail, getAllUsers } = require('../models/userModel');
require('dotenv').config();

const registre = async (req, res) => {
    const { email, password, username } = req.body;

    try {
        const existinUser = await findUserByEmail(email);
        if(existinUser) return res.status(400).json({ message: 'Usuario ja Existe!'});

        const hashedPassword = await bcrypt.hash(password,10);

        const user = await createUser(email, hashedPassword, username);

        res.status(201).json({ message: 'Usuario Registrado, coom sucesso!', user});
    } catch (error) {
        res.status(500).json({ message: 'Server error', error });
    }
};

const login = async ( req, res) => {
    const { email, password} = req.body;

    try {

      const user = await findUserByEmail(email);
      if ( !user ) {
        return res.status(404).json({ message: 'E-email não encontroda'});
      }

      const isMatch = await bcrypt.compare(password, user.password);
      if ( !isMatch ) {
        return res.status(401).json({ message: ' Senha errada! '});
      }

      const token = jwt.sign(
        { id: user.id, username: user.username },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES }
      );
      
      res.status(200).json({ 
        message: 'Login bem-sucedido', 
        user: { id: user.id, username: user.username }, 
        token 
      });
        
    } catch (error) {
        res.status(500).json({ message: 'Erro no servidor', error });
    }
}

module.exports = {registre, login};