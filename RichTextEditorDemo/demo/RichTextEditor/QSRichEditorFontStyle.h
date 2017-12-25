//
//  QSRichEditorFontStyle.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextEditorAction.h"

@interface QSRichEditorFontStyle : NSObject <NSCoding>

@property(nonatomic, assign) QSRichEditorTextStyle style;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;

- (id)initWithStyle:(QSRichEditorTextStyle)style;

@end
