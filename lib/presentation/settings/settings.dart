import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/about_section_widget.dart';
import './widgets/audio_settings_widget.dart';
import './widgets/display_preferences_widget.dart';
import './widgets/storage_management_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Display preferences
  double _brightness = 0.8;
  bool _autoRotation = true;
  String _ledStyle = 'dot-matrix';

  // Audio settings
  double _masterVolume = 0.7;
  bool _soundEffects = true;
  bool _loopBeep = false;

  // Storage management
  int _presetCount = 12;
  double _usedSpace = 4.2;
  double _totalSpace = 50.0;
  bool _cloudBackup = false;

  // App info
  final String _appVersion = '2.1.4';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        _brightness = prefs.getDouble('brightness') ?? 0.8;
        _autoRotation = prefs.getBool('autoRotation') ?? true;
        _ledStyle = prefs.getString('ledStyle') ?? 'dot-matrix';
        _masterVolume = prefs.getDouble('masterVolume') ?? 0.7;
        _soundEffects = prefs.getBool('soundEffects') ?? true;
        _loopBeep = prefs.getBool('loopBeep') ?? false;
        _presetCount = prefs.getInt('presetCount') ?? 12;
        _usedSpace = prefs.getDouble('usedSpace') ?? 4.2;
        _cloudBackup = prefs.getBool('cloudBackup') ?? false;
      });
    } catch (e) {
      _showToast('Failed to load settings');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setDouble('brightness', _brightness);
      await prefs.setBool('autoRotation', _autoRotation);
      await prefs.setString('ledStyle', _ledStyle);
      await prefs.setDouble('masterVolume', _masterVolume);
      await prefs.setBool('soundEffects', _soundEffects);
      await prefs.setBool('loopBeep', _loopBeep);
      await prefs.setInt('presetCount', _presetCount);
      await prefs.setDouble('usedSpace', _usedSpace);
      await prefs.setBool('cloudBackup', _cloudBackup);
    } catch (e) {
      _showToast('Failed to save settings');
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
    );
  }

  void _showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetToDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      setState(() {
        _brightness = 0.8;
        _autoRotation = true;
        _ledStyle = 'dot-matrix';
        _masterVolume = 0.7;
        _soundEffects = true;
        _loopBeep = false;
        _presetCount = 0;
        _usedSpace = 0.0;
        _cloudBackup = false;
      });

      _showToast('Settings reset to defaults');
    } catch (e) {
      _showToast('Failed to reset settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onSelected: (String value) {
              switch (value) {
                case 'reset':
                  _showConfirmationDialog(
                    title: 'Reset Settings',
                    content:
                        'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
                    onConfirm: _resetToDefaults,
                  );
                  break;
                case 'export':
                  _showToast('Export feature coming soon');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(
                      Icons.restore,
                      color: AppTheme.warning,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Reset to Defaults',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.warning,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'export',
                child: Row(
                  children: [
                    Icon(
                      Icons.file_download,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      'Export Settings',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 2.h),

              // Display Preferences Section
              DisplayPreferencesWidget(
                brightness: _brightness,
                autoRotation: _autoRotation,
                ledStyle: _ledStyle,
                onBrightnessChanged: (double value) {
                  setState(() => _brightness = value);
                  _saveSettings();
                },
                onAutoRotationChanged: (bool value) {
                  setState(() => _autoRotation = value);
                  _saveSettings();
                },
                onLedStyleChanged: (String value) {
                  setState(() => _ledStyle = value);
                  _saveSettings();
                },
              ),

              // Audio Settings Section
              AudioSettingsWidget(
                masterVolume: _masterVolume,
                soundEffects: _soundEffects,
                loopBeep: _loopBeep,
                onMasterVolumeChanged: (double value) {
                  setState(() => _masterVolume = value);
                  _saveSettings();
                },
                onSoundEffectsChanged: (bool value) {
                  setState(() => _soundEffects = value);
                  _saveSettings();
                },
                onLoopBeepChanged: (bool value) {
                  setState(() => _loopBeep = value);
                  _saveSettings();
                },
                onTestSound: () {
                  if (_soundEffects) {
                    _showToast('🔊 Test sound played');
                  } else {
                    _showToast('Sound effects are disabled');
                  }
                },
              ),

              // Storage Management Section
              StorageManagementWidget(
                presetCount: _presetCount,
                usedSpace: _usedSpace,
                totalSpace: _totalSpace,
                cloudBackup: _cloudBackup,
                onCloudBackupChanged: (bool value) {
                  setState(() => _cloudBackup = value);
                  _saveSettings();
                  _showToast(
                      value ? 'Cloud backup enabled' : 'Cloud backup disabled');
                },
                onBackupData: () {
                  _showToast('Backing up data...');
                  Future.delayed(const Duration(seconds: 2), () {
                    _showToast('Backup completed successfully');
                  });
                },
                onRestoreData: () {
                  _showConfirmationDialog(
                    title: 'Restore Data',
                    content:
                        'This will replace your current settings and presets with backed up data. Continue?',
                    onConfirm: () {
                      _showToast('Restoring data...');
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          _presetCount = 8;
                          _usedSpace = 3.1;
                        });
                        _saveSettings();
                        _showToast('Data restored successfully');
                      });
                    },
                  );
                },
                onClearCache: () {
                  _showConfirmationDialog(
                    title: 'Clear Cache',
                    content:
                        'This will clear temporary files and cached data. Your presets will not be affected.',
                    onConfirm: () {
                      setState(() {
                        _usedSpace =
                            _usedSpace * 0.6; // Simulate cache clearing
                      });
                      _saveSettings();
                      _showToast('Cache cleared successfully');
                    },
                  );
                },
              ),

              // About Section
              AboutSectionWidget(
                appVersion: _appVersion,
                onPrivacyPolicy: () {
                  _showToast('Opening privacy policy...');
                },
                onTermsOfService: () {
                  _showToast('Opening terms of service...');
                },
                onRateApp: () {
                  _showToast('Opening app store...');
                },
                onContactSupport: () {
                  _showToast('Opening support contact...');
                },
              ),

              SizedBox(height: 4.h),

              // Footer
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    Text(
                      'LED Banner Display v$_appVersion',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '© 2025 Digital Solutions Studio',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}
