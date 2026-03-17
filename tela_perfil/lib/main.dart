import 'package:flutter/material.dart';

void main() {
  runApp(const TelaPerfil());
}

// O Ponto de Entrada
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PaginaPerfil(),
    );
  }
}

// Página Principal
class PaginaPerfil extends StatelessWidget {
  const PaginaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF315666), 
      
      // Configurações
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Color(0xFFE4F3FA)),
            onPressed: () {},
          ),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),     // Perfil e descrição
              _buildStatsRow(),   // Barra de row 
              const SizedBox(height: 20),
              
              // Escrita da habilidades, localização...
              _buildInfoSection("Habilidades", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"),
              _buildInfoSection("Localização", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"),
              _buildInfoSection("Empresa", "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      
      // BNBar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // Parte da foto de avatar, nome e icons de redes sociais
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFD9CCFF),
                child: Icon(Icons.person, size: 60, color: Color(0xFF7B61FF)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Usuário", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFE4F3FA))),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4B88A2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Descrição do Usuário", style: TextStyle(fontSize: 18, color: Color(0xFFE4F3FA))),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Redes sociais
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.facebook, color: Color(0xFFE4F3FA),), Icon(Icons.telegram, color: Color(0xFFE4F3FA)), Icon(Icons.email, color: Color(0xFFE4F3FA)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Row dos seguidores, seguindo e postagens
  Widget _buildStatsRow() {
    return Container(
      color: const Color(0xFFA0C1D1), // retangulinho dos numeros e titulo
      padding: const EdgeInsets.symmetric(vertical: 15,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard("Seguidores", "14"),
          _buildStatCard("Seguindo", "30"),
          _buildStatCard("Postagens", "6"),
        ],
      ),
    );
  }

  // Cards
  Widget _buildStatCard(String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF4B88A2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFE4F3FA))),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE4F3FA))),
        ],
      ),
    );
  }

  // Cards do body
  Widget _buildInfoSection(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4B88A2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE4F3FA))),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFFF2FBFF),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Text(texto),
          ),
        ],
      ),
    );
  }

  // BNBar
  Widget _buildBottomNav() {
    return Container(
      height: 60,
      color: const Color(0xFFE4F3FA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.arrow_circle_left_outlined, color: Color(0xFFA0C1D1), size: 40), onPressed: () {}),
          IconButton(icon: const Icon(Icons.home_outlined, size: 40), color: Color(0xFFA0C1D1), onPressed: () {}),
          IconButton(icon: const Icon(Icons.arrow_circle_right_outlined, size: 40), color: Color(0xFFA0C1D1), onPressed: () {}),
        ],
      ),
    );
  }
}

