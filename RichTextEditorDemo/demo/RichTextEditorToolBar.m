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

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation RichTextEditorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
        
        self.beginTextEditorButton = [self setBarButtonItem:@"toolbar_style" action:@selector(beginTextEditor:)];
        self.fontStyleButton = [self setBarButtonItem:@"toolbar_font_style1" action:@selector(setFontStyle:)];
        self.boldButton = [self setBarButtonItem:@"toolbar_bold" action:@selector(setBold)];
        self.italicButton = [self setBarButtonItem:@"toolbar_italic" action:@selector(setItalic)];
        self.strikeThroughButton = [self setBarButtonItem:@"toolbar_strikethrough" action:@selector(setUnderline)];
        self.alignButton = [self setBarButtonItem:@"toolbar_align_left" action:@selector(align:)];
        self.orderedListButton = [self setBarButtonItem:@"toolbar_order" action:@selector(setOrderedList:)];
        self.photoButton = [self setBarButtonItem:@"toolbar_image" action:@selector(insertImage:)];
        self.blockquoteButton = [self setBarButtonItem:@"toolbar_blockquote" action:@selector(setBlockquote)];
        self.moreButton = [self setBarButtonItem:@"toolbar_more" action:@selector(openMoreView:)];
        self.textEditorCloseButton = [self setBarButtonItem:@"toolbar_close" action:@selector(endTextEditor)];
        self.moreViewCloseButton = [self setBarButtonItem:@"icon_close" action:@selector(closeMoreView:)];
        
        self.fontStyleButton.tag = QSRichEditorTextStyleNormal;
        self.alignButton.tag = kCTTextAlignmentLeft;
        self.orderedListButton.tag = DTCSSListStyleTypeNone;
		
        [self setupTextCountItemWithCount:0];
        [self initEditorBarItems];
	}
	return self;
}

-(UIBarButtonItem *)setBarButtonItem:(NSString *)imageName action:(SEL)selector {
    return [QMUIToolbarButton barButtonItemWithImage:[UIImageMake(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] target:self action:selector];
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

//中划线
- (void)setStrikeThrough {
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleStrikethrough)]) {
        [self.formatDelegate formatDidToggleStrikethrough];
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
