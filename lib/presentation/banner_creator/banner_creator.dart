// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:led_banner_display/presentation/full_screen_display/full_screen_display.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:sizer/sizer.dart';

// import '../../core/app_export.dart';
// import './widgets/color_picker_widget.dart';
// import './widgets/font_size_slider_widget.dart';
// import './widgets/font_style_picker_widget.dart';
// import './widgets/led_preview_widget.dart';
// import './widgets/scroll_direction_widget.dart';
// import './widgets/speed_control_widget.dart';
// import './widgets/text_input_widget.dart';
// import './widgets/toggle_controls_widget.dart';

// class BannerCreator extends StatefulWidget {
//   const BannerCreator({Key? key}) : super(key: key);

//   @override
//   State<BannerCreator> createState() => _BannerCreatorState();
// }

// class _BannerCreatorState extends State<BannerCreator>
//     with TickerProviderStateMixin {
//   late TabController _tabController;
//   late TextEditingController _textController;

//   // Banner configuration
//   String _bannerText = '';
//   Color _textColor = AppTheme.ledRed;
//   Color _backgroundColor = Colors.black;
//   double _fontSize = 40.0;
//   String _scrollDirection = 'left';
//   double _scrollSpeed = 1.0;
//   bool _isFlashing = false;
//   String _fontStyle = 'dot-matrix';
//   bool _isPlaying = true;
//   bool _soundEnabled = false;

//   // Mock presets data
//   final List<Map<String, dynamic>> _presets = [
//     {
//       "id": 1,
//       "name": "Welcome Banner",
//       "text": "WELCOME TO OUR STORE",
//       "textColor": 0xFFFF3333,
//       "backgroundColor": 0xFF000000,
//       "fontSize": 45.0,
//       "scrollDirection": "left",
//       "scrollSpeed": 1.5,
//       "isFlashing": false,
//       "fontStyle": "dot-matrix",
//       "soundEnabled": false,
//       "createdAt": "2025-08-01T10:30:00Z"
//     },
//     {
//       "id": 2,
//       "name": "Sale Alert",
//       "text": "50% OFF TODAY ONLY",
//       "textColor": 0xFF00FF41,
//       "backgroundColor": 0xFF000000,
//       "fontSize": 50.0,
//       "scrollDirection": "right",
//       "scrollSpeed": 2.0,
//       "isFlashing": true,
//       "fontStyle": "segment",
//       "soundEnabled": true,
//       "createdAt": "2025-08-01T14:15:00Z"
//     },
//     {
//       "id": 3,
//       "name": "Event Notice",
//       "text": "LIVE MUSIC TONIGHT 8PM",
//       "textColor": 0xFF0099FF,
//       "backgroundColor": 0xFF000000,
//       "fontSize": 35.0,
//       "scrollDirection": "up",
//       "scrollSpeed": 1.2,
//       "isFlashing": false,
//       "fontStyle": "dot-matrix",
//       "soundEnabled": false,
//       "createdAt": "2025-08-02T09:00:00Z"
//     }
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Set initial orientation to portrait only
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

//     _tabController = TabController(length: 3, vsync: this);
//     _textController = TextEditingController();
//     _loadLastConfiguration();
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     _textController.dispose();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   Future<void> _loadLastConfiguration() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final configJson = prefs.getString('last_banner_config');

//       if (configJson != null) {
//         final config = json.decode(configJson) as Map<String, dynamic>;
//         setState(() {
//           _bannerText = config['text'] ?? '';
//           _textController.text = _bannerText;
//           _textColor = Color(config['textColor'] ?? AppTheme.ledRed.value);
//           _backgroundColor =
//               Color(config['backgroundColor'] ?? Colors.black.value);
//           _fontSize = (config['fontSize'] ?? 40.0).toDouble();
//           _scrollDirection = config['scrollDirection'] ?? 'left';
//           _scrollSpeed = (config['scrollSpeed'] ?? 1.0).toDouble();
//           _isFlashing = config['isFlashing'] ?? false;
//           _fontStyle = config['fontStyle'] ?? 'dot-matrix';
//           _soundEnabled = config['soundEnabled'] ?? false;
//         });
//       }
//     } catch (e) {
//       // Silent fail - use default values
//     }
//   }

