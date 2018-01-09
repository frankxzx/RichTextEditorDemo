//
//  QSRichTextMoreView.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextMoreView.h"
#import "QSRichTextWordCell.h"

@interface QSRichTextMoreView()

@property(nonatomic, strong) QMUIButton *videoButton;
@property(nonatomic, strong) QMUIButton *audioButton;
@property(nonatomic, strong) QMUIButton *seperatorButton;
@property(nonatomic, strong) QMUIButton *hyperlinkButton;

@end

@implementation QSRichTextMoreView


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.videoButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_video") title:@"视频"];
        self.audioButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"icon_code") title:@"代码块"];
        self.seperatorButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_seperator") title:@"分割线"];
        self.hyperlinkButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_hyperlink") title:@"超链接"];
        self.videoButton.imagePosition = QMUIButtonImagePositionTop;
        self.audioButton.imagePosition = QMUIButtonImagePositionTop;
        self.seperatorButton.imagePosition = QMUIButtonImagePositionTop;
        self.hyperlinkButton.imagePosition = QMUIButtonImagePositionTop;
        
        self.seperatorButton.titleLabel.font = UIFontMake(15);
        self.audioButton.titleLabel.font = UIFontMake(15);
        self.hyperlinkButton.titleLabel.font = UIFontMake(15);
        self.videoButton.titleLabel.font = UIFontMake(15);
        
        [self.videoButton addTarget:self action:@selector(insertVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.audioButton addTarget:self action:@selector(insertCodeBlock) forControlEvents:UIControlEventTouchUpInside];
        [self.seperatorButton addTarget:self action:@selector(insertSeperator) forControlEvents:UIControlEventTouchUpInside];
        [self.hyperlinkButton addTarget:self action:@selector(insertHyperlink) forControlEvents:UIControlEventTouchUpInside];
        
        [self.videoButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [self.audioButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [self.seperatorButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        [self.hyperlinkButton setTitleColor:UIColorBlack forState:UIControlStateNormal];
        
        [self addSubview:self.videoButton];
        [self addSubview:self.audioButton];
        [self addSubview:self.seperatorButton];
        [self addSubview:self.hyperlinkButton];
        
        self.videoButton.backgroundColor = UIColorWhite;
        self.audioButton.backgroundColor = UIColorWhite;
        self.seperatorButton.backgroundColor = UIColorWhite;
        self.hyperlinkButton.backgroundColor = UIColorWhite;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = SCREEN_WIDTH/2;
    CGFloat height = self.frame.size.height/2;
    self.seperatorButton.frame = CGRectMake(0, 0, width, height);
    self.hyperlinkButton.frame = CGRectMake(width, 0, width, height);
    self.videoButton.frame = CGRectMake(0, height, width, height);
    self.audioButton.frame = CGRectMake(width, height, width, height);
}

-(void)insertVideo {
    
    if ([self.actionDelegate respondsToSelector:@selector(insertVideo)]) {
        [self.actionDelegate insertVideo];
    }
}

-(void)insertCodeBlock {
    if ([self.actionDelegate respondsToSelector:@selector(insertCodeBlock)]) {
        [self.actionDelegate insertCodeBlock];
    }
}

-(void)insertSeperator {
    if ([self.actionDelegate respondsToSelector:@selector(insertSeperator)]) {
        [self.actionDelegate insertSeperator];
    }
}

-(void)insertHyperlink {
    if ([self.actionDelegate respondsToSelector:@selector(insertHyperlink)]) {
        [self.actionDelegate insertHyperlink];
    }
}

-(void)editHyperlink {
    [self insertHyperlink];
}

@end
