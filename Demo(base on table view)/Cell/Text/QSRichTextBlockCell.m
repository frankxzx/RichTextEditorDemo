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
    self.textView.backgroundColor = LightenPlaceholderColor;
    self.textView.qmui_borderPosition = QMUIButtonImagePositionTop | QMUIButtonImagePositionLeft | QMUIButtonImagePositionRight | QMUIButtonImagePositionBottom;
    self.textView.qmui_borderWidth = PixelOne;
    self.textView.qmui_borderColor = UIColorGray;
}

@end
