import 'package:cloud_firestore/cloud_firestore.dart';

class crearBD {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> crearDBFirebase() async {
    await crearMapas();
    await crearRutas();
    await crearParadas();
    await crearCentrosRecarga();

    await _db.collection('membresias').doc('basico').set({
      'nombre': 'Plan Básico',
      'price': 49,
      'descripcion': 'Descripción membresía 1',
    });

    await _db.collection('membresias').doc('plus').set({
      'nombre': 'Plan Plus',
      'price': 99,
      'descripcion': 'Descripcion membresia plus',
    });

    await _db.collection('membresias').doc('premium').set({
      'nombre': 'Plan Premium',
      'price': 149,
      'descripcion': 'Descripción plan premium',
    });
  }

  Future<void> crearMapas() async {
    await _db.collection('Mapas').doc('MapaPinos').set({
      'fotoM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRuta60.jpg',
      'DescripcionM': 'Ruta 60',
    });
    await _db.collection('Mapas').doc('MapaLatino2').set({
      'fotoM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRuta45.jpg',
      'DescripcionM': 'Ruta',
    });
    await _db.collection('Mapas').doc('MapaRuta63').set({
      'fotoM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRuta63.jpg',
      'DescripcionM': '',
    });
    await _db.collection('Mapas').doc('MapaGober1').set({
      'fotoM': '',
      'DescripcionM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRutaGobers.jpg',
    });
    await _db.collection('Mapas').doc('MapaGober2').set({
      'fotoM': '',
      'DescripcionM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRutaGobers.jpg',
    });

    await _db.collection('Mapas').doc('MapaMteBlancoE').set({
      'fotoM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRutaMteBlanco.png',
      'DescripcionM': '',
    });

    await _db.collection('Mapas').doc('MapaMteBlancoC').set({
      'fotoM':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/MapasRuta/MapaRutaMteBlanco.png',
      'DescripcionM': '',
    });
  }

  Future<void> crearRutas() async {
    await _db.collection('Rutas').doc('ruta60').set({
      'nombreR': 'Pinos',
      'numR': '60',
      'descripcionR': 'Descripcion ruta 60-pinos',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/Ruta60.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaPinos',
    });

    await _db.collection('Rutas').doc('ruta45').set({
      'nombreR': 'Latino 2',
      'numR': '45',
      'descripcionR': 'Descripcion ruta 45-Latino 2',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/Ruta45.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaLatino2',
    });

    await _db.collection('Rutas').doc('ruta63').set({
      'nombreR': 'Ruta 63',
      'numR': '63',
      'descripcionR': 'Descripcion ruta 63',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/Ruta60.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaRuta63',
    });

    await _db.collection('Rutas').doc('rutaGober1').set({
      'nombreR': 'Ruta Gobernadores irrigación',
      'numR': '',
      'descripcionR': 'Descripcion ruta Gobernadores irrigación',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/Ruta45.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaGober1',
    });

    await _db.collection('Rutas').doc('rutaGober2').set({
      'nombreR': 'Ruta Gobernadores 16 de septiembre',
      'numR': '',
      'descripcionR': 'Descripcion ruta Gobernadores 16 de septiembre',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/Ruta45.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaGober2',
    });

    await _db.collection('Rutas').doc('rutaMteBlancoE').set({
      'nombreR': 'Ruta MonteBlanco por eje',
      'numR': '',
      'descripcionR': 'Descripcion ruta Ruta MonteBlanco por eje',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/RutaMteBlanco.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaMteBlancoE',
    });

    await _db.collection('Rutas').doc('rutaMteBlancoC').set({
      'nombreR': 'Ruta MonteBlanco por curva',
      'numR': '',
      'descripcionR': 'Ruta MonteBlanco por curva',
      'fotoR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Rutas/RutaMteBlanco.jpg',
      'costoEfectivo': 11,
      'costoSibe': 9,
      'costoSibePreferencial': 6.5,
      'mapId': 'MapaMteBlancoC',
    });
  }

