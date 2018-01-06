//
//  QSRichEditorFontStyle.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, QSRichEditorTextStyle) {
    QSRichEditorTextStylePlaceholder,
    QSRichEditorTextStyleNormal,
    QSRichEditorTextStyleLarger
};

extern NSString * const QSRichEditorTextStyleKey;

@interface QSRichEditorFontStyle : NSObject <NSCoding>

@property(nonatomic, assign) QSRichEditorTextStyle style;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, copy) NSDictionary *attributes;

- (id)initWithStyle:(QSRichEditorTextStyle)style;

@end
