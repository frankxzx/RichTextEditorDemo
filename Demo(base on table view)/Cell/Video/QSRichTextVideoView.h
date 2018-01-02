//
//  QSRichTextVideoView.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/2.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSRichTextVideoViewDelegate;
@interface QSRichTextVideoView : UIView

@property(nonatomic, weak) id <QSRichTextVideoViewDelegate> actionDelegate;
@property(nonatomic, strong) UIImage *thumbnailImage;

@end

@protocol QSRichTextVideoViewDelegate <NSObject>

-(void)editorViewDeleteVideo:(QSRichTextVideoView *)sender;
-(void)editorViewPlayVideo:(QSRichTextVideoView *)sender;

@end
