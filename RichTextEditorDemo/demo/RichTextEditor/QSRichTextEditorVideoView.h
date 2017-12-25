//
//  QSRichTextEditorVideoView.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@protocol QSRichTextEditorVideoViewDelegate <NSObject>

-(void)editorViewDeleteVideo:(UIButton *)sender attachment:(DTVideoTextAttachment *)attachment;
-(void)editorViewPlayVideo:(UIButton *)sender attachment:(DTVideoTextAttachment *)attachment;

@end

@interface QSRichTextEditorVideoView : UIView

@property(nonatomic, weak) id <QSRichTextEditorVideoViewDelegate> actionDelegate;
@property(nonatomic, strong) DTVideoTextAttachment *attachment;

@end
