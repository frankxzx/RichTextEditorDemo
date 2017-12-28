//
//  NSDictionary+qsRIchTextStyle.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/28.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>
#import <QMUIKit/QMUIKit.h>
#import "QSRichEditorFontStyle.h"

@interface NSDictionary (qsRIchTextStyle)

- (QSRichEditorTextStyle)qsTextStyle;

@end
