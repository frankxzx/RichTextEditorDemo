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
#import "QSRichEditorFontStyle.h"
#import <YYText/YYText.h>
#import "DTTextAttachment+qs.h"

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

//当前行
static UITextRange * _Nullable extracted(DTRichTextEditorView *object) {
    return object.selectedTextRange;
}

- (DTCoreTextLayoutLine *)currentLine {
    UITextPosition *currentPosition = (DTTextPosition *)[extracted(self) start];
    return [self layoutLineContainingTextPosition:currentPosition];
}

//设置样式
- (void)updateTextStyle:(QSRichEditorTextStyle)style inRange:(UITextRange *)range {

    QSRichEditorFontStyle *fontStyle = [[QSRichEditorFontStyle alloc]initWithStyle:style];
    QMUILog(@"=== QSRichEditorFontStyle: %@",fontStyle);
    NSMutableAttributedString *attributeString = [[self attributedSubstringForRange:range]mutableCopy];
    [attributeString addAttribute:@"QSRichEditorFontStyle" value:fontStyle range:attributeString.yy_rangeOfAll];
    [self replaceRange:range withText:attributeString];
    [self configStyle:fontStyle inRange:range];
}

-(void)configStyle:(QSRichEditorFontStyle *)style inRange:(UITextRange *)range {
    
    UIFont *font = style.font;
    CTFontRef ctFont = DTCTFontCreateWithUIFont(font);
    DTCoreTextFontDescriptor *fontDescriptor = [DTCoreTextFontDescriptor fontDescriptorForCTFont:ctFont];
    CFRelease(ctFont);
    
    [self setForegroundColor:style.textColor inRange:range];
    [self updateFontInRange:range withFontFamilyName:fontDescriptor.fontFamily  pointSize:font.pointSize];
}

//插入多媒体
-(void)insertAttachment:(DTTextAttachment *)attchment {
    [self replaceRange:self.selectedTextRange withAttachment:attchment inParagraph:YES];
}

//删除附件
-(void)removeAttachment:(DTTextAttachment *)attchment {
    [self replaceRange:attchment.range withText:@""];
}

-(void)resetDefaultTextStyle {
    //        CTForegroundColor = "<CGColor 0x103db5fb0> [<CGColorSpace 0x103db4d40> (kCGColorSpaceICCBased; kCGColorSpaceModelRGB; sRGB IEC61966-2.1; extended range)] ( 0 0 0 1 )";
    //        NSFont = "<UICTFont: 0x10ac90500> font-family: \".SFUIText\"; font-weight: normal; font-style: normal; font-size: 16.00pt";
    //        NSParagraphStyle = "<CTParagraphStyle: 0x10ab4e9a0>{base writing direction = -1, alignment = 4, line break mode = 0, default tab interval = 36\nfirst line head indent = 0, head indent = 0, tail indent = 0\nline height multiple = 0, maximum line height = 27, minimum line height = 27\nline spacing adjustment = 0, paragraph spacing = 16, paragraph spacing before = 0\n}";
    //        QSRichEditorFontStyle
    
    //        NSMutableDictionary *defaultStyles = [NSMutableDictionary dictionary];
    //
    //        self.richEditor.overrideInsertionAttributes = defaultStyles;
}

@end
