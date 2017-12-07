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
		self.fontStyleButton = [QMUIToolbarButton barButtonItemWithImage:UIImageMake(@"toolbar_font_style1") target:self action:@selector(setFontStyle)];
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
		
		[self setItems:@[self.beginTextEditorButton,
						 self.fontStyleButton,
						 self.alignButton,
						 self.blockquoteButton,
						 self.orderedListButton,
						 self.photoButton,
						 self.moreButton]];
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

-(void)setFontStyle {
	
}

- (void)align:(UIBarButtonItem *)sender {

}

- (void)setBold {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBold)]) {
		[self.formatDelegate formatDidToggleBold];
	}
}

- (void)setItalic {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleItalic)]) {
		[self.formatDelegate formatDidToggleItalic];
	}
}

- (void)setUnderline {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleUnderline)]) {
		[self.formatDelegate formatDidToggleUnderline];
	}
}

- (void)setOrderedList:(UIBarButtonItem *)sender {
	if ([self.formatDelegate respondsToSelector:@selector(toggleListType:)]) {
		[self.formatDelegate toggleListType:sender.tag];
	}
}

-(void)setBlockquote {
	if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBlockquote)]) {
		[self.formatDelegate formatDidToggleBlockquote];
	}
}

#pragma mark - Lazy subviews

#pragma mark - Helpers

@end
