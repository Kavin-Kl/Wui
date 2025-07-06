import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String selected = "12h";
  late AnimationController _rotationController;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration position = Duration.zero;
  Duration totalDuration = Duration.zero;

  final String audioUrl =
      "https://raw.githubusercontent.com/Kavin-Kl/assets/main/Enna-Naan-Seiven-MassTamilan.com.mp3";

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _audioPlayer.setReleaseMode(ReleaseMode.stop);

    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => totalDuration = duration);
    });
    _audioPlayer.onPositionChanged.listen((pos) {
      setState(() => position = pos);
    });
  }

  Future<void> _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.setSource(UrlSource(audioUrl));
        await _audioPlayer.resume();
      }
      setState(() => isPlaying = !isPlaying);
    } catch (e) {
      print("Audio Error: $e");
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(),
              _buildDateTemp(),
              const SizedBox(height: 6),
              SizedBox(
                height: 380,
                child: ModelViewer(
                  src: 'assets/tape.glb',
                  autoPlay: true,
                  autoRotate: true,
                  cameraControls: true,
                  ar: true,
                  arModes: ['scene-viewer', 'webxr', 'quick-look'],
                  cameraOrbit: '180deg 90deg 30m',
                  cameraTarget: '0m 0m 0m',
                  fieldOfView: '1deg',
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: IconButton(
                        icon: Image.asset(
                          'assets/vinyl-record.png',
                          height: 20,
                          width: 20,
                        ),
                        onPressed: _togglePlayPause,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 200,
                      height: 40,
                      child: SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 2,
                          activeTrackColor: Colors.black,
                          inactiveTrackColor: Colors.black87,
                          thumbColor: Colors.black,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 0,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 2,
                          ),
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble(),
                          min: 0,
                          max: totalDuration.inSeconds.toDouble() + 1,
                          onChanged: (value) async {
                            final newPosition = Duration(
                              seconds: value.toInt(),
                            );
                            await _audioPlayer.seek(newPosition);
                          },
                          activeColor: Colors.black87,
                          inactiveColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', height: 60, width: 60),
          GestureDetector(
            child: Image.asset('assets/git.png', height: 40),
            onTap: () async {
              const url = 'https://github.com/Kavin-Kl';
              if (await canLaunch(url)) {
                await launch(url);
              }
            },
          ),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment<String>(
                value: '12h',
                label: Text('12h', style: TextStyle(fontFamily: 'Orbitron')),
              ),
              ButtonSegment<String>(
                value: '24h',
                label: Text('24h', style: TextStyle(fontFamily: 'Orbitron')),
              ),
            ],
            selected: {selected},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() => selected = newSelection.first);
            },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.black
                    : Colors.white,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTemp() {
    final now = DateTime.now();
    final day = DateFormat('EEEE').format(now);
    final month = DateFormat('MMMM dd').format(now);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$day,',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                month,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Text(
            '58°F',
            style: TextStyle(
              fontSize: 56,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
