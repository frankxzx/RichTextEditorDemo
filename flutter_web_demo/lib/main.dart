import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

void main() {
  runApp(const RichTextEditorApp());
}

class RichTextEditorApp extends StatelessWidget {
  const RichTextEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rich Text Editor Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RichTextEditorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RichTextEditorPage extends StatefulWidget {
  const RichTextEditorPage({super.key});

  @override
  State<RichTextEditorPage> createState() => _RichTextEditorPageState();
}

class _RichTextEditorPageState extends State<RichTextEditorPage> {
  final quill.QuillController _controller = quill.QuillController.basic();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _editorFocusNode = FocusNode();
  bool _isPreview = false;

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }

  void _togglePreview() {
    setState(() {
      _isPreview = !_isPreview;
      if (!_isPreview) {
        _editorFocusNode.requestFocus();
      }
    });
  }

  void _clearContent() {
    _controller.clear();
    _titleController.clear();
    setState(() {});
  }

  String _getHtml() {
    // Convert Quill delta to HTML-like representation
    final doc = _controller.document.toDelta().toJson();
    return doc.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rich Text Editor Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isPreview ? Icons.edit : Icons.preview),
            onPressed: _togglePreview,
            tooltip: _isPreview ? 'Edit' : 'Preview',
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearContent,
            tooltip: 'Clear',
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Document JSON'),
                  content: SingleChildScrollView(
                    child: SelectableText(_getHtml()),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'View JSON',
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isPreview)
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: quill.QuillToolbar.simple(
                configurations: quill.QuillSimpleToolbarConfigurations(
                  controller: _controller,
                  multiRowsDisplay: false,
                  showAlignmentButtons: true,
                  showBackgroundColorButton: true,
                  showBoldButton: true,
                  showCenterAlignment: true,
                  showClearFormat: true,
                  showCodeBlock: true,
                  showColorButton: true,
                  showDirection: false,
                  showDividers: true,
                  showFontFamily: false,
                  showFontSize: true,
                  showHeaderStyle: true,
                  showIndent: true,
                  showInlineCode: true,
                  showItalicButton: true,
                  showJustifyAlignment: true,
                  showLeftAlignment: true,
                  showLink: true,
                  showListBullets: true,
                  showListCheck: true,
                  showListNumbers: true,
                  showQuote: true,
                  showRedo: true,
                  showRightAlignment: true,
                  showSearchButton: false,
                  showSmallButton: false,
                  showStrikeThrough: true,
                  showSubscript: false,
                  showSuperscript: false,
                  showUnderLineButton: true,
                  showUndo: true,
                ),
              ),
            ),
          Expanded(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title input
                    TextField(
                      controller: _titleController,
                      enabled: !_isPreview,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        hintText: '请输入标题',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      maxLength: 100,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    // Editor
                    Container(
                      constraints: const BoxConstraints(minHeight: 400),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: quill.QuillEditor.basic(
                        configurations: quill.QuillEditorConfigurations(
                          controller: _controller,
                          readOnly: _isPreview,
                          padding: EdgeInsets.zero,
                          autoFocus: false,
                          expands: false,
                          placeholder: '开始编辑内容...',
                          scrollable: true,
                        ),
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
  }
}
