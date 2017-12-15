//
//  RichTextEditorToolBar.m
//  Demo App
//
//  Created by Xuzixiang on 2017/12/5.
//  Copyright © 2017年 Cocoanetics. All rights reserved.
//

#import "RichTextEditorToolBar.h"
#import "RichTextEditorAction.h"
#import <QMUIKit/QMUIKit.h>
#import <YYText/YYText.h>

@interface RichTextEditorToolBar()

// font
@property(nonatomic, strong) UIBarButtonItem *beginTextEditorButton;
@property(nonatomic, strong) UIBarButtonItem *boldButton;
@property(nonatomic, strong) UIBarButtonItem *italicButton;
@property(nonatomic, strong) UIBarButtonItem *strikeThroughButton;

//目前一共提供了三种样式
@property(nonatomic, strong) UIBarButtonItem *fontStyleButton;

// paragraph alignment
@property(nonatomic, strong) UIBarButtonItem *alignButton;

@property(nonatomic, strong) UIBarButtonItem *blockquoteButton;

// lists
@property(nonatomic, strong) UIBarButtonItem *orderedListButton;

//插入照片
@property(nonatomic, strong) UIBarButtonItem *photoButton;

//展开
@property(nonatomic, strong) UIBarButtonItem *moreButton;

//关闭
@property(nonatomic, strong) UIBarButtonItem *textEditorCloseButton;
@property(nonatomic, strong) UIBarButtonItem *moreViewCloseButton;

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation RichTextEditorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
        self.beginTextEditorButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_style") target:self action:@selector(beginTextEditor:)];
        self.fontStyleButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_font_style1") target:self action:@selector(setFontStyle:)];
        self.fontStyleButton.tag = QSRichEditorTextStyleNormal;
        
		self.boldButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_bold") target:self action:@selector(setBold)];
		self.italicButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_italic") target:self action:@selector(setItalic)];
		self.strikeThroughButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_strikethrough") target:self action:@selector(setUnderline)];
		
		self.alignButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_align_left") target:self action:@selector(align:)];
        self.alignButton.tag = kCTTextAlignmentLeft;
		
		self.orderedListButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_order") target:self action:@selector(setOrderedList:)];
        self.orderedListButton.tag = DTCSSListStyleTypeNone;
		
		self.photoButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_image") target:self action:@selector(insertImage:)];
		self.blockquoteButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_blockquote") target:self action:@selector(setBlockquote)];
		
        self.moreButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_more") target:self action:@selector(openMoreView:)];
		self.textEditorCloseButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_close") target:self action:@selector(endTextEditor)];
        self.moreViewCloseButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"icon_close") target:self action:@selector(closeMoreView:)];
		
        [self setupTextCountItemWithCount:0];
        [self initEditorBarItems];
	}
	return self;
}

-(void)setupTextCountItemWithCount:(NSUInteger)count {
    UILabel *label = [[UILabel alloc]init];
    NSString *countString = [NSString stringWithFormat:@"%lu",(unsigned long)count];
    NSMutableAttributedString *textCountString = [[NSMutableAttributedString alloc] initWithString:countString attributes:@{NSFontAttributeName: UIFontBoldMake(20), NSForegroundColorAttributeName: UIColorBlack, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
    NSMutableAttributedString *zi = [[NSMutableAttributedString alloc] initWithString:@"字" attributes:@{NSFontAttributeName: UIFontMake(15), NSForegroundColorAttributeName: UIColorGray}];
    [textCountString appendAttributedString: zi];
    [textCountString yy_setKern:@8 range:NSMakeRange(countString.length-1, 1)];
    label.attributedText = textCountString;
    [label sizeToFit];
    
    self.textCountButton = [[UIBarButtonItem alloc]initWithCustomView:label];
}

-(void)initEditorBarItems {
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setItems:@[self.beginTextEditorButton,
                     flexibleSpace,
                     self.fontStyleButton,
                     flexibleSpace,
                     self.alignButton,
                     flexibleSpace,
                     self.blockquoteButton,
                     flexibleSpace,
                     self.orderedListButton,
                     flexibleSpace,
                     self.photoButton,
                     flexibleSpace,
                     self.moreButton] animated:YES];
}

-(void)beginTextEditor:(UIBarButtonItem *)sender {
    if ([self isTextEditor]) {
        [self endTextEditor];
        return;
    }

	[self setItems:@[self.beginTextEditorButton,
					 self.boldButton,
					 self.italicButton,
					 self.strikeThroughButton,
					 self.textEditorCloseButton] animated:YES];
}

-(void)endTextEditor {
	[self initEditorBarItems];
}

-(void)editorMoreViewToolBarItems {
     UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self setItems:@[self.textCountButton, flexibleSpace, self.moreViewCloseButton] animated:YES];
}

