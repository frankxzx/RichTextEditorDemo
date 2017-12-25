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
#import "UIBarButtonItem+qs.h"
#import "QSRichEditorFontStyle.h"

@interface RichTextEditorToolBar()

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation RichTextEditorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.beginTextEditorButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_style" target:self action:@selector(beginTextEditor:)];
        self.fontStyleButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_font_style1" target:self action:@selector(setFontStyle:)];
        self.boldButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_bold" target:self action:@selector(setBold)];
        self.italicButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_italic" target:self action:@selector(setItalic)];
        self.strikeThroughButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_strikethrough" target:self action:@selector(setStrikeThrough)];
        self.alignButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_align_left" target:self action:@selector(align:)];
        self.orderedListButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_order" target:self action:@selector(setOrderedList:)];
        self.photoButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_image" target:self action:@selector(insertImage:)];
        self.blockquoteButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_blockquote" target:self action:@selector(setBlockquote)];
        self.moreButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_more" target:self action:@selector(openMoreView:)];
        self.textEditorCloseButton = [UIBarButtonItem qs_setBarButtonItem:@"toolbar_close" target:self action:@selector(endTextEditor)];
        self.moreViewCloseButton = [UIBarButtonItem qs_setBarButtonItem:@"icon_close" target:self action:@selector(closeMoreView)];
        
        self.fontStyleButton.tag = QSRichEditorTextStyleNormal;
        self.alignButton.tag = kCTTextAlignmentLeft;
        self.orderedListButton.tag = DTCSSListStyleTypeNone;
        
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
        sender.image = [UIImageMake(@"toolbar_font_style2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = QSRichEditorTextStyleLarger;
    } else if (sender.tag == QSRichEditorTextStyleLarger) {
        sender.image = [UIImageMake(@"toolbar_font_style3") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = QSRichEditorTextStylePlaceholder;
    } else if (sender.tag == QSRichEditorTextStylePlaceholder) {
        sender.image = [UIImageMake(@"toolbar_font_style1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = QSRichEditorTextStyleNormal;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidSelectTextStyle:)]) {
        [self.formatDelegate formatDidSelectTextStyle:sender.tag];
    }
}

//对齐方式
- (void)align:(UIBarButtonItem *)sender {
    
    if (sender.tag == kCTTextAlignmentLeft) {
        sender.image = [UIImageMake(@"toolbar_align_center") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = kCTTextAlignmentCenter;
    } else if (sender.tag == kCTTextAlignmentCenter) {
        sender.image = [UIImageMake(@"toolbar_align_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = kCTTextAlignmentRight;
    } else if (sender.tag == kCTTextAlignmentRight) {
        sender.image = [UIImageMake(@"toolbar_align_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = kCTTextAlignmentLeft;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidChangeTextAlignment:)]) {
        [self.formatDelegate formatDidChangeTextAlignment:sender.tag];
    }
}

//加粗
- (void)setBold {
    self.boldButton.image = [self.boldButton.image qmui_imageWithTintColor:UIColorBlue];
    self.italicButton.image = self.italicButton.originalImage;
    self.strikeThroughButton.image = self.strikeThroughButton.originalImage;
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBold)]) {
        [self.formatDelegate formatDidToggleBold];
    }
}

//斜体
- (void)setItalic {
    self.boldButton.image = self.boldButton.originalImage;
    self.italicButton.image = [self.italicButton.image qmui_imageWithTintColor:UIColorBlue];
    self.strikeThroughButton.image = self.strikeThroughButton.originalImage;
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleItalic)]) {
        [self.formatDelegate formatDidToggleItalic];
    }
}

//下滑线
- (void)setUnderline {
    self.boldButton.image = self.boldButton.originalImage;
    self.italicButton.image = self.italicButton.originalImage;
    self.strikeThroughButton.image = [self.strikeThroughButton.image qmui_imageWithTintColor:UIColorBlue];
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleUnderline)]) {
        [self.formatDelegate formatDidToggleUnderline];
    }
}

