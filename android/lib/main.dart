import 'package:flutter/material.dart';
import 'dart:async';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Mudamos a rota inicial para a splash screen
      routes: {
        '/': (context) => const SplashScreen(),  // Tela de Boas-vindas
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  bool _isVisible = true;
  late AnimationController _scaleController;
  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    // Inicia a animação de fade-out após 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isVisible = false;
      });
      // Depois de desaparecer, redireciona para o login com uma animação de slide
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          _createSlideTransition(),  // Aplica a animação personalizada
        );
      });
    });

    // Cria animações de escala e movimento
    _scaleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);  // Faz a animação de escala repetir

    _moveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);  // Faz o movimento para cima e para baixo
  }

  // Função para criar a animação de slide da esquerda para a direita
  Route _createSlideTransition() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);  // Começo da animação (da esquerda)
        const end = Offset.zero;  // Fim da animação (no centro)
        const curve = Curves.easeInOutCubic;  // Curva da animação mais suave

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: FadeTransition(opacity: animation, child: child));
      },
    );
  }

  @override
  void dispose() {
    // Limpa os controladores de animação
    _scaleController.dispose();
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,  // Controla o fade-in/fade-out
        duration: const Duration(seconds: 1),  // Duração do fade
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Texto de boas-vindas com animação de movimento
              AnimatedBuilder(
                animation: _moveController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 10 * _moveController.value),  // Movimento para cima e para baixo
                    child: child,
                  );
                },
                child: Text(
                  'Bem-vindo à Loja de Bolos!',
                  style: TextStyle(
                    color: Colors.amber[800],
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Adiciona uma animação de escala e movimento para o ícone
              AnimatedBuilder(
                animation: _scaleController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1 + _scaleController.value * 0.1,  // Aumenta e diminui o ícone
                    child: Transform.translate(
                      offset: Offset(0, 10 * _moveController.value),  // Movimento para cima e para baixo
                      child: child,
                    ),
                  );
                },
                child: const Icon(
                  Icons.cake,
                  color: Colors.amber,
                  size: 80,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
