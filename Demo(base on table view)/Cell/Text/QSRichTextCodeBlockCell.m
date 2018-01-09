//
//  QSRichTextCodeBlockCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/9.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextCodeBlockCell.h"

@implementation QSRichTextCodeBlockCell

-(void)makeUI {
    [super makeUI];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 35, 10, 35);
}

-(void)updateCellTextStyle {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.textView.attributedText];
    YYTextBorder *border = [YYTextBorder new];
    border.lineStyle = YYTextLineStyleSingle;
    border.fillColor = LightenPlaceholderColor;
    border.strokeColor = [UIColor colorWithWhite:0.200 alpha:0.300];
    border.insets = UIEdgeInsetsMake(-8, -15, -8, -15);
    border.cornerRadius = 3;
    border.strokeWidth = YYTextCGFloatFromPixel(2);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    [attributedText yy_setAttributes:@{
                                       NSFontAttributeName: UIFontMake(15),
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName: UIColorGray,
                                       }];
    [attributedText yy_setTextBlockBorder:border range:attributedText.yy_rangeOfAll];
    self.textView.attributedText = attributedText;
}

@end
