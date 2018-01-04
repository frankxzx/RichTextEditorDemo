//
//  QSRichTextAttributes.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/4.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextAttributes.h"

@interface QSRichTextAttributes ()

@property(nonatomic, copy) NSDictionary *defaultAttributes;

@end

@implementation QSRichTextAttributes

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QSRichTextAttributes *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+(NSDictionary *)defaultAttributes {
    return [QSRichTextAttributes sharedInstance].defaultAttributes;
}

-(NSDictionary *)defaultAttributes {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    paragraphStyle.alignment = self.aligment;
    return @{
           NSFontAttributeName:self.font ?: [UIFont systemFontOfSize:16],
           NSParagraphStyleAttributeName:paragraphStyle,
           NSForegroundColorAttributeName: self.textColor ?: [UIColor darkTextColor],
           NSKernAttributeName:@(1)
           };
}

+ (void)setFont:(UIFont *)font textColor:(UIColor *)color {
    [QSRichTextAttributes sharedInstance].textColor = color;
    [QSRichTextAttributes sharedInstance].font = font;
}

+ (void)setQSRichTextStyle:(QSRichEditorFontStyle *)style {
    [self setFont:style.font textColor:style.textColor];
}

@end
