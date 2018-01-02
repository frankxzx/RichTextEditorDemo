//
//  QSRichTextWordCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextWordCell.h"

@interface QSRichTextWordCell () <YYTextViewDelegate>

@property(nonatomic, strong, readwrite) QSRichTextView * textView;

@end

@implementation QSRichTextWordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    [self.contentView addSubview:self.textView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat contentLabelWidth = self.contentView.qmui_width;
    CGSize textViewSize = [self.textView sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    self.textView.frame = CGRectFlatMake(0, 0, contentLabelWidth, textViewSize.height);
}

-(CGSize)sizeThatFits:(CGSize)size {
    
    CGSize resultSize = CGSizeMake(size.width, 0);
    CGFloat resultHeight = 0;
    CGFloat contentLabelWidth = size.width;
    CGSize contentSize = [self.textView sizeThatFits:CGSizeMake(contentLabelWidth, CGFLOAT_MAX)];
    resultHeight += contentSize.height;
    resultSize.height = resultHeight;
    return resultSize;
}

- (void)renderRichText:(NSAttributedString *)text {
    
    self.textView.attributedText = text;
    self.textView.textAlignment = NSTextAlignmentJustified;
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
    [self handleTextChanged:self.textView];
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
        
        CGFloat resultHeight = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds), CGFLOAT_MAX)].height;
        
        NSLog(@"handleTextDidChange, text = %@, resultHeight = %f", textView.text, resultHeight);
        
        // 通知delegate去更新textView的高度
        if ([textView.qs_delegate respondsToSelector:@selector(qsTextView:newHeightAfterTextChanged:)] && resultHeight != CGRectGetHeight(self.bounds)) {
            [textView.qs_delegate qsTextView:self.textView newHeightAfterTextChanged:resultHeight];
        }
        
        // textView 尚未被展示到界面上时，此时过早进行光标调整会计算错误
        if (!textView.window) {
            return;
        }
    }
}

@end
