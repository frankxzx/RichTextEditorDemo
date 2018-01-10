//
//  QSRIchTextBar.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextBar.h"
#import <QMUIKit/QMUIKit.h>
#import <YYText/YYText.h>
#import "QSRichEditorFontStyle.h"
#import "UIResponder+qs.h"
#import "NSAttributedString+qs.h"

@interface QSRichTextBar()

@property(nonatomic, assign) BOOL isAllowTextEdit;

@property(nonatomic, strong) UIBarButtonItem *textCountButton;

@end

@implementation QSRichTextBar

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
        self.blockquoteButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_blockquote")
                                                                selectedImage:[UIImageMake(@"toolbar_blockquote") qmui_imageWithTintColor:UIColorBlue]
                                                                       target:self action:@selector(setBlockquote)];
        self.moreButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_more") target:self action:@selector(openMoreView:)];
        self.textEditorCloseButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"toolbar_close") target:self action:@selector(endTextEditor)];
        self.moreViewCloseButton = [UIBarButtonItem qs_setBarButtonItemWithImage:UIImageMake(@"icon_close") target:self action:@selector(closeMoreView)];
        
        self.fontStyleButton.tag = QSRichEditorTextStyleNormal;
        self.alignButton.tag = NSTextAlignmentLeft;
        self.orderedListButton.tag = QSRichTextListTypeNone;
        
        [self setupTextCountItemWithCount:0];
        [self initEditorBarItems];
        [self.beginTextEditorButton qs_setEnable:NO];
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
        [self initEditorBarItems];
        return;
    }
    
    [self setItems:@[self.beginTextEditorButton,
                     self.boldButton,
                     self.italicButton,
                     self.strikeThroughButton,
                     self.textEditorCloseButton] animated:YES];
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
    
    if (sender.tag == NSTextAlignmentLeft) {
        sender.image = UIImageMake(@"toolbar_align_center").originalImage;
        sender.tag = NSTextAlignmentCenter;
    } else if (sender.tag == NSTextAlignmentCenter) {
        sender.image = UIImageMake(@"toolbar_align_right").originalImage;
        sender.tag = NSTextAlignmentRight;
    } else if (sender.tag == NSTextAlignmentRight) {
        sender.image = UIImageMake(@"toolbar_align_left").originalImage;
        sender.tag = NSTextAlignmentLeft;
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
    
    if (sender.tag == QSRichTextListTypeNone) {
        sender.image = UIImageMake(@"toolbar_order_number").originalImage;
        sender.tag = (NSInteger)QSRichTextListTypeDecimal;
    } else if (sender.tag == QSRichTextListTypeCircle) {
        sender.image = UIImageMake(@"toolbar_order").originalImage;
        sender.tag = (NSInteger)QSRichTextListTypeNone;
    } else if (sender.tag == QSRichTextListTypeDecimal) {
        sender.image = UIImageMake(@"toolbar_order_dot").originalImage;
        sender.tag = (NSInteger)QSRichTextListTypeCircle;
    }
    
    if ([self.formatDelegate respondsToSelector:@selector(formatDidToggleListStyle:)]) {
        [self.formatDelegate formatDidToggleListStyle:sender.tag];
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
    [self initEditorBarItems];
}

//插入图片
-(void)insertImage:(id)sender {
    if ([self.formatDelegate respondsToSelector:@selector(insertPhoto)]) {
        [self.formatDelegate insertPhoto];
    }
}

-(void)updateStateWithAttributedString:(NSAttributedString *)attributedText selectedRange:(NSRange)selectedRange {
    
    // range length 为 0 禁止选中
    [self.beginTextEditorButton qs_setEnable:selectedRange.length != 0];
    
    //选取选中样式
    if (selectedRange.location > attributedText.length) { return; }
    
    NSAttributedString *selectedAttributedText;
    if (selectedRange.location == attributedText.length) {
        //当选中 range 为末尾时,取前一个字符
        selectedAttributedText = [attributedText attributedSubstringFromRange:NSMakeRange(selectedRange.location-1, 1)];
    } else if (selectedRange.length == 0) {
        //当选中 range length 为 0 时,取后面一个字符
        selectedAttributedText = [attributedText attributedSubstringFromRange:NSMakeRange(selectedRange.location, 1)];
    } else {
        //正常选中 range
        selectedAttributedText = [attributedText attributedSubstringFromRange:selectedRange];
    }
    
    BOOL isBold = [selectedAttributedText isBold];
    BOOL isItalic = [selectedAttributedText isItalic];
    BOOL isStrikeThrough = [selectedAttributedText isStrikeThrough];
    
    [self.boldButton qs_setSelected:isBold];
    [self.italicButton qs_setSelected:isItalic];
    [self.strikeThroughButton qs_setSelected:isStrikeThrough];
    
    QSRichEditorTextStyle textStyle = [selectedAttributedText qsStyle];
    switch (textStyle) {
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
    
    NSTextAlignment alignment = attributedText.yy_alignment;
    if (alignment == NSTextAlignmentLeft) {
        self.alignButton.image = UIImageMake(@"toolbar_align_center").originalImage;
        self.alignButton.tag = NSTextAlignmentCenter;
    } else if (alignment == NSTextAlignmentCenter) {
        self.alignButton.image = UIImageMake(@"toolbar_align_right").originalImage;
        self.alignButton.tag = NSTextAlignmentRight;
    } else if (alignment == NSTextAlignmentRight) {
        self.alignButton.image = UIImageMake(@"toolbar_align_left").originalImage;
        self.alignButton.tag = NSTextAlignmentLeft;
    }
}

-(void)setListType:(QSRichTextListStyleType)listType {
    self.orderedListButton.tag = listType;
    switch (listType) {
        case QSRichTextListTypeNone:
            self.orderedListButton.image = UIImageMake(@"toolbar_order").originalImage;
            break;
        case QSRichTextListTypeDecimal:
            self.orderedListButton.image = UIImageMake(@"toolbar_order_number").originalImage;
            break;
        case QSRichTextListTypeCircle:
            self.orderedListButton.image = UIImageMake(@"toolbar_order_dot").originalImage;
            break;
    }
}

-(BOOL)isTextEditor {
    return  [self.items containsObject:self.textEditorCloseButton];
}

@end
