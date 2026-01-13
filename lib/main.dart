import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

void main() {
  runApp(const MarkdownValidatorApp());
}

class MarkdownValidatorApp extends StatelessWidget {
  const MarkdownValidatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT Markdown Validator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A1A2E),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0F1A),
        useMaterial3: true,
        fontFamily: 'JetBrains Mono',
      ),
      home: const MarkdownValidatorScreen(),
    );
  }
}

class MarkdownValidatorScreen extends StatefulWidget {
  const MarkdownValidatorScreen({super.key});

  @override
  State<MarkdownValidatorScreen> createState() =>
      _MarkdownValidatorScreenState();
}

class _MarkdownValidatorScreenState extends State<MarkdownValidatorScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _copied = false;

  static const String _sampleMarkdown = '''# Welcome to GPT Markdown Validator

This tool helps you test **Markdown** rendering with the `gpt_markdown` library.

## Features

- Real-time preview
- LaTeX support: \$E = mc^2\$
- Code blocks with syntax highlighting

```dart
void main() {
  print('Hello, Markdown!');
}
```

### Try it out!

1. Edit the text above
2. See changes instantly below
3. Copy your markdown when ready

> "The best way to test is to experiment."

---

[ ] checkbox 1
[x] checkbox 2
[Click Here](/foo "title")
[ ] checkbox 4

| Feature | Supported |
|---------|-----------|
| Headers | ✓ |
| Lists | ✓ |
| Tables | ✓ |
| LaTeX | ✓ |
''';

  @override
  void initState() {
    super.initState();
    _controller.text = _sampleMarkdown;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: _controller.text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0F1A), Color(0xFF1A1A2E), Color(0xFF16213E)],
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
                    const Text(
                      'GPT Markdown Validator',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
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
                              const Color(0xFF00D9FF).withValues(alpha: 0.5),
                              const Color(0xFFFF006E).withValues(alpha: 0.5),
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
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2D44)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF2D2D44))),
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
                const Text(
                  'Markdown Input',
                  style: TextStyle(
                    color: Color(0xFF8888AA),
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
              style: const TextStyle(
                color: Color(0xFFE0E0E0),
                fontSize: 14,
                height: 1.6,
                fontFamily: 'JetBrains Mono',
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(20),
                border: InputBorder.none,
                hintText: 'Enter your markdown here...',
                hintStyle: TextStyle(color: Color(0xFF555566)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2D2D44)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF2D2D44))),
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
                const Text(
                  'Preview',
                  style: TextStyle(
                    color: Color(0xFF8888AA),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const Spacer(),
                Text(
                  'gpt_markdown v1.1.5',
                  style: TextStyle(
                    color: const Color(0xFF8888AA).withValues(alpha: 0.6),
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
                _controller.text,
                style: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