  Future<void> crearParadas() async {
    await _db.collection('ParadasC').doc('Parada1').set({
      'nombreP': 'Parada 1',
      'direccionP': 'Av. Mexico Japón frente a farmacioa ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaFarmacia.png',
      'coord1P': 20.544202,
      'coord2P': -100.779815,
      'rutasAsociadasP': ['ruta60', 'ruta45', 'rutaMteBlancoC'],
    });

    await _db.collection('ParadasC').doc('Parada2').set({
      'nombreP': 'Parada 1',
      'direccionP': 'Av. Mexico Japón frente a parque celaya ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaFrenteParqueCelaya.png',
      'coord1P': 20.548809,
      'coord2P': -100.840836,
      'rutasAsociadasP': ['ruta60', 'ruta45'],
    });

    await _db.collection('ParadasC').doc('Parada3').set({
      'nombreP': 'Parada 3',
      'direccionP': 'Av. Mexico Japón cruzando avenida ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaArbol.png',
      'coord1P': 20.543659,
      'coord2P': -100.780367,
      'rutasAsociadasP': [
        'ruta60',
        'rutaGober1',
        'rutaGober2',
        'rutaMteBlancoE',
      ],
    });

    await _db.collection('ParadasC').doc('Parada4').set({
      'nombreP': 'Parada 4',
      'direccionP': 'Frente a galerías celaya ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaGalerias.png',
      'coord1P': 20.532915,
      'coord2P': -100.777106,
      'rutasAsociadasP': ['ruta60'],
      //https://www.google.com/maps/@20.5332408,-100.7771441,3a,75y,239.11h,81.58t/data=!3m7!1e1!3m5!1sD5yIBl5w33-WiAue1UHBAg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D8.4233644524153%26panoid%3DD5yIBl5w33-WiAue1UHBAg%26yaw%3D239.1092964822063!7i16384!8i8192?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    await _db.collection('ParadasC').doc('Parada5').set({
      'nombreP': 'Parada 5',
      'direccionP': 'Frente a hotel ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/Parahotel.png',
      'coord1P': 20.533173,
      'coord2P': -100.776648,
      'rutasAsociadasP': ['ruta60', 'ruta63'],
      //https://www.google.com/maps/@20.5331111,-100.7767824,3a,75y,68.3h,89.28t/data=!3m7!1e1!3m5!1sjQUZtRO4WVUvzlv7mkQ2Dg!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D0.7228776411939748%26panoid%3DjQUZtRO4WVUvzlv7mkQ2Dg%26yaw%3D68.30464352355564!7i16384!8i8192?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    await _db.collection('ParadasC').doc('Parada6').set({
      'nombreP': 'Parada 6',
      'direccionP': 'Av. irrigación, cruzando ',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaIrrigacion.png',
      'coord1P': 20.536610,
      'coord2P': -100.786504,
      'rutasAsociadasP': ['ruta63', 'rutaMteBlancoE'],
    });

    await _db.collection('ParadasC').doc('Parada7').set({
      'nombreP': 'Parada 7',
      'direccionP': 'Frente a farmacias similares',
      'fotoP':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/Paradas/ParadaSimi.png',
      'coord1P': 20.536256,
      'coord2P': -100.786155,
      'rutasAsociadasP': ['ruta63', 'rutaMteBlancoE'],
      //https://www.google.com/maps/place/Farmacias+Similares/@20.5362704,-100.786168,3a,75y,146.82h,80.47t/data=!3m7!1e1!3m5!1sGbkW_KJuuAQVWDuX7E6nAw!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D9.531780235277921%26panoid%3DGbkW_KJuuAQVWDuX7E6nAw%26yaw%3D146.8184342556844!7i13312!8i6656!4m6!3m5!1s0x842cb10015c11359:0xab5e444aaf414f00!8m2!3d20.5362306!4d-100.7860459!16s%2Fg%2F11y_rx0wh9?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    /*await _db.collection('ParadasC').doc('Parada1').set({
      'nombreP': 'Parada 1',
      'direccionP': 'Av. Mexico Japón frente a farmacioa ',
      'fotoP': '',
      'coord1P': 20.5221,
      'coord2P': -100.8123,
      'rutasAsociadasP': ['ruta60'],
    });*/
  }

