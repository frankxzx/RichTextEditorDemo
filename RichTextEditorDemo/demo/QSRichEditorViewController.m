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
#import "QSRichTextEditorImageView.h"
#import "QSRichTextSeperatorAttachment.h"
#import "QSHyperlinkAttachment.h"
#import "DTImageTextAttachment+qs.h"
#import "DTImageCaptionAttachment.h"
#import "DTTextBlockAttachment.h"
#import "NSString+YYAdd.h"

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
	QSRichEditorStateDone,//完成上传，同步服务器
    QSRichEditorStateCaption
};

typedef NS_OPTIONS(NSUInteger, QSImageAttachmentState) {
    QSImageAttachmentStateBegin,
    QSImageAttachmentStateEditing,
    QSImageAttachmentStateEnd
};

@interface QSRichEditorViewController () <UIScrollViewDelegate,
                                          DTAttributedTextContentViewDelegate,
 										  DTRichTextEditorViewDelegate,
                                          RichTextEditorAction,
										  QMUIKeyboardManagerDelegate,
                                          QSRichTextEditorImageViewDelegate>

@property(nonatomic, assign) QSRichEditorState state;
@property(nonatomic, assign) QSImageAttachmentState editImageState;
@property(nonatomic, strong) RichTextEditorToolBar *editorToolBar;
@property(nonatomic, strong) RichTextEditorMoreView *editorMoreView;
@property(nonatomic, weak) DTRichTextEditorView *richEditor;
@property(nonatomic, weak) YYTextView *titleTextView;
@property(nonatomic, weak) DTImageTextAttachment *currentEditingAttachment;
@property(nonatomic, strong) UIBarButtonItem *doneItem;
@property(nonatomic, strong) NSCache *imageCache;
@property(nonatomic, strong) QMUIKeyboardManager *keyboardManager;

@end

@implementation QSRichEditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [QMUINavigationButton barButtonItemWithType:QMUINavigationButtonTypeNormal title:@"打印 Html" tintColor:UIColorBlack position:QMUINavigationButtonPositionLeft target:self action:@selector(showHtmlString:)];
	self.state = QSRichEditorStateNoneContent;
	[self configDefaultStyle];
    self.keyboardManager.delegateEnabled = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initSubviews {
	[super initSubviews];

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
            self.richEditor.defaultFontSize = 16;
			break;
		case QSRichEditorStateScrolling:
			self.doneItem.enabled = NO;
            [self.view endEditing:YES];
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
        case QSRichEditorStateCaption:
            self.richEditor.defaultFontSize = 14;
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

//二次编辑超链接
-(void)editHyperlink {
    [self.editorMoreView editHyperlink];
}

//二次编辑图片注释
-(void)editImageCaption:(QMUIButton *)sender {
    CGPoint touchPoint = [sender.superview convertPoint:sender.center toView:self.richEditor];
    [self.richEditor qmui_performSelector:NSSelectorFromString(@"moveCursorToPositionClosestToLocation:") withArguments:&touchPoint];
}

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
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = UIColorWhite;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadHTMLString:htmlString baseURL:nil];
    [contentView addSubview:webView];
    
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view = contentView;
    [self.navigationController pushViewController:controller animated:true];
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
        _editorMoreView.actionDelegate = self;
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

//图片缓存
- (NSCache *)imageCache {
	if (!_imageCache) {
		_imageCache = [[NSCache alloc] init];
	}
	return _imageCache;
}

