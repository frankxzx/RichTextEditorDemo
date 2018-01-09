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

-(BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    if (self.qs_delegate && [self.qs_delegate respondsToSelector:@selector(qsTextViewShouldBeginEditing:)]) {
      return [self.qs_delegate qsTextViewShouldBeginEditing:textView];
    }
    return NO;
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
        //行高不足 50 设置为 50
        CGFloat resultHeight = MAX([textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.textView.bounds), CGFLOAT_MAX)].height, 50);
        CGFloat oldValue = CGRectGetHeight(self.contentView.bounds);
        
        NSLog(@"handleTextDidChange, text = %@, resultHeight = %f old value = %f", textView.text, resultHeight, oldValue);
        
        // 通知delegate去更新textView的高度
        if ([textView.qs_delegate respondsToSelector:@selector(qsTextView:newHeightAfterTextChanged:)] && resultHeight != oldValue) {
            [textView.qs_delegate qsTextView:self.textView newHeightAfterTextChanged:resultHeight];
        }
    }
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
