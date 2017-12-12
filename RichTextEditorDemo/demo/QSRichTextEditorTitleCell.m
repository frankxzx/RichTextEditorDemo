//
//  QSRichTextEditorTitleCell.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorTitleCell.h"

@interface QSRichTextEditorTitleCell()

@end

@implementation QSRichTextEditorTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.titleTextView = [YYTextView new];
    self.titleTextView.font = [UIFont boldSystemFontOfSize:30];
    self.titleTextView.placeholderFont = [UIFont boldSystemFontOfSize:30];
    self.titleTextView.placeholderText = @"请输入标题";
    self.titleTextView.textContainerInset = UIEdgeInsetsMake(10, 20, 10, 20);
    [self.contentView addSubview:self.titleTextView];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    resultSize.height = [QSRichTextEditorTitleCell cellRect].size.height;
    return resultSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleTextView.frame = [QSRichTextEditorTitleCell cellRect];
}

+(CGRect)cellRect {
    return CGRectMake(0, 0, SCREEN_WIDTH, 60);
}

@end
