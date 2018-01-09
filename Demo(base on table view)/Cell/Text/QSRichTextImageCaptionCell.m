//
//  QSRichTextImageCaptionCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/3.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextImageCaptionCell.h"

@implementation QSRichTextImageCaptionCell

-(void)makeUI {
    [super makeUI];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.textView.typingAttributes = @{
             NSFontAttributeName: UIFontMake(15),
             NSParagraphStyleAttributeName:paragraphStyle,
             NSForegroundColorAttributeName: UIColorGrayLighten,
             };
    NSMutableAttributedString *placeholderText = [[NSMutableAttributedString alloc]initWithString:@"请输入图片标注"];
    [placeholderText yy_setAttributes:@{
                                        NSFontAttributeName: UIFontMake(15),
                                        NSParagraphStyleAttributeName:paragraphStyle,
                                        NSForegroundColorAttributeName: UIColorGrayLighten,
                                        }];
    self.textView.placeholderAttributedText = placeholderText;
}

@end
