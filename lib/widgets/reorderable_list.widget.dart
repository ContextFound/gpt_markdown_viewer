import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ReorderableMarkdownList extends StatelessWidget {
  const ReorderableMarkdownList({
    super.key,
    required this.items,
    required this.onReorder,
  });

  final List<ListGroupItem> items;
  final void Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: onReorder,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          key: ValueKey('${item.rawText}_$index'),
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 2, right: 8),
                child: Text('•'),
              ),
              Expanded(child: item.content),
            ],
          ),
        );
      },
    );
  }
}
