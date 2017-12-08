//
//  QSRichTextEditorTitleCell.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorTitleCell.h"

@interface QSRichTextEditorTitleCell()

@property(nonatomic, strong) UIImageView *coverImageView;

@end

@implementation QSRichTextEditorTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIImage *coverImage = UIImageMake(@"edit_Header");
    self.coverImageView = [[UIImageView alloc] initWithImage:coverImage];
    [self.contentView addSubview:self.coverImageView];
}

@end
