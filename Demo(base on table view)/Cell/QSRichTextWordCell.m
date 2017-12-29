//
//  QSRichTextWordCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextWordCell.h"

@interface QSRichTextWordCell ()

@property(nonatomic, strong, readwrite) YYTextView * textView;

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

- (void)renderRichText:(NSString *)text {
    
    self.textView.text = text;
    self.textView.attributedText = [self attributeStringWithString:text lineHeight:26];
    self.textView.textAlignment = NSTextAlignmentJustified;
    
    [self setNeedsLayout];
}

- (NSAttributedString *)attributeStringWithString:(NSString *)textString lineHeight:(CGFloat)lineHeight {
    if (!textString.qmui_trim && textString.qmui_trim.length <= 0) return nil;
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:textString attributes:@{NSParagraphStyleAttributeName:[NSMutableParagraphStyle qmui_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByTruncatingTail]}];
    return attriString;
}

-(YYTextView *)textView {
    if (!_textView) {
        _textView = [YYTextView new];
    }
    return _textView;
}

@end
