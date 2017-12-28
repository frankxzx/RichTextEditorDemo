//
//  QSTextBlockView.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSTextBlockView.h"

@interface QSTextBlockView() {
    BOOL isClear; // QMUITextView text.length 永远等于 1, 所以加个标识做判断
}

@end

@implementation QSTextBlockView

-(instancetype)initWithAttachment:(DTTextBlockAttachment *)attachment {
    if (self = [super init]) {
        self.autoResizable = YES;
        self.qmui_borderWidth = PixelOne;
        self.qmui_borderPosition = QMUIBorderViewPositionTop|QMUIBorderViewPositionLeft|QMUIBorderViewPositionRight|QMUIBorderViewPositionBottom;
        self.qmui_borderColor = UIColorGray;
        self.layer.cornerRadius = 2;
        self.font = [QSTextBlockView font];
        self.attachment = attachment;
        isClear = NO;
    }
    return self;
}

+(UIFont *)font {
    return [UIFont systemFontOfSize:13];
}

- (void)deleteBackward {
    [super deleteBackward];
    if (isClear && [self.qs_delegate respondsToSelector:@selector(qsTextFieldDeleteBackward:)]) {
        [self.qs_delegate qsTextFieldDeleteBackward:self];
    }
    if (self.text.length == 1) {
        isClear = YES;
    }
}

-(BOOL)becomeFirstResponder {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kDidSelectedTextBlockView" object:self];
    return [super becomeFirstResponder];
}

-(BOOL)resignFirstResponder {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"kDidResignTextBlockView" object:self];
    return [super resignFirstResponder];
}

@end
