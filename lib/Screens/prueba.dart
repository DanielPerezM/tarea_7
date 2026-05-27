import 'package:flutter/material.dart';
import 'package:local_hero_transform/local_hero_transform.dart';

void main() {
  runApp(const Prueba());
}

class Prueba extends StatelessWidget {
  const Prueba({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
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
    return Scaffold(appBar: _buildAppBar(context), body: _buildBody());
  }

  Widget _buildBody() {
    return LocalHeroViews(
      tabController: _tabController,
      onPressedCard: _handleCardPressed,
      textDirection: TextDirection.ltr,
      itemCount: locations.length,
      itemsModel: _buildItemsModel,
    );
  }

  void _handleCardPressed(int index) {
    final location = locations[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DetailsScreen(name: location.name, imageUrl: location.imageUrl),
      ),
    );
  }

  ItemsModel _buildItemsModel(int index) {
    final location = locations[index];
    final textTheme = _buildTextTheme();

    return ItemsModel(
      favoriteIconButton: const SizedBox.shrink(),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
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
        child: AspectRatio(
          aspectRatio: 1.9 / 2,
          child: RawMaterialButton(
            onPressed: _toggleView,
            elevation: 0,
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            shape: _buttonShape,
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
      ),
    );
  }

  final _buttonShape = RoundedRectangleBorder(
    side: const BorderSide(color: Colors.black, width: 0.2),
    borderRadius: BorderRadius.circular(5),
  );

  void _toggleView() {
    final newIndex = _tabController.index == 0 ? 1 : 0;
    _tabController.animateTo(newIndex);
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

enum FavoriteShape { grid, list }

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.name, required this.imageUrl});

  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 14,
          child: Image.network(imageUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
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
