//
//  RichTextEditorMoreView.m
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "RichTextEditorMoreView.h"
#import <QMUIKit/QMUIKit.h>
#import "RichTextEditorAction.h"

@interface RichTextEditorMoreView()

@property(nonatomic, strong) QMUIButton *videoButton;
@property(nonatomic, strong) QMUIButton *audioButton;
@property(nonatomic, strong) QMUIButton *seperatorButton;
@property(nonatomic, strong) QMUIButton *hyperlinkButton;

@end

@implementation RichTextEditorMoreView

-(instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.videoButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_video") title:@"视频"];
		self.audioButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_audio") title:@"语音"];
		self.seperatorButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_seperator") title:@"分割线"];
		self.hyperlinkButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"toolbar_hyperlink") title:@"超链接"];
        self.videoButton.imagePosition = QMUIButtonImagePositionTop;
        self.audioButton.imagePosition = QMUIButtonImagePositionTop;
        self.seperatorButton.imagePosition = QMUIButtonImagePositionTop;
        self.hyperlinkButton.imagePosition = QMUIButtonImagePositionTop;
		
		[self addSubview:self.videoButton];
		[self addSubview:self.audioButton];
		[self addSubview:self.seperatorButton];
		[self addSubview:self.hyperlinkButton];
	}
	return self;
}

-(void)layoutSubviews {
	[super layoutSubviews];

}

-(void)insertVideo {
    
	if ([self.actionDelegate respondsToSelector:@selector(insertVideo)]) {
		[self.actionDelegate insertVideo];
	}
}

-(void)insertAudio {
	if ([self.actionDelegate respondsToSelector:@selector(insertAudio)]) {
		[self.actionDelegate insertAudio];
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

@end
