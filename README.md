# GPT Markdown Viewer

A Flutter web application for viewing and validating Markdown content using the [gpt_markdown](https://github.com/Infinitix-LLC/gpt_markdown) library.

## Overview

This project serves two purposes:

1. **Markdown Validator** — Test and validate how the `gpt_markdown` library renders various Markdown and LaTeX content, making it useful for library development and debugging.

2. **General-Purpose Markdown Viewer** — A clean, modern interface for previewing Markdown with real-time rendering, suitable for everyday use.

## Features

- **Live Preview** — See your Markdown rendered instantly as you type
- **Dark/Light Theme** — Toggle between dark and light modes for comfortable viewing
- **LaTeX Support** — Full mathematical expression rendering (e.g., `$E = mc^2$`)
- **Rich Markdown** — Headers, lists, tables, code blocks, blockquotes, links, and more
- **Copy to Clipboard** — Easily copy your Markdown content
- **Clickable Links** — Links open in external browser

## Supported Markdown Features

| Feature | Example |
|---------|---------|
| Headers | `# H1` through `###### H6` |
| Bold | `**bold text**` |
| Italic | `*italic text*` |
| Strikethrough | `~~striked~~` |
| Links | `[text](url)` |
| Images | `![alt](url)` |
| Code Blocks | ` ```language ` |
| Inline Code | `` `code` `` |
| Tables | `\| col1 \| col2 \|` |
| Blockquotes | `> quote` |
| Ordered Lists | `1. item` |
| Unordered Lists | `- item` |
| Checkboxes | `[x] checked` / `[ ] unchecked` |
| Horizontal Rules | `---` |
| LaTeX (inline) | `$formula$` or `\(formula\)` |
| LaTeX (block) | `$$formula$$` or `\[formula\]` |

## Getting Started

### Prerequisites

- Flutter SDK 3.10.1 or later
- A web browser (Chrome recommended for development)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/gpt_markdown_viewer.git
   cd gpt_markdown_viewer
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run -d chrome
   ```

## Usage

1. **Enter Markdown** — Type or paste your Markdown content in the left panel
2. **View Preview** — The right panel displays the rendered output in real-time
3. **Toggle Theme** — Click the sun/moon icon to switch between light and dark modes
4. **Copy Content** — Use the "Copy" button to copy your Markdown to the clipboard

## Dependencies

- [gpt_markdown](https://github.com/Infinitix-LLC/gpt_markdown) — Markdown and LaTeX rendering engine optimized for AI outputs
- [url_launcher](https://pub.dev/packages/url_launcher) — Opens links in external browser

## About gpt_markdown

The `gpt_markdown` library is a comprehensive Flutter package for rendering rich Markdown and LaTeX content, designed for seamless integration with AI outputs like ChatGPT and Gemini. It serves as a drop-in replacement for `flutter_markdown` with extended LaTeX support and better AI integration.

For more information, visit the [gpt_markdown repository](https://github.com/Infinitix-LLC/gpt_markdown).

## License

This project is licensed under the BSD-3-Clause License. See [LICENSE](LICENSE) for details.