//   Future<void> _saveConfiguration() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final config = {
//         'text': _bannerText,
//         'textColor': _textColor.value,
//         'backgroundColor': _backgroundColor.value,
//         'fontSize': _fontSize,
//         'scrollDirection': _scrollDirection,
//         'scrollSpeed': _scrollSpeed,
//         'isFlashing': _isFlashing,
//         'fontStyle': _fontStyle,
//         'soundEnabled': _soundEnabled,
//       };
//       await prefs.setString('last_banner_config', json.encode(config));
//     } catch (e) {
//       // Silent fail
//     }
//   }

//   void _loadPreset(Map<String, dynamic> preset) {
//     setState(() {
//       _bannerText = preset['text'] ?? '';
//       _textController.text = _bannerText;
//       _textColor = Color(preset['textColor'] ?? AppTheme.ledRed.value);
//       _backgroundColor = Color(preset['backgroundColor'] ?? Colors.black.value);
//       _fontSize = (preset['fontSize'] ?? 40.0).toDouble();
//       _scrollDirection = preset['scrollDirection'] ?? 'left';
//       _scrollSpeed = (preset['scrollSpeed'] ?? 1.0).toDouble();
//       _isFlashing = preset['isFlashing'] ?? false;
//       _fontStyle = preset['fontStyle'] ?? 'dot-matrix';
//       _soundEnabled = preset['soundEnabled'] ?? false;
//     });
//     _saveConfiguration();
//     _tabController.animateTo(0); // Switch to Create tab
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: Text(
//           'LED Banner Creator',
//           style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
//         elevation: 0,
//         actions: [
//           IconButton(
//             onPressed: () => _saveConfiguration(),
//             icon: Icon(
//               Icons.save,
//               color: AppTheme.lightTheme.colorScheme.primary,
//               size: 24,
//             ),
//           ),
//           // IconButton(
//           //   onPressed: () =>
//           //       Navigator.pushNamed(context, '/full-screen-display'),
//           //   icon: Icon(
//           //     Icons.fullscreen,
//           //     color: AppTheme.lightTheme.colorScheme.primary,
//           //     size: 24,
//           //   ),
//           // ),
//           // ...existing code...
//           // ...existing code...
//           IconButton(
//             onPressed: () {
//               String getMappedDirection(String direction) {
//                 switch (direction) {
//                   case 'left':
//                     return 'right_to_left';
//                   case 'right':
//                     return 'left_to_right';
//                   default:
//                     return direction;
//                 }
//               }

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => FullScreenDisplay(
//                     bannerConfig: {
//                       'text': _bannerText,
//                       'textColor':
//                           '#${_textColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
//                       'backgroundColor':
//                           '#${_backgroundColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
//                       'fontSize': _fontSize,
//                       'scrollDirection': getMappedDirection(_scrollDirection),
//                       'scrollSpeed': _scrollSpeed,
//                       'isFlashing': _isFlashing,
//                       'soundEnabled': _soundEnabled,
//                       'fontStyle': _fontStyle,
//                     },
//                   ),
//                 ),
//               );
//             },
// // ...existing code...
//             icon: Icon(
//               Icons.fullscreen,
//               color: AppTheme.lightTheme.colorScheme.primary,
//               size: 24,
//             ),
//           ),
// // ...existing code...
//           SizedBox(width: 2.w),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Create'),
//             Tab(text: 'Presets'),
//             Tab(text: 'Display'),
//           ],
//           labelColor: AppTheme.lightTheme.colorScheme.primary,
//           unselectedLabelColor:
//               AppTheme.lightTheme.colorScheme.onSurfaceVariant,
//           indicatorColor: AppTheme.lightTheme.colorScheme.primary,
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           _buildCreateTab(),
//           _buildPresetsTab(),
//           _buildDisplayTab(),
//         ],
//       ),
//     );
//   }

//   Widget _buildCreateTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(4.w),
//       child: Column(
//         children: [
//           // LED Preview
//           LedPreviewWidget(
//             text: _bannerText,
//             textColor: _textColor,
//             backgroundColor: _backgroundColor,
//             fontSize: _fontSize,
//             scrollDirection: _scrollDirection,
//             scrollSpeed: _scrollSpeed,
//             isFlashing: _isFlashing,
//             // fontStyle: _fontStyle,
//             isPlaying: _isPlaying,
//           ),
//           SizedBox(height: 4.h),

//           // Text Input
//           TextInputWidget(
//             controller: _textController,
//             onChanged: (value) {
//               setState(() {
//                 _bannerText = value;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           FontStylePickerWidget(
//             selectedStyle: _fontStyle,
//             onStyleChanged: (style) {
//               setState(() {
//                 _fontStyle = style;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Text Color Picker
//           ColorPickerWidget(
//             title: 'Text Color',
//             selectedColor: _textColor,
//             onColorChanged: (color) {
//               setState(() {
//                 _textColor = color;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Background Color Picker
//           ColorPickerWidget(
//             title: 'Background Color',
//             selectedColor: _backgroundColor,
//             onColorChanged: (color) {
//               setState(() {
//                 _backgroundColor = color;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Font Size Slider
//           FontSizeSliderWidget(
//             fontSize: _fontSize,
//             onSizeChanged: (size) {
//               setState(() {
//                 _fontSize = size;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Scroll Direction
//           ScrollDirectionWidget(
//             selectedDirection: _scrollDirection,
//             onDirectionChanged: (direction) {
//               setState(() {
//                 _scrollDirection = direction;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Speed Control
//           SpeedControlWidget(
//             speed: _scrollSpeed,
//             isPlaying: _isPlaying,
//             onSpeedChanged: (speed) {
//               setState(() {
//                 _scrollSpeed = speed;
//               });
//               _saveConfiguration();
//             },
//             onPlayPause: () {
//               setState(() {
//                 _isPlaying = !_isPlaying;
//               });
//             },
//           ),
//           SizedBox(height: 3.h),

//           // Toggle Controls
//           ToggleControlsWidget(
//             isFlashing: _isFlashing,
//             soundEnabled: _soundEnabled,
//             onFlashingChanged: (value) {
//               setState(() {
//                 _isFlashing = value;
//               });
//               _saveConfiguration();
//             },
//             onSoundChanged: (value) {
//               setState(() {
//                 _soundEnabled = value;
//               });
//               _saveConfiguration();
//             },
//           ),
//           SizedBox(height: 4.h),
//         ],
//       ),
//     );
//   }

//   Widget _buildPresetsTab() {
//     return ListView.builder(
//       padding: EdgeInsets.all(4.w),
//       itemCount: _presets.length,
//       itemBuilder: (context, index) {
//         final preset = _presets[index];
//         return Card(
//           margin: EdgeInsets.only(bottom: 2.h),
//           child: ListTile(
//             contentPadding: EdgeInsets.all(4.w),
//             leading: Container(
//               width: 12.w,
//               height: 6.h,
//               decoration: BoxDecoration(
//                 color: Color(preset['backgroundColor'] as int),
//                 borderRadius: BorderRadius.circular(6),
//                 border: Border.all(
//                   color: AppTheme.lightTheme.colorScheme.outline,
//                 ),
//               ),
//               child: Center(
//                 child: Container(
//                   width: 2.w,
//                   height: 2.w,
//                   decoration: BoxDecoration(
//                     color: Color(preset['textColor'] as int),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ),
//             ),
//             title: Text(
//               preset['name'] as String,
//               style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(height: 1.h),
//                 Text(
//                   preset['text'] as String,
//                   style: AppTheme.lightTheme.textTheme.bodyMedium,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 SizedBox(height: 0.5.h),
//                 Text(
//                   '${preset['fontStyle']} • ${preset['scrollDirection']} • ${preset['scrollSpeed']}x',
//                   style: AppTheme.lightTheme.textTheme.bodySmall,
//                 ),
//               ],
//             ),
//             trailing: Icon(
//               Icons.play_arrow,
//               color: AppTheme.lightTheme.colorScheme.primary,
//               size: 24,
//             ),
//             onTap: () => _loadPreset(preset),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDisplayTab() {
//     return Container(
//       padding: EdgeInsets.all(4.w),
//       child: Column(
//         children: [
//           Expanded(
//             child: LedPreviewWidget(
//               text: _bannerText,
//               textColor: _textColor,
//               backgroundColor: _backgroundColor,
//               fontSize: _fontSize * 1.2, // Slightly larger for display tab
//               scrollDirection: _scrollDirection,
//               scrollSpeed: _scrollSpeed,
//               isFlashing: _isFlashing,
//               // fontStyle: _fontStyle,
//               isPlaying: _isPlaying,
//             ),
//           ),
//           SizedBox(height: 4.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   setState(() {
//                     _isPlaying = !_isPlaying;
//                   });
//                 },
//                 icon: Icon(
//                   _isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 label: Text(_isPlaying ? 'Pause' : 'Play'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.lightTheme.colorScheme.primary,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 6.w,
//                     vertical: 2.h,
//                   ),
//                 ),
//               ),
//               // ElevatedButton.icon(
//               //   onPressed: () =>
//               //       Navigator.pushNamed(context, '/full-screen-display'),
//               //   icon: Icon(
//               //     Icons.fullscreen,
//               //     color: Colors.white,
//               //     size: 20,
//               //   ),
//               //   label: const Text('Full Screen'),
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
//               //     foregroundColor: Colors.white,
//               //     padding: EdgeInsets.symmetric(
//               //       horizontal: 6.w,
//               //       vertical: 2.h,
//               //     ),
//               //   ),
//               // ),
//               // ...existing code...
//               ElevatedButton.icon(
//                 onPressed: () {
//                   String getMappedDirection(String direction) {
//                     switch (direction) {
//                       case 'left':
//                         return 'right_to_left';
//                       case 'right':
//                         return 'left_to_right';
//                       default:
//                         return direction;
//                     }
//                   }

//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => FullScreenDisplay(
//                         bannerConfig: {
//                           'text': _bannerText,
//                           'textColor':
//                               '#${_textColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
//                           'backgroundColor':
//                               '#${_backgroundColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
//                           'fontSize': _fontSize,
//                           'scrollDirection':
//                               getMappedDirection(_scrollDirection),
//                           'scrollSpeed': _scrollSpeed,
//                           'isFlashing': _isFlashing,
//                           'soundEnabled': _soundEnabled,
//                           'fontStyle': _fontStyle,
//                         },
//                       ),
//                     ),
//                   );
//                 },
// // ...existing code...
//                 icon: Icon(
//                   Icons.fullscreen,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 label: const Text('Full Screen'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
//                   foregroundColor: Colors.white,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 6.w,
//                     vertical: 2.h,
//                   ),
//                 ),
//               ),
// // ...existing code...
//             ],
//           ),
//           SizedBox(height: 2.h),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:led_banner_display/presentation/full_screen_display/full_screen_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/color_picker_widget.dart';
import './widgets/font_size_slider_widget.dart';
import './widgets/font_style_picker_widget.dart';
import './widgets/led_preview_widget.dart';
import './widgets/scroll_direction_widget.dart';
import './widgets/speed_control_widget.dart';
import './widgets/text_input_widget.dart';
import './widgets/toggle_controls_widget.dart';

class BannerCreator extends StatefulWidget {
  const BannerCreator({Key? key}) : super(key: key);

  @override
  State<BannerCreator> createState() => _BannerCreatorState();
}

class _BannerCreatorState extends State<BannerCreator>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _textController;
  late AnimationController _previewAnimationController;

  // Banner configuration
  String _bannerText = '';
  Color _textColor = AppTheme.ledRed;
  Color _backgroundColor = Colors.black;
  double _fontSize = 40.0;
  String _scrollDirection = 'left';
  double _scrollSpeed = 1.0;
  bool _isFlashing = false;
  String _fontStyle = 'dot-matrix';
  bool _isPlaying = true;
  bool _soundEnabled = false;
  bool _isLoading = false;

  // Enhanced presets with more professional examples
  final List<Map<String, dynamic>> _presets = [
    {
      "id": 1,
      "name": "Welcome Banner",
      "text": "WELCOME TO OUR STORE",
      "textColor": 0xFF00D4FF,
      "backgroundColor": 0xFF000000,
      "fontSize": 45.0,
      "scrollDirection": "left",
      "scrollSpeed": 1.5,
      "isFlashing": false,
      "fontStyle": "dot-matrix",
      "soundEnabled": false,
      "category": "Business",
      "icon": Icons.store,
      "createdAt": "2025-08-01T10:30:00Z"
    },
    {
      "id": 2,
      "name": "Flash Sale Alert",
      "text": "🔥 50% OFF TODAY ONLY 🔥",
      "textColor": 0xFFFF3D71,
      "backgroundColor": 0xFF000000,
      "fontSize": 50.0,
      "scrollDirection": "right",
      "scrollSpeed": 2.0,
      "isFlashing": true,
      "fontStyle": "segment",
      "soundEnabled": true,
      "category": "Promotion",
      "icon": Icons.local_fire_department,
      "createdAt": "2025-08-01T14:15:00Z"
    },
    {
      "id": 3,
      "name": "Event Notice",
      "text": "🎵 LIVE MUSIC TONIGHT 8PM 🎵",
      "textColor": 0xFF00FFB3,
      "backgroundColor": 0xFF001122,
      "fontSize": 35.0,
      "scrollDirection": "up",
      "scrollSpeed": 1.2,
      "isFlashing": false,
      "fontStyle": "dot-matrix",
      "soundEnabled": false,
      "category": "Event",
      "icon": Icons.music_note,
      "createdAt": "2025-08-02T09:00:00Z"
    },
    {
      "id": 4,
      "name": "Breaking News",
      "text": "BREAKING: Latest Updates Available Now",
      "textColor": 0xFFFFD700,
      "backgroundColor": 0xFF1a1a2e,
      "fontSize": 42.0,
      "scrollDirection": "left",
      "scrollSpeed": 1.8,
      "isFlashing": false,
      "fontStyle": "segment",
      "soundEnabled": false,
      "category": "News",
      "icon": Icons.newspaper,
      "createdAt": "2025-08-03T16:20:00Z"
    },
    {
      "id": 5,
      "name": "Open Sign",
      "text": "✨ WE ARE OPEN ✨",
      "textColor": 0xFF00FF00,
      "backgroundColor": 0xFF000000,
      "fontSize": 48.0,
      "scrollDirection": "right",
      "scrollSpeed": 1.0,
      "isFlashing": true,
      "fontStyle": "dot-matrix",
      "soundEnabled": false,
      "category": "Business",
      "icon": Icons.door_front_door,
      "createdAt": "2025-08-03T08:00:00Z"
    }
  ];

  @override
  void initState() {
    super.initState();

    // Set initial orientation to portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    _tabController = TabController(length: 3, vsync: this);
    _textController = TextEditingController();
    _previewAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadLastConfiguration();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _previewAnimationController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  Future<void> _loadLastConfiguration() async {
    try {
      setState(() => _isLoading = true);
      final prefs = await SharedPreferences.getInstance();
      final configJson = prefs.getString('last_banner_config');

      if (configJson != null) {
        final config = json.decode(configJson) as Map<String, dynamic>;
        setState(() {
          _bannerText = config['text'] ?? '';
          _textController.text = _bannerText;
          _textColor = Color(config['textColor'] ?? AppTheme.ledRed.value);
          _backgroundColor =
              Color(config['backgroundColor'] ?? Colors.black.value);
          _fontSize = (config['fontSize'] ?? 40.0).toDouble();
          _scrollDirection = config['scrollDirection'] ?? 'left';
          _scrollSpeed = (config['scrollSpeed'] ?? 1.0).toDouble();
          _isFlashing = config['isFlashing'] ?? false;
          _fontStyle = config['fontStyle'] ?? 'dot-matrix';
          _soundEnabled = config['soundEnabled'] ?? false;
        });
      }
    } catch (e) {
      _showSnackBar('Failed to load configuration', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final config = {
        'text': _bannerText,
        'textColor': _textColor.value,
        'backgroundColor': _backgroundColor.value,
        'fontSize': _fontSize,
        'scrollDirection': _scrollDirection,
        'scrollSpeed': _scrollSpeed,
        'isFlashing': _isFlashing,
        'fontStyle': _fontStyle,
        'soundEnabled': _soundEnabled,
      };
      await prefs.setString('last_banner_config', json.encode(config));
      _showSnackBar('Configuration saved successfully!');
    } catch (e) {
      _showSnackBar('Failed to save configuration', isError: true);
    }
  }

  void _loadPreset(Map<String, dynamic> preset) {
    setState(() {
      _bannerText = preset['text'] ?? '';
      _textController.text = _bannerText;
      _textColor = Color(preset['textColor'] ?? AppTheme.ledRed.value);
      _backgroundColor = Color(preset['backgroundColor'] ?? Colors.black.value);
      _fontSize = (preset['fontSize'] ?? 40.0).toDouble();
      _scrollDirection = preset['scrollDirection'] ?? 'left';
      _scrollSpeed = (preset['scrollSpeed'] ?? 1.0).toDouble();
      _isFlashing = preset['isFlashing'] ?? false;
      _fontStyle = preset['fontStyle'] ?? 'dot-matrix';
      _soundEnabled = preset['soundEnabled'] ?? false;
    });
    _saveConfiguration();
    _tabController.animateTo(0); // Switch to Create tab
    _showSnackBar('Preset "${preset['name']}" loaded successfully!');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error : Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.video_settings,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 3.w),
            Text(
              'LED Banner Studio',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.black12,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            child: IconButton(
              onPressed: _isLoading ? null : () => _saveConfiguration(),
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.save_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 4.w),
            child: IconButton(
              onPressed: _isLoading || _bannerText.isEmpty
                  ? null
                  : () {
                      String getMappedDirection(String direction) {
                        switch (direction) {
                          case 'left':
                            return 'right_to_left';
                          case 'right':
                            return 'left_to_right';
                          default:
                            return direction;
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenDisplay(
                            bannerConfig: {
                              'text': _bannerText,
                              'textColor':
                                  '#${_textColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                              'backgroundColor':
                                  '#${_backgroundColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                              'fontSize': _fontSize,
                              'scrollDirection':
                                  getMappedDirection(_scrollDirection),
                              'scrollSpeed': _scrollSpeed,
                              'isFlashing': _isFlashing,
                              'soundEnabled': _soundEnabled,
                              'fontStyle': _fontStyle,
                            },
                          ),
                        ),
                      );
                    },
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFa8edea), Color(0xFFfed6e3)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.fullscreen,
                  color: const Color(0xFF2D3748),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                _buildTab('Create', Icons.edit, 0),
                _buildTab('Presets', Icons.bookmarks, 1),
                _buildTab('Preview', Icons.preview, 2),
              ],
              labelColor: const Color(0xFF667eea),
              unselectedLabelColor: const Color(0xFF718096),
              indicatorColor: const Color(0xFF667eea),
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingScreen()
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCreateTab(),
                _buildPresetsTab(),
                _buildDisplayTab(),
              ],
            ),
    );
  }

  Widget _buildTab(String label, IconData icon, int index) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 1.w),
          Text(label, style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Loading your banner configuration...',
            style: TextStyle(
              fontSize: 16,
              color: const Color(0xFF718096),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Enhanced LED Preview with modern styling
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            padding: EdgeInsets.all(4.w),
            child: LedPreviewWidget(
              text: _bannerText.isEmpty ? 'Enter your text above' : _bannerText,
              textColor: _textColor,
              backgroundColor: _backgroundColor,
              fontSize: _fontSize,
              scrollDirection: _scrollDirection,
              scrollSpeed: _scrollSpeed,
              isFlashing: _isFlashing,
              isPlaying: _isPlaying,
            ),
          ),
          SizedBox(height: 6.h),

          // Professional section cards
          _buildSectionCard(
            'Text Content',
            Icons.text_fields,
            TextInputWidget(
              controller: _textController,
              onChanged: (value) {
                setState(() {
                  _bannerText = value;
                });
                _saveConfiguration();
              },
            ),
          ),
          SizedBox(height: 4.h),

          _buildSectionCard(
            'Font Style',
            Icons.font_download,
            FontStylePickerWidget(
              selectedStyle: _fontStyle,
              onStyleChanged: (style) {
                setState(() {
                  _fontStyle = style;
                });
                _saveConfiguration();
              },
            ),
          ),
          SizedBox(height: 4.h),

          Row(
            children: [
              Expanded(
                child: _buildSectionCard(
                  'Text Color',
                  Icons.palette,
                  ColorPickerWidget(
                    title: 'Text Color',
                    selectedColor: _textColor,
                    onColorChanged: (color) {
                      setState(() {
                        _textColor = color;
                      });
                      _saveConfiguration();
                    },
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildSectionCard(
                  'Background',
                  Icons.format_color_fill,
                  ColorPickerWidget(
                    title: 'Background Color',
                    selectedColor: _backgroundColor,
                    onColorChanged: (color) {
                      setState(() {
                        _backgroundColor = color;
                      });
                      _saveConfiguration();
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),

          _buildSectionCard(
            'Font Size',
            Icons.format_size,
            FontSizeSliderWidget(
              fontSize: _fontSize,
              onSizeChanged: (size) {
                setState(() {
                  _fontSize = size;
                });
                _saveConfiguration();
              },
            ),
          ),
          SizedBox(height: 4.h),

          _buildSectionCard(
            'Animation Settings',
            Icons.animation,
            Column(
              children: [
                ScrollDirectionWidget(
                  selectedDirection: _scrollDirection,
                  onDirectionChanged: (direction) {
                    setState(() {
                      _scrollDirection = direction;
                    });
                    _saveConfiguration();
                  },
                ),
                SizedBox(height: 3.h),
                SpeedControlWidget(
                  speed: _scrollSpeed,
                  isPlaying: _isPlaying,
                  onSpeedChanged: (speed) {
                    setState(() {
                      _scrollSpeed = speed;
                    });
                    _saveConfiguration();
                  },
                  onPlayPause: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          _buildSectionCard(
            'Effects',
            Icons.auto_awesome,
            ToggleControlsWidget(
              isFlashing: _isFlashing,
              soundEnabled: _soundEnabled,
              onFlashingChanged: (value) {
                setState(() {
                  _isFlashing = value;
                });
                _saveConfiguration();
              },
              onSoundChanged: (value) {
                setState(() {
                  _soundEnabled = value;
                });
                _saveConfiguration();
              },
            ),
          ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              SizedBox(width: 3.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          child,
        ],
      ),
    );
  }

  Widget _buildPresetsTab() {
    final categories =
        _presets.map((p) => p['category'] as String).toSet().toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.bookmarks, color: Colors.white, size: 28),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Professional Templates',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Choose from our curated collection',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),

          // Categories
          for (String category in categories) ...[
            Text(
              category,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2D3748),
              ),
            ),
            SizedBox(height: 2.h),
            ...(_presets
                .where((p) => p['category'] == category)
                .map((preset) => _buildPresetCard(preset))
                .toList()),
            SizedBox(height: 3.h),
          ],
        ],
      ),
    );
  }

  Widget _buildPresetCard(Map<String, dynamic> preset) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _loadPreset(preset),
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Row(
            children: [
              // Color preview
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(preset['backgroundColor'] as int),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(preset['textColor'] as int),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          preset['icon'] as IconData,
                          size: 20,
                          color: const Color(0xFF667eea),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          preset['name'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      preset['text'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF718096),
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        _buildTag(preset['fontStyle'] as String),
                        SizedBox(width: 2.w),
                        _buildTag('${preset['scrollSpeed']}x speed'),
                        if (preset['isFlashing'] as bool) ...[
                          SizedBox(width: 2.w),
                          _buildTag('Flash', color: Colors.orange[100]!),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Action button
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String text, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color ?? const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: const Color(0xFF4A5568),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDisplayTab() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Preview card with enhanced styling
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    spreadRadius: 0,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              padding: EdgeInsets.all(4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: LedPreviewWidget(
                  text: _bannerText.isEmpty
                      ? 'Your LED banner preview'
                      : _bannerText,
                  textColor: _textColor,
                  backgroundColor: _backgroundColor,
                  fontSize: _fontSize * 1.1,
                  scrollDirection: _scrollDirection,
                  scrollSpeed: _scrollSpeed,
                  isFlashing: _isFlashing,
                  isPlaying: _isPlaying,
                ),
              ),
            ),
          ),
          SizedBox(height: 4.h),

          // Enhanced control buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPlaying = !_isPlaying;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isPlaying ? Colors.orange[400] : Colors.green[400],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _isPlaying ? 'Pause' : 'Play',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Container(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _bannerText.isEmpty
                        ? null
                        : () {
                            String getMappedDirection(String direction) {
                              switch (direction) {
                                case 'left':
                                  return 'right_to_left';
                                case 'right':
                                  return 'left_to_right';
                                default:
                                  return direction;
                              }
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenDisplay(
                                  bannerConfig: {
                                    'text': _bannerText,
                                    'textColor':
                                        '#${_textColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                                    'backgroundColor':
                                        '#${_backgroundColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
                                    'fontSize': _fontSize,
                                    'scrollDirection':
                                        getMappedDirection(_scrollDirection),
                                    'scrollSpeed': _scrollSpeed,
                                    'isFlashing': _isFlashing,
                                    'soundEnabled': _soundEnabled,
                                    'fontStyle': _fontStyle,
                                  },
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF667eea),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.fullscreen,
                          size: 24,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Full Screen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Quick settings row
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickControl(
                  'Flash',
                  _isFlashing ? Icons.flash_on : Icons.flash_off,
                  _isFlashing,
                  () {
                    setState(() {
                      _isFlashing = !_isFlashing;
                    });
                    _saveConfiguration();
                  },
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFE2E8F0),
                ),
                _buildQuickControl(
                  'Sound',
                  _soundEnabled ? Icons.volume_up : Icons.volume_off,
                  _soundEnabled,
                  () {
                    setState(() {
                      _soundEnabled = !_soundEnabled;
                    });
                    _saveConfiguration();
                  },
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFE2E8F0),
                ),
                _buildQuickControl(
                  'Save',
                  Icons.bookmark_border,
                  false,
                  () => _saveConfiguration(),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildQuickControl(
      String label, IconData icon, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFF667eea).withOpacity(0.1)
                    : const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isActive
                    ? const Color(0xFF667eea)
                    : const Color(0xFF718096),
                size: 20,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF667eea)
                    : const Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
