//
//  QSRichTextEditorView.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/13.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@protocol QSRichTextEditorImageViewDelegate <NSObject>

-(void)editorViewDeleteImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment;
-(void)editorViewEditImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment;
-(void)editorViewCaptionImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment;
-(void)editorViewReplaceImage:(UIButton *)sender attachment:(DTImageTextAttachment *)attachment;

@end

@interface QSRichTextEditorImageView : UIView

@property(nonatomic, weak) id <QSRichTextEditorImageViewDelegate> actionDelegate;
@property(nonatomic, strong) DTImageTextAttachment *attachment;

-(void)setImage:(UIImage *)image;

@end
