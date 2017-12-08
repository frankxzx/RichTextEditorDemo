//
//  QSRichTextEditorCoverCell.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorCoverCell.h"

@interface QSRichTextEditorCoverCell()

@property(nonatomic, strong) UIImageView *coverImageView;

@end

@implementation QSRichTextEditorCoverCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIImage *coverImage = UIImageMake(@"edit_Header");
    self.coverImageView = [[UIImageView alloc] initWithImage:coverImage];
    UIGestureRecognizer *tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(addArticleCover:)];
    [self.coverImageView  addGestureRecognizer:tap];
    [self.contentView addSubview:self.coverImageView];
}

-(void)addArticleCover:(UIGestureRecognizer *)sender {
    if ([self.cellDelegate respondsToSelector:@selector(richEditorViewControllerWillInsertAticleCover)]) {
        [self.cellDelegate richEditorViewControllerWillInsertAticleCover];
    }
}

@end
