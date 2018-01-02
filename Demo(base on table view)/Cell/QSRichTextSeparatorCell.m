//
//  QSRichTextSeparatorCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextSeparatorCell.h"

@interface QSRichTextSeparatorCell ()

@property(nonatomic, strong) CALayer *separatorLayer;

@end

@implementation QSRichTextSeparatorCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    self.contentView.qmui_borderPosition = QMUIBorderViewPositionBottom;
    self.contentView.qmui_borderColor = [UIColorGrayLighten colorWithAlphaComponent:0.8];
}

@end
