//
//  QSRichTextEditorView.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/13.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSRichTextEditorImageViewDelegate <NSObject>

-(void)editorViewDeleteImage;
-(void)editorViewEditImage;
-(void)editorViewCaptionImage;
-(void)editorViewReplaceImage;

@end

@interface QSRichTextEditorImageView : UIView

@property(nonatomic, weak) id <QSRichTextEditorImageViewDelegate> actionDelegate;

-(void)setImage:(UIImage *)image;

@end
