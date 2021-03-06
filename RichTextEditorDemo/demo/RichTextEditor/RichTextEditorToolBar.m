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
#import "UIResponder+qs.h"

@interface RichTextEditorToolBar()

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation RichTextEditorToolBar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.beginTextEditorButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_style").originalImage target:self action:@selector(beginTextEditor:)];;
        self.fontStyleButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_font_style1") target:self action:@selector(setFontStyle:)];
        
        self.boldButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_bold")
                                                          selectedImage:[UIImageMake(@"toolbar_bold") qmui_imageWithTintColor:UIColorBlue]
                                                                 target:self action:@selector(setBold)];
        
        self.italicButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_italic")
                                                                 selectedImage:[UIImageMake(@"toolbar_italic") qmui_imageWithTintColor:UIColorBlue]
                                                                   target:self
                                                                   action:@selector(setItalic)];
        
        self.strikeThroughButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_strikethrough")
                                                                        selectedImage:[UIImageMake(@"toolbar_strikethrough") qmui_imageWithTintColor:UIColorBlue]
                                                                          target:self action:@selector(setStrikeThrough)];
        
        self.alignButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_align_left") target:self action:@selector(align:)];
        self.orderedListButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_order") target:self action:@selector(setOrderedList:)];
        self.photoButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_image") target:self action:@selector(insertImage:)];
        self.blockquoteButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_blockquote") target:self action:@selector(setBlockquote)];
        self.moreButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_more") target:self action:@selector(openMoreView:)];
        self.textEditorCloseButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_close") target:self action:@selector(endTextEditor)];
        self.moreViewCloseButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"icon_close") target:self action:@selector(closeMoreView)];
        
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
    //先关闭 『更多』
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
        sender.image = UIImageMake(@"toolbar_font_style2").originalImage;
        sender.tag = QSRichEditorTextStyleLarger;
    } else if (sender.tag == QSRichEditorTextStyleLarger) {
        sender.image = UIImageMake(@"toolbar_font_style3").originalImage;
        sender.tag = QSRichEditorTextStylePlaceholder;
    } else if (sender.tag == QSRichEditorTextStylePlaceholder) {
        sender.image = UIImageMake(@"toolbar_font_style1").originalImage;
        sender.tag = QSRichEditorTextStyleNormal;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidSelectTextStyle:)]) {
        [self.formatDelegate formatDidSelectTextStyle:sender.tag];
    }
}

//对齐方式
- (void)align:(UIBarButtonItem *)sender {
    
    if (sender.tag == kCTTextAlignmentLeft) {
        sender.image = UIImageMake(@"toolbar_align_center").originalImage;
        sender.tag = kCTTextAlignmentCenter;
    } else if (sender.tag == kCTTextAlignmentCenter) {
        sender.image = UIImageMake(@"toolbar_align_right").originalImage;
        sender.tag = kCTTextAlignmentRight;
    } else if (sender.tag == kCTTextAlignmentRight) {
        sender.image = UIImageMake(@"toolbar_align_left").originalImage;
        sender.tag = kCTTextAlignmentLeft;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidChangeTextAlignment:)]) {
        [self.formatDelegate formatDidChangeTextAlignment:sender.tag];
    }
}

//加粗
- (void)setBold {
    
    [self initEditorBarItems];
    
    [self.boldButton qs_setSelected:YES];
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleBold)]) {
        [self.formatDelegate formatDidToggleBold];
    }
}

//斜体
- (void)setItalic {
    
    [self initEditorBarItems];
    
    [self.italicButton qs_setSelected:YES];
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleItalic)]) {
        [self.formatDelegate formatDidToggleItalic];
    }
}

//中划线
- (void)setStrikeThrough {
    
    [self initEditorBarItems];
    
    [self.strikeThroughButton qs_setSelected:YES];
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleStrikethrough)]) {
        [self.formatDelegate formatDidToggleStrikethrough];
    }
}

//排序
- (void)setOrderedList:(UIBarButtonItem *)sender {
    
    if (sender.tag == DTCSSListStyleTypeNone) {
        sender.image = UIImageMake(@"toolbar_order_number").originalImage;
        sender.tag = (NSInteger)DTCSSListStyleTypeDecimal;
    } else if (sender.tag == DTCSSListStyleTypeCircle) {
        sender.image = UIImageMake(@"toolbar_order").originalImage;
        sender.tag = (NSInteger)DTCSSListStyleTypeNone;
    } else if (sender.tag == DTCSSListStyleTypeDecimal) {
        sender.image = UIImageMake(@"toolbar_order_dot").originalImage;
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
    if (fontStyle) {
        switch (fontStyle.style) {
            case QSRichEditorTextStyleNormal:
                self.fontStyleButton.image = UIImageMake(@"toolbar_font_style1").originalImage;
                break;
                
            case QSRichEditorTextStylePlaceholder:
                self.fontStyleButton.image = UIImageMake(@"toolbar_font_style2").originalImage;
                break;
                
            case QSRichEditorTextStyleLarger:
                self.fontStyleButton.image = UIImageMake(@"toolbar_font_style3").originalImage;
                break;
        }
    } else {
         self.fontStyleButton.image = UIImageMake(@"toolbar_font_style1").originalImage;
    }
    
    NSArray *styles = attributes[@"DTTextLists"];
    DTCSSListStyle *listStyle = styles.firstObject;
    if (listStyle) {
        switch (listStyle.type) {
            case DTCSSListStyleTypeNone:
                self.orderedListButton.image = UIImageMake(@"toolbar_order").originalImage;
                break;
                
            case DTCSSListStyleTypeDecimal:
                self.orderedListButton.image = UIImageMake(@"toolbar_order_number").originalImage;
                break;
                
            case DTCSSListStyleTypeCircle:
                self.orderedListButton.image = UIImageMake(@"toolbar_order_dot").originalImage;
                break;
                
            default:
                break;
        }
        [self.photoButton qs_setEnable:NO];
    } else {
        self.orderedListButton.image = UIImageMake(@"toolbar_order").originalImage;
        [self.photoButton qs_setEnable:YES];
    }
    
    CTTextAlignment alignmanet = attributes.paragraphStyle.alignment;
    switch (alignmanet) {
        case kCTTextAlignmentLeft:
            self.alignButton.image = UIImageMake(@"toolbar_align_left").originalImage;
            break;
            
        case kCTTextAlignmentRight:
            self.alignButton.image = UIImageMake(@"toolbar_align_right").originalImage;
            break;
            
        case kCTTextAlignmentCenter:
            self.alignButton.image = UIImageMake(@"toolbar_align_center").originalImage;
            break;
        default: break;
    }
    
    [self.boldButton qs_setSelected:isBlod];
    [self.italicButton qs_setSelected:isItalic];
    [self.strikeThroughButton qs_setSelected:isStrikeThrough];
    
    UIResponder *currentFirstResponder = [UIResponder currentFirstResponder];
    if ([currentFirstResponder isKindOfClass:NSClassFromString(@"QSTextBlockView")]) {
        [self.alignButton qs_setEnable:NO];
    } else {
        [self.alignButton qs_setEnable:NO];
    }
    
}

-(BOOL)isTextEditor {
    return  [self.items containsObject:self.textEditorCloseButton];
}

@end