-(DTTextRange *)selectedTextRange {
    return (DTTextRange *)self.richEditor.selectedTextRange;
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
- (BOOL)editorView:(DTRichTextEditorView *)editorView shouldChangeTextInRange:(NSRange)range replacementText:(NSAttributedString *)text {
    
	return YES;
}

- (void)editorViewDidChangeSelection:(DTRichTextEditorView *)editorView
{
	QMUILog(@"editorViewDidChangeSelection:");
    DTTextRange *selectedRange = (DTTextRange *)editorView.selectedTextRange;
    NSUInteger textCount = [self.richEditor attributedSubstringForRange:selectedRange].plainTextString.length;
    if (textCount > 0) {
        self.editorToolBar.beginTextEditorButton.enabled = YES;
        self.editorToolBar.blockquoteButton.enabled = YES;
        self.editorToolBar.photoButton.enabled = NO;
    } else {
        self.editorToolBar.beginTextEditorButton.enabled = NO;
        self.editorToolBar.blockquoteButton.enabled = NO;
        self.editorToolBar.photoButton.enabled = YES;
    }
}

- (void)editorViewDidChange:(DTRichTextEditorView *)editorView
{
	QMUILog(@"editorViewDidChange:");
}

//选中文本后出现的 UIMenu 点击事件
- (BOOL)editorView:(DTRichTextEditorView *)editorView canPerformAction:(SEL)action withSender:(id)sender
{
	DTTextRange *selectedTextRange = (DTTextRange *)editorView.selectedTextRange;
	BOOL hasSelection = ![selectedTextRange isEmpty];
	
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
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        
        QSRichTextEditorImageView *imageView = [[QSRichTextEditorImageView alloc]initWithFrame:frame];
        imageView.attachment = (DTImageTextAttachment *)attachment;
        imageView.actionDelegate = self;
        [imageView setImage:[UIImage qmui_imageWithColor:[UIColor qmui_randomColor]]];
        return imageView;
        
    } else if ([attachment isKindOfClass:[QSRichTextSeperatorAttachment class]]) {
        
        UIView *line = [[UIView alloc]initWithFrame:frame];
        line.backgroundColor = [UIColor lightGrayColor];
        line.qmui_height = PixelOne;
        return line;
        
    }  else if ([attachment isKindOfClass:[QSHyperlinkAttachment class]]) {
        
        QMUIButton *linkButon = [[QMUIButton alloc]initWithFrame:frame];
        [linkButon setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        linkButon.qmui_borderColor = [UIColor lightGrayColor];
        linkButon.qmui_borderWidth = PixelOne;
        linkButon.qmui_borderPosition = QMUIBorderViewPositionBottom;
        linkButon.titleLabel.font = ((QSHyperlinkAttachment *) attachment).titleFont;
        [linkButon setTitle:((QSHyperlinkAttachment *) attachment).title forState:UIControlStateNormal];
        [linkButon addTarget:self action:@selector(editHyperlink) forControlEvents:UIControlEventTouchUpInside];
        return linkButon;
        
    } else if ([attachment isKindOfClass:[DTTextBlockAttachment class]]) {
        
        YYTextView *textView = [YYTextView new];
        textView.text = ((DTTextBlockAttachment *)attachment).text;
        textView.editable = NO;
        textView.frame = frame;
        textView.qmui_borderWidth = PixelOne;
        textView.qmui_borderPosition = QMUIBorderViewPositionTop|QMUIBorderViewPositionLeft|QMUIBorderViewPositionRight|QMUIBorderViewPositionBottom;
        textView.qmui_borderColor = UIColorGray;
        textView.backgroundColor = UIColorGrayLighten;
        textView.layer.cornerRadius = 2;
        textView.textAlignment = NSTextAlignmentCenter;
        
        return textView;
        
    } else if ([attachment isKindOfClass:[DTImageCaptionAttachment class]]) {
        
        QMUIButton *linkButon = [[QMUIButton alloc]initWithFrame:frame];
        linkButon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [linkButon setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        linkButon.titleLabel.font = ((DTImageCaptionAttachment *) attachment).titleFont;
        [linkButon setTitle:((DTImageCaptionAttachment *) attachment).text forState:UIControlStateNormal];
        [linkButon addTarget:self action:@selector(editImageCaption:) forControlEvents:UIControlEventTouchUpInside];
        return linkButon;
        
    }
    
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
	
	return button;
}

- (BOOL)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView shouldDrawBackgroundForTextBlock:(DTTextBlock *)textBlock frame:(CGRect)frame context:(CGContextRef)context forLayoutFrame:(DTCoreTextLayoutFrame *)layoutFrame
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(frame,1,1) cornerRadius:10];
    
    CGColorRef color = [textBlock.backgroundColor CGColor];
    if (color)
    {
        CGContextSetFillColorWithColor(context, color);
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextFillPath(context);
        
        CGContextAddPath(context, [roundedRect CGPath]);
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
        CGContextStrokePath(context);
        return NO;
    }
    
    return YES; // draw standard background
}

#pragma mark - DTFormatDelegate

//插入分割线
-(void)insertSeperator {
    QSRichTextSeperatorAttachment *line = [[QSRichTextSeperatorAttachment alloc]init];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = 0.5;
    CGSize size = CGSizeMake(w-40, h);
    line.displaySize = size;
    line.originalSize = size;
    [self.richEditor replaceRange:self.richEditor.selectedTextRange withAttachment:line inParagraph:NO];
}

