//
//  QSRichTextAddCoverCell.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextAddCoverCell.h"
#import <QMUIKit/QMUIKit.h>

@interface QSRichTextAddCoverCell ()

@property(nonatomic, strong) QMUIButton *coverButton;

@end

@implementation QSRichTextAddCoverCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self makeUI];
    }
    return self;
}

-(void)makeUI {
    [self.contentView addSubview:self.coverButton];
}

//封面
-(QMUIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"edit_Header") title:@"添加封面"];
        _coverButton.frame = CGRectMake(20, 20 , SCREEN_WIDTH - 40, 80);
        _coverButton.spacingBetweenImageAndTitle = 12;
        [_coverButton setBackgroundColor:LightenPlaceholderColor];
        [_coverButton setTitleColor:UIColorGray forState:UIControlStateNormal];
        [_coverButton addTarget:self action:@selector(addArticleCover:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

-(void)addArticleCover:(UIButton *)sender {
    [self.actionDelegate didInsertArticleCover:sender];
}

@end
