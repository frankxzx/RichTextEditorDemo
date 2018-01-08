//
//  QSRichTextListCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/7.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextListCell.h"

@interface QSRichTextListCell () {
    BOOL _shouldInsertPrefix;
}

@end

@implementation QSRichTextListCell

- (void)makeUI {
    [super makeUI];
    self.prefixRanges = [NSMutableArray array];
    [self.prefixRanges addObject:[YYTextRange rangeWithRange:NSMakeRange(0, self.prefix.length)]];
}

//当输入 \n 回车时 currentLine +1
-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        _shouldInsertPrefix = YES;
        return YES;
    }
    
    if (self.qs_delegate && [self.qs_delegate respondsToSelector:@selector(qsTextView:shouldChangeTextInRange:replacementText:)]) {
        return [self.qs_delegate qsTextView:(QSRichTextView *)textView shouldChangeTextInRange:range replacementText:text];
    }
    return NO;
}

-(void)textViewDidChange:(YYTextView *)textView {
    
    if (_shouldInsertPrefix) {
        self.textView.delegate = nil;
        YYTextRange *range = [YYTextRange rangeWithRange:NSMakeRange(textView.text.length, 0)];
        YYTextRange *replaceRange = [YYTextRange rangeWithRange:NSMakeRange(textView.text.length, self.prefix.length)];
        [self.prefixRanges addObject:replaceRange];
        [self.textView replaceRange:range withText:self.prefix];
        self.textView.delegate = self;;
        _shouldInsertPrefix = NO;
    }
    [super textViewDidChange:textView];
}

-(NSString *)prefix {
    return @"  ";
}

//无法定位 当前删除的是第几行，从而无法接着 序列往下排
-(void)updateListTypeStyle {
    int i = 1;
    for (YYTextRange *range in self.prefixRanges) {
        if ([self isKindOfClass:[QSRichTextListNumberCell class]]) {
            [self.textView replaceRange:range withText:[NSString stringWithFormat:@"%@.",@(i)]];
        } else {
            [self.textView replaceRange:range withText:self.prefix];
        }
        i++;
    }
}

-(void)initListType {
    YYTextRange *replaceRange = [YYTextRange rangeWithRange:NSMakeRange(0, 0)];
    [self.textView replaceRange:replaceRange withText:self.prefix];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.prefixRanges = [NSMutableArray array];
}

@end

@implementation QSRichTextListNumberCell

-(NSString *)prefix {
    return [NSString stringWithFormat:@"%@.",@(self.prefixRanges.count)];
}

@end

@implementation QSRichTextListCircleCell

-(NSString *)prefix {
    return @"\u2022 ";
}

@end