//插入图片
- (void)replaceCurrentSelectionWithPhoto
{
	// make an attachment
	DTImageTextAttachment *attachment = [[DTImageTextAttachment alloc] initWithElement:nil options:nil];
//    attachment.captionRange = [self.richEditor selectedTextRange offse]
    attachment.image = (id)[UIImage qmui_imageWithColor:[UIColor qmui_randomColor]];
	CGFloat w = [UIScreen mainScreen].bounds.size.width;
	CGFloat h = [UIScreen mainScreen].bounds.size.height / 3;
	CGSize size = CGSizeMake(w-40, h);
	attachment.displaySize = size;
	attachment.originalSize = size;
	
    UITextRange * _Nullable extractedExpr = [self.richEditor selectedTextRange];
    [self.richEditor replaceRange:extractedExpr withAttachment:attachment inParagraph:NO];
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
    [self.richEditor updateTextStyle:style inRange:self.richEditor.qs_selectedTextRange];
}

//应用样式
-(void)formatDidToggleBlockquote {
    DTTextBlockAttachment *attachment = [[DTTextBlockAttachment alloc]init];
    NSString *text = [self.richEditor attributedSubstringForRange:self.richEditor.selectedTextRange].string;
    UIFont *font = [self.richEditor attributedSubstringForRange:self.richEditor.selectedTextRange].yy_font;
    CGFloat textMaxWidth = SCREEN_WIDTH - 40;
    CGFloat textHeight = [text heightForFont:font width:textMaxWidth];
    attachment.displaySize = CGSizeMake(textMaxWidth, textHeight);
    attachment.text = text;
    [self.richEditor replaceRange:self.richEditor.qs_selectedTextRange withAttachment:attachment inParagraph:NO];
    [self.richEditor applyTextAlignment:kCTTextAlignmentCenter toParagraphsContainingRange:self.richEditor.qs_selectedTextRange];
}

//加粗
- (void)formatDidToggleBold
{
	[self.richEditor toggleBoldInRange:self.richEditor.qs_selectedTextRange];
}

//斜体
- (void)formatDidToggleItalic
{
	[self.richEditor toggleItalicInRange:self.richEditor.qs_selectedTextRange];
}

//下划线
- (void)formatDidToggleUnderline
{
	[self.richEditor toggleUnderlineInRange:self.richEditor.qs_selectedTextRange];
}

//中划线
- (void)formatDidToggleStrikethrough
{
	[self.richEditor toggleStrikethroughInRange:self.richEditor.qs_selectedTextRange];
}

//对齐
- (void)formatDidChangeTextAlignment:(CTTextAlignment)alignment
{
	UITextRange *range = self.richEditor.qs_selectedTextRange;
	[self.richEditor applyTextAlignment:alignment toParagraphsContainingRange:range];
}

//列表缩进
- (void)increaseTabulation
{
	UITextRange *range = self.richEditor.qs_selectedTextRange;
	[self.richEditor changeParagraphLeftMarginBy:36 toParagraphsContainingRange:range];
}

//撤销列表缩进
- (void)decreaseTabulation
{
	UITextRange *range = self.richEditor.qs_selectedTextRange;
	[self.richEditor changeParagraphLeftMarginBy:-36 toParagraphsContainingRange:range];
}

//设置序列样式
- (void)toggleListType:(DTCSSListStyleType)listType
{
	UITextRange *range = self.richEditor.qs_selectedTextRange;
	
	DTCSSListStyle *listStyle = [[DTCSSListStyle alloc] init];
	listStyle.startingItemNumber = 1;
	listStyle.type = listType;
	
	[self.richEditor toggleListStyle:listStyle inRange:range];
}

//设置超链接
- (void)insertHyperlink:(HyperlinkModel *)link
{
	UITextRange *range = self.richEditor.selectedTextRange;
    NSURL *url = [NSURL URLWithString:link.link];
    NSString *title = link.title;
    QSHyperlinkAttachment *linkAttachment = [[QSHyperlinkAttachment alloc]init];
    UIFont *buttonTextFont = [UIFont systemFontOfSize:15];
    linkAttachment.titleFont = buttonTextFont;
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 40, HUGE);
    CGSize textRect = [title sizeForFont:buttonTextFont size:maxSize mode:NSLineBreakByWordWrapping];
    linkAttachment.displaySize = textRect;
    linkAttachment.title = title;
    linkAttachment.hyperLinkURL = url;
    [self.richEditor replaceRange:range withAttachment:linkAttachment inParagraph:NO];
}

-(void)richTextEditorOpenMoreView {
    
    [self.editorToolBar setupTextCountItemWithCount:  self.richEditor.attributedText.plainTextString.length - 1];
    [self.richEditor setInputView:self.editorMoreView animated:YES];
}

