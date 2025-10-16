import 'package:flutter/material.dart';

class ReflectiveBackground extends StatelessWidget {
  final Widget child;
  const ReflectiveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Fondo base
        Container(color: const Color(0xFF0F172A)),

        // Reflejo superior (según Figma)
        Positioned(
          left: -size.width * -0.1, // ≈ X:-114 relativo
          top: -size.height * 0.35, // ≈ Y:-69 relativo
          child: Transform.rotate(
            angle: 40 * 3.1416 / 180, // rotación exacta
            child: Container(
              width: size.width * 0.45, // 131.5 en base a pantalla promedio
              height: size.height * 0.8, // 482 px aprox
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.18), // capa superior visible
                    Colors.white.withOpacity(0.0005), // se disuelve hacia abajo
                  ],
                ),
              ),
            ),
          ),
        ),

        // Reflejo inferior (ajuste complementario para balance visual)
        Positioned(
          right: -size.width * 0.20,
          bottom: -size.height * 0.15,
          child: Transform.rotate(
            angle: 40 * 3.1416 / 180,
            child: Container(
              width: size.width * 0.45,
              height: size.height * 0.70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.0),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Contenido principal
        child,
      ],
    );
  }
}
