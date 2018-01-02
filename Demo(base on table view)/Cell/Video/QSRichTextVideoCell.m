//
//  QSRichTextVideoCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextVideoCell.h"

@interface QSRichTextVideoCell ()

@property(nonatomic, strong) QSRichTextVideoView *videoView;

@end

@implementation QSRichTextVideoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    [self.contentView addSubview:self.videoView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.videoView.frame = CGRectFlatMake(0, 0, SCREEN_WIDTH, self.thumbnailImage.size.height);
}

-(CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(SCREEN_WIDTH, 0);
    CGFloat resultHeight = 0;
    CGSize imageSize = self.thumbnailImage.size;
    resultHeight += imageSize.height;
    resultSize.height = resultHeight;
    return resultSize;
}

-(QSRichTextVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[QSRichTextVideoView alloc]init];
    }
    return _videoView;
}

-(void)setThumbnailImage:(UIImage *)thumbnailImage {
    self.videoView.thumbnailImage = thumbnailImage;
}

@end
