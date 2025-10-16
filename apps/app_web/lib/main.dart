// tattoo_frontend/apps/app_web/lib/main.dart
import 'package:flutter/material.dart';
import 'package:features/features.dart';

late final ArtistModule artist; // 데모용 전역

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  artist = ArtistModule.defaultClient(); // ✅ Dio 주입 없이 사용
  runApp(const MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<ArtistEntity> _future;

  @override
  void initState() {
    super.initState();
    _future = artist.getArtistById(1); // dummyjson /users/1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dummy Artist')),
      body: Center(
        child: FutureBuilder<ArtistEntity>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) return const CircularProgressIndicator();
            if (snap.hasError) return Text('에러: ${snap.error}');
            return Text('dummyArtist=${snap.data!.name}');
          },
        ),
      ),
    );
  }
}