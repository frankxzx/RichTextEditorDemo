//
//  QSRichTextImageCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import "QSRichTextImageView.h"

@interface QSRichTextImageCell : QSRichTextCell

@property(nonatomic, strong) UIImage *attchmentImage;
@property(nonatomic, strong, readonly) QSRichTextImageView *attchmentImageView;

@end
