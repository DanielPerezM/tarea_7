import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_7/auth/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OnBoardingS extends StatefulWidget {
  const OnBoardingS({super.key});

  @override
  State<OnBoardingS> createState() => _OnBoardingSState();
}

class _OnBoardingSState extends State<OnBoardingS> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Future<void> _finishOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnBoarding', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Authenticate()),
    );
  }

  Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 130, color: Colors.orange.shade900);
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: const TextStyle(fontSize: 17, color: Colors.black54),
      bodyPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      pageColor: const Color(0xFFF2F3F8),
      imagePadding: const EdgeInsets.only(top: 60),
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: const Color(0xFFF2F3F8),
      pages: [
        PageViewModel(
          title: 'Conoce tus rutas',
          image: _buildGif(
            'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/onBoarding/camionAnimation1.gif',
            context,
          ),
          body:
              'Consulta la información de las rutas que puedes tomar en Celaya',
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Estaciones',
          body: 'Conoce dónde puedes abordar o bajar',
          image: _buildGif(
            'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/onBoarding/paradas.gif',
            context,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Centros de recarga',
          body: 'Encuentra donde recargar tu tarjeta SIBE',
          image: imagenSINcache(
            'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/onBoarding/CentroRecarga.gif',
            context,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: _finishOnBoarding,
      onSkip: _finishOnBoarding,
      showSkipButton: true,
      skip: const Text(
        'Saltar',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
      ),
      next: const Icon(Icons.arrow_forward, size: 35),
      done: const Text(
        'Comenzar',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      dotsDecorator: DotsDecorator(
        size: const Size(24, 24),
        color: Colors.grey.shade400,
        activeColor: Colors.orange.shade900,
        activeSize: const Size(24, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  Widget _buildGif(String url, BuildContext context) {
    final size = MediaQuery.of(context).size;

    final circleSize = size.height * 0.33; // 1/3 de la altura

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade200,
            child: Icon(
              Icons.image_not_supported,
              size: circleSize * 0.25,
              color: Colors.orange.shade900,
            ),
          ),
        ),
      ),
    );
  }

  Widget imagenSINcache(String url, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.height * 0.33;

    return Container(
      width: circleSize,
      height: circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Container(
              color: Colors.grey.shade200,
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: Icon(
                Icons.image_not_supported,
                size: circleSize * 0.25,
                color: Colors.orange.shade900,
              ),
            );
          },
        ),
      ),
    );
  }
}
