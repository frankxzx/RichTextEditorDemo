//
//  QSRichTextView.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextView.h"

@implementation QSRichTextView

- (void)deleteBackward {
    if (self.text.length == 0 && [self.qs_delegate respondsToSelector:@selector(qsTextFieldDeleteBackward:)]) {
        [self.qs_delegate qsTextFieldDeleteBackward:self];
    }

    [super deleteBackward];
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
