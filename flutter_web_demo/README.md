# Rich Text Editor Demo - Flutter Web

这是使用 Flutter 重新实现的富文本编辑器演示项目，可以在 Web 浏览器中运行。

## 功能特性

- ✨ 富文本编辑功能
- 📝 标题和内容编辑
- 🎨 文本格式化（粗体、斜体、下划线、删除线）
- 📋 列表支持（有序列表、无序列表、复选框列表）
- 🎯 文本对齐（左对齐、居中、右对齐、两端对齐）
- 🔗 超链接插入
- 💬 引用块
- 📊 代码块
- 🎨 文本颜色和背景色
- 👁️ 预览模式
- 📄 查看 JSON 文档结构

## 在线演示

访问 GitHub Pages 查看在线演示：[https://frankxzx.github.io/RichTextEditorDemo/](https://frankxzx.github.io/RichTextEditorDemo/)

## 本地运行

### 前置要求

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)

### 安装步骤

1. 克隆仓库：
```bash
git clone https://github.com/frankxzx/RichTextEditorDemo.git
cd RichTextEditorDemo/flutter_web_demo
```

2. 安装依赖：
```bash
flutter pub get
```

3. 运行开发服务器：
```bash
flutter run -d chrome
```

### 构建生产版本

```bash
flutter build web --release --base-href /RichTextEditorDemo/
```

构建完成后，产物位于 `build/web/` 目录。

## 技术栈

- **Flutter**: Google 的 UI 工具包，用于构建跨平台应用
- **flutter_quill**: 富文本编辑器库
- **Dart**: Flutter 使用的编程语言

## 项目结构

```
flutter_web_demo/
├── lib/
│   └── main.dart          # 主应用入口和编辑器实现
├── web/
│   ├── index.html         # Web 入口 HTML
│   └── manifest.json      # PWA 配置
├── pubspec.yaml           # 项目依赖配置
└── README.md              # 项目说明
```

## 与原项目对比

原项目是基于 iOS 的 UIKit 和 DTRichTextEditor 实现的富文本编辑器，本项目使用 Flutter 重新实现，具有以下优势：

- 🌐 **跨平台**: 可以在 Web、iOS、Android 等多个平台运行
- 🚀 **现代化**: 使用现代化的 Flutter 框架和 Material Design
- 📱 **响应式**: 自动适应不同屏幕尺寸
- 🔄 **可维护**: 代码结构清晰，易于维护和扩展

## 部署

项目使用 GitHub Actions 自动部署到 GitHub Pages。每次推送到主分支时，会自动构建并部署最新版本。

## 许可证

MIT License

## 原项目

本项目是对原 iOS 富文本编辑器项目的 Flutter Web 重新实现。原项目地址：[https://github.com/frankxzx/RichTextEditorDemo](https://github.com/frankxzx/RichTextEditorDemo)