//一共三种默认的字体样式
-(void)setFontStyle:(UIBarButtonItem *)sender {
    
    if (sender.tag == QSRichEditorTextStyleNormal) {
        sender.image = UIImageMake(@"toolbar_font_style2");
        sender.tag = QSRichEditorTextStyleLarger;
    } else if (sender.tag == QSRichEditorTextStyleLarger) {
        sender.image = UIImageMake(@"toolbar_font_style3");
        sender.tag = QSRichEditorTextStylePlaceholder;
    } else if (sender.tag == QSRichEditorTextStylePlaceholder) {
        sender.image = UIImageMake(@"toolbar_font_style1");
        sender.tag = QSRichEditorTextStyleNormal;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidSelectTextStyle:)]) {
        [self.formatDelegate formatDidSelectTextStyle:sender.tag];
    }
}

//对齐方式
- (void)align:(UIBarButtonItem *)sender {
    
    if (sender.tag == kCTTextAlignmentLeft) {
        sender.image = UIImageMake(@"toolbar_align_center");
        sender.tag = kCTTextAlignmentCenter;
    } else if (sender.tag == kCTTextAlignmentCenter) {
        sender.image = UIImageMake(@"toolbar_align_right");
        sender.tag = kCTTextAlignmentRight;
    } else if (sender.tag == kCTTextAlignmentRight) {
        sender.image = UIImageMake(@"toolbar_align_left");
        sender.tag = kCTTextAlignmentLeft;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidChangeTextAlignment:)]) {
        [self.formatDelegate formatDidChangeTextAlignment:sender.tag];
    }
}

//加粗
- (void)setBold {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBold)]) {
		[self.formatDelegate formatDidToggleBold];
	}
}

//斜体
- (void)setItalic {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleItalic)]) {
		[self.formatDelegate formatDidToggleItalic];
	}
}

//下滑线
- (void)setUnderline {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleUnderline)]) {
		[self.formatDelegate formatDidToggleUnderline];
	}
}

//排序
- (void)setOrderedList:(UIBarButtonItem *)sender {
    
    if (sender.tag == DTCSSListStyleTypeNone) {
        sender.image = UIImageMake(@"toolbar_order_number");
        sender.tag = DTCSSListStyleTypeDecimal;
    } else if (sender.tag == DTCSSListStyleTypeCircle) {
        sender.image = UIImageMake(@"toolbar_order");
        sender.tag = DTCSSListStyleTypeNone;
    } else if (sender.tag == DTCSSListStyleTypeDecimal) {
        sender.image = UIImageMake(@"toolbar_order_dot");
        sender.tag = DTCSSListStyleTypeCircle;
    }
    
	if ([self.formatDelegate respondsToSelector:@selector(toggleListType:)]) {
		[self.formatDelegate toggleListType:sender.tag];
	}
}

//引用
-(void)setBlockquote {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBlockquote)]) {
		[self.formatDelegate formatDidToggleBlockquote];
	}
}

//打开
-(void)openMoreView:(id)sender {
    if ([self.formatDelegate respondsToSelector:@selector(richTextEditorOpenMoreView)]) {
        [self.formatDelegate richTextEditorOpenMoreView];
    }
    [self editorMoreViewToolBarItems];
}

//关闭
-(void)closeMoreView:(id)sender {
    [self initEditorBarItems];
    if ([self.formatDelegate respondsToSelector:@selector(richTextEditorCloseMoreView)]) {
        [self.formatDelegate richTextEditorCloseMoreView];
    }
}

//插入图片
-(void)insertImage:(id)sender {
    if ([self.formatDelegate respondsToSelector:@selector(replaceCurrentSelectionWithPhoto)]) {
        [self.formatDelegate replaceCurrentSelectionWithPhoto];
    }
}

-(BOOL)isTextEditor {
    return  [self.items containsObject:self.textEditorCloseButton];
}

#pragma mark - Lazy subviews

#pragma mark - Helpers

@end
