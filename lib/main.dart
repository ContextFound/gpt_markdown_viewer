import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'providers/markdown.provider.dart';
import 'widgets/interactive_checkbox.widget.dart';
import 'widgets/reorderable_list.widget.dart';

void main() {
  runApp(const ProviderScope(child: MarkdownValidatorApp()));
}

class MarkdownValidatorApp extends StatefulWidget {
  const MarkdownValidatorApp({super.key});

  @override
  State<MarkdownValidatorApp> createState() => _MarkdownValidatorAppState();
}

class _MarkdownValidatorAppState extends State<MarkdownValidatorApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _seedColor = Colors.blue;
  bool _customBuildersEnabled = true;

  static const Map<String, Color> colorOptions = {
    'Blue': Colors.blue,
    'Purple': Colors.deepPurple,
    'Teal': Colors.teal,
    'Green': Colors.green,
    'Orange': Colors.orange,
    'Red': Colors.red,
    'Pink': Colors.pink,
    'Indigo': Colors.indigo,
    'Blue Grey': Colors.blueGrey,
  };

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark
          ? ThemeMode.light
          : ThemeMode.dark;
    });
  }

  void _setSeedColor(Color color) {
    setState(() {
      _seedColor = color;
    });
  }

  void _toggleCustomBuilders() {
    setState(() {
      _customBuildersEnabled = !_customBuildersEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Markdown Validator',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'JetBrains Mono',
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'JetBrains Mono',
      ),
      home: MarkdownValidatorScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onToggleTheme: _toggleTheme,
        seedColor: _seedColor,
        colorOptions: colorOptions,
        onColorChanged: _setSeedColor,
        customBuildersEnabled: _customBuildersEnabled,
        onToggleCustomBuilders: _toggleCustomBuilders,
      ),
    );
  }
}

class MarkdownValidatorScreen extends ConsumerStatefulWidget {
  const MarkdownValidatorScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.seedColor,
    required this.colorOptions,
    required this.onColorChanged,
    required this.customBuildersEnabled,
    required this.onToggleCustomBuilders,
  });

  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Color seedColor;
  final Map<String, Color> colorOptions;
  final ValueChanged<Color> onColorChanged;
  final bool customBuildersEnabled;
  final VoidCallback onToggleCustomBuilders;

  @override
  ConsumerState<MarkdownValidatorScreen> createState() =>
      _MarkdownValidatorScreenState();
}

