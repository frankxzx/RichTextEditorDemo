# RichTextEditorDemo

模仿「字里行间」的 iOS 富文本编辑器，基于 UITableView 构建，支持图文混排、多种文字样式、多媒体插入等功能。

---

## 目录

- [功能特性](#功能特性)
- [环境要求](#环境要求)
- [安装与集成](#安装与集成)
- [快速开始](#快速开始)
- [核心组件](#核心组件)
- [编辑器工具栏](#编辑器工具栏)
- [文字样式与格式](#文字样式与格式)
- [多媒体内容插入](#多媒体内容插入)
- [架构说明](#架构说明)
- [依赖库](#依赖库)

---

## 功能特性

### 文字格式
- **加粗**、*斜体*、~~删除线~~、下划线
- 文字对齐方式：左对齐、居中、右对齐、两端对齐
- 三种文字样式：占位符样式、正文样式、大号标题样式
- 引用块（Blockquote）
- 有序/无序列表，支持缩进增减

### 内容插入
- 插入相册图片或拍摄照片
- 图片附带说明文字（Caption）
- 插入视频（集成 ZFPlayer 播放器）
- 插入音频附件
- 插入分隔线
- 超链接插入与编辑

### 编辑器 UI
- 文章封面图管理
- 文章标题输入框（自适应高度）
- 底部工具栏（高度 44pt）
- 可展开的更多操作面板（高度 200pt）
- 键盘弹出/收起自动滚动适配
- HTML 内容导出

---

## 环境要求

| 项目 | 要求 |
|------|------|
| iOS 版本 | iOS 8.0+（推荐 iOS 11.2+）|
| Xcode 版本 | Xcode 9.0+ |
| 开发语言 | Objective-C |
| 依赖管理 | CocoaPods |

---

## 安装与集成

### 1. 克隆项目

```bash
git clone https://github.com/frankxzx/RichTextEditorDemo.git
cd RichTextEditorDemo
```

### 2. 安装依赖

```bash
pod install
```

> 安装完成后，请使用 `.xcworkspace` 文件而非 `.xcodeproj` 打开项目。

### 3. 打开工作区

```bash
open RichTextEditorDemo.xcworkspace
```

### 4. 编译运行

在 Xcode 中选择目标设备（模拟器或真机），按 `Cmd + R` 编译运行。

---

## 快速开始

### 在项目中使用编辑器

将 `demo/` 目录下的文件复制到你的项目中，并确保已安装相同的 CocoaPods 依赖。

### 初始化并展示编辑器

```objc
#import "QSRichEditorViewController.h"

// 初始化编辑器 ViewController
QSRichEditorViewController *editorVC = [[QSRichEditorViewController alloc] init];

// 以 push 方式展示
[self.navigationController pushViewController:editorVC animated:YES];

// 或以 modal 方式展示
UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:editorVC];
[self presentViewController:navVC animated:YES completion:nil];
```

---

## 核心组件

### QSRichEditorViewController

富文本编辑器的主视图控制器，继承自 `QMUICommonViewController`。

**公开属性：**

| 属性 | 类型 | 说明 |
|------|------|------|
| `toolView` | `UIView *` | 工具栏容器视图 |
| `menuItems` | `NSArray *` | 自定义菜单项 |

**协议（QSRichEditorViewControllerDelegate）：**

```objc
@protocol QSRichEditorViewControllerDelegate <NSObject>

// 即将插入文章封面图时回调
- (void)richEditorViewControllerWillInsertAticleCover;

// 即将插入文章标题时回调
- (void)richEditorViewControllerWillInsertAticleTitle;

@end
```

### RichTextEditorAction 协议

工具栏操作通过该协议传递给编辑器，如需自定义工具栏，需实现此协议。

```objc
@protocol RichTextEditorAction <NSObject>

// 切换文字样式（占位符 / 正文 / 大号）
- (void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style;

// 文字格式
- (void)formatDidToggleBold;           // 加粗
- (void)formatDidToggleItalic;         // 斜体
- (void)formatDidToggleUnderline;      // 下划线
- (void)formatDidToggleStrikethrough;  // 删除线

// 文字对齐
- (void)formatDidChangeTextAlignment:(CTTextAlignment)alignment;

// 列表缩进
- (void)decreaseTabulation;   // 减少缩进
- (void)increaseTabulation;   // 增加缩进

// 列表类型
- (void)toggleListType:(DTCSSListStyleType)listType;

// 超链接
- (void)insertHyperlink:(HyperlinkModel *)link;

// 插入图片
- (void)replaceCurrentSelectionWithPhoto;

// 其他格式
- (void)formatDidToggleBlockquote;  // 引用块

// 多媒体插入
- (void)insertVideo;      // 视频
- (void)insertAudio;      // 音频
- (void)insertSeperator;  // 分隔线

// 更多面板控制
- (void)richTextEditorOpenMoreView;   // 展开更多面板
- (void)richTextEditorCloseMoreView;  // 收起更多面板

@end
```

### QSRichEditorFontStyle

管理编辑器中的文字样式。

**文字样式枚举：**

```objc
typedef NS_OPTIONS(NSUInteger, QSRichEditorTextStyle) {
    QSRichEditorTextStylePlaceholder,  // 占位符样式（提示文字）
    QSRichEditorTextStyleNormal,       // 正文样式
    QSRichEditorTextStyleLarger        // 大号标题样式
};
```

**使用示例：**

```objc
// 创建正文样式
QSRichEditorFontStyle *fontStyle = [[QSRichEditorFontStyle alloc] initWithStyle:QSRichEditorTextStyleNormal];
NSLog(@"字体: %@, 颜色: %@", fontStyle.font, fontStyle.textColor);
```

---

## 编辑器工具栏

`RichTextEditorToolBar` 继承自 `UIToolbar`，内置以下操作按钮：

| 按钮属性 | 说明 |
|----------|------|
| `boldButton` | 加粗 |
| `italicButton` | 斜体 |
| `strikeThroughButton` | 删除线 |
| `fontStyleButton` | 切换文字样式（三种） |
| `alignButton` | 文字对齐 |
| `blockquoteButton` | 引用块 |
| `orderedListButton` | 有序列表 |
| `photoButton` | 插入图片 |
| `moreButton` | 展开更多操作 |
| `textEditorCloseButton` | 关闭文字编辑模式 |
| `moreViewCloseButton` | 关闭更多面板 |

**常用方法：**

```objc
// 更新工具栏字数统计
[toolBar setupTextCountItemWithCount:100];

// 根据当前光标处的文字属性更新工具栏按钮状态（高亮/非高亮）
[toolBar updateStateWithTypingAttributes:attributes];

// 初始化编辑状态下的工具栏按钮
[toolBar initEditorBarItems];

// 收起更多面板
[toolBar closeMoreView];
```

---

## 文字样式与格式

### 超链接

```objc
// 构造超链接数据模型
HyperlinkModel *link = [[HyperlinkModel alloc] init];
link.title = @"GitHub";
link.link  = @"https://github.com";

// 通过协议方法插入
[self insertHyperlink:link];
```

### 列表

```objc
// 插入有序列表（1. 2. 3. ...）
[self toggleListType:kCSSListStyleTypeDecimal];

// 插入无序列表（• • • ...）
[self toggleListType:kCSSListStyleTypeDisc];

// 增加缩进
[self increaseTabulation];

// 减少缩进
[self decreaseTabulation];
```

---

## 多媒体内容插入

### 图片附件（QSImageAttachment）

编辑器通过 `replaceCurrentSelectionWithPhoto` 方法触发系统相册/相机，选择后自动插入图片至光标位置。

### 带说明图片（DTImageCaptionAttachment）

支持在图片下方添加说明文字（Caption），适用于文章配图场景。

### 视频（QSRichTextEditorVideoView）

集成 ZFPlayer 播放器，调用以下方法插入视频占位符：

```objc
[self insertVideo];
```

### 分隔线（QSRichTextSeperatorAttachment）

在段落之间插入横线分隔符：

```objc
[self insertSeperator];
```

---

## 架构说明

```
QSRichEditorViewController          // 主编辑器 ViewController
├── DTRichTextEditorView            // 核心富文本编辑视图（来自 DTRichTextEditor）
├── RichTextEditorToolBar           // 底部工具栏
├── RichTextEditorMoreView          // 更多操作面板（超链接、视频、音频等）
├── QSTextFieldsViewController      // 标题/文本输入字段管理
└── QSRichEditorViewController+keyboard  // 键盘事件处理（Category）

Attachments/                        // 各类富文本附件
├── QSImageAttachment               // 图片
├── DTImageCaptionAttachment        // 带说明图片
├── QSHyperlinkAttachment           // 超链接
├── QSRichTextSeperatorAttachment   // 分隔线
├── DTTextBlockAttachment           // 文本块
├── DTDateAttachement               // 日期
└── DTTextPlaceholderAttachment     // 占位符

Helper/                             // 工具类与扩展
├── DTRichTextEditorView+qs         // DTRichTextEditorView 功能扩展
├── UIBarButtonItem+qs              // UIBarButtonItem 扩展
├── NSDictionary+qsRichTextStyle    // 文字样式字典扩展
└── NSString+YYAdd                  // 字符串工具
```

**编辑器状态（QSRichEditorState）：**

编辑器内部维护以下 7 种状态，自动根据用户操作切换：

| 状态 | 说明 |
|------|------|
| 输入中 | 用户正在键盘输入文字 |
| 编辑中 | 选中文字，工具栏激活 |
| 滚动中 | 用户滑动页面 |
| 上传中 | 附件正在上传 |
| 预览中 | 只读预览模式 |
| 图片编辑开始 | 进入图片编辑态 |
| 图片编辑结束 | 退出图片编辑态 |

---

## 依赖库

| 库名 | 用途 |
|------|------|
| [QMUIKit](https://github.com/Tencent/QMUI_iOS) | UI 基础组件与键盘管理 |
| [DTRichTextEditor](https://github.com/Cocoanetics/DTRichTextEditor) | 核心富文本编辑引擎 |
| [DTCoreText](https://github.com/Cocoanetics/DTCoreText) | Core Text 处理与 HTML 解析 |
| [YYText](https://github.com/ibireme/YYText) | 高性能文字渲染与属性文本 |
| [ZFPlayer](https://github.com/renzifeng/ZFPlayer) | 视频播放器（支持多格式） |
| [Masonry](https://github.com/SnapKit/Masonry) | 自动布局约束封装 |
| [DTLoupe](https://github.com/Cocoanetics/DTLoupe) | 文字放大镜（选词辅助） |
| [DTWebArchive](https://github.com/Cocoanetics/DTWebArchive) | Web Archive 支持 |

---

## License

Copyright © 2017 frankxzx. All rights reserved.
