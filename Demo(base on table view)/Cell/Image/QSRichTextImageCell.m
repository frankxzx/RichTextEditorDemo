//
//  QSRichTextImageCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextImageCell.h"
#import <QMUIKit/QMUIKit.h>

@interface QSRichTextImageCell()

@property(nonatomic, strong, readwrite) QSRichTextImageView *attchmentImageView;

@end

@implementation QSRichTextImageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    [self.contentView addSubview:self.attchmentImageView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.attchmentImageView.frame = CGRectFlatMake(0, 0, SCREEN_WIDTH, self.attchmentImage.size.height);
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(SCREEN_WIDTH, 0);
    CGFloat resultHeight = 0;
    CGSize imageSize = self.attchmentImage.size;
    resultHeight += imageSize.height;
    resultSize.height = resultHeight;
    return resultSize;
}

-(QSRichTextImageView *)attchmentImageView {
    if (!_attchmentImageView) {
        _attchmentImageView = [[QSRichTextImageView alloc]init];
    }
    return _attchmentImageView;
}

-(void)setAttchmentImage:(UIImage *)attchmentImage {
    _attchmentImage = attchmentImage;
    self.attchmentImageView.image = attchmentImage;
}

@end
