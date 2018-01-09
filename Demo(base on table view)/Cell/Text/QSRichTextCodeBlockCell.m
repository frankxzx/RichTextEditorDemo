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
    self.textView.backgroundColor = LightenPlaceholderColor;
    self.textView.textColor = UIColorGray;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    self.textView.typingAttributes = @{
                                       NSFontAttributeName: UIFontMake(17),
                                       NSParagraphStyleAttributeName:paragraphStyle,
                                       NSForegroundColorAttributeName: UIColorGray,
                                       };
}

@end
