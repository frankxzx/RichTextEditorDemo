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
    self.currentLine = 1;
    self.prefixRanges = [NSMutableArray array];
    [self.prefixRanges addObject:[YYTextRange rangeWithRange:NSMakeRange(0, 0)]];
}

//当输入 \n 回车时 currentLine +1
-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    if ([text isEqualToString:@"\n"]) {
        _shouldInsertPrefix = YES;
        self.currentLine += 1;
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
        [self.textView replaceRange:range withText:self.prefix];
        YYTextRange *replaceRange = [YYTextRange rangeWithRange:NSMakeRange(textView.text.length, 1)];
        [self.prefixRanges addObject:replaceRange];
        self.textView.delegate = self;;
        _shouldInsertPrefix = NO;
    }
    [super textViewDidChange:textView];
}

-(NSString *)prefix {
    return @"";
}

-(void)updateListTypeStyle {
    for (YYTextRange *range in self.prefixRanges) {
        [self.textView replaceRange:range withText:self.prefix];
    }
}

@end

@implementation QSRichTextListNumberCell

-(NSString *)prefix {
    return [NSString stringWithFormat:@"%@.",@(self.currentLine)];
}

@end

@implementation QSRichTextListCircleCell

-(NSString *)prefix {
    return @"\u2022";
}

@end



