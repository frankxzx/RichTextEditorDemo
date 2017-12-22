//
//  QSTextBlockView.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSTextBlockView.h"

@interface QSTextBlockView()

@end

@implementation QSTextBlockView

-(instancetype)initWithAttachment:(DTTextBlockAttachment *)attachment {
    if (self = [super init]) {
        self.autoResizable = YES;
        self.qmui_borderWidth = PixelOne;
        self.qmui_borderPosition = QMUIBorderViewPositionTop|QMUIBorderViewPositionLeft|QMUIBorderViewPositionRight|QMUIBorderViewPositionBottom;
        self.qmui_borderColor = UIColorGray;
        self.layer.cornerRadius = 2;
        self.textAlignment = NSTextAlignmentCenter;
        self.attachment = attachment;
    }
    return self;
}

@end
