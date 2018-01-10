//
//  QSRichEditorFontStyle.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichEditorFontStyle.h"
#import <QMUIKit/QMUIKit.h>
#import "QSRichTextAttributes.h"

NSString * const QSRichEditorTextStyleKey = @"QSRichEditorTextStyle";

@implementation QSRichEditorFontStyle

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _style = [aDecoder decodeIntegerForKey:@"style"];
        _font = [aDecoder decodeObjectForKey:@"font"];
        _textColor = [aDecoder decodeObjectForKey:@"textColor"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_style forKey:@"style"];
    [aCoder encodeObject:_textColor forKey:@"textColor"];
    [aCoder encodeObject:_font forKey:@"font"];
}

- (id)initWithStyle:(QSRichEditorTextStyle)style {
    self = [super init];
    
    if (self)
    {
        self.style = style;
        switch (style) {
            case QSRichEditorTextStylePlaceholder:
                self.font = QSRichEditorPlaceholderFont;
                self.textColor = QSRichEditorPlaceholderColor;
                break;
            case QSRichEditorTextStyleNormal:
                self.font = QSRichEditorNormalFont;
                self.textColor = QSRichEditorNormalColor;
                break;
            case QSRichEditorTextStyleLarger:
                self.font = QSRichEditorLargerFont;
                self.textColor = QSRichEditorLargerColor;
                break;
        }
    }
    
    return self;
}

-(NSDictionary *)attributes {
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithDictionary:[QSRichTextAttributes defaultAttributes]];
    attributes[NSForegroundColorAttributeName] = self.textColor;
    attributes[NSFontAttributeName] = self.font;
    return attributes;
}

@end
