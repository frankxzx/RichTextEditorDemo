# RichTextEditorDemo

rich text editor demo
模仿 字里行间 富文本编辑器

## 项目说明

本仓库包含两个版本的富文本编辑器实现：

### 1. iOS 原生版本
- 使用 Objective-C 和 UITableView 构建
- 基于 DTRichTextEditor 框架
- 位于根目录

### 2. Flutter Web 版本 ✨ 新增
- 使用 Flutter 框架重新实现
- 支持 Web 平台，可在浏览器中直接运行
- 位于 `flutter_web_demo/` 目录
- **在线演示**: [https://frankxzx.github.io/RichTextEditorDemo/](https://frankxzx.github.io/RichTextEditorDemo/)

## Flutter Web 版本特性

- ✨ 完整的富文本编辑功能
- 📝 标题和内容编辑
- 🎨 文本格式化（粗体、斜体、下划线、删除线）
- 📋 列表支持（有序列表、无序列表、复选框）
- 🎯 文本对齐
- 🔗 超链接
- 💬 引用块和代码块
- 👁️ 预览模式

## 快速开始 (Flutter Web)

```bash
cd flutter_web_demo
flutter pub get
flutter run -d chrome
```

更多详情请查看 [flutter_web_demo/README.md](flutter_web_demo/README.md)
