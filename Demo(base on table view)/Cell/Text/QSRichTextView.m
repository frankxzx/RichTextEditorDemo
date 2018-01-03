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

- (void)qmui_scrollCaretVisibleAnimated:(BOOL)animated {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    CGRect caretRect = [self caretRectForPosition:self.selectedTextRange.end];
    
    // scrollEnabled 为 NO 时可能产生不合法的 rect 值 https://github.com/QMUI/QMUI_iOS/issues/205
    if (isinf(CGRectGetMinX(caretRect)) || isinf(CGRectGetMinY(caretRect))) {
        return;
    }
    
    CGFloat contentOffsetY = self.contentOffset.y;
    
    if (CGRectGetMinY(caretRect) == self.contentOffset.y + self.textContainerInset.top) {
        // 命中这个条件说明已经不用调整了，直接 return，避免继续走下面的判断，会重复调整，导致光标跳动
        return;
    }
    
    if (CGRectGetMinY(caretRect) < self.contentOffset.y + self.textContainerInset.top) {
        // 光标在可视区域上方，往下滚动
        contentOffsetY = CGRectGetMinY(caretRect) - self.textContainerInset.top - self.contentInset.top;
    } else if (CGRectGetMaxY(caretRect) > self.contentOffset.y + CGRectGetHeight(self.bounds) - self.textContainerInset.bottom - self.contentInset.bottom) {
        // 光标在可视区域下方，往上滚动
        contentOffsetY = CGRectGetMaxY(caretRect) - CGRectGetHeight(self.bounds) + self.textContainerInset.bottom + self.contentInset.bottom;
    } else {
        // 光标在可视区域内，不用调整
        return;
    }
    [self setContentOffset:CGPointMake(self.contentOffset.x, contentOffsetY) animated:animated];
}

@end
