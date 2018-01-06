//
//  QSRichTextAttributes.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/4.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSRichEditorFontStyle.h"

@interface QSRichTextAttributes : NSObject

@property(nonatomic, assign) NSTextAlignment aligment;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;

+ (instancetype)sharedInstance;
+ (NSDictionary *)defaultAttributes;

+ (void)setFont:(UIFont *)font textColor:(UIColor *)color;
+ (void)setQSRichTextStyle:(QSRichEditorFontStyle *)style;

@end
