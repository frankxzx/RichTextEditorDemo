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

-(void)qs_setLineSpacing:(CGFloat)space {
}

-(DTTextAttachment *)qs_attachmentWithRange:(DTTextRange *)range {
    NSAttributedString *string = self.attributedText;
    if (![string length]) { return nil; }
    __block DTTextAttachment *attachment;
    [string enumerateAttribute:NSAttachmentAttributeName inRange:range.NSRangeValue options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *_attachment, NSRange _range, BOOL *stop) {
        if (!_attachment) { return; }
        if (NSEqualRanges(_range, range.NSRangeValue)) {
            attachment = _attachment;
        }
    }];
    return attachment;
}

-(DTTextRange *)qs_rangeOfAttachment:(DTTextAttachment *)attachment {
    NSAttributedString *string = self.attributedText;
        if (![string length]) { return nil; }
        NSRange entireRange = NSMakeRange(0, [string length]);
        __block DTTextRange *range;
        [string enumerateAttribute:NSAttachmentAttributeName inRange:entireRange options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(DTTextAttachment *_attachment, NSRange _range, BOOL *stop) {
            if (!_attachment) { return; }
            if ([_attachment isEqual:attachment]) {
                range = [DTTextRange rangeWithNSRange:_range];
            }
        }];
        return range;
}

-(DTTextRange *)qs_selectedTextRange {
    DTTextRange *textRange = (DTTextRange *)self.selectedTextRange;
    if (textRange.length < 1) {
       NSRange nsRange = [self currentLine].stringRange;
       return [DTTextRange rangeWithNSRange:nsRange];
    }
    return textRange;
}

static UITextRange * _Nullable extracted(DTRichTextEditorView *object) {
    return object.selectedTextRange;
}

- (DTCoreTextLayoutLine *)currentLine {
    UITextPosition *currentPosition = (DTTextPosition *)[extracted(self) start];
    return [self layoutLineContainingTextPosition:currentPosition];
}

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

-(void)insertAttachment:(DTTextAttachment *)attchment {
    [self replaceRange:self.selectedTextRange withAttachment:attchment inParagraph:YES];
}

@end
