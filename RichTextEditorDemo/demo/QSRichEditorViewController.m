//
//  QSRichEditorViewController.m
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/5.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "QSRichEditorViewController.h"
#import "QSRichEditorViewController+keyboard.h"
#import "DTRichTextEditorView+qs.h"
#import <DTRichTextEditor/DTRichTextEditor.h>
#import "RichTextEditorToolBar.h"
#import "RichTextEditorMoreView.h"
#import "RichTextEditorAction.h"
#import "QSRichTextEditorCoverCell.h"
#import "QSRichTextEditorTitleCell.h"
#import "QSRichTextEditorBodyCell.h"
#import <YYText/YYText.h>

CGFloat const toolBarHeight = 44;
CGFloat const editorMoreViewHeight = 200;
#define richTextHighlightColor [UIColor lightGrayColor]

typedef NS_OPTIONS(NSUInteger, QSRichEditorState) {
	QSRichEditorStateNoneContent,// 没有编辑内容
	QSRichEditorStateSelection,//正在编辑选中的文本
	QSRichEditorStateInputing,//正在输入
	QSRichEditorStateScrolling,//上下滑动（键盘失去响应）
	QSRichEditorStateDidFinishEditing,//上下滑动（键盘失去响应）
	QSRichEditorStateWirtingToHtml,//原生转译成 Html
	QSRichEditorStatePreview,//预览富文本
	QSRichEditorStateAttachmentUploding,//上传语音 短视频
	QSRichEditorStateDone//完成上传，同步服务器
};

@interface QSRichEditorViewController () <UIScrollViewDelegate,
                                          DTAttributedTextContentViewDelegate,
 										  DTRichTextEditorViewDelegate,
                                          RichTextEditorAction,
										  QMUIKeyboardManagerDelegate>

@property(nonatomic, assign) QSRichEditorState state;
@property(nonatomic, strong) RichTextEditorToolBar *editorToolBar;
@property(nonatomic, strong) RichTextEditorMoreView *editorMoreView;
@property(nonatomic, weak) DTRichTextEditorView *richEditor;
@property(nonatomic, weak) YYTextView *titleTextView;
@property(nonatomic, strong) UIBarButtonItem *doneItem;
@property(nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@end

@implementation QSRichEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeBack title:nil position:QMUINavigationButtonPositionLeft target:self action:nil];
	self.state = QSRichEditorStateNoneContent;
	[self configDefaultStyle];
    self.keyboardManager.delegateEnabled = YES;
}

-(void)initSubviews {
	[super initSubviews];
//    [self.view addSubview:self.toolView];
//    [self.toolView addSubview:self.editorToolBar];
//    [self.toolView addSubview:self.editorMoreView];
}

-(void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
    [self updateToolBarFrame];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.richEditor becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.view endEditing:YES];
}

#pragma mark - Editor State
-(void)setState:(QSRichEditorState)state {
	switch (state) {
		case QSRichEditorStateNoneContent:
			self.doneItem.enabled = NO;
			break;
		case QSRichEditorStateSelection:
			self.doneItem.enabled = NO;
			break;
		case QSRichEditorStateInputing:
			self.doneItem.enabled = NO;
			break;
		case QSRichEditorStateScrolling:
			self.doneItem.enabled = NO;
			break;
		case QSRichEditorStateDidFinishEditing:
			break;
		case QSRichEditorStateWirtingToHtml:
			[self lodingWithText:@"生成 html 中..."];
			break;
        case QSRichEditorStatePreview:
            break;
        case QSRichEditorStateAttachmentUploding:
			[self lodingWithText:@"上传附件中..."];
			break;
		case QSRichEditorStateDone:
			break;
	}
	_state = state;
}

#pragma mark - Menu Item Actions
- (void)menuDidHide:(NSNotification *)notification {
}

