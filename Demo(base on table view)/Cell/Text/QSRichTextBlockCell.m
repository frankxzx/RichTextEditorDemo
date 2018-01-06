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
    self.textView.backgroundColor = LightenPlaceholderColor;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    self.textView.typingAttributes = @{
                                       NSFontAttributeName: UIFontMake(15),
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName: UIColorGray,
                                       };
}

@end
