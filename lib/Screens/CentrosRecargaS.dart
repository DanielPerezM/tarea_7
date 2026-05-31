import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_hero_transform/local_hero_transform.dart';

class CentrosRecargasS extends StatefulWidget {
  const CentrosRecargasS({super.key});

  @override
  State<CentrosRecargasS> createState() => _CentrosRecargasSState();
}

class _CentrosRecargasSState extends State<CentrosRecargasS>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  late final TabController _tabController;
  late final ValueNotifier<bool> _isGridModeNotifier;

  bool isLoading = false;
  bool hasSearched = false;

  List<CentroRecargaModel> centros = [];

  static const double maxDistanceMeters = 1500;

  @override
  void initState() {
    super.initState();

    _isGridModeNotifier = ValueNotifier(true);

    _tabController = TabController(length: 2, vsync: this)
      ..addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _isGridModeNotifier.value = _tabController.index == 0;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    _isGridModeNotifier.dispose();
    super.dispose();
  }

  Future<void> buscarPorLugar() async {
    final lugar = _searchController.text.trim();

    if (lugar.isEmpty) {
      showMessage('Ingresa un lugar para buscar');
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
      centros = [];
    });

    try {
      final locations = await locationFromAddress(lugar);

      if (locations.isEmpty) {
        showMessage('No se encontró el lugar');
        setState(() => isLoading = false);
        return;
      }

      final lat = locations.first.latitude;
      final lng = locations.first.longitude;
      print('===== BÚSQUEDA POR LUGAR =====');
      print('Lugar buscado: $lugar');
      print('Lat destino: $lat');
      print('Lng destino: $lng');

      await cargarCentrosCercanos(lat, lng);
    } catch (e) {
      setState(() => isLoading = false);
      showMessage('Error: $e');
    }
  }

  Future<void> buscarCercaDeMi() async {
    setState(() {
      isLoading = true;
      hasSearched = true;
      centros = [];
    });

    try {
      final position = await obtenerUbicacionActual();
      print('===== BÚSQUEDA CERCA DE MI =====');
      print('Mi latitud: ${position.latitude}');
      print('Mi longitud: ${position.longitude}');

      await cargarCentrosCercanos(position.latitude, position.longitude);
    } catch (e) {
      setState(() => isLoading = false);
      showMessage('Error: $e');
    }
  }

  Future<void> cargarCentrosCercanos(double latBase, double lngBase) async {
    print('===== CARGANDO CENTROS =====');
    print('Lat base: $latBase');
    print('Lng base: $lngBase');

    final snapshot = await FirebaseFirestore.instance
        .collection('centrosRecarga')
        .get();

    print('Documentos encontrados en Firestore: ${snapshot.docs.length}');

    final resultados =
        snapshot.docs
            .map((doc) {
              final data = doc.data();

              final lat = (data['coord1CR'] ?? 0).toDouble();
              final lng = (data['coord2CR'] ?? 0).toDouble();

              final distancia = Geolocator.distanceBetween(
                latBase,
                lngBase,
                lat,
                lng,
              );

              print('---------------------------');
              print('ID centro: ${doc.id}');
              print('Nombre: ${data['nombreCR']}');
              print('Lat centro: $lat');
              print('Lng centro: $lng');
              print('Distancia metros: $distancia');
              print('Foto: ${data['fotoCR']}');

              return CentroRecargaModel(
                id: doc.id,
                nombreCR: data['nombreCR'] ?? '',
                direccionCR: data['direccionCR'] ?? '',
                fotoCR: data['fotoCR'] ?? '',
                coord1CR: lat,
                coord2CR: lng,
                horarioCR: data['horarioCR'] ?? '',
                calfCR: (data['calfCR'] ?? 0).toDouble(),
                comentariosCR: List<String>.from(data['comentariosCR'] ?? []),
                distancia: distancia,
              );
            })
            .where((centro) {
              return centro.distancia <= maxDistanceMeters;
            })
            .toList()
          ..sort((a, b) => a.distancia.compareTo(b.distancia));

    print('Centros dentro de 1.5 km: ${resultados.length}');
    for (final centro in resultados) {
      print(
        '${centro.nombreCR} - ${(centro.distancia / 1000).toStringAsFixed(2)} km',
      );
    }

    setState(() {
      centros = resultados;
      isLoading = false;
    });

    if (resultados.isEmpty) {
      showMessage('No hay centros de recarga a menos de 1.5 km');
    }
  }

  Future<Position> obtenerUbicacionActual() async {
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
      throw 'Permiso de ubicación denegado permanentemente';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(text, textAlign: TextAlign.center)));
  }

  ItemsModel _buildItemsModel(BuildContext context, CentroRecargaModel centro) {
    final textTheme = _buildTextTheme();

    return ItemsModel(
      cardStyleMode: CardStyleMode(isDarkMode: false, isLoading: false),
      loadingImageBuilder: (context, child, loadingProgress) {
        return const CustomShimmer(isDark: false);
      },
      image: DecorationImage(
        image: centro.fotoCR.isEmpty
            ? const AssetImage('assets/images/no_image.png')
            : CachedNetworkImageProvider(centro.fotoCR) as ImageProvider,
        fit: BoxFit.cover,
      ),
      name: Text(centro.nombreCR, style: textTheme.name),
      title: Text(
        '${(centro.distancia / 1000).toStringAsFixed(2)} km',
        style: textTheme.title,
      ),
      subTitle: Text(centro.direccionCR, style: textTheme.subTitle),
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

  Widget _buildViewToggleButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isGridModeNotifier,
      builder: (context, isGridMode, _) => ConstrainedBox(
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
            isGridMode ? Icons.grid_view_rounded : Icons.view_agenda_outlined,
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
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        title: const Text(
          'Centros de recarga',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildViewToggleButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => buscarPorLugar(),
              decoration: InputDecoration(
                hintText: 'Buscar lugar...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: buscarPorLugar,
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: buscarCercaDeMi,
                icon: const Icon(Icons.my_location),
                label: const Text('Cerca de ti'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : !hasSearched
                ? const Center(
                    child: Text(
                      'Busca un lugar o usa "Cerca de ti"',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : centros.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No se encontraron centros de recarga cercanos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : LocalHeroViews(
                    tabController: _tabController,
                    onPressedCard: (index) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CentroRecargaDetailS(centro: centros[index]),
                        ),
                      );
                    },
                    textDirection: TextDirection.ltr,
                    itemCount: centros.length,
                    itemsModel: (index) {
                      return _buildItemsModel(context, centros[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CentroRecargaDetailS extends StatelessWidget {
  final CentroRecargaModel centro;

  const CentroRecargaDetailS({super.key, required this.centro});

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
                child: centro.fotoCR.isEmpty
                    ? Container(
                        height: size.height * 0.4,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.account_balance_wallet,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: centro.fotoCR,
                        height: size.height * 0.4,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: size.height * 0.4,
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: size.height * 0.4,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.image_not_supported,
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
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          centro.nombreCR,
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
                    centro.nombreCR,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: centro.direccionCR,
                  ),

                  _InfoRow(icon: Icons.schedule, text: centro.horarioCR),

                  _InfoRow(
                    icon: Icons.star,
                    text: 'Calificación: ${centro.calfCR}',
                  ),

                  _InfoRow(
                    icon: Icons.route,
                    text:
                        'Distancia aproximada: ${(centro.distancia / 1000).toStringAsFixed(2)} km',
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Comentarios',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  if (centro.comentariosCR.isEmpty)
                    const Text('Sin comentarios disponibles')
                  else
                    ...centro.comentariosCR.map(
                      (comentario) => Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: const Icon(Icons.comment),
                          title: Text(comentario),
                        ),
                      ),
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

class CentroRecargaModel {
  final String id;
  final String nombreCR;
  final String direccionCR;
  final String fotoCR;
  final double coord1CR;
  final double coord2CR;
  final String horarioCR;
  final double calfCR;
  final List<String> comentariosCR;
  final double distancia;

  CentroRecargaModel({
    required this.id,
    required this.nombreCR,
    required this.direccionCR,
    required this.fotoCR,
    required this.coord1CR,
    required this.coord2CR,
    required this.horarioCR,
    required this.calfCR,
    required this.comentariosCR,
    required this.distancia,
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
