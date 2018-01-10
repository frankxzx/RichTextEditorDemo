//
//  QSRichTextView.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextView.h"
#import <QMUIKit/QMUIKit.h>

@interface QSRichTextView ()

@end

@implementation QSRichTextView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)updateTextStyle {
    self.typingAttributes = [QSRichTextAttributes defaultAttributes];
}

- (void)deleteBackward {
    if (self.text.length == 0 && [self.qs_delegate respondsToSelector:@selector(qsTextFieldDeleteBackward:)]) {
        [self.qs_delegate qsTextFieldDeleteBackward:self];
    }
    [super deleteBackward];
}

@end
