import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/multi_select_bottom_bar_widget.dart';
import './widgets/preset_list_widget.dart';
import './widgets/search_bar_widget.dart';

class PresetManager extends StatefulWidget {
  const PresetManager({Key? key}) : super(key: key);

  @override
  State<PresetManager> createState() => _PresetManagerState();
}

class _PresetManagerState extends State<PresetManager> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allPresets = [];
  List<Map<String, dynamic>> _filteredPresets = [];
  List<int> _selectedPresetIds = [];
  bool _isMultiSelectMode = false;
  bool _isLoading = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMockPresets();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadMockPresets() {
    setState(() {
      _isLoading = true;
    });

    // Mock preset data
    _allPresets = [
      {
        "id": 1,
        "name": "Welcome Banner",
        "text": "WELCOME TO OUR STORE",
        "textColor": 0xFFFF3333,
        "backgroundColor": 0xFF000000,
        "scrollDirection": "left_to_right",
        "scrollSpeed": 2.0,
        "fontSize": 24.0,
        "isFlashing": false,
        "createdDate": "2025-08-01",
        "lastModified": "2025-08-01",
      },
      {
        "id": 2,
        "name": "Sale Alert",
        "text": "50% OFF EVERYTHING TODAY ONLY!",
        "textColor": 0xFF00FF41,
        "backgroundColor": 0xFF1A1A1A,
        "scrollDirection": "right_to_left",
        "scrollSpeed": 3.0,
        "fontSize": 20.0,
        "isFlashing": true,
        "createdDate": "2025-07-30",
        "lastModified": "2025-08-01",
      },
      {
        "id": 3,
        "name": "Event Announcement",
        "text": "LIVE MUSIC TONIGHT 8PM",
        "textColor": 0xFF0099FF,
        "backgroundColor": 0xFF000000,
        "scrollDirection": "up",
        "scrollSpeed": 1.5,
        "fontSize": 22.0,
        "isFlashing": false,
        "createdDate": "2025-07-28",
        "lastModified": "2025-07-29",
      },
      {
        "id": 4,
        "name": "Happy Hour",
        "text": "HAPPY HOUR 4-6PM DAILY",
        "textColor": 0xFFFFFF00,
        "backgroundColor": 0xFF2D2D2D,
        "scrollDirection": "left_to_right",
        "scrollSpeed": 2.5,
        "fontSize": 18.0,
        "isFlashing": true,
        "createdDate": "2025-07-25",
        "lastModified": "2025-07-26",
      },
      {
        "id": 5,
        "name": "Contact Info",
        "text": "CALL 555-0123 FOR RESERVATIONS",
        "textColor": 0xFFFF00FF,
        "backgroundColor": 0xFF000000,
        "scrollDirection": "down",
        "scrollSpeed": 1.0,
        "fontSize": 16.0,
        "isFlashing": false,
        "createdDate": "2025-07-20",
        "lastModified": "2025-07-21",
      },
    ];

    _filteredPresets = List.from(_allPresets);

    setState(() {
      _isLoading = false;
    });
  }

  void _filterPresets(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredPresets = List.from(_allPresets);
      } else {
        _filteredPresets = _allPresets.where((preset) {
          final name = (preset['name'] as String? ?? '').toLowerCase();
          final text = (preset['text'] as String? ?? '').toLowerCase();
          final searchLower = query.toLowerCase();
          return name.contains(searchLower) || text.contains(searchLower);
        }).toList();
      }
    });
  }

  void _onPresetTap(Map<String, dynamic> preset) {
    if (_isMultiSelectMode) {
      _togglePresetSelection(preset['id'] as int);
    } else {
      // Load preset into Banner Creator
      Navigator.pushNamed(context, '/banner-creator', arguments: preset);
    }
  }

  void _onPresetEdit(Map<String, dynamic> preset) {
    Navigator.pushNamed(context, '/banner-creator', arguments: preset);
  }

  void _onPresetDuplicate(Map<String, dynamic> preset) {
    final duplicatedPreset = Map<String, dynamic>.from(preset);
    duplicatedPreset['id'] = DateTime.now().millisecondsSinceEpoch;
    duplicatedPreset['name'] = '${preset['name']} (Copy)';
    duplicatedPreset['createdDate'] = '2025-08-02';
    duplicatedPreset['lastModified'] = '2025-08-02';

    setState(() {
      _allPresets.insert(0, duplicatedPreset);
      _filterPresets(_searchQuery);
    });

    Fluttertoast.showToast(
      msg: "Preset duplicated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onPresetShare(Map<String, dynamic> preset) {
    // Mock share functionality
    Fluttertoast.showToast(
      msg: "Sharing preset: ${preset['name']}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _onPresetDelete(Map<String, dynamic> preset) {
    setState(() {
      _allPresets.removeWhere((p) => p['id'] == preset['id']);
      _filterPresets(_searchQuery);
    });

    Fluttertoast.showToast(
      msg: "Preset deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _togglePresetSelection(int presetId) {
    setState(() {
      if (_selectedPresetIds.contains(presetId)) {
        _selectedPresetIds.remove(presetId);
      } else {
        _selectedPresetIds.add(presetId);
      }

      if (_selectedPresetIds.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _enterMultiSelectMode(int presetId) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedPresetIds = [presetId];
    });
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedPresetIds.clear();
    });
  }

  void _deleteSelectedPresets() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.warning,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Text(
                'Delete Presets',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete ${_selectedPresetIds.length} preset${_selectedPresetIds.length != 1 ? 's' : ''}? This action cannot be undone.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _allPresets.removeWhere(
                      (preset) => _selectedPresetIds.contains(preset['id']));
                  _filterPresets(_searchQuery);
                });
                _exitMultiSelectMode();

                Fluttertoast.showToast(
                  msg:
                      "${_selectedPresetIds.length} preset${_selectedPresetIds.length != 1 ? 's' : ''} deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Delete',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _exportSelectedPresets() {
    final selectedPresets = _allPresets
        .where((preset) => _selectedPresetIds.contains(preset['id']))
        .toList();

    // Mock export functionality
    Fluttertoast.showToast(
      msg:
          "Exporting ${selectedPresets.length} preset${selectedPresets.length != 1 ? 's' : ''}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    _exitMultiSelectMode();
  }

  void _createNewPreset() {
    Navigator.pushNamed(context, '/banner-creator');
  }

  Future<void> _refreshPresets() async {
    await Future.delayed(const Duration(seconds: 1));
    _loadMockPresets();

    Fluttertoast.showToast(
      msg: "Presets refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _isMultiSelectMode
          ? null
          : AppBar(
              backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
              elevation: 0,
              title: Text(
                'Preset Manager',
                style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
              ),
              actions: [
                IconButton(
                  onPressed: _createNewPreset,
                  icon: Icon(
                    Icons.add,
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                  tooltip: 'New Preset',
                ),
                SizedBox(width: 2.w),
              ],
            ),
      body: Stack(
        children: [
          Column(
            children: [
              if (!_isMultiSelectMode) ...[
                // Search Bar
                SearchBarWidget(
                  onSearchChanged: _filterPresets,
                  hintText: 'Search presets by name or text...',
                ),
              ],

              // Main Content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      )
                    : _allPresets.isEmpty
                        ? EmptyStateWidget(
                            onCreatePreset: _createNewPreset,
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshPresets,
                            color: AppTheme.lightTheme.primaryColor,
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                if (_isMultiSelectMode) ...[
                                  SliverToBoxAdapter(
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      color: AppTheme.lightTheme.primaryColor
                                          .withValues(alpha: 0.1),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check_circle,
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                            size: 6.w,
                                          ),
                                          SizedBox(width: 3.w),
                                          Text(
                                            'Multi-select mode active',
                                            style: AppTheme
                                                .lightTheme.textTheme.titleSmall
                                                ?.copyWith(
                                              color: AppTheme
                                                  .lightTheme.primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                PresetListWidget(
                                  presets: _filteredPresets,
                                  onPresetTap: _onPresetTap,
                                  onPresetEdit: _onPresetEdit,
                                  onPresetDuplicate: _onPresetDuplicate,
                                  onPresetShare: _onPresetShare,
                                  onPresetDelete: _onPresetDelete,
                                  isMultiSelectMode: _isMultiSelectMode,
                                  selectedPresetIds: _selectedPresetIds,
                                  onPresetSelect: (presetId) {
                                    if (_isMultiSelectMode) {
                                      _togglePresetSelection(presetId);
                                    } else {
                                      _enterMultiSelectMode(presetId);
                                    }
                                  },
                                ),
                                SliverToBoxAdapter(
                                  child: SizedBox(height: 10.h),
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),

          // Multi-select bottom bar
          if (_isMultiSelectMode)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: MultiSelectBottomBarWidget(
                selectedCount: _selectedPresetIds.length,
                onDeleteSelected: _deleteSelectedPresets,
                onExportSelected: _exportSelectedPresets,
                onCancelSelection: _exitMultiSelectMode,
              ),
            ),
        ],
      ),

      // Floating Action Button (only when not in multi-select mode)
      floatingActionButton: _isMultiSelectMode
          ? null
          : FloatingActionButton(
              onPressed: _createNewPreset,
              backgroundColor: AppTheme.lightTheme.primaryColor,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 6.w,
              ),
              tooltip: 'Create New Preset',
            ),
    );
  }
}