  Future<void> crearCentrosRecarga() async {
    await _db.collection('centrosRecarga').doc('crPresidencia').set({
      'nombreCR': 'Anexo presidencia',
      'direccionCR': 'frente a jardin principal',
      'fotoCR':
          'https://gdsnuhnhbqwhpsaaeovq.supabase.co/storage/v1/object/public/Fotos/CentrosRecarga/centroRecargaPresidencia.png',
      'coord1CR': 20.521666,
      'coord2CR': -100.813719,
      'horarioCR': '8:00 AM - 5:00 PM',
      'calfCR': 4.7,
      'comentariosCR': ['Atienden rápido', 'Buena ubicación'],
      //https://www.google.com/maps/place/Jard%C3%ADn+Principal+Celaya/@20.5216676,-100.8136196,3a,75y,97.04h,85.13t/data=!3m7!1e1!3m5!1stTbmOCzn1aG0naXhjZOySA!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D4.870817019128594%26panoid%3DtTbmOCzn1aG0naXhjZOySA%26yaw%3D97.03852949902812!7i16384!8i8192!4m6!3m5!1s0x842cba88d53e3bd5:0xb1d834747e87c0f5!8m2!3d20.5218683!4d-100.8140826!16s%2Fg%2F1hhhc0fn1?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    await _db.collection('centrosRecarga').doc('crBoulevard').set({
      'nombreCR': 'Oficinas SIBE ',
      'direccionCR': 'Zona Centro',
      'coord1CR': 20.521,
      'coord2CR': -100.813,
      'horarioCR': '8:00 AM - 10:00 PM',
      'calfCR': 4.5,
      'comentariosCR': [
        'Atienden rápido',
        'Buena ubicación',
        'A veces no tienen sistema',
      ],
      //https://www.google.com/maps/place/SIBE+TP+Centro+de+Emisi%C3%B3n/@20.5196424,-100.8095698,3a,75y,343.99h,90t/data=!3m7!1e1!3m5!1sWsf0585mxee7wzuZY80RaQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D0%26panoid%3DWsf0585mxee7wzuZY80RaQ%26yaw%3D343.9936!7i16384!8i8192!4m15!1m7!3m6!1s0x842cbaec0ea395a9:0x41ca6f05c0fe46af!2sSIBE+TP+Centro+de+Emisi%C3%B3n!8m2!3d20.5198986!4d-100.8096587!16s%2Fg%2F11bvv52gxy!3m6!1s0x842cbaec0ea395a9:0x41ca6f05c0fe46af!8m2!3d20.5198986!4d-100.8096587!10e5!16s%2Fg%2F11bvv52gxy?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    await _db.collection('centrosRecarga').doc('crOxxoTec1').set({
      'nombreCR': 'OXXO Centro',
      'direccionCR': 'Zona Centro',
      'coord1CR': 20.539591,
      'coord2CR': -100.820047,
      'horarioCR': '8:00 AM - 10:00 PM',
      'calfCR': 4.5,
      'comentariosCR': [
        'Atienden rápido',
        'Buena ubicación',
        'A veces no tienen sistema',
      ],
      //https://www.google.com/maps/@20.5397127,-100.8200914,3a,75y,42.87h,82.36t/data=!3m7!1e1!3m5!1sVm85aNZWESgVWZ4CfHv9jQ!2e0!6shttps:%2F%2Fstreetviewpixels-pa.googleapis.com%2Fv1%2Fthumbnail%3Fcb_client%3Dmaps_sv.tactile%26w%3D900%26h%3D600%26pitch%3D7.637736546901351%26panoid%3DVm85aNZWESgVWZ4CfHv9jQ%26yaw%3D42.87014429142538!7i16384!8i8192?entry=ttu&g_ep=EgoyMDI2MDUyNi4wIKXMDSoASAFQAw%3D%3D
    });

    /*await _db.collection('centrosRecarga').doc('centroR1').set({
      'nombreCR': 'OXXO Centro',
      'direccionCR': 'Zona Centro',
      'coord1CR': 20.521,
      'coord2CR': -100.813,
      'horarioCR': '8:00 AM - 10:00 PM',
      'calfCR': 4.5,
      'comentariosCR': [
        'Atienden rápido',
        'Buena ubicación',
        'A veces no tienen sistema',
      ],
    });*/
  }
}
