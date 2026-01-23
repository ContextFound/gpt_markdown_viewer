import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpt_markdown/custom_widgets/markdown_config.dart';

const String initialMarkdown = '''# Welcome to GPT Markdown Validator

This tool helps you test **Markdown** rendering with the `gpt_markdown` library.

## Features

- Real-time preview
- Code blocks with syntax highlighting

```dart
void main() {
  print('Hello, Markdown!');
}
```

LaTeX support: \$E = mc^2\$

### Try it out!

1. Edit the text above
2. See changes instantly below
3. Copy your markdown when ready

> "The best way to test is to experiment."

---

### Interactive Checkboxes

[ ] Click me to check this box
[x] Click me to uncheck this box
[ ] Try toggling this checkbox too

### Radio Buttons - Pick your favorite!

( ) Select me as your choice
(x) I'm currently selected - click another!
( ) Click to switch to this option
( ) Or pick this one instead

[Click Here](https://github.com/Infinitix-LLC/gpt_markdown "title")

| Feature | Supported |
|---------|-----------|
| Headers | ✓ |
| Lists | ✓ |
| Tables | ✓ |
| LaTeX | ✓ |

### Reorderable List Demo

Drag and drop to reorder these items:

- First item
- Second item
- Third item
''';

final markdownProvider = NotifierProvider<MarkdownNotifier, String>(
  MarkdownNotifier.new,
);

class MarkdownNotifier extends Notifier<String> {
  @override
  String build() => initialMarkdown;

  void updateMarkdown(String value) => state = value;

  void reorderListItems(List<ListGroupItem> items, int oldIndex, int newIndex) {
    if (oldIndex == newIndex) return;

    // Adjust newIndex for ReorderableListView behavior
    if (newIndex > oldIndex) {
      newIndex--;
    }

    // Build the original list string from items
    final originalListLines = items
        .map((item) => _buildListLine(item, items.indexOf(item)))
        .toList();
    final originalListString = originalListLines.join('\n');

    // Reorder the items
    final reorderedItems = List<ListGroupItem>.from(items);
    final movedItem = reorderedItems.removeAt(oldIndex);
    reorderedItems.insert(newIndex, movedItem);

    // Build the new list string
    final newListLines = <String>[];
    for (int i = 0; i < reorderedItems.length; i++) {
      newListLines.add(_buildListLine(reorderedItems[i], i));
    }
    final newListString = newListLines.join('\n');

    // Replace the original list with the new list in the markdown source
    state = state.replaceFirst(originalListString, newListString);
  }

  void toggleCheckbox(String label, bool newValue) {
    final escapedLabel = RegExp.escape(label);

    if (newValue) {
      // Changing from unchecked [ ] to checked [x]
      final uncheckedPattern = RegExp(
        r'\[ \]\s+' + escapedLabel,
        multiLine: true,
      );
      state = state.replaceFirst(uncheckedPattern, '[x] $label');
    } else {
      // Changing from checked [x] to unchecked [ ]
      final checkedPattern = RegExp(
        r'\[[xX]\]\s+' + escapedLabel,
        multiLine: true,
      );
      state = state.replaceFirst(checkedPattern, '[ ] $label');
    }
  }

  void selectRadioButton(String label) {
    // Find the radio button group containing this label
    // Radio buttons are on consecutive lines starting with ( ) or (x)
    final radioPattern = RegExp(
      r'(\([xX ]\)\s+.+\n?)+',
      multiLine: true,
    );

    final matches = radioPattern.allMatches(state);
    for (final match in matches) {
      final group = match.group(0)!;
      // Check if this group contains our label
      if (group.contains(label)) {
        // Deselect all radio buttons in this group and select the clicked one
        var newGroup = group;
        
        // First, deselect all (change (x) to ( ))
        newGroup = newGroup.replaceAllMapped(
          RegExp(r'\([xX]\)(\s+)'),
          (m) => '( )${m.group(1)}',
        );
        
        // Then select the one with our label
        final escapedLabel = RegExp.escape(label);
        newGroup = newGroup.replaceFirstMapped(
          RegExp(r'\( \)(\s+)' + escapedLabel),
          (m) => '(x)${m.group(1)}$label',
        );
        
        state = state.replaceFirst(group, newGroup);
        break;
      }
    }
  }

  String _buildListLine(ListGroupItem item, int index) {
    // Detect if this is an ordered or unordered list by checking the source
    // For now, we detect by checking if the item appears to be from an ordered list
    // by looking at the markdown source context
    final rawText = item.rawText;

    // Check if the current state contains this item as an ordered list
    final orderedPattern = RegExp(
      r'^\d+\.\s+' + RegExp.escape(rawText),
      multiLine: true,
    );
    final unorderedPattern = RegExp(
      r'^[-*]\s+' + RegExp.escape(rawText),
      multiLine: true,
    );

    if (orderedPattern.hasMatch(state)) {
      // Ordered list - use sequential numbering
      return '${index + 1}. $rawText';
    } else if (unorderedPattern.hasMatch(state)) {
      // Unordered list - use dash marker
      return '- $rawText';
    } else {
      // Default to unordered
      return '- $rawText';
    }
  }
}
