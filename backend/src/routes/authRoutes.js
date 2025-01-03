const express = require('express');
const { registre, login } = require('../controllers/authController');

const router = express.Router();

router.post('/registre', registre);
router.post('/login', login);

module.exports = router;
