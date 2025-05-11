import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/facebook_banner_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _errorMessage;
  final String _stationName = "صوت السلام";
  final String _frequency = "105.5";
  final String _streamUrl =
      "https://stream-165.zeno.fm/nbe77drdmfktv?zt=eyJhbGciOiJIUzI1NiJ9.eyJzdHJlYW0iOiJuYmU3N2RyZG1ma3R2IiwiaG9zdCI6InN0cmVhbS0xNjUuemVuby5mbSIsInJ0dGwiOjUsImp0aSI6IkFRd1A3TFFDU2M2c012WUJqOVJDYmciLCJpYXQiOjE3NDY2MDI0MDQsImV4cCI6MTc0NjYwMjQ2NH0.9sAPjUlJnByhKtnPEgKUYwByk-7C25hAaxO719yJlF4";

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
      backgroundColor: const Color(0xFFEF4A2B),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Top section with banner and logo
            Column(
              children: [
                const SizedBox(height: 16),
                const FacebookBannerWidget(),
                const SizedBox(height: 16),
                Image.asset('assets/logo.jpg', width: 80),
                const SizedBox(height: 8),
                const Text(
                  'صوت السلام',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),

            // White bottom section
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  Waveform
                  SizedBox(
                    height: 48,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 48),
                      painter: const WaveformPainter(
                        color: Color(0xFFEF4A2B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Radio live',
                    style: TextStyle(
                      color: Color(0xFFEF4A2B),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Play button
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0x1AEF4A2B),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFEF4A2B),
                        width: 4,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x44EF4A2B),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 64,
                        color: const Color(0xFFEF4A2B),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                        if (_isPlaying) {
                          _audioPlayer.play();
                        } else {
                          _audioPlayer.pause();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Social icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon(
                        'assets/facebook.png',
                        _socialLinks['facebook']!,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialIcon(
                        'assets/youtube.png',
                        _socialLinks['youtube']!,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialIcon(
                        'assets/tiktok.png',
                        _socialLinks['tiktok']!,
                      ),
                      const SizedBox(width: 16),
                      _buildSocialIcon(
                        'assets/instagram.png',
                        _socialLinks['instagram']!,
                        color: Colors.black,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
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
    const barCount = 32;
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
