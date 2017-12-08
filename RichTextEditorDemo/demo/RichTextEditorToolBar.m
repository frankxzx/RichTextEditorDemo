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
@property(nonatomic, strong) UIBarButtonItem *closeButton;

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation RichTextEditorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.beginTextEditorButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_style") target:self action:@selector(beginTextEditor)];
        self.fontStyleButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_font_style1") target:self action:@selector(setFontStyle:)];
		self.boldButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_bold") target:self action:@selector(setBold)];
		self.italicButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_italic") target:self action:@selector(setItalic)];
		self.strikeThroughButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_strikethrough") target:self action:@selector(setUnderline)];
		
		self.alignButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_align_left") target:self action:@selector(align:)];
		
		self.orderedListButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_order") target:self action:@selector(setOrderedList:)];
		
		self.photoButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_image") target:self action:@selector(setBold)];
		self.blockquoteButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_blockquote") target:self action:@selector(setBlockquote)];
		
		self.moreButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_more") target:self action:@selector(setBlockquote)];
		self.closeButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_close") target:self action:@selector(endTextEditor)];
		
		UILabel *label = [[UILabel alloc]init];
		label.attributedText = [[NSAttributedString alloc] initWithString:@"0 字" attributes:@{NSFontAttributeName: UIFontMake(12), NSForegroundColorAttributeName: UIColorGray, NSParagraphStyleAttributeName: [NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:16 lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentCenter]}];
		[label sizeToFit];
		
		self.textCountButton = [[UIBarButtonItem alloc]initWithCustomView:label];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
		
		[self setItems:@[flexibleSpace,
                         self.beginTextEditorButton,
						 self.fontStyleButton,
						 self.alignButton,
						 self.blockquoteButton,
						 self.orderedListButton,
						 self.photoButton,
						 self.moreButton,
                         flexibleSpace]];
	}
	return self;
}

-(void)beginTextEditor {
	[self setItems:@[self.beginTextEditorButton,
					 self.boldButton,
					 self.italicButton,
					 self.strikeThroughButton,
					 self.closeButton] animated:YES];
}

-(void)endTextEditor {
	[self setItems:@[self.beginTextEditorButton,
					 self.boldButton,
					 self.italicButton,
					 self.strikeThroughButton,
					 self.closeButton] animated:YES];
}

//一共三种默认的字体样式
-(void)setFontStyle:(UIBarButtonItem *)sender {
    if ([self.formatDelegate respondsToSelector:@selector(formatDidSelectTextStyle:)]) {
        [self.formatDelegate formatDidSelectTextStyle:sender.tag];
    }
}

//对齐方式
- (void)align:(UIBarButtonItem *)sender {
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
}

//关闭
-(void)closeMoreView:(id)sender {
    if ([self.formatDelegate respondsToSelector:@selector(richTextEditorCloseMoreView)]) {
        [self.formatDelegate richTextEditorCloseMoreView];
    }
}

#pragma mark - Lazy subviews

#pragma mark - Helpers

@end