class _MarkdownValidatorScreenState
    extends ConsumerState<MarkdownValidatorScreen> {
  late final TextEditingController _controller;
  bool _copied = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(markdownProvider));
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    ref.read(markdownProvider.notifier).updateMarkdown(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: ref.read(markdownProvider)));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    // Theme-aware colors
    final gradientColors = isDark
        ? [
            const Color(0xFF0F0F1A),
            const Color(0xFF1A1A2E),
            const Color(0xFF16213E),
          ]
        : [
            const Color(0xFFF0F4F8),
            const Color(0xFFE8EDF5),
            const Color(0xFFE0E8F0),
          ];
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A2E);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF00D9FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF00D9FF).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.code,
                        color: Color(0xFF00D9FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'GPT Markdown Validator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Spacer(),
                    // Custom Builders Toggle
                    Tooltip(
                      message: 'Enable custom builders like checkboxes and list items',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onToggleCustomBuilders,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: widget.customBuildersEnabled
                                  ? const Color(0xFF00FF88).withValues(alpha: 0.1)
                                  : isDark
                                      ? const Color(0xFF666666).withValues(alpha: 0.1)
                                      : const Color(0xFF999999).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: widget.customBuildersEnabled
                                    ? const Color(0xFF00FF88).withValues(alpha: 0.3)
                                    : isDark
                                        ? const Color(0xFF666666).withValues(alpha: 0.3)
                                        : const Color(0xFF999999).withValues(alpha: 0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.customBuildersEnabled
                                      ? Icons.toggle_on_rounded
                                      : Icons.toggle_off_rounded,
                                  size: 20,
                                  color: widget.customBuildersEnabled
                                      ? const Color(0xFF00FF88)
                                      : isDark
                                          ? const Color(0xFF666666)
                                          : const Color(0xFF999999),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Custom Builders',
                                  style: TextStyle(
                                    color: widget.customBuildersEnabled
                                        ? const Color(0xFF00FF88)
                                        : isDark
                                            ? const Color(0xFF666666)
                                            : const Color(0xFF999999),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Color Picker Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.seedColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.seedColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Color>(
                          value: widget.seedColor,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: widget.seedColor,
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1E1E32)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          items: widget.colorOptions.entries.map((entry) {
                            return DropdownMenuItem<Color>(
                              value: entry.value,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: entry.value,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    entry.key,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF1A1A2E),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (color) {
                            if (color != null) {
                              widget.onColorChanged(color);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Theme Toggle Button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: widget.onToggleTheme,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFFFFAA00).withValues(alpha: 0.1)
                                : const Color(
                                    0xFF6366F1,
                                  ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? const Color(
                                      0xFFFFAA00,
                                    ).withValues(alpha: 0.3)
                                  : const Color(
                                      0xFF6366F1,
                                    ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: isDark
                                ? const Color(0xFFFFAA00)
                                : const Color(0xFF6366F1),
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Side-by-side panes
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Input Section
                      Expanded(child: _buildInputSection()),

                      const SizedBox(width: 16),

                      // Vertical Divider
                      Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00D9FF).withValues(alpha: 0),
                              Color(
                                0xFF00D9FF,
                              ).withValues(alpha: isDark ? 0.5 : 0.7),
                              Color(
                                0xFFFF006E,
                              ).withValues(alpha: isDark ? 0.5 : 0.7),
                              const Color(0xFFFF006E).withValues(alpha: 0),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Preview Section
                      Expanded(child: _buildPreviewSection()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    final isDark = widget.isDarkMode;

    // Theme-aware colors
    final containerColor = isDark ? const Color(0xFF1E1E32) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2D2D44)
        : const Color(0xFFE0E4EA);
    final labelColor = isDark
        ? const Color(0xFF8888AA)
        : const Color(0xFF6B7280);
    final textColor = isDark
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF1F2937);
    final hintColor = isDark
        ? const Color(0xFF555566)
        : const Color(0xFF9CA3AF);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Input Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF00D9FF),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Markdown Input',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                // Copy Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _copyToClipboard,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: _copied
                            ? const Color(0xFF00FF88).withValues(alpha: 0.15)
                            : const Color(0xFF00D9FF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _copied
                              ? const Color(0xFF00FF88).withValues(alpha: 0.4)
                              : const Color(0xFF00D9FF).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _copied ? Icons.check : Icons.copy_rounded,
                            size: 16,
                            color: _copied
                                ? const Color(0xFF00FF88)
                                : const Color(0xFF00D9FF),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _copied ? 'Copied!' : 'Copy',
                            style: TextStyle(
                              color: _copied
                                  ? const Color(0xFF00FF88)
                                  : const Color(0xFF00D9FF),
                              fontSize: 13,
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
          ),
          // Text Input
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                height: 1.6,
                fontFamily: 'JetBrains Mono',
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: 'Enter your markdown here...',
                hintStyle: TextStyle(color: hintColor),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    final isDark = widget.isDarkMode;

    // Theme-aware colors
    final containerColor = isDark ? const Color(0xFF1E1E32) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF2D2D44)
        : const Color(0xFFE0E4EA);
    final labelColor = isDark
        ? const Color(0xFF8888AA)
        : const Color(0xFF6B7280);
    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.3)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF006E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Preview',
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  // 'gpt_markdown v1.1.5',
                  'gpt_markdown: https://github.com/ContextFound/gpt_markdown.git',
                  style: TextStyle(
                    color: labelColor.withValues(alpha: 0.6),
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          // Markdown Preview
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: GptMarkdown(
                key: ValueKey('markdown_${widget.customBuildersEnabled}'),
                ref.watch(markdownProvider),
                checkBoxBuilder: widget.customBuildersEnabled
                    ? (context, isChecked, child, config) {
                        return InteractiveCheckbox(
                          isChecked: isChecked,
                          child: child,
                          onChanged: (newValue) {
                            final rawText = config.rawText;
                            if (rawText != null) {
                              ref
                                  .read(markdownProvider.notifier)
                                  .toggleCheckbox(rawText, newValue);
                              // Sync controller with updated markdown
                              _controller.removeListener(_onTextChanged);
                              _controller.text = ref.read(markdownProvider);
                              _controller.addListener(_onTextChanged);
                            }
                          },
                        );
                      }
                    : null,
                listGroupBuilder: widget.customBuildersEnabled
                    ? (context, items, config) {
                        return ReorderableMarkdownList(
                          items: items,
                          onReorder: (oldIndex, newIndex) {
                            ref
                                .read(markdownProvider.notifier)
                                .reorderListItems(items, oldIndex, newIndex);
                            // Sync controller with updated markdown
                            _controller.removeListener(_onTextChanged);
                            _controller.text = ref.read(markdownProvider);
                            _controller.addListener(_onTextChanged);
                          },
                        );
                      }
                    : null,
                onLinkTap: (url, title) async {
                  final uri = Uri.tryParse(url);
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
