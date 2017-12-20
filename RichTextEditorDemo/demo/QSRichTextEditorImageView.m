//
//  QSRichTextEditorView.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/13.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorImageView.h"
#import <QMUIKit/QMUIKit.h>

@interface QSRichTextEditorImageView()

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) QMUIFillButton *captionButton;
@property(nonatomic, strong) QMUIFillButton *replaceButton;
@property(nonatomic, strong) QMUIFillButton *editButton;
@property(nonatomic, strong) QMUIButton *closeButton;
@property(nonatomic, strong) UIControl *contentView;

@end

@implementation QSRichTextEditorImageView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.captionButton = [[QMUIFillButton alloc]initWithImage:UIImageMake(@"icon_editor_caption") title:@"注释"];
        self.replaceButton = [[QMUIFillButton alloc]initWithImage:UIImageMake(@"icon_editor_pick") title:@"替换"];
        self.editButton = [[QMUIFillButton alloc]initWithImage:UIImageMake(@"icon_editor_crop") title:@"编辑"];
        self.closeButton = [[QMUIButton alloc]initWithImage:UIImageMake(@"edit_close") title:nil];
        self.captionButton.fillColor = FillButtonColorGray;
        self.replaceButton.fillColor = FillButtonColorGray;
        self.editButton.fillColor = FillButtonColorGray;
        
        self.captionButton.titleTextColor = UIColorBlack;
        self.replaceButton.titleTextColor = UIColorBlack;
        self.editButton.titleTextColor = UIColorBlack;
        
        self.editButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.captionButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.replaceButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.captionButton addTarget:self action:@selector(captionImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.editButton addTarget:self action:@selector(editorImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.replaceButton addTarget:self action:@selector(replaceImage:) forControlEvents:UIControlEventTouchUpInside];
        [self.closeButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        
        UIGestureRecognizer *tap = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(showButtons:)];
        self.imageView = [[UIImageView alloc]init];
        [self.imageView setUserInteractionEnabled:YES];
        [self.imageView addGestureRecognizer:tap];
        [self addSubview:self.imageView];
        
        self.contentView = [[UIControl alloc]init];
        [self.contentView addTarget:self action:@selector(hideButtons:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.captionButton];
        [self.contentView addSubview:self.replaceButton];
        [self.contentView addSubview:self.editButton];
        [self.contentView addSubview:self.closeButton];
        [self.imageView addSubview:self.contentView];
    }
    return self;
}

-(void)hideButtons:(id)sender {
    [self.contentView setHidden:YES];
}

-(void)showButtons:(id)sender {
    [self.contentView setHidden:NO];
}

-(void)captionImage:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(editorViewCaptionImage:attachment:)]) {
        [self.actionDelegate editorViewCaptionImage:sender attachment:self.attachment];
    }
}

-(void)editorImage:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(editorViewEditImage:attachment:)]) {
        [self.actionDelegate editorViewEditImage:sender attachment:self.attachment];
    }
}

-(void)deleteImage:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(editorViewDeleteImage:attachment:)]) {
        [self.actionDelegate editorViewDeleteImage:sender attachment:self.attachment];
    }
}

-(void)replaceImage:(id)sender {
    if ([self.actionDelegate respondsToSelector:@selector(editorViewReplaceImage:attachment:)]) {
        [self.actionDelegate editorViewReplaceImage:sender attachment:self.attachment];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat margin = 20;
    CGFloat width = 75;
    CGFloat height = 30;
    self.captionButton.frame = CGRectMake(margin, self.qmui_height - margin - height, width, height);
    self.editButton.frame = CGRectMake(self.qmui_width - margin - width, self.qmui_height - margin - height, width, height);
    self.replaceButton.frame = CGRectMake(self.qmui_width - margin - width - margin - width, self.qmui_height - margin - height, width, height);
    self.closeButton.frame = CGRectMake(self.qmui_width - margin - 44, margin, 44, 44);
    self.imageView.frame = self.bounds;
    self.contentView.frame = self.imageView.bounds;
}

-(void)setImage:(UIImage *)image {
    self.imageView.image = image;
}

@end

