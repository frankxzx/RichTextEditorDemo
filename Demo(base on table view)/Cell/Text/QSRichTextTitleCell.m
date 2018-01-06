//
//  QSRichTextTitleCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/3.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextTitleCell.h"

@implementation QSRichTextTitleCell

-(void)makeUI {
    [super makeUI];
    self.textView.placeholderTextColor = UIColorGrayLighten;
    self.textView.placeholderFont = UIFontBoldMake(20);
    self.textView.font = UIFontMake(20);
    self.textView.placeholderText = @"请输入标题";
    self.textView.textColor = UIColorBlack;
    self.textView.textAlignment = NSTextAlignmentLeft;
}

@end
