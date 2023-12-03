import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    verificarUsuario().then((temUsuario) {
      setState(() {
        _hasToken = temUsuario;
      });

      if (_hasToken) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildPage("Todos já tiveram alguma decepção com o serviço público, mas poucos sabem ou querem fazer uma reclamação formal na prefeitura. Mas nem por isso deveriamos ficar calados!"),
          _buildPage("Demonstre sua insatisfação e reclame dos problemas da sua cidade!"),
          _buildPage("Suas queixas e dos demais usuários ficam marcados no mapa e você poderá acompanhar o resultado."),
          _buildLoginPage(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildPage(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Cor do texto
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPage() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_hasToken) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xffff09416e), // Cor do botão
        ),
        child: const Text(
          "Iniciar",
          style: TextStyle(
            color: Colors.white, // Cor do texto
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: const Color(0xffff09416e), // Cor da barra de navegação
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (_currentPage > 0) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: const Icon(Icons.arrow_back),
            color: Colors.white, // Cor do ícone
          ),
          IconButton(
            onPressed: () {
              if (_currentPage < 3) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              }
            },
            icon: const Icon(Icons.arrow_forward),
            color: Colors.white, // Cor do ícone
          ),
        ],
      ),
    );
  }

  Future<bool> verificarUsuario() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    return token != null;
  }
}

