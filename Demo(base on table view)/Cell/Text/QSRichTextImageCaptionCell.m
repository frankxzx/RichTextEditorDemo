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
    self.textView.font = UIFontMake(15);
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.textColor = UIColorGrayLighten;
}

@end
