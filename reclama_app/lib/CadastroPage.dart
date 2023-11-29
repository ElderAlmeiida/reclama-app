import 'package:flutter/material.dart';
import 'package:reclama_app/database_helper.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  late final DatabaseHelper _database;

  @override
  void initState() {
    super.initState();
    _database = DatabaseHelper();
  }

  Future<void> _cadastrarUsuario() async {
    final String nome = _nomeController.text;
    final String email = _emailController.text;
    final String senha = _senhaController.text;
    final String confirmarSenha = _confirmarSenhaController.text;

    if (senha != confirmarSenha) {
      // Senha e confirmação de senha não coincidem
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('A senha e a confirmação de senha não coincidem.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      // Criar um mapa com os dados do usuário
      final Map<String, dynamic> usuario = {
        'nome_usuario': nome,
        'email_usuario': email,
        'senha_usuario': senha,
        // Adicione outros campos conforme necessário
      };

      // Inserir usuário no banco de dados SQLite
      await _database.insertUsuario(usuario);

      // Cadastro bem-sucedido
      print('Usuário cadastrado com sucesso!');
      // Adicione aqui a navegação para a próxima página se desejar
    } catch (error) {
      // Tratar erros de conexão ou outros erros
      print('Erro: $error');
      // Exibir mensagem de erro para o usuário
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Erro ao cadastrar usuário.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome de Usuário'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'E-mail'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _confirmarSenhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar Senha'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _cadastrarUsuario,
              child: const Text('Cadastrar'),
            ),
            const SizedBox(height: 8.0),
            TextButton(
              onPressed: () {
                // Navegar de volta para a página de login
                Navigator.pop(context);
              },
              child: const Text('Já tenho uma conta. Faça login.'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: CadastroPage(),
    ),
  );
}

