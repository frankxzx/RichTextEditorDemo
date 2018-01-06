//
//  QSRichTextVideoCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import "QSRichTextVideoView.h"

@interface QSRichTextVideoCell : QSRichTextCell

@property(nonatomic, strong) UIImage *thumbnailImage;
@property(nonatomic, strong, readonly) QSRichTextVideoView *videoView;

@end