- (void)displayInsertMenu:(id)sender {
	[[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)insertStar:(id)sender {
	[self.richEditor insertText:@"★"];
}

- (void)insertWhiteStar:(id)sender {
	[self.richEditor insertText:@"☆"];
}

#pragma mark - Editor Actions
//点击完成按钮
-(void)doneButtonClick:(id)sender {
	self.state = QSRichEditorStateWirtingToHtml;
	//转译 html
	void(^didSuccessHandle)() = ^{
		[self showPreviewController];
	};
}

//点击预览按钮
-(void)showPreviewController {
	self.state = QSRichEditorStatePreview;
}

//上传语音短视频
-(void)uploadAttachment {
	self.state = QSRichEditorStateAttachmentUploding;
}

//同步服务器
-(void)syncService {
	//同步成功
	void(^didSuccessHandle)() = ^{
		self.state = QSRichEditorStateDone;
	};
}

//Html 打印
-(void)showHtmlString:(UIBarButtonItem *)sender {
	NSString *htmlString = [self.richEditor HTMLStringWithOptions:DTHTMLWriterOptionDocument];
	NSLog(@"======= \n %@ \n ======\n======= \n %@ \n ======",self.richEditor.attributedText, htmlString);
}

-(void)hyperlinkPushed:(UIButton *)sender {
    
}

#pragma mark - Helpers
//文章尾部 插入 创建时间
-(void)insertFooter {
	
}

//插入分隔线
-(void)insertSeparatorLine {
	
}

//图片更换
-(void)replaceImageAtRange:(id)range {
	
}

//图片注释
-(void)commentImageAtRange:(id)range {
	
}

//插入文章封面
-(void)insertArticleCover {
	
}

//插入文章标题
-(void)insertArticleTitle {
	
}

//加载 loding
-(void)lodingWithText:(NSString *)text {
	
}

//取消loding
-(void)hideAllLoding {
	
}

-(void)showPhotoPicker {
	
}

//通知管理
-(void)configNotifications {
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
}

//文本对齐
-(void)changeTextAligment:(CTTextAlignment)alignment {
	
}

-(NSArray <DTImageTextAttachment *>*)imagAttachments {
	
	NSArray *images = [self.richEditor.attributedText textAttachmentsWithPredicate:nil class:[DTImageTextAttachment class]];
	return images;
}

-(void)uploadImageAttachments {
	
	NSArray <DTImageTextAttachment *>*images = [self imagAttachments];
	if ([images count])
	{
		for (DTImageTextAttachment *oneAttachment in images)
		{
			NSData *imageData = UIImageJPEGRepresentation(oneAttachment.image, 0.8);
		}
	}
}

-(void)configDefaultStyle {

	// demonstrate half em paragraph spacing
    //DTCSSStylesheet *styleSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:@"p {margin-bottom:0.5em} ol {margin-bottom:0.5em; -webkit-padding-start:40px;} ul {margin-bottom:0.5em;-webkit-padding-start:40px;}"];
}

#pragma mark - Lazy subviews

//工具栏
-(UIView *)toolView {
	if (!_toolView) {
		_toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, toolBarHeight+editorMoreViewHeight)];
        _toolView.backgroundColor = UIColorWhite;
	}
	return _toolView;
}

-(RichTextEditorToolBar *)editorToolBar {
	if (!_editorToolBar) {
		_editorToolBar = [[RichTextEditorToolBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, toolBarHeight)];
        _editorToolBar.formatDelegate = self;
	}
	return _editorToolBar;
}

-(RichTextEditorMoreView *)editorMoreView {
	if (!_editorMoreView) {
		_editorMoreView = [[RichTextEditorMoreView alloc]initWithFrame:CGRectMake(0, toolBarHeight, self.view.bounds.size.width, editorMoreViewHeight)];
	}
	return _editorMoreView;
}

//编辑器
-(DTRichTextEditorView *)richEditor {
   QSRichTextEditorBodyCell *cell  = (QSRichTextEditorBodyCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (cell) {
        
        DTRichTextEditorView *editorView = cell.richEditor;
        editorView.delegate = self;
        editorView.textDelegate = self;
        
        editorView.textSizeMultiplier = 1.0;
        editorView.maxImageDisplaySize = CGSizeMake(300, 300);
        editorView.autocorrectionType = UITextAutocorrectionTypeYes;
        editorView.editorViewDelegate = self;
        editorView.defaultFontSize = 16;
        editorView.attributedTextContentView.shouldDrawImages = NO;
        editorView.inputAccessoryView = self.editorToolBar;
        
        return editorView;
    }
    return nil;
}

-(YYTextView *)titleTextView {
    QSRichTextEditorTitleCell *cell  = (QSRichTextEditorTitleCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell) {
        YYTextView *titleTextView = cell.titleTextView;
        return titleTextView;
    }
    return nil;
}

//键盘管理
-(QMUIKeyboardManager *)keyboardManager {
    if (!_keyboardManager) {
        _keyboardManager = [[QMUIKeyboardManager alloc]initWithDelegate:self];
    }
    return _keyboardManager;
}

//选中文本出现的 UIMenu
//@synthesize menuItems = _menuItems;
//- (NSArray *)menuItems {
//    if (!_menuItems) {
//        UIMenuItem *insertItem = [[UIMenuItem alloc] initWithTitle:@"Insert" action:@selector(displayInsertMenu:)];
//        UIMenuItem *insertStarItem = [[UIMenuItem alloc] initWithTitle:@"★" action:@selector(insertStar:)];
//        UIMenuItem *insertCheckItem = [[UIMenuItem alloc] initWithTitle:@"☆" action:@selector(insertWhiteStar:)];
//        _menuItems = [NSMutableArray arrayWithArray:@[insertItem, insertStarItem, insertCheckItem]];
//    }
//    return _menuItems;
//}

//图片缓存
- (NSCache *)imageCache {
	if (!_imageCache) {
		_imageCache = [[NSCache alloc] init];
	}
	return _imageCache;
}

#pragma mark - QMUITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier;
    switch (indexPath.row) {
        case 0:
            cellIdentifier = @"coverCell";
            break;
        case 1:
            cellIdentifier = @"titleCell";
            break;
        case 2:
            cellIdentifier = @"bodyCell";
            break;
        default:
            break;
    }
  
    return [self.tableView qmui_heightForCellWithIdentifier:cellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        
    }];
}

