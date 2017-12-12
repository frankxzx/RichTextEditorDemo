//
//  DTRichTextEditorView+qs.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/12.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTRichTextEditorView+qs.h"
#import <QMUIKit/QMUIKit.h>
#import <DTCoreText/DTCoreText.h>

#define QSRichEditorPlaceholderColor UIColorGray
#define QSRichEditorLargerColor UIColorBlack
#define QSRichEditorNormalColor UIColorBlack


@implementation DTRichTextEditorView (qs)

- (void)updateTextStyle:(QSRichEditorTextStyle)style inRange:(UITextRange *)range {

    UIFont *font;
    switch (style) {
        case QSRichEditorTextStyleNormal: {
            font = UIFontMake(16);
            CTFontRef ctFont = DTCTFontCreateWithUIFont(font);
            DTCoreTextFontDescriptor *fontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:ctFont];
            CFRelease(ctFont);
            
            [self setForegroundColor:QSRichEditorNormalColor inRange:range];
            [self updateFontInRange:range withFontFamilyName:fontDescriptor.fontFamily pointSize:16];
            break;
        }
            
        case QSRichEditorTextStyleLarger: {
            font = UIFontBoldMake(20);
            CTFontRef ctFont = DTCTFontCreateWithUIFont(font);
            DTCoreTextFontDescriptor *fontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:ctFont];
            CFRelease(ctFont);
            
            [self setForegroundColor:QSRichEditorLargerColor inRange:range];
            [self updateFontInRange:range withFontFamilyName:fontDescriptor.fontFamily  pointSize:20];
            break;
        }
            
        case QSRichEditorTextStylePlaceholder: {
            font = UIFontLightMake(15);
            CTFontRef ctFont = DTCTFontCreateWithUIFont(font);
            DTCoreTextFontDescriptor *fontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:ctFont];
            CFRelease(ctFont);
            
            [self setForegroundColor:QSRichEditorPlaceholderColor inRange:range];
            [self updateFontInRange:range withFontFamilyName:fontDescriptor.fontFamily  pointSize:15];
            break;
        }
    }
}

@end
