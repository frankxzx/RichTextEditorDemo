//
//  NSDictionary+qsRIchTextStyle.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/28.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "NSDictionary+qsRIchTextStyle.h"

@implementation NSDictionary (qsRIchTextStyle)

- (QSRichEditorTextStyle)qsTextStyle {
    
    QSRichEditorFontStyle *text = [self objectForKey:QSRichEditorTextStyleKey];
    return text.style;
}

@end
