import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apsl_sun_calc/apsl_sun_calc.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'dot_map_painter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selected = "12h";

  late final List<SunPosition> sunPathPoints;
  late final SunPosition currentSunPosition;

  @override
  // ✅ Generate sun path points
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _buildTopBar()),
              _buildDateTemp(),
              const SizedBox(height: 10),
              SizedBox(
                height: 400,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ModelViewer(
                        src: 'assets/tape_recorder.glb',
                        autoPlay: true,
                        autoRotateDelay: 1,
                        ar: true,
                        arModes: ['scene-viewer', 'webxr', 'quick-look'],
                        cameraOrbit: '0deg 90deg 30m',
                        autoRotate: true,
                        cameraControls: true,
                        minCameraOrbit: '0deg 90deg 30m',
                        maxCameraOrbit: '0eg 90deg 30m',
                        cameraTarget: '0m 0m 0m',
                        fieldOfView: '1deg',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logo.png', height: 80, width: 80),
          GestureDetector(
            child: Image.asset('assets/git.png'),
            onTap: () async {
              const url = 'https://github.com/Kavin-Kl';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
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
                const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