//中划线
- (void)setStrikeThrough {
    self.boldButton.image = self.boldButton.originalImage;
    self.italicButton.image = self.italicButton.originalImage;
    self.strikeThroughButton.image = [self.strikeThroughButton.image qmui_imageWithTintColor:UIColorBlue];
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleStrikethrough)]) {
        [self.formatDelegate formatDidToggleStrikethrough];
    }
}

//排序
- (void)setOrderedList:(UIBarButtonItem *)sender {
    
    if (sender.tag == DTCSSListStyleTypeNone) {
        sender.image = [UIImageMake(@"toolbar_order_number") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = (NSInteger)DTCSSListStyleTypeDecimal;
    } else if (sender.tag == DTCSSListStyleTypeCircle) {
        sender.image = [UIImageMake(@"toolbar_order") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = (NSInteger)DTCSSListStyleTypeNone;
    } else if (sender.tag == DTCSSListStyleTypeDecimal) {
        sender.image = [UIImageMake(@"toolbar_order_dot") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        sender.tag = (NSInteger)DTCSSListStyleTypeCircle;
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
-(void)closeMoreView {
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

-(void)updateStateWithTypingAttributes:(NSDictionary *)attributes {
    BOOL isBlod = attributes.isBold;
    BOOL isItalic = attributes.isItalic;
    BOOL isStrikeThrough = attributes.isStrikethrough;
    
    QSRichEditorFontStyle *fontStyle = attributes[@"QSRichEditorFontStyle"];
    switch (fontStyle.style) {
        case QSRichEditorTextStylePlaceholder:
            self.fontStyleButton.image = [UIImageMake(@"toolbar_font_style1") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
            
        case QSRichEditorTextStyleNormal:
            self.fontStyleButton.image = [UIImageMake(@"toolbar_font_style2") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
            
        case QSRichEditorTextStyleLarger:
            self.fontStyleButton.image = [UIImageMake(@"toolbar_font_style3") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
    }
    
    NSArray *styles = attributes[@"DTTextLists"];
    DTCSSListStyle *listStyle = styles.firstObject;
    if (listStyle) {
        switch (listStyle.type) {
            case DTCSSListStyleTypeNone:
                self.orderedListButton.image = [UIImageMake(@"toolbar_order") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            case DTCSSListStyleTypeDecimal:
                self.orderedListButton.image = [UIImageMake(@"toolbar_order_number") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            case DTCSSListStyleTypeCircle:
                self.orderedListButton.image = [UIImageMake(@"toolbar_order_dot") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                break;
                
            default:
                break;
        }
    } else {
        self.orderedListButton.image = [UIImageMake(@"toolbar_order") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    CTTextAlignment alignmanet = attributes.paragraphStyle.alignment;
    switch (alignmanet) {
        case kCTTextAlignmentLeft:
            self.alignButton.image = [UIImageMake(@"toolbar_align_left") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
            
        case kCTTextAlignmentRight:
            self.alignButton.image = [UIImageMake(@"toolbar_align_right") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
            
        case kCTTextAlignmentCenter:
            self.alignButton.image = [UIImageMake(@"toolbar_align_center") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            break;
        default: break;
    }
    
    if (isBlod) {
        self.boldButton.image = [self.boldButton.image qmui_imageWithTintColor:UIColorBlue];
        self.italicButton.image = self.italicButton.originalImage;
        self.strikeThroughButton.image = self.strikeThroughButton.originalImage;
    } else if (isItalic) {
        self.boldButton.image = self.boldButton.originalImage;
        self.italicButton.image = [self.italicButton.image qmui_imageWithTintColor:UIColorBlue];
        self.strikeThroughButton.image = self.strikeThroughButton.originalImage;
    } else if (isStrikeThrough) {
        self.boldButton.image = self.boldButton.originalImage;
        self.italicButton.image = self.italicButton.originalImage;
        self.strikeThroughButton.image = [self.strikeThroughButton.image qmui_imageWithTintColor:UIColorBlue];
    }
}

-(BOOL)isTextEditor {
    return  [self.items containsObject:self.textEditorCloseButton];
}

#pragma mark - Lazy subviews

#pragma mark - Helpers

@end
