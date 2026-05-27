import 'package:flutter/material.dart';
import 'package:local_hero_transform/local_hero_transform.dart';
import 'package:provider/provider.dart';
import 'package:tarea_7/Screens/prueba.dart';
import 'package:tarea_7/listeners/provider_searchRutas.dart' hide FavoriteShape;

class RutasInfS extends StatefulWidget {
  const RutasInfS({super.key});

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

    final filteredLocations = locations.where((location) {
      final name = location.name.toLowerCase();
      final place = location.place.toLowerCase();

      return name.contains(rutasProvider.query) ||
          place.contains(rutasProvider.query);
    }).toList();

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
                hintText: 'Buscar por ruta o lugar...',
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
            child: filteredLocations.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron rutas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : LocalHeroViews(
                    tabController: _tabController,
                    onPressedCard: (index) {
                      final location = filteredLocations[index];

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailsScreen(
                            name: location.name,
                            place: location.place,
                            imageUrl: location.imageUrl,
                            subtitle: location.subtitle,
                          ),
                        ),
                      );
                    },
                    textDirection: TextDirection.ltr,
                    itemCount: filteredLocations.length,
                    itemsModel: (index) {
                      return _buildItemsModel(
                        context,
                        filteredLocations[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  ItemsModel _buildItemsModel(BuildContext context, Location location) {
    final textTheme = _buildTextTheme();

    return ItemsModel(
      cardStyleMode: CardStyleMode(isDarkMode: false, isLoading: false),
      loadingImageBuilder: (context, child, loadingProgress) {
        return const CustomShimmer(isDark: false);
      },
      image: DecorationImage(
        image: NetworkImage(location.imageUrl),
        fit: BoxFit.cover,
      ),
      name: Text(location.name, style: textTheme.name),
      title: Text(location.place, style: textTheme.title),
      subTitle: Text(location.subtitle, style: textTheme.subTitle),
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

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
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
      backgroundColor: AppColors.backgroundColor,
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
              child: SingleChildScrollView(
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
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const _InfoRow(
                      icon: Icons.access_time,
                      text: "Tiempo estimado: 15 - 25 min",
                    ),

                    const _InfoRow(
                      icon: Icons.location_on,
                      text: "Paradas principales cercanas",
                    ),

                    const _InfoRow(
                      icon: Icons.payments_outlined,
                      text: "Costo aproximado: \$10 MXN",
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      "Paradas de ejemplo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

                    const SizedBox(height: 25),

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

                    const SizedBox(height: 25),
                  ],
                ),
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

class Location {
  final String name;
  final String place;
  final String imageUrl;
  final String subtitle;

  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
    required this.subtitle,
  });
}

const urlPrefix =
    'https://docs.flutter.dev/cookbook/img-files/effects/parallax';

const locations = [
  Location(
    name: 'Ruta Centro',
    place: 'Zona Centro',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
    subtitle: 'Ruta con paradas principales en el centro',
  ),
  Location(
    name: 'Ruta Tecnológico',
    place: 'Instituto Tecnológico',
    imageUrl: '$urlPrefix/02-singapore.jpg',
    subtitle: 'Conecta zonas escolares y avenidas principales',
  ),
  Location(
    name: 'Ruta Hospital',
    place: 'Zona Hospitalaria',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
    subtitle: 'Ideal para traslados a centros médicos',
  ),
  Location(
    name: 'Ruta Alameda',
    place: 'Alameda',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
    subtitle: 'Paradas cercanas a parques y comercios',
  ),
  Location(
    name: 'Ruta Universidad',
    place: 'Zona Universitaria',
    imageUrl: '$urlPrefix/05-bali.jpg',
    subtitle: 'Ruta recomendada para estudiantes',
  ),
  Location(
    name: 'Ruta Mercado',
    place: 'Mercado Principal',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
    subtitle: 'Acceso a zona comercial y transporte local',
  ),
];
