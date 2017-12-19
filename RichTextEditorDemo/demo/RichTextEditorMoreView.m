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
#import "QSTextFieldsViewController.h"

@interface RichTextEditorMoreView() <QMUITextFieldDelegate>

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
        
        [self.videoButton addTarget:self action:@selector(insertVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.audioButton addTarget:self action:@selector(insertAudio) forControlEvents:UIControlEventTouchUpInside];
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
    QSTextFieldsViewController *dialogViewController = [[QSTextFieldsViewController alloc] init];
    dialogViewController.headerViewHeight = 70;
    dialogViewController.headerViewBackgroundColor = UIColorWhite;
    dialogViewController.title = @"超链接";
    dialogViewController.titleView.horizontalTitleFont = UIFontBoldMake(20);
    dialogViewController.titleLabelFont = UIFontBoldMake(20);
    dialogViewController.textField1.delegate = self;
    dialogViewController.textField2.delegate = self;
    dialogViewController.textField1.placeholder = @"请输入标题（非必需）";
    dialogViewController.textField2.placeholder = @"输入网址";
    [dialogViewController addCancelButtonWithText:@"取消" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
        if (self.actionDelegate) {
            [self.actionDelegate richTextEditorCloseMoreView];
        }
    }];
    
    __weak __typeof(QSTextFieldsViewController *)weakDialog = dialogViewController;
    [dialogViewController addSubmitButtonWithText:@"确定" block:^(QMUIDialogViewController *aDialogViewController) {
        [aDialogViewController hide];
        if ([self.actionDelegate respondsToSelector:@selector(insertHyperlink:)]) {
            HyperlinkModel *link = [[HyperlinkModel alloc]init];
            link.title = weakDialog.textField1.text;
            link.link = weakDialog.textField2.text;
            [self.actionDelegate insertHyperlink:link];
            [self.actionDelegate richTextEditorCloseMoreView];
        }
    }];
    [dialogViewController show];
}

-(void)editHyperlink {
    [self insertHyperlink];
}

#pragma mark - <QMUITextFieldDelegate>

@end

@implementation HyperlinkModel

@end
