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
    self.textView.textColor = UIColorGrayLighten;
    self.textView.placeholderFont = UIFontMake(15);
    self.textView.placeholderTextColor = UIColorGrayLighten;
    self.textView.placeholderText = @"请输入图片标注";
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    self.textView.typingAttributes = @{
             NSFontAttributeName: UIFontMake(15),
             NSParagraphStyleAttributeName:paragraphStyle,
             NSForegroundColorAttributeName: UIColorGrayLighten,
             };
}

@end
