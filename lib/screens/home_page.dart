import 'package:flutter/material.dart';
import 'package:kicknplay_app/pages/mi_cuenta_page.dart';
import '../pages/eventos_page.dart';
import '../pages/canchas_page.dart';
import '../pages/map_page.dart';
import '../pages/reservas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // Pantallas para el BottomNavigationBar
  final List<Widget> _screens = [
    HomeContent(), // Pantalla de Inicio mejorada
    MapPage(),
    ReservasPage(),
    CanchasPage(),
    EventosPage(),
    MiCuentaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KicknPlay'),
        backgroundColor: Color(0xFF0077FF), // Azul para consistencia visual
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Reservas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: 'Canchas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Eventos'), // Nuevo ítem para Eventos
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Mi Cuenta'), // Nuevo ítem para Mi Cuenta
        ],
        selectedItemColor: Color(0xFF0077FF), // Azul
        unselectedItemColor: Color(0xFF333333), // Gris oscuro
        backgroundColor: Colors.white, // Fondo blanco
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de Bienvenida
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/k&plogo.jpg',
                  width: 150,
                  height: 150,
                ),
                SizedBox(height: 10),
                Text(
                  _getDynamicGreeting(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0077FF), // Azul
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Estadísticas
          _buildSectionTitle('Tus Estadísticas', Color(0xFF0077FF)),
          _buildCard(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: 0.75, // 75% de progreso
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0077FF)),
                ),
                SizedBox(height: 10),
                Text(
                  '75% de tus reservas completadas esta semana.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Promociones Activas
          _buildSectionTitle('Promociones Activas', Color(0xFFFF8C00)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0077FF), Color(0xFFFF8C00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Reserva 2 canchas y obtén un 20% de descuento!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Búsqueda Rápida
          _buildSectionTitle('Busca una cancha', Color(0xFF0077FF)),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre o ubicación',
              prefixIcon: Icon(Icons.search, color: Color(0xFFFF8C00)),
              suffixIcon:
                  Icon(Icons.filter_alt_outlined, color: Color(0xFF0077FF)),
            ),
          ),
          SizedBox(height: 24),

          // Próximos Torneos
          _buildSectionTitle('Próximos Torneos', Color(0xFF0077FF)),
          _buildCard(
            context,
            ListTile(
              title: Text(
                'Torneo de Verano - 15 de Junio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Ubicación: Central Park'),
              trailing: ElevatedButton(
                onPressed: () {
                  // Lógica para inscribirse
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0077FF),
                  foregroundColor: Colors.white,
                ),
                child: Text('Inscribirse'),
              ),
            ),
          ),
          SizedBox(height: 24),

          // Opiniones de Usuarios
          _buildSectionTitle('Opiniones de Usuarios', Color(0xFFFF8C00)),
          _buildCard(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      color: Color(0xFFFF8C00),
                    );
                  }),
                ),
                SizedBox(height: 10),
                Text(
                  '“Excelente experiencia, muy fácil de usar!”',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método para generar un título de sección
  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style:
            TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  // Método para generar una tarjeta
  Widget _buildCard(BuildContext context, Widget child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  // Saludo dinámico según la hora del día
  static String _getDynamicGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '¡Buenos días! ¿Listo para jugar?';
    if (hour < 18) return '¡Buenas tardes! ¿Preparado para un partido?';
    return '¡Buenas noches! Relájate y organiza un juego';
  }
}
