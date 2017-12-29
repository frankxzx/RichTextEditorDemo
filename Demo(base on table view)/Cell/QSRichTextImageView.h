//
//  QSRichTextImageView.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSRichTextImageViewDelegate <NSObject>

-(void)editorViewDeleteImage:(UIButton *)sender;
-(void)editorViewEditImage:(UIButton *)sender;
-(void)editorViewCaptionImage:(UIButton *)sender;
-(void)editorViewReplaceImage:(UIButton *)sender;

@end

@interface QSRichTextImageView : UIView

@property(nonatomic, weak) id <QSRichTextImageViewDelegate> actionDelegate;
@property(nonatomic, strong) UIImage *image;

@end
