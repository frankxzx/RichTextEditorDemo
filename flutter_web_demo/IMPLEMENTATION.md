# Flutter Web 富文本编辑器实现说明

## 项目概述

本项目使用 Flutter 框架重新实现了原 iOS 富文本编辑器，并配置为可在 Web 浏览器中运行的应用。

## 已实现功能

### 核心功能
1. **文本编辑**
   - 标题输入（独立的标题输入框）
   - 正文编辑（支持富文本格式）
   - 预览模式（只读查看）

2. **文本格式化**
   - 粗体 (Bold)
   - 斜体 (Italic)
   - 下划线 (Underline)
   - 删除线 (Strikethrough)
   - 文本颜色
   - 背景色

3. **段落格式**
   - 标题样式 (H1-H6)
   - 段落对齐（左对齐、居中、右对齐、两端对齐）
   - 引用块 (Blockquote)
   - 代码块 (Code Block)
   - 行内代码 (Inline Code)

4. **列表功能**
   - 无序列表 (Bullet List)
   - 有序列表 (Numbered List)
   - 复选框列表 (Checklist)
   - 列表缩进控制

5. **其他功能**
   - 超链接插入和编辑
   - 撤销/重恢复
   - 清除格式
   - 字体大小调整
   - 查看文档 JSON 结构

## 技术架构

### 使用的 Flutter 包
- **flutter_quill**: 核心富文本编辑器库（v10.0.0）
- **flutter_quill_extensions**: 扩展功能支持（v10.0.0）
- **file_picker**: 文件选择功能（v8.0.0）
- **url_launcher**: URL 启动器（v6.2.0）

### 项目结构
```
flutter_web_demo/
├── lib/
│   └── main.dart              # 主应用和编辑器实现
├── web/
│   ├── index.html             # Web 入口
│   ├── manifest.json          # PWA 配置
│   └── .nojekyll              # GitHub Pages 配置
├── pubspec.yaml               # 依赖配置
├── build.sh                   # 构建脚本
└── README.md                  # 项目文档
```

## GitHub Pages 部署

### 自动部署流程
1. GitHub Actions 工作流已配置在 `.github/workflows/deploy.yml`
2. 当代码推送到 `main`、`master` 或 `claude/implement-flutter-web-demo` 分支时自动触发
3. 工作流执行以下步骤：
   - 安装 Flutter SDK (v3.24.0)
   - 获取项目依赖
   - 构建 Web 应用（使用 `--base-href /RichTextEditorDemo/`）
   - 部署到 GitHub Pages

### 访问地址
- 生产环境：https://frankxzx.github.io/RichTextEditorDemo/

## 本地开发和测试

### 开发模式
```bash
cd flutter_web_demo
flutter pub get
flutter run -d chrome
```

### 生产构建
```bash
cd flutter_web_demo
./build.sh
```
或手动执行：
```bash
flutter build web --release --base-href /RichTextEditorDemo/
```

### 本地预览构建结果
```bash
cd flutter_web_demo/build/web
python3 -m http.server 8000
# 访问 http://localhost:8000
```

## 与原 iOS 版本对比

### 功能对比
| 功能 | iOS 版本 | Flutter Web 版本 |
|------|---------|-----------------|
| 文本格式化 | ✅ | ✅ |
| 列表支持 | ✅ | ✅ |
| 对齐方式 | ✅ | ✅ |
| 图片插入 | ✅ | ⚠️ 待扩展 |
| 视频插入 | ✅ | ⚠️ 待扩展 |
| 超链接 | ✅ | ✅ |
| 引用块 | ✅ | ✅ |
| 代码块 | ⚠️ 部分 | ✅ |
| 跨平台 | ❌ 仅 iOS | ✅ Web/iOS/Android |

### 优势
1. **跨平台**: 一套代码可运行在 Web、iOS、Android 等多个平台
2. **现代化**: 使用 Material Design 3，界面更现代
3. **易部署**: 可直接部署到 Web，无需安装
4. **易维护**: Dart 语言和 Flutter 框架提供更好的开发体验

## 未来扩展方向

1. **媒体支持**
   - 图片上传和插入
   - 视频嵌入
   - 音频支持

2. **高级功能**
   - 表格支持
   - 数学公式 (LaTeX)
   - 图表支持
   - 文件附件

3. **协作功能**
   - 实时协作编辑
   - 评论和批注
   - 版本历史

4. **导出功能**
   - 导出为 PDF
   - 导出为 Markdown
   - 导出为 Word

5. **移动端优化**
   - iOS 和 Android 原生应用
   - 触摸优化
   - 离线支持

## 注意事项

1. **base-href 配置**: 构建时必须使用正确的 `--base-href` 参数，否则资源路径可能错误
2. **.nojekyll 文件**: 确保 GitHub Pages 正确处理下划线开头的文件
3. **依赖版本**: 使用稳定版本的 flutter_quill 以确保兼容性

## 参考资源

- [Flutter 官方文档](https://flutter.dev/docs)
- [flutter_quill GitHub](https://github.com/singerdmx/flutter-quill)
- [GitHub Pages 文档](https://docs.github.com/en/pages)
- [原 iOS 项目](https://github.com/frankxzx/RichTextEditorDemo)
