//
//  QSRichTextBaseWordCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/4.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextBaseWordCell.h"
#import "QSRichTextMoreView.h"
#import "QSRichTextAttributes.h"
#import "QSTextFieldsViewController.h"
#import "NSString+YYAdd.h"

@interface QSRichTextBaseWordCell ()

@property(nonatomic, strong, readwrite) QSRichTextView * textView;

@end

@implementation QSRichTextBaseWordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    [self.contentView addSubview:self.textView];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.textView.scrollEnabled = NO;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentLabelWidth = self.contentView.qmui_width;
    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    CGFloat textCellHeight = textViewSize.height;
    textCellHeight = MAX(50, textCellHeight);
    self.textView.frame = CGRectFlatMake(0, 0, contentLabelWidth, textCellHeight);
}

-(CGSize)sizeThatFits:(CGSize)size {
    
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat resultHeight = 0;
    CGSize contentSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.bounds), CGFLOAT_MAX)];
    resultHeight += contentSize.height;
    resultSize.height = resultHeight;
    return resultSize;
}

- (void)renderRichText:(NSAttributedString *)text {
    
    self.textView.attributedText = text;
    self.textView.textAlignment = NSTextAlignmentLeft;
    [self setNeedsLayout];
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (!textString.qmui_trim && textString.qmui_trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByTruncatingTail]}];
    return attriString;
}

-(QSRichTextView *)textView {
    if (!_textView) {
        _textView = [QSRichTextView new];
        _textView.scrollEnabled = NO;
        _textView.delegate = self;
    }
    return _textView;
}

-(void)setQs_delegate:(id<QSRichTextWordCellDelegate>)qs_delegate {
    self.textView.qs_delegate = qs_delegate;
    _qs_delegate = qs_delegate;
}

#pragma mark -
#pragma mark YYTextViewDelegate
-(void)textViewDidChange:(YYTextView *)textView {
    if (self.qs_delegate && [self.qs_delegate respondsToSelector:@selector(qsTextViewDidChangeText:)]) {
        [self.qs_delegate qsTextViewDidChangeText:(QSRichTextView *)textView];
    }
    [self handleTextChanged:self.textView];
}

-(void)textViewDidChangeSelection:(YYTextView *)textView {
    if (self.qs_delegate && [self.qs_delegate respondsToSelector:@selector(qsTextViewDidChanege:selectedRange:)]) {
        [self.qs_delegate qsTextViewDidChanege:(QSRichTextView *)textView selectedRange:textView.selectedRange];
    }
}

-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (self.qs_delegate && [self.qs_delegate respondsToSelector:@selector(qsTextView:shouldChangeTextInRange:replacementText:)]) {
      return [self.qs_delegate qsTextView:(QSRichTextView *)textView shouldChangeTextInRange:range replacementText:text];
    }
    return NO;
}

-(void)textViewDidBeginEditing:(YYTextView *)textView {
    NSRange selectedRange = NSMakeRange(textView.text.length, 0);
    textView.selectedTextRange = [YYTextRange rangeWithRange:selectedRange];
}

- (void)handleTextChanged:(id)sender {
    
    QSRichTextView *textView = nil;
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        id object = ((NSNotification *)sender).object;
        if (object == self) {
            textView = (QSRichTextView *)object;
        }
    } else if ([sender isKindOfClass:[QSRichTextView class]]) {
        textView = (QSRichTextView *)sender;
    }
    
    if (textView) {
        
        CGFloat resultHeight = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.bounds), CGFLOAT_MAX)].height;
        CGFloat oldValue = CGRectGetHeight(self.contentView.bounds);
        
        NSLog(@"handleTextDidChange, text = %@, resultHeight = %f old value = %f", textView.text, resultHeight, oldValue);
        
        // 通知delegate去更新textView的高度
        if ([textView.qs_delegate respondsToSelector:@selector(qsTextView:newHeightAfterTextChanged:)] && resultHeight != oldValue) {
            [textView.qs_delegate qsTextView:self.textView newHeightAfterTextChanged:resultHeight];
        }
    }
}

#pragma mark -
#pragma mark QSRichTextEditorFormat

