import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Instagram Filter Example';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.red),
        home: FilterPage(),
      );
}

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final String imagePath = 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=633&q=80'; 
  final List<String> filters = ['Normal', 'Sepia', 'Grayscale', 'Invert']; 
  int selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Filters view'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: applyFilter(selectedFilterIndex),
              ),
            ),
            Container(
              height: 120,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => setState(() => selectedFilterIndex = index),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedFilterIndex == index
                                ? Colors.red
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: applyFilter(index, isThumbnail: true),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        filters[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedFilterIndex == index
                              ? Colors.red
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget applyFilter(int filterIndex, {bool isThumbnail = false}) {
  switch (filterIndex) {
      case 1: // Sepia
        return ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.brown.withOpacity(0.5),
            BlendMode.modulate,
          ),
          child: Image.network(imagePath, fit: BoxFit.cover),
        );
      case 2: // Grayscale
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            0.2126, 0.7152, 0.0722, 0, 0, // R
            0.2126, 0.7152, 0.0722, 0, 0, // G
            0.2126, 0.7152, 0.0722, 0, 0, // B
            0, 0, 0, 1, 0, // Alpha
          ]),
          child: Image.network(imagePath, fit: BoxFit.cover),
        );
      case 3: // Invert
        return ColorFiltered(
          colorFilter: const ColorFilter.matrix([
            -1, 0, 0, 0, 255, // R
            0, -1, 0, 0, 255, // G
            0, 0, -1, 0, 255, // B
            0, 0, 0, 1, 0, // Alpha
          ]),
          child: Image.network(imagePath, fit: BoxFit.cover),
        );
      default: // Normal
        return Image.network(
          imagePath,
          fit: isThumbnail ? BoxFit.cover : BoxFit.contain,
        );
    }
  }
}



// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:minimize_with_overlay/pages/home_page.dart';
// import 'package:minimize_with_overlay/provider_models/app_state_model.dart';
// import 'package:provider/provider.dart';

// void main() {
//   runApp(MultiProvider(providers: [
//     ChangeNotifierProvider<AppStateModel>(
//       create: (_) => AppStateModel(),
//     )
//   ], child: const MyApp()));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Platform.isIOS
//         ? const CupertinoApp(
//             title: 'Minimize feature',
//             home: HomePage(),
//             theme: CupertinoThemeData(
//                 barBackgroundColor: Colors.white,
//                 primaryColor: CupertinoColors.darkBackgroundGray,
//                 brightness: Brightness.light),
//           )
//         : MaterialApp(
//             title: 'Minimize feature',
//             theme: ThemeData(
//                 primaryColor: Colors.grey.shade800,
//                 primarySwatch: Colors.blueGrey,
//                 brightness: Brightness.light),
//             home: const HomePage(),
//           );
//   }
// }

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

final ValueNotifier<double> playerExpandProgress = ValueNotifier(0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Video Miniplayer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _getScreen(_currentIndex),
          Miniplayer(
            minHeight: 70,
            maxHeight: MediaQuery.of(context).size.height * 0.4,
            valueNotifier: playerExpandProgress,
            builder: (height, percentage) {
              return VideoMiniplayer(
                isExpanded: height > 100,
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return Center(child: Text('Home Screen'));
      case 1:
        return Center(child: Text('Videos Screen'));
      case 2:
        return Center(child: Text('Settings Screen'));
      default:
        return Center(child: Text('Home Screen'));
    }
  }
}
class VideoMiniplayer extends StatefulWidget {
  final bool isExpanded;

  const VideoMiniplayer({Key? key, required this.isExpanded}) : super(key: key);

  @override
  _VideoMiniplayerState createState() => _VideoMiniplayerState();
}

class _VideoMiniplayerState extends State<VideoMiniplayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
    print("?????????????????????????????");
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      );

      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });

      _controller.play();
    } catch (e) {
      print('Error initializing video: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Column(
        mainAxisAlignment: widget.isExpanded
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          if (_isInitialized)
            widget.isExpanded
                ? Column(
                    children: [
                      Text(
                        'Video Player',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 120,
                        height: 70,
                        child: VideoPlayer(_controller),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Now Playing: Bee Video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_controller.value.isPlaying) {
                              _controller.pause();
                            } else {
                              _controller.play();
                            }
                          });
                        },
                      ),
                    ],
                  )
          else
            Center(
              child: CircularProgressIndicator(),
            ),
          if (widget.isExpanded && _isInitialized)
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.blue,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.black,
              ),
            ),
        ],
      ),
    );
  }
}
