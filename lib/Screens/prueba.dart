import 'package:flutter/material.dart';
import 'package:tarea_7/db.dart';

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Crear base de datos'),
          onPressed: () async {
            // await crearBD().crearDBFirebase();

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Base de datos creada correctamente'),
              ),
            );
          },
        ),
      ),
    );
  }
}
