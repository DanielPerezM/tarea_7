import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_hero_transform/local_hero_transform.dart';
import 'package:tarea_7/Screens/RutasInfScreen.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart';

class SearchS extends StatefulWidget {
  const SearchS({super.key});

  @override
  State<SearchS> createState() => _SearchSState();
}

class _SearchSState extends State<SearchS> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late final TabController _tabController;
  late final ValueNotifier<FavoriteShape> _viewModeNotifier;

  bool isLoading = false;
  bool hasSearched = false;

  List<ParadaModel> paradasUsuario = [];
  List<ParadaModel> paradasDestino = [];

  static const double maxDistanceMeters = 1000;

  @override
  void initState() {
    super.initState();

    _viewModeNotifier = ValueNotifier(FavoriteShape.grid);

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _viewModeNotifier.value = _tabController.index == 0
          ? FavoriteShape.grid
          : FavoriteShape.list;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();

    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();

    _viewModeNotifier.dispose();

    super.dispose();
  }

  Future<void> buscarDestino() async {
    final destino = _searchController.text.trim();

    if (destino.isEmpty) {
      _showMessage('Ingresa un destino');
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      paradasUsuario = [];
      paradasDestino = [];
    });

    try {
      final userPosition = await _getUserLocation();

      final destinationLocations = await locationFromAddress(destino);

      if (destinationLocations.isEmpty) {
        _showMessage('No se encontró el destino');
        setState(() => isLoading = false);
        return;
      }

      final destinoLat = destinationLocations.first.latitude;
      final destinoLng = destinationLocations.first.longitude;

      final snapshot = await FirebaseFirestore.instance
          .collection('ParadasC')
          .get();

      final todasParadas = snapshot.docs.map((doc) {
        final data = doc.data();

        final lat = (data['coord1P'] ?? 0).toDouble();
        final lng = (data['coord2P'] ?? 0).toDouble();

        final distanciaUsuario = Geolocator.distanceBetween(
          userPosition.latitude,
          userPosition.longitude,
          lat,
          lng,
        );

        final distanciaDestino = Geolocator.distanceBetween(
          destinoLat,
          destinoLng,
          lat,
          lng,
        );

        return ParadaModel(
          id: doc.id,
          nombreP: data['nombreP'] ?? '',
          direccionP: data['direccionP'] ?? '',
          fotoP: data['fotoP'] ?? '',
          coord1P: lat,
          coord2P: lng,
          rutasAsociadasP: List<String>.from(data['rutasAsociadasP'] ?? []),
          distanciaUsuario: distanciaUsuario,
          distanciaDestino: distanciaDestino,
        );
      }).toList();

      final cercanasUsuario =
          todasParadas
              .where((p) => p.distanciaUsuario <= maxDistanceMeters)
              .toList()
            ..sort((a, b) => a.distanciaUsuario.compareTo(b.distanciaUsuario));

      final cercanasDestino =
          todasParadas
              .where((p) => p.distanciaDestino <= maxDistanceMeters)
              .toList()
            ..sort((a, b) => a.distanciaDestino.compareTo(b.distanciaDestino));

      final rutasDestino = <String>{};

      for (final paradaDestino in cercanasDestino) {
        rutasDestino.addAll(paradaDestino.rutasAsociadasP);
      }

      final paradasUsuarioConRuta = cercanasUsuario.where((paradaUsuario) {
        final rutasUsuario = paradaUsuario.rutasAsociadasP.toSet();
        final rutasCoincidentes = rutasUsuario.intersection(rutasDestino);

        return rutasCoincidentes.isNotEmpty;
      }).toList();

      setState(() {
        paradasUsuario = paradasUsuarioConRuta;
        paradasDestino = cercanasDestino;
        isLoading = false;
      });

      if (paradasUsuarioConRuta.isEmpty) {
        _showMessage(
          'No se encontraron paradas cercanas con rutas directas hacia tu destino',
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showMessage('Error: $e');
    }
  }

  Future<Position> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw 'Activa la ubicación del dispositivo';
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw 'Permiso de ubicación denegado';
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Permiso denegado permanentemente';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  List<String> obtenerRutasRecomendadas(ParadaModel paradaUsuario) {
    final rutasDestino = <String>{};

    for (final paradaDestino in paradasDestino) {
      rutasDestino.addAll(paradaDestino.rutasAsociadasP);
    }

    final rutasUsuario = paradaUsuario.rutasAsociadasP.toSet();

    return rutasUsuario.intersection(rutasDestino).toList();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  ItemsModel _buildItemsModel(BuildContext context, ParadaModel parada) {
    final textTheme = _buildTextTheme();

    return ItemsModel(
      cardStyleMode: CardStyleMode(isDarkMode: false, isLoading: false),
      loadingImageBuilder: (context, child, loadingProgress) {
        return const CustomShimmer(isDark: false);
      },
      image: DecorationImage(
        image: CachedNetworkImageProvider(parada.fotoP),
        fit: BoxFit.cover,
      ),
      name: Text(parada.nombreP, style: textTheme.name),
      title: Text(
        '${(parada.distanciaUsuario / 1000).toStringAsFixed(2)} km de ti',
        style: textTheme.title,
      ),
      subTitle: Text(parada.direccionP, style: textTheme.subTitle),
      subTitleIcon: Icon(
        Icons.location_on_outlined,
        color: AppColors.subtitleColor,
        size: MediaQuery.sizeOf(context).width * 0.03,
      ),
      favoriteIconButton: const SizedBox.shrink(),
    );
  }

  _TextTheme _buildTextTheme() {
    return const _TextTheme(
      name: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      title: TextStyle(
        color: Colors.blue,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      subTitle: TextStyle(
        color: AppColors.subtitleColor,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: const Text(
        'Buscar destino',
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildViewToggleButton(),
        ),
      ],
    );
  }

  Widget _buildViewToggleButton() {
    return ValueListenableBuilder<FavoriteShape>(
      valueListenable: _viewModeNotifier,
      builder: (context, value, _) => ConstrainedBox(
        constraints: BoxConstraints.tight(Size(35, 35)),
        child: RawMaterialButton(
          onPressed: _toggleView,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: Colors.blue,
          child: Icon(
            value == FavoriteShape.grid
                ? Icons.grid_view_rounded
                : Icons.view_agenda_outlined,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _toggleView() {
    final newIndex = _tabController.index == 0 ? 1 : 0;
    _tabController.animateTo(newIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => buscarDestino(),
              decoration: InputDecoration(
                hintText: 'Buscar destino...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: buscarDestino,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : !hasSearched
                ? const Center(
                    child: Text(
                      'Busca un destino para ver paradas cercanas',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : paradasUsuario.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No se encontraron paradas a menos de 1 km de tu ubicación.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : LocalHeroViews(
                    tabController: _tabController,
                    onPressedCard: (index) {
                      final parada = paradasUsuario[index];
                      final rutasRecomendadas = obtenerRutasRecomendadas(
                        parada,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ParadaDetailScreen(
                            parada: parada,
                            rutasRecomendadas: rutasRecomendadas,
                          ),
                        ),
                      );
                    },
                    textDirection: TextDirection.ltr,
                    itemCount: paradasUsuario.length,
                    itemsModel: (index) {
                      return _buildItemsModel(context, paradasUsuario[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ParadaDetailScreen extends StatelessWidget {
  final ParadaModel parada;
  final List<String> rutasRecomendadas;

  const ParadaDetailScreen({
    super.key,
    required this.parada,
    required this.rutasRecomendadas,
  });

  Future<List<String>> obtenerNombresRutas() async {
    final nombres = <String>[];

    for (final routeId in rutasRecomendadas) {
      final doc = await FirebaseFirestore.instance
          .collection('Rutas')
          .doc(routeId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final nombre = data['nombreR'] ?? '';
        final numero = data['numR'] ?? '';

        if (numero.toString().isNotEmpty) {
          nombres.add('$nombre - Ruta $numero');
        } else {
          nombres.add(nombre);
        }
      }
    }

    return nombres;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
                child: parada.fotoP.isEmpty
                    ? Container(
                        height: size.height * 0.4,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.location_on,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: parada.fotoP,
                        height: size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: size.height * 0.4,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: size.height * 0.4,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.location_on,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                      ),
              ),

              Positioned(
                top: 45,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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
                        child: Icon(Icons.location_on, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          parada.nombreP,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    parada.nombreP,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    parada.direccionP,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  _InfoRow(
                    icon: Icons.my_location,
                    text:
                        'Distancia desde tu ubicación: ${(parada.distanciaUsuario / 1000).toStringAsFixed(2)} km',
                  ),

                  _InfoRow(
                    icon: Icons.place,
                    text:
                        'Distancia al destino: ${(parada.distanciaDestino / 1000).toStringAsFixed(2)} km',
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Rutas recomendadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  FutureBuilder<List<String>>(
                    future: obtenerNombresRutas(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('Cargando rutas recomendadas...');
                      }

                      final nombres = snapshot.data!;

                      if (nombres.isEmpty) {
                        return const Text(
                          'No se encontraron rutas directas para este destino.',
                        );
                      }

                      return Text(
                        nombres.join(', '),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  if (rutasRecomendadas.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                RutasInfS(routeIdsFilter: rutasRecomendadas),
                          ),
                        );
                      },
                      child: Text(
                        'Conoce más de estas rutas',
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParadaModel {
  final String id;
  final String nombreP;
  final String direccionP;
  final String fotoP;
  final double coord1P;
  final double coord2P;
  final List<String> rutasAsociadasP;
  final double distanciaUsuario;
  final double distanciaDestino;

  ParadaModel({
    required this.id,
    required this.nombreP,
    required this.direccionP,
    required this.fotoP,
    required this.coord1P,
    required this.coord2P,
    required this.rutasAsociadasP,
    required this.distanciaUsuario,
    required this.distanciaDestino,
  });
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _TextTheme {
  final TextStyle name;
  final TextStyle title;
  final TextStyle subTitle;

  const _TextTheme({
    required this.name,
    required this.title,
    required this.subTitle,
  });
}

class AppColors {
  static const backgroundColor = Color(0xFFF2F3F8);
  static const subtitleColor = Color(0xFF95979A);
}
