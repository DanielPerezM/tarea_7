import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_hero_transform/local_hero_transform.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart';

class RutasInfS extends StatefulWidget {
  final List<String>? routeIdsFilter;

  const RutasInfS({super.key, this.routeIdsFilter});

  @override
  State<RutasInfS> createState() => _RutasInfSState();
}

class _RutasInfSState extends State<RutasInfS>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final ValueNotifier<FavoriteShape> _viewModeNotifier;

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
    _tabController
      ..removeListener(_handleTabChange)
      ..dispose();

    _viewModeNotifier.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rutasProvider = Provider.of<RutasProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: TextField(
              onChanged: rutasProvider.updateQuery,
              decoration: InputDecoration(
                hintText: 'Buscar por ruta o numero...',
                prefixIcon: const Icon(Icons.search),
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Rutas')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay rutas registradas',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                var rutas = snapshot.data!.docs.map((doc) {
                  return RutaModel.fromFirestore(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  );
                }).toList();

                if (widget.routeIdsFilter != null &&
                    widget.routeIdsFilter!.isNotEmpty) {
                  rutas = rutas.where((ruta) {
                    return widget.routeIdsFilter!.contains(ruta.id);
                  }).toList();
                }

                final filteredRutas = rutas.where((ruta) {
                  final query = rutasProvider.query.toLowerCase();

                  return ruta.nombreR.toLowerCase().contains(query) ||
                      ruta.numR.toLowerCase().contains(query);
                }).toList();

                if (filteredRutas.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron rutas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return LocalHeroViews(
                  tabController: _tabController,
                  onPressedCard: (index) {
                    final ruta = filteredRutas[index];

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(ruta: ruta),
                      ),
                    );
                  },
                  textDirection: TextDirection.ltr,
                  itemCount: filteredRutas.length,
                  itemsModel: (index) {
                    return _buildItemsModel(context, filteredRutas[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ItemsModel _buildItemsModel(BuildContext context, RutaModel ruta) {
    final textTheme = _buildTextTheme();

    return ItemsModel(
      cardStyleMode: CardStyleMode(isDarkMode: false, isLoading: false),
      loadingImageBuilder: (context, child, loadingProgress) {
        return const CustomShimmer(isDark: false);
      },

      image: DecorationImage(
        image: CachedNetworkImageProvider(ruta.fotoR),
        fit: BoxFit.cover,
      ),
      name: Text(ruta.nombreR, style: textTheme.name),
      title: Text(
        ruta.numR.isEmpty ? 'Sin número de ruta' : 'Ruta ${ruta.numR}',
        style: textTheme.title,
      ),
      subTitle: Text(''),
      subTitleIcon: const SizedBox.shrink(),
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      surfaceTintColor: AppColors.backgroundColor,
      title: const Text(
        'Rutas disponibles',
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
}

class DetailsScreen extends StatefulWidget {
  final RutaModel ruta;

  const DetailsScreen({super.key, required this.ruta});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool showMap = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final ruta = widget.ruta;

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
                child: widget.ruta.fotoR.isEmpty
                    ? Container(
                        height: size.height * 0.4,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.directions_bus,
                          size: 80,
                          color: Colors.grey,
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: ruta.fotoR,
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
                            Icons.directions_bus,
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
                        child: Icon(Icons.directions_bus, color: Colors.white),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.ruta.nombreR,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (widget.ruta.numR.isNotEmpty)
                              Text(
                                'Ruta ${widget.ruta.numR}',
                                style: const TextStyle(color: Colors.white),
                              ),
                          ],
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
                    widget.ruta.nombreR,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  if (ruta.numR.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade900,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Ruta ${widget.ruta.numR}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 10),

                  Text(
                    ruta.descripcionR,
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),

                  const SizedBox(height: 25),

                  _InfoRow(
                    icon: Icons.payments_rounded,
                    text: 'Efectivo: ${ruta.costoEfectivo}',
                  ),

                  _InfoRow(
                    icon: Icons.credit_card,
                    text: 'SIBE: \$${ruta.costoSibe}',
                  ),

                  _InfoRow(
                    icon: Icons.school,
                    text: 'SIBE preferencial: \$${ruta.costoSibePreferencial}',
                  ),

                  SizedBox(height: 25),

                  if (showMap) ...[
                    const Text(
                      'Mapa asociado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('Mapas')
                          .doc(widget.ruta.mapId)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (!snapshot.hasData || !snapshot.data!.exists) {
                          return const Text('No hay mapa disponible');
                        }

                        final data =
                            snapshot.data!.data() as Map<String, dynamic>;

                        final fotoM = data['fotoM'] ?? '';
                        final descripcionM = data['DescripcionM'] ?? '';

                        if (fotoM.isEmpty) {
                          return const Text('No hay imagen de mapa disponible');
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (descripcionM.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(descripcionM),
                              ),
                            Center(
                              child: SizedBox(
                                height: size.height * 0.5,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: CachedNetworkImage(
                                    imageUrl: fotoM,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.map_outlined,
                                          size: 70,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 25),
                  ],
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade900,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            setState(() {
                              showMap = !showMap;
                            });
                          },
                          icon: Icon(
                            showMap ? Icons.visibility_off : Icons.map_outlined,
                          ),
                          label: Text(
                            showMap ? 'Ocultar mapa' : 'Mostrar Mapa',
                          ),
                        ),
                      ),
                    ],
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

class RutaModel {
  final String id;
  final String nombreR;
  final String numR;
  final String descripcionR;
  final String fotoR;
  final double costoEfectivo;
  final double costoSibe;
  final double costoSibePreferencial;
  final String mapId;

  RutaModel({
    required this.id,
    required this.nombreR,
    required this.numR,
    required this.descripcionR,
    required this.fotoR,
    required this.costoEfectivo,
    required this.costoSibe,
    required this.costoSibePreferencial,
    required this.mapId,
  });

  factory RutaModel.fromFirestore(String id, Map<String, dynamic> data) {
    return RutaModel(
      id: id,
      nombreR: data['nombreR'] ?? '',
      numR: data['numR'] ?? '',
      descripcionR: data['descripcionR'] ?? '',
      fotoR: data['fotoR'] ?? '',
      costoEfectivo: (data['costoEfectivo'] ?? 0).toDouble(),
      costoSibe: (data['costoSibe'] ?? 0).toDouble(),
      costoSibePreferencial: (data['costoSibePreferencial'] ?? 0).toDouble(),
      mapId: data['mapId'] ?? '',
    );
  }
}