-(void)richTextEditorCloseMoreView {
    [self.richEditor setInputView:nil animated:YES];
}

#pragma mark - QSRichTextEditorImageViewDelegate
//删除
-(void)editorViewDeleteImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment{
    DTTextRange *range = [self rangeOfAttachment:sender];
    [self.richEditor replaceRange:range withText:@""];
}

//编辑
-(void)editorViewEditImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment {
    [self rangeOfAttachment:sender];
}

//注释
-(void)editorViewCaptionImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment {
    self.currentEditingAttachment = attachment;
    QMUIDialogTextFieldViewController *captionInputController = [[QMUIDialogTextFieldViewController alloc]init];
    captionInputController.title = @"图片注释";
    captionInputController.headerViewHeight = 70;
    captionInputController.headerViewBackgroundColor = UIColorWhite;
    captionInputController.titleView.horizontalTitleFont = UIFontBoldMake(20);
    captionInputController.titleLabelFont = UIFontBoldMake(20);
    captionInputController.textField.placeholder = @"注释";
    [captionInputController addCancelButtonWithText:@"取消" block:nil];
    [captionInputController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *dialogViewController) {
        [dialogViewController hide];
        NSString *text = ((QMUIDialogTextFieldViewController *)dialogViewController).textField.text;
        DTImageCaptionAttachment *caption = [[DTImageCaptionAttachment alloc]init];
        UIFont *captionTitleFont = [UIFont systemFontOfSize:15];
        caption.titleFont = captionTitleFont;
        caption.text = text;
        CGFloat captionHeight = [text heightForFont:captionTitleFont width:SCREEN_WIDTH - 40];
        CGSize captionSize = CGSizeMake(SCREEN_WIDTH - 40, captionHeight);
        caption.displaySize = captionSize;
        attachment.captionAttachment = caption;
//        [self.richEditor attributedSubstringForRange:<#(UITextRange *)#>];
        [self.richEditor replaceRange:self.richEditor.selectedTextRange withAttachment:caption inParagraph:NO];
        [self.richEditor insertText:@"\n"];
    }];
    [captionInputController show];
}

//替换
-(void)editorViewReplaceImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment {
    DTImageTextAttachment *replaceAttachment = [[DTImageTextAttachment alloc] initWithElement:nil options:nil];
    attachment.image = (id)[UIImage qmui_imageWithColor:[UIColor qmui_randomColor]];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height / 3;
    CGSize size = CGSizeMake(w-40, h);
    attachment.displaySize = size;
    attachment.originalSize = size;
    
    DTTextRange *range = [self rangeOfAttachment:sender];
    [self.richEditor replaceRange:range withAttachment:replaceAttachment inParagraph:NO];
}

-(DTTextRange *)rangeOfAttachment:(UIButton *)sender {
    CGPoint touchPoint = [sender.superview convertPoint:sender.center toView:self.richEditor];
    DTTextPosition *touchPosition = (DTTextPosition *)[self.richEditor closestPositionToPoint:touchPoint];
    DTTextPosition *endPosition = (DTTextPosition *)[self.richEditor endOfDocument];
    
    QMUILog(@"closestPositionToPoint position %lu", (unsigned long)touchPosition.location);
    QMUILog(@"end docoment position %lu", (unsigned long)endPosition.location);
    
    DTTextPosition *finalPosition;
    if (touchPosition.location == endPosition.location) {
        finalPosition = [DTTextPosition textPositionWithLocation:touchPosition.location -1];
    } else {
        finalPosition = touchPosition;
    }
    
    DTTextRange *range = [DTTextRange rangeWithNSRange:NSMakeRange(finalPosition.location, 1)];
    return range;
}

#pragma mark - UIScrollView Delegate
//上下滑动取消键盘响应
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	self.state = QSRichEditorStateScrolling;
}

-(void)setSelectedRangeObserver {
    [self.richEditor addObserver:self forKeyPath:@"selectedTextRange" options:kNilOptions context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    BOOL isPrior = [[change objectForKey:NSKeyValueChangeNotificationIsPriorKey] boolValue];
    if (isPrior) return;
    
    NSKeyValueChange changeKind = [[change objectForKey:NSKeyValueChangeKindKey] integerValue];
    if (changeKind != NSKeyValueChangeSetting) return;
    
    id newVal = [change objectForKey:NSKeyValueChangeNewKey];
    if (newVal == [NSNull null]) newVal = nil;
    
    QMUILog(@"change selectedTextRange %@",newVal);
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
