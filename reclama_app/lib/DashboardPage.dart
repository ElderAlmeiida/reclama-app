import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPage();
}

class _DashboardPage extends State<DashboardPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    verificarUsuario().then((temUsuario) {
      if (temUsuario) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      } else {
        // Continue com a inicialização normal
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
            style: const TextStyle(fontSize: 18.0),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPage() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF204E79), // Background color
        ),
        child: const Text(
          "Iniciar",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: const Color(0xFF204E79),
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
            color: Colors.white,
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
            color: Colors.white,
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
