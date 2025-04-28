import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const RadioApp());
}

class RadioApp extends StatelessWidget {
  const RadioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'صوت السلام',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF232323),
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const RadioPlayerScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEF4A2B),
      body: Center(
        child: Image.asset(
          'assets/logo.jpg',
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

class RadioPlayerScreen extends StatefulWidget {
  const RadioPlayerScreen({super.key});

  @override
  State<RadioPlayerScreen> createState() => _RadioPlayerScreenState();
}

class _RadioPlayerScreenState extends State<RadioPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _errorMessage;
  final String _stationName = "صوت السلام";
  final String _frequency = "105.5";
  final String _streamUrl = "https://icecast.radiofrance.fr/fip-hifi.aac";

  final Map<String, String> _socialLinks = {
    'facebook':
        'https://www.facebook.com/Qaladshlama?mibextid=wwXIfr&rdid=w8npJSzGNX6MHjzJ&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1AZtzYd5AZ%2F%3Fmibextid%3DwwXIfr#',
    'instagram':
        'https://www.instagram.com/voice_of_peace2025?igsh=MXJvaWFvYWx5dDdyZw%3D%3D',
    'tiktok': 'https://www.tiktok.com/@voice_of_pease?_t=ZS-8vpErrIl7NI&_r=1',
    'youtube': 'https://www.youtube.com/channel/UCkHdPuqGFKPWrL7GjNyS_pg',
  };

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      setState(() {
        _errorMessage = null;
      });
      await _audioPlayer.setUrl(_streamUrl);
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _isPlaying = false;
          });
        }
      }, onError: (error) {
        setState(() {
          _errorMessage = "Stream error: $error";
        });
      });
      setState(() {});
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to initialize audio: ${e.toString()}";
      });
      debugPrint("Error initializing audio: $e");
    }
  }

  Future<void> _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play();
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to play/pause: ${e.toString()}";
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      setState(() {
        _errorMessage = "Could not open the link.";
      });
    }
  }

  Widget _buildSocialIcon(String asset, String url,
      {Color? color, double size = 36}) {
    return IconButton(
      icon: Image.asset(asset, width: size, height: size, color: color),
      onPressed: () => _launchURL(url),
      splashRadius: 24,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEF4A2B), // Red background
      body: Stack(
        children: [
          // Top Banner
          Column(
            children: [
              SizedBox(height: 48),
              FacebookBanner(), // Your horizontal banner widget
              SizedBox(height: 16),
              // Logo and station name
              Column(
                children: [
                  Image.asset('assets/logo.jpg', width: 80),
                  SizedBox(height: 8),
                  Text('صوت السلام',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          // White Card with waveform and controls
          Positioned(
            top: 220, // Adjust as needed
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 32),
              child: Column(
                children: [
                  // Waveform
                  SizedBox(
                    height: 48,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 48),
                      painter: WaveformPainter(
                          color: Color(0xFFEF4A2B)), // Red waveform
                    ),
                  ),
                  SizedBox(height: 16),
                  Text('Radio live',
                      style: TextStyle(color: Color(0xFFEF4A2B), fontSize: 18)),
                  SizedBox(height: 24),
                  // Play/Pause Button
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0x1AEF4A2B),
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFEF4A2B), width: 4),
                      boxShadow: [
                        BoxShadow(color: Color(0x44EF4A2B), blurRadius: 16)
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 64, color: Color(0xFFEF4A2B)),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                  SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                          'assets/facebook.png', _socialLinks['facebook']!),
                      SizedBox(width: 16),
                      _buildSocialIcon(
                          'assets/youtube.png', _socialLinks['youtube']!),
                      SizedBox(width: 16),
                      _buildSocialIcon(
                          'assets/tiktok.png', _socialLinks['tiktok']!),
                      SizedBox(width: 16),
                      _buildSocialIcon(
                          color: Colors.black,
                          'assets/instagram.png',
                          _socialLinks['instagram']!),
                    ],
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final Color color;

  const WaveformPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final barCount = 32;
    final barWidth = size.width / (barCount * 1.5);
    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth * 1.5;
      final barHeight =
          (size.height / 2) * (0.5 + 0.5 * (i % 2 == 0 ? 1 : 0.7));
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x, size.height - barHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class FacebookBanner extends StatefulWidget {
  const FacebookBanner({super.key});

  @override
  State<FacebookBanner> createState() => _FacebookBannerState();
}

class _FacebookBannerState extends State<FacebookBanner> {
  late Future<List<String>> _imagesFuture;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _imagesFuture = fetchFacebookImages();
    _timer = Timer.periodic(const Duration(hours: 12), (timer) {
      setState(() {
        _imagesFuture = fetchFacebookImages();
      });
    });
  }

  Future<List<String>> fetchFacebookImages() async {
    const pageId = '100013533072894';
    const accessToken =
        'EAAUA0hNH6IQBO4XTuQvtOyb9QSjyJxZB6boyyaD51DPpQ8bcYRRby1zHbaFrfkMKCI0jIFlDJC4K4MI9ZC7KwwJc4z6J7sdLZA1ZCTlgDE94GfwqAW8qkfbZByO0Pit4blKQbvuRUNxbIBiyc9VSjjcmyCIZA5VZB1gh23TM3fWNqEnIc6axEwMLu93LOjRy2i4bSHebAWC8vazCc8voSd03ubHrpfCW1JTqti8PFUkBlB5DsY8Qn8vBHDPmbG5zRcZD';
    final url =
        'https://graph.facebook.com/v19.0/$pageId/photos?fields=images&limit=4&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List photos = data['data'];

      if (photos.isEmpty) {
        print('No photos available');
        return [];
      }

      // طباعة استجابة البيانات للتحقق
      print('Response Data: $data');

      return photos
          .where(
              (photo) => photo['images'] != null && photo['images'].isNotEmpty)
          .map<String>((photo) => photo['images'][0]['source'] as String)
          .toList();
    } else {
      print('Failed to load Facebook images: ${response.body}');
      throw Exception('Failed to load Facebook images');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          FutureBuilder<List<String>>(
            future: _imagesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error loading images ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No images found'));
              }
              final images = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 32, bottom: 16),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(right: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Image.network(
                          images[index],
                          width: 140,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          // LIVE NOW label
          Positioned(
            left: 24,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'LIVE NOW',
                style: TextStyle(
                  color: Color(0xFFEF4A2B),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