- (UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    QSRichTextEditorCell *cell = (QSRichTextEditorCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        if ([identifier isEqualToString:@"coverCell"]) {
            cell = [[QSRichTextEditorCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else if ([identifier isEqualToString:@"titleCell"]) {
            cell = [[QSRichTextEditorTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        } else if ([identifier isEqualToString:@"bodyCell"]) {
            cell = [[QSRichTextEditorBodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QSRichTextEditorCell *cell;
    switch (indexPath.row) {
        case 0:
             cell = (QSRichTextEditorCoverCell *)[self qmui_tableView:tableView cellWithIdentifier:@"coverCell"];
            break;
        case 1:
            cell = (QSRichTextEditorTitleCell *)[self qmui_tableView:tableView cellWithIdentifier:@"titleCell"];
            break;
        case 2:
            cell = (QSRichTextEditorBodyCell *)[self qmui_tableView:tableView cellWithIdentifier:@"bodyCell"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView qmui_clearsSelection];
}

#pragma mark - DTRichTextEditorViewDelegate

// RichTextEditor 编辑生命周期
- (BOOL)editorViewShouldBeginEditing:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewShouldBeginEditing:");
//    return !self.testState.blockShouldBeginEditing;
    return YES;
}

- (void)editorViewDidBeginEditing:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewDidBeginEditing:");
}

- (BOOL)editorViewShouldEndEditing:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewShouldEndEditing:");
    
    return YES;
//    return !self.testState.blockShouldEndEditing;
}

- (void)editorViewDidEndEditing:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewDidEndEditing:");
}

// RichTextEditor 选中文本生命周期
- (BOOL)editorView:(DTRichTextEditorView *)editorView shouldChangeTextInRange:(NSRange)range replacementText:(NSAttributedString *)text
{
	NSLog(@"editorView:shouldChangeTextInRange:replacementText:");
	
	return YES;
}

- (void)editorViewDidChangeSelection:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewDidChangeSelection:");
	
//    if( self.formatViewController && [self.richEditor inputView] == self.formatViewController.view ){
//        self.formatViewController.fontDescriptor = [self.richEditor fontDescriptorForRange:self.richEditor.selectedTextRange];
//    }
}

- (void)editorViewDidChange:(DTRichTextEditorView *)editorView
{
	NSLog(@"editorViewDidChange:");
}

//选中文本后出现的 UIMenu 点击事件
- (BOOL)editorView:(DTRichTextEditorView *)editorView canPerformAction:(SEL)action withSender:(id)sender
{
	DTTextRange *selectedTextRange = (DTTextRange *)editorView.selectedTextRange;
	BOOL hasSelection = ![selectedTextRange isEmpty];
	
//    if (action == @selector(insertStar:) || action == @selector(insertWhiteStar:))
//    {
//        return _showInsertMenu;
//    }
//
//    if (_showInsertMenu)
//    {
//        return NO;
//    }
//
//    if (action == @selector(displayInsertMenu:))
//    {
//        return (!hasSelection && _showInsertMenu == NO);
//    }
	
	// For fun, disable selectAll:
	if (action == @selector(selectAll:))
	{
		return NO;
	}
	return YES;
}

#pragma mark - DTAttributedTextContentViewDelegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
//    NSNumber *cacheKey = [NSNumber numberWithUnsignedInteger:[attachment hash]];
//
//    UIImageView *imageView = [self.imageViewCache objectForKey:cacheKey];
//
//    if (imageView)
//    {
//        imageView.frame = frame;
//        return imageView;
//    }
//
//    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
//    {
//        DTImageTextAttachment *imageAttachment = (DTImageTextAttachment *)attachment;
//
//        imageView = [[UIImageView alloc] initWithFrame:frame];
//        imageView.image = imageAttachment.image;
//
//        [self.imageViewCache setObject:imageView forKey:cacheKey];
//
//        return imageView;
//    }
	
	
	return nil;
}

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForLink:(NSURL *)url identifier:(NSString *)identifier frame:(CGRect)frame
{
    //超链接跳转按钮
	DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
	button.URL = url;
	button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
	button.GUID = identifier;
	
	// use normal push action for opening URL
	[button addTarget:self action:@selector(hyperlinkPushed:) forControlEvents:UIControlEventTouchUpInside];
	
	// demonstrate combination with long press
	//UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(linkLongPressed:)];
	//[button addGestureRecognizer:longPress];
	
	return button;
}

#pragma mark - DTFormatDelegate
//插入图片
- (void)replaceCurrentSelectionWithPhoto:(UIImage *)image
{
	// make an attachment
	DTImageTextAttachment *attachment = [[DTImageTextAttachment alloc] initWithElement:nil options:nil];
	attachment.image = (id)image;
	CGFloat w = [UIScreen mainScreen].bounds.size.width;
	CGFloat h = [UIScreen mainScreen].bounds.size.height / 3;
	CGSize size = CGSizeMake(w-20, h);
	attachment.displaySize = size;
	attachment.originalSize = size;
	
	[self.richEditor replaceRange:[self.richEditor selectedTextRange] withAttachment:attachment inParagraph:YES];
}

//设置字体
- (void)formatDidSelectFont:(DTCoreTextFontDescriptor *)font
{
	[self.richEditor updateFontInRange:self.richEditor.selectedTextRange
			   withFontFamilyName:font.fontFamily
						pointSize:font.pointSize];
}

//当前设置了三种默认字体的样式
-(void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style {
    [self.richEditor updateTextStyle:style inRange:self.richEditor.selectedTextRange];
}

//应用样式
-(void)formatDidToggleBlockquote {
    [self.richEditor toggleHighlightInRange:self.richEditor.selectedTextRange color:richTextHighlightColor];
    [self.richEditor applyTextAlignment:kCTTextAlignmentCenter toParagraphsContainingRange:self.richEditor.selectedTextRange];
}

//加粗
- (void)formatDidToggleBold
{
	[self.richEditor toggleBoldInRange:self.richEditor.selectedTextRange];
}

//斜体
- (void)formatDidToggleItalic
{
	[self.richEditor toggleItalicInRange:self.richEditor.selectedTextRange];
}

//下划线
- (void)formatDidToggleUnderline
{
	[self.richEditor toggleUnderlineInRange:self.richEditor.selectedTextRange];
}

//中划线
- (void)formatDidToggleStrikethrough
{
	[self.richEditor toggleStrikethroughInRange:self.richEditor.selectedTextRange];
}

//对齐
- (void)formatDidChangeTextAlignment:(CTTextAlignment)alignment
{
	UITextRange *range = self.richEditor.selectedTextRange;
	[self.richEditor applyTextAlignment:alignment toParagraphsContainingRange:range];
}

//列表缩进
- (void)increaseTabulation
{
	UITextRange *range = self.richEditor.selectedTextRange;
	[self.richEditor changeParagraphLeftMarginBy:36 toParagraphsContainingRange:range];
}

//撤销列表缩进
- (void)decreaseTabulation
{
	UITextRange *range = self.richEditor.selectedTextRange;
	[self.richEditor changeParagraphLeftMarginBy:-36 toParagraphsContainingRange:range];
}

- (void)toggleListType:(DTCSSListStyleType)listType
{
	UITextRange *range = self.richEditor.selectedTextRange;
	
	DTCSSListStyle *listStyle = [[DTCSSListStyle alloc] init];
	listStyle.startingItemNumber = 1;
	listStyle.type = listType;
	
	[self.richEditor toggleListStyle:listStyle inRange:range];
}

//设置超链接
- (void)applyHyperlinkToSelectedText:(NSURL *)url
{
	UITextRange *range = self.richEditor.selectedTextRange;
	[self.richEditor toggleHyperlinkInRange:range URL:url];
}

-(void)richTextEditorOpenMoreView {
    [self.richEditor setInputView:self.editorMoreView animated:YES];
}

-(void)richTextEditorCloseMoreView {
    [self.richEditor setInputView:nil animated:YES];
}

#pragma mark - UIScrollView Delegate
//上下滑动取消键盘响应
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.state = QSRichEditorStateScrolling;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.richEditor removeObserver:self forKeyPath:@"selectedTextRange"];
}

// letting iOS set the insets automatically interferes with
- (BOOL)automaticallyAdjustsScrollViewInsets {
	return NO;
}

@end
