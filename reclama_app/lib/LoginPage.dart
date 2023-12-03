import 'package:flutter/material.dart';
import 'CadastroPage.dart'; // Importe a página de cadastro
import 'HomePage.dart'; // Importe a página inicial (HomePage)

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Usuário e senha padrão para teste
  final String usuarioPadrao = 'user';
  final String senhaPadrao = '123456';

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF204E79)),
                      onPressed: () {
                        // Adicione a navegação de volta ao Dashboard aqui
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF204E79),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Image.asset(
                  'assets/images/Logo.png',
                  width: deviceWidth * 0.8,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Entre com suas credenciais:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF204E79),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 304,
                  height: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'nome@email.com',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um e-mail válido.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 304,
                  height: 41,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua senha',
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha.';
                      } else if (value.length < 6) {
                        return 'Digite uma senha mais forte';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 304,
                  height: 41,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Verificar as credenciais
                        if (_emailController.text == usuarioPadrao &&
                            _senhaController.text == senhaPadrao) {
                          // Credenciais corretas, navegar para HomePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } else {
                          // Credenciais incorretas, exibir mensagem
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Credenciais incorretas. Tente novamente.'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF204E79),
                    ),
                    child: const Text('ENTRAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ainda não tem uma conta?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF204E79),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CadastroPage()),
                    );
                  },
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF204E79),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




