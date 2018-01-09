//
//  QSRichTextBlockCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/3.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextBlockCell.h"

@implementation QSRichTextBlockCell

-(void)makeUI {
    [super makeUI];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 35, 10, 35);
}

-(void)updateCellTextStyle {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    YYTextBorder *border = [YYTextBorder new];
    border.fillColor = LightenPlaceholderColor;
    border.lineStyle = YYTextLineStyleNone;
    border.insets = UIEdgeInsetsMake(-8, -15, -8, -15);
    border.cornerRadius = 3;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attributedText yy_setAttributes:@{
                                       NSFontAttributeName: UIFontMake(14),
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName: UIColorGray,
                                       }];
    [attributedText yy_setTextBlockBorder:border range:attributedText.yy_rangeOfAll];
    self.textView.attributedText = attributedText;
    if ([attributedText.string isEqualToString:@" "]) {
        [self.textView deleteBackward];
    }
}

@end
