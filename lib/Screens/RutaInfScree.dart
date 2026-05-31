/*import 'package:flutter/material.dart';

class RutaInfScreen extends StatelessWidget {
  const RutaInfScreen({
    super.key,
    required this.name,
    required this.place,
    required this.imageUrl,
    required this.subtitle,
  });

  final String name;
  final String place;
  final String imageUrl;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                child: Image.network(
                  imageUrl,
                  height: size.height * 0.4,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 45,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.directions_bus, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            place,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  const Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Tiempo estimado: 15 - 25 min"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Paradas principales cercanas"),
                    ],
                  ),

                  const SizedBox(height: 12),

                  const Row(
                    children: [
                      Icon(Icons.payments_outlined, color: Colors.orange),
                      SizedBox(width: 8),
                      Text("Costo aproximado: \$10 MXN"),
                    ],
                  ),

                  const SizedBox(height: 25),
                  /*
                  const Text(
                    "Paradas de ejemplo",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  const ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Parada Centro"),
                    subtitle: Text("A 5 minutos aproximadamente"),
                  ),

                  const ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Parada Tecnológico"),
                    subtitle: Text("A 12 minutos aproximadamente"),
                  ),

                  const ListTile(
                    leading: Icon(Icons.directions_bus),
                    title: Text("Parada Mercado"),
                    subtitle: Text("A 18 minutos aproximadamente"),
                  ),
*/
                  const Spacer(),

                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.report_problem_outlined,
                          size: 30,
                          color: Colors.orange,
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text("Tomar esta ruta"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/
