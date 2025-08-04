import 'dart:convert';

import 'package:flutter/material.dart';
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

  // Mock presets data
  final List<Map<String, dynamic>> _presets = [
    {
      "id": 1,
      "name": "Welcome Banner",
      "text": "WELCOME TO OUR STORE",
      "textColor": 0xFFFF3333,
      "backgroundColor": 0xFF000000,
      "fontSize": 45.0,
      "scrollDirection": "left",
      "scrollSpeed": 1.5,
      "isFlashing": false,
      "fontStyle": "dot-matrix",
      "soundEnabled": false,
      "createdAt": "2025-08-01T10:30:00Z"
    },
    {
      "id": 2,
      "name": "Sale Alert",
      "text": "50% OFF TODAY ONLY",
      "textColor": 0xFF00FF41,
      "backgroundColor": 0xFF000000,
      "fontSize": 50.0,
      "scrollDirection": "right",
      "scrollSpeed": 2.0,
      "isFlashing": true,
      "fontStyle": "segment",
      "soundEnabled": true,
      "createdAt": "2025-08-01T14:15:00Z"
    },
    {
      "id": 3,
      "name": "Event Notice",
      "text": "LIVE MUSIC TONIGHT 8PM",
      "textColor": 0xFF0099FF,
      "backgroundColor": 0xFF000000,
      "fontSize": 35.0,
      "scrollDirection": "up",
      "scrollSpeed": 1.2,
      "isFlashing": false,
      "fontStyle": "dot-matrix",
      "soundEnabled": false,
      "createdAt": "2025-08-02T09:00:00Z"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _textController = TextEditingController();
    _loadLastConfiguration();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadLastConfiguration() async {
    try {
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
      // Silent fail - use default values
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
    } catch (e) {
      // Silent fail
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'LED Banner Creator',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _saveConfiguration(),
            icon: Icon(
              Icons.save,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          // IconButton(
          //   onPressed: () =>
          //       Navigator.pushNamed(context, '/full-screen-display'),
          //   icon: Icon(
          //     Icons.fullscreen,
          //     color: AppTheme.lightTheme.colorScheme.primary,
          //     size: 24,
          //   ),
          // ),
          // ...existing code...
          // ...existing code...
          IconButton(
            onPressed: () {
              String mappedDirection;
              switch (_scrollDirection) {
                case 'left':
                  mappedDirection = 'right_to_left';
                  break;
                case 'right':
                  mappedDirection = 'left_to_right';
                  break;
                default:
                  mappedDirection = _scrollDirection;
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
                      'scrollDirection': mappedDirection,
                      'scrollSpeed': _scrollSpeed,
                      'isFlashing': _isFlashing,
                      'soundEnabled': _soundEnabled,
                      'fontStyle': _fontStyle,
                    },
                  ),
                ),
              );
            },
// ...existing code...
            icon: Icon(
              Icons.fullscreen,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
// ...existing code...
          SizedBox(width: 2.w),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Create'),
            Tab(text: 'Presets'),
            Tab(text: 'Display'),
          ],
          labelColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedLabelColor:
              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          indicatorColor: AppTheme.lightTheme.colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCreateTab(),
          _buildPresetsTab(),
          _buildDisplayTab(),
        ],
      ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // LED Preview
          LedPreviewWidget(
            text: _bannerText,
            textColor: _textColor,
            backgroundColor: _backgroundColor,
            fontSize: _fontSize,
            scrollDirection: _scrollDirection,
            scrollSpeed: _scrollSpeed,
            isFlashing: _isFlashing,
            // fontStyle: _fontStyle,
            isPlaying: _isPlaying,
          ),
          SizedBox(height: 4.h),

          // Text Input
          TextInputWidget(
            controller: _textController,
            onChanged: (value) {
              setState(() {
                _bannerText = value;
              });
              _saveConfiguration();
            },
          ),
          SizedBox(height: 3.h),

          FontStylePickerWidget(
            selectedStyle: _fontStyle,
            onStyleChanged: (style) {
              setState(() {
                _fontStyle = style;
              });
              _saveConfiguration();
            },
          ),
          SizedBox(height: 3.h),

          // Text Color Picker
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
          SizedBox(height: 3.h),

          // Background Color Picker
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
          SizedBox(height: 3.h),

          // Font Size Slider
          FontSizeSliderWidget(
            fontSize: _fontSize,
            onSizeChanged: (size) {
              setState(() {
                _fontSize = size;
              });
              _saveConfiguration();
            },
          ),
          SizedBox(height: 3.h),

          // Scroll Direction
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

          // Speed Control
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
          SizedBox(height: 3.h),

          // Toggle Controls
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
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Widget _buildPresetsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _presets.length,
      itemBuilder: (context, index) {
        final preset = _presets[index];
        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: ListTile(
            contentPadding: EdgeInsets.all(4.w),
            leading: Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: Color(preset['backgroundColor'] as int),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
              ),
              child: Center(
                child: Container(
                  width: 2.w,
                  height: 2.w,
                  decoration: BoxDecoration(
                    color: Color(preset['textColor'] as int),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            title: Text(
              preset['name'] as String,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.h),
                Text(
                  preset['text'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  '${preset['fontStyle']} • ${preset['scrollDirection']} • ${preset['scrollSpeed']}x',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
            trailing: Icon(
              Icons.play_arrow,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onTap: () => _loadPreset(preset),
          ),
        );
      },
    );
  }

  Widget _buildDisplayTab() {
    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          Expanded(
            child: LedPreviewWidget(
              text: _bannerText,
              textColor: _textColor,
              backgroundColor: _backgroundColor,
              fontSize: _fontSize * 1.2, // Slightly larger for display tab
              scrollDirection: _scrollDirection,
              scrollSpeed: _scrollSpeed,
              isFlashing: _isFlashing,
              // fontStyle: _fontStyle,
              isPlaying: _isPlaying,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                },
                icon: Icon(
                  _isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(_isPlaying ? 'Pause' : 'Play'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                ),
              ),
              // ElevatedButton.icon(
              //   onPressed: () =>
              //       Navigator.pushNamed(context, '/full-screen-display'),
              //   icon: Icon(
              //     Icons.fullscreen,
              //     color: Colors.white,
              //     size: 20,
              //   ),
              //   label: const Text('Full Screen'),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              //     foregroundColor: Colors.white,
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 6.w,
              //       vertical: 2.h,
              //     ),
              //   ),
              // ),
              // ...existing code...
              ElevatedButton.icon(
                onPressed: () {
                  String mappedDirection;
                  switch (_scrollDirection) {
                    case 'left':
                      mappedDirection = 'right_to_left';
                      break;
                    case 'right':
                      mappedDirection = 'left_to_right';
                      break;
                    default:
                      mappedDirection = _scrollDirection;
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
                          'scrollDirection': mappedDirection,
                          'scrollSpeed': _scrollSpeed,
                          'isFlashing': _isFlashing,
                          'soundEnabled': _soundEnabled,
                          'fontStyle': _fontStyle,
                        },
                      ),
                    ),
                  );
                },
// ...existing code...
                icon: Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text('Full Screen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 2.h,
                  ),
                ),
              ),
// ...existing code...
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
