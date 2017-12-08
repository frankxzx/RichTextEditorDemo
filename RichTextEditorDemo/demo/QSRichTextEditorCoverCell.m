//
//  QSRichTextEditorCoverCell.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorCoverCell.h"

static UIEdgeInsets const kInsets = {16, 20, 16, 20};

@interface QSRichTextEditorCoverCell()

@property(nonatomic, strong) QMUIButton *coverButton;

@end

@implementation QSRichTextEditorCoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    self.coverButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"edit_Header") title:@"添加封面"];
    self.coverButton.spacingBetweenImageAndTitle = 12;
    [self.coverButton setBackgroundColor:UIColorGray];
    [self.coverButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
    [self.coverButton addTarget:self action:@selector(addArticleCover:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.coverButton];
}

-(void)addArticleCover:(UIGestureRecognizer *)sender {
    if ([self.cellDelegate respondsToSelector:@selector(richEditorViewControllerWillInsertAticleCover)]) {
        [self.cellDelegate richEditorViewControllerWillInsertAticleCover];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.coverButton.frame = CGRectInsetEdges([QSRichTextEditorCoverCell cellRect], kInsets);
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    resultSize.height = [QSRichTextEditorCoverCell cellRect].size.height;
    return resultSize;
}

+(CGRect)cellRect {
    return CGRectMake(0, 0, SCREEN_WIDTH, 120);
}

@end
