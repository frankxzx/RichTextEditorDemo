//
//  QSTextBlockView.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "DTTextBlockAttachment.h"

@interface QSTextBlockView : QMUITextView

@property(nonatomic, strong) DTTextBlockAttachment *attachment;

-(instancetype)initWithAttachment:(DTTextBlockAttachment *)attachment;

@end
