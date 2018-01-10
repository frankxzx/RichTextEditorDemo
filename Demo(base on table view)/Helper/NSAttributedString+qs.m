//
//  NSAttributedString+qs.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/9.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "NSAttributedString+qs.h"
#import <QMUIKit/QMUIKit.h>

@implementation NSAttributedString (qs)

+ (NSMutableAttributedString *)yy_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                               attachmentSize:(CGSize)attachmentSize
                                                  alignToFont:(UIFont *)font
                                                    alignment:(YYTextVerticalAlignment)alignment
                                                     userInfo:(NSDictionary *)userInfo {
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    
    YYTextAttachment *attach = [YYTextAttachment new];
    attach.content = content;
    attach.contentMode = contentMode;
    attach.userInfo = userInfo.copy;
    [atr yy_setTextAttachment:attach range:NSMakeRange(0, atr.length)];
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.width = attachmentSize.width;
    switch (alignment) {
        case YYTextVerticalAlignmentTop: {
            delegate.ascent = font.ascender;
            delegate.descent = attachmentSize.height - font.ascender;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentCenter: {
            CGFloat fontHeight = font.ascender - font.descender;
            CGFloat yOffset = font.ascender - fontHeight * 0.5;
            delegate.ascent = attachmentSize.height * 0.5 + yOffset;
            delegate.descent = attachmentSize.height - delegate.ascent;
            if (delegate.descent < 0) {
                delegate.descent = 0;
                delegate.ascent = attachmentSize.height;
            }
        } break;
        case YYTextVerticalAlignmentBottom: {
            delegate.ascent = attachmentSize.height + font.descender;
            delegate.descent = -font.descender;
            if (delegate.ascent < 0) {
                delegate.ascent = 0;
                delegate.descent = attachmentSize.height;
            }
        } break;
        default: {
            delegate.ascent = attachmentSize.height;
            delegate.descent = 0;
        } break;
    }
    
    CTRunDelegateRef delegateRef = delegate.CTRunDelegate;
    [atr yy_setRunDelegate:delegateRef range:NSMakeRange(0, atr.length)];
    if (delegate) CFRelease(delegateRef);
    
    return atr;
}

-(BOOL)isBold {
    UIFontDescriptor *fontDescriptor = self.yy_font.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    return isBold;
}

-(BOOL)isItalic {
    return  CGAffineTransformEqualToTransform(self.yy_textGlyphTransform, YYTextCGAffineTransformMakeSkew(-0.3, 0));
}

-(BOOL)isStrikeThrough {
    return self.yy_textStrikethrough.style == YYTextLineStyleSingle;
}

-(QSRichEditorTextStyle)qsStyle {
    UIColor *color = self.yy_color;
    UIFont *font = self.yy_font;
    
    if (color == QSRichEditorPlaceholderColor && font == QSRichEditorPlaceholderFont) {
        return QSRichEditorTextStylePlaceholder;
    } else if (color == QSRichEditorNormalColor && font == QSRichEditorNormalFont) {
        return QSRichEditorTextStyleNormal;
    } else if (color == QSRichEditorLargerColor && font == QSRichEditorLargerFont) {
        return QSRichEditorTextStyleLarger;
    }
    return QSRichEditorTextStyleNormal;
}

@end
