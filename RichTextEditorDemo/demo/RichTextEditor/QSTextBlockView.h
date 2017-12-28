//
//  QSTextBlockView.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "DTTextBlockAttachment.h"

@class QSTextBlockView;
@protocol QSTextBlockViewDelegate <NSObject>

- (void)qsTextFieldDeleteBackward:(QSTextBlockView *)textView;

@end

@interface QSTextBlockView : QMUITextView

@property(nonatomic, strong) DTTextBlockAttachment *attachment;
@property (nonatomic,weak) id <QSTextBlockViewDelegate> qs_delegate;

-(instancetype)initWithAttachment:(DTTextBlockAttachment *)attachment;

+(UIFont *)font;

@end