//当前设置了三种默认字体的样式
-(void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style {
    [self.qs_delegate formatDidSelectTextStyle:style];
}

//加粗
- (void)formatDidToggleBold {
    [self.qs_delegate formatDidToggleBold];
}

//斜体
- (void)formatDidToggleItalic {
    [self.qs_delegate formatDidToggleItalic];
}

//中划线
- (void)formatDidToggleStrikethrough {
    [self.qs_delegate formatDidToggleStrikethrough];
}

//对齐
- (void)formatDidChangeTextAlignment:(NSTextAlignment)alignment {
    [self.qs_delegate formatDidChangeTextAlignment:alignment];
}

//设置序列样式
- (void)formatDidToggleListStyle:(QSRichTextListStyleType)listType {
    [self.qs_delegate formatDidToggleListStyle:listType];
}

-(void)formatDidToggleBlockquote {
    [self.qs_delegate formatDidToggleBlockquote];
}

//设置超链接
- (void)insertHyperlink {
    [self didInsertHyperlink:nil];
}


-(void)didInsertHyperlink:(QSRichTextHyperlink *)link {
    QSTextFieldsViewController *dialogViewController = [[QSTextFieldsViewController alloc] init];
    dialogViewController.headerViewHeight = 70;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.title = @"超链接";
    dialogViewController.titleView.horizontalTitleFont = UIFontBoldMake(20);
    dialogViewController.titleLabelFont = UIFontBoldMake(20);
    if (link) {
        dialogViewController.textField1.text = link.title;
        dialogViewController.textField2.text = link.link;
    } else {
        dialogViewController.textField1.placeholder = @"请输入标题（非必需）";
        dialogViewController.textField2.placeholder = @"输入网址";
    }
    
    [dialogViewController addCancelButtonWithText:@"取消" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
        [self richTextEditorCloseMoreView];
    }];
    
    __weak __typeof(QSTextFieldsViewController *)weakDialog = dialogViewController;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [self richTextEditorCloseMoreView];
        
        NSString *urlRegEx = @"([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
        //NSString *urlRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
        NSPredicate *checkURL = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        BOOL isVaild = [checkURL evaluateWithObject:weakDialog.textField2.text];
        
        if (!isVaild) {
            return;
        }
        
        [aDialogViewController hide];
        
        QSRichTextHyperlink *link = [[QSRichTextHyperlink alloc]init];
        link.title = weakDialog.textField1.text;
        link.link = weakDialog.textField2.text;
        [self insertHyperlink:link];
    }];
    [dialogViewController show];
}

-(void)insertHyperlink:(id)sender {
    
    QSRichTextHyperlink *hyperlink;
    if ([sender isKindOfClass:[QSRichTextHyperlink class]]) {
        hyperlink = sender;
    } else if([hyperlink isKindOfClass:[QSRichTextLinkButton class]]){
        hyperlink = ((QSRichTextLinkButton *)sender).link;
    }
    
    UIFont *buttonTextFont = [UIFont systemFontOfSize:15];
    CGSize maxSize = CGSizeMake(SCREEN_WIDTH - 40, HUGE);
    CGSize textSize = [hyperlink.title sizeForFont:buttonTextFont size:maxSize mode:NSLineBreakByWordWrapping];
    
    QSRichTextLinkButton *linkButon = [[QSRichTextLinkButton alloc]initWithFrame:CGRectMakeWithSize(textSize)];
    [linkButon setLink:hyperlink];
    [linkButon setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [linkButon setTitle:hyperlink.title forState:UIControlStateNormal];
    [linkButon.titleLabel setFont:buttonTextFont];
    [linkButon addTarget:self action:@selector(insertHyperlink:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableAttributedString *linkString = [NSMutableAttributedString yy_attachmentStringWithContent:linkButon contentMode:UIViewContentModeScaleAspectFit attachmentSize:textSize alignToFont:buttonTextFont alignment:YYTextVerticalAlignmentCenter];
    
    NSMutableAttributedString *pading = [[NSMutableAttributedString alloc]initWithString:@" " attributes:[QSRichTextAttributes defaultAttributes]];
    
    NSMutableAttributedString *linkStringWithPadding = [[NSMutableAttributedString alloc]init];
    [linkStringWithPadding appendAttributedString:pading];
    [linkStringWithPadding appendAttributedString:linkString];
    [linkStringWithPadding appendAttributedString:pading];
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    [attributedText replaceCharactersInRange:self.textView.selectedRange withAttributedString:linkStringWithPadding];
    self.textView.attributedText = attributedText;
}

-(void)insertVideo {
    [self.qs_delegate insertVideo];
}

-(void)insertSeperator {
    [self.qs_delegate insertSeperator];
}

-(void)insertPhoto {
    [self.qs_delegate insertPhoto];
}

-(BOOL)becomeFirstResponder {
    if (self.textView) {
        [self.textView becomeFirstResponder];
        return YES;
    }
    return NO;
}

@end

@implementation QSRichTextLinkButton

@end
