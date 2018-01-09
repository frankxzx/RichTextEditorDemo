//
//  QSRichTextModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextModel.h"

NSString *const QSRichTextLinkAttributedName = @"QSRichTextLinkAttributedName";

@implementation QSRichTextModel

-(instancetype)initWithCellType:(QSRichTextCellType)cellType {
    if (self = [super init]) {
        self.cellType = cellType;
    }
    return self;
}

-(NSString *)reuseID {
    switch (self.cellType) {
        case QSRichTextCellTypeText:
            return @"QSRichTextWordCell";
            
        case QSRichTextCellTypeSeparator:
            return @"QSRichTextSeparatorCell";
            
        case QSRichTextCellTypeImage:
            return @"QSRichTextImageCell";
            
        case QSRichTextCellTypeVideo:
            return @"QSRichTextVideoCell";
            
        case QSRichTextCellTypeImageCaption:
            return @"QSRichTextImageCaptionCell";
            
        case QSRichTextCellTypeCover:
            return @"QSRichTextAddCoverCell";
            
        case QSRichTextCellTypeTitle:
            return @"QSRichTextTitleCell";
            
        case QSRichTextCellTypeTextBlock:
            return @"QSRichTextBlockCell";
            
        case QSRichTextCellTypeListCellNone:
            return @"QSRichTextListCell";
        case QSRichTextCellTypeListCellCircle:
            return @"QSRichTextListCircleCell";
        case QSRichTextCellTypeListCellNumber:
            return @"QSRichTextListNumberCell";
        case QSRichTextCellTypeCodeBlock:
            return @"QSRichTextCodeBlockCell";
    }
}

-(NSString *)stringByEncodingAsHTML {
    
    NSMutableAttributedString *(^applyStrikeThroughText)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:YYTextStrikethroughAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            YYTextDecoration *strikethrough = value;
            if (strikethrough) {
                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<strike>%@</strike>", [attributedText.string substringWithRange:range]]];
            }
        }];
        return text;
    };
    
    NSMutableAttributedString *(^applyBold)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:NSFontAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            UIFont *font = value;
            if (font) {
                UIFontDescriptor *fontDescriptor = font.fontDescriptor;
                UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
                BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
                if (isBold) {
                    [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<b>%@</b>", [attributedText.string substringWithRange:range]]];
                }
            }
        }];
        return text;
    };
    
    NSMutableAttributedString *(^applyFontStyle)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:NSFontAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            UIFont *font = value;
            if (font) {
                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<font style=\"font-size:%fpx\">%@</font>", font.pointSize, [attributedText.string substringWithRange:range]]];
            }
        }];
        return text;
    };
    
    NSMutableAttributedString *(^applyTextColor)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:NSForegroundColorAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            UIColor *color = value;
            if (color) {
                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@" <font style=\"color:%@\">%@</font>", [QSRichTextModel hexStringFromColor:color], [attributedText.string substringWithRange:range]]];
            }
        }];
        return text;
    };
    
    NSMutableAttributedString *(^applyItalicText)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:YYTextGlyphTransformAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            NSValue *transform = value;
            if (transform) {
                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<i>%@</i>", [attributedText.string substringWithRange:range]]];
            }
        }];
        return text;
    };
    
//    NSMutableAttributedString *(^applyNumberListType)(QSRichTextCellType, NSMutableAttributedString *) = ^(QSRichTextCellType cellType, NSMutableAttributedString *attributedText) {
//        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
//        if (cellType == QSRichTextCellTypeListCellNumber) {
//            [text yy_insertString:@"<ol>" atIndex:0];
//            [text yy_insertString:@"</ol>" atIndex:attributedText.length];
//        } else {
//            [text yy_insertString:@"<ul>" atIndex:0];
//            [text yy_insertString:@"</ul>" atIndex:attributedText.length];
//        }
//
//        [attributedText enumerateAttribute:YYTextGlyphTransformAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
//            NSValue *transform = value;
//            if (transform) {
//                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<i>%@</i>", [attributedText.string substringWithRange:range]]];
//            }
//        }];
//        return text;
//    };
    
    NSMutableAttributedString *(^applyHyperlink)(NSMutableAttributedString *) = ^(NSMutableAttributedString *attributedText) {
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithAttributedString:attributedText];
        [attributedText enumerateAttribute:YYTextAttachmentAttributeName inRange:attributedText.yy_rangeOfAll options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            YYTextAttachment *attach = value;
            QSRichTextHyperlink *link = attach.userInfo[QSRichTextLinkAttributedName];
            if (link) {
                [text replaceCharactersInRange:range withString:[NSString stringWithFormat:@"<a href=\"http://%@\">%@</a>", link.link, link.title]];
            }
        }];
        return text;
    };
    
    NSMutableString *htmlString = [[NSMutableString alloc]init];
    switch (self.cellType) {
        case QSRichTextCellTypeCover:
            [htmlString appendString:@"<img src=https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513334563991&di=7ecafd20cfd4bfd2a7516f1034241df6&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F29381f30e924b89905322ad164061d950b7bf6c9.jpg width=\'100%\'/>"];
            break;
        case QSRichTextCellTypeTitle:
            [htmlString appendFormat:@"<div class='title'>%@</div>", self.attributedString.string];
            break;
        case QSRichTextCellTypeText:
        case QSRichTextCellTypeListCellNumber:
        case QSRichTextCellTypeListCellCircle:
        case QSRichTextCellTypeListCellNone:
           [htmlString appendFormat:@"<div>%@</div>", applyHyperlink(applyTextColor(applyBold(applyStrikeThroughText(applyFontStyle(applyItalicText(self.attributedString)))))).string];
            break;
        case QSRichTextCellTypeImage:
            [htmlString appendString:@"<img src=https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513334563991&di=7ecafd20cfd4bfd2a7516f1034241df6&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F29381f30e924b89905322ad164061d950b7bf6c9.jpg width=\'100%\'/>"];
            break;
        case QSRichTextCellTypeVideo:
            [htmlString appendString:@"<video controls poster=\"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1513334563991&di=7ecafd20cfd4bfd2a7516f1034241df6&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F29381f30e924b89905322ad164061d950b7bf6c9.jpg\" width=\'100%\' controls=\'controls\'> <source src=https://lightsns.oss-cn-qingdao.aliyuncs.com/demo_video.mp4 type=\"video/mp4\" /></video>"];
            break;
        case QSRichTextCellTypeSeparator:
            [htmlString appendString:@"<hr></hr>"];
            break;
        case QSRichTextCellTypeImageCaption:
            [htmlString appendFormat:@"<div class='imageDes'>%@</div>", self.attributedString.string];
            break;
        case QSRichTextCellTypeTextBlock:
            [htmlString appendFormat:@"<div class='block'>%@</div>", self.attributedString.string];
            break;
        case QSRichTextCellTypeCodeBlock:
            [htmlString appendFormat:@"<div class='codeBlock'>%@</div>", self.attributedString.string];
            break;
        default:
            [htmlString appendFormat:@"<div>%@</div>", self.attributedString.string];
            break;
    }
    
    return  [htmlString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
}

+ (NSString *)hexStringFromColor:(UIColor *)color
{
    CGColorSpaceModel colorSpace = CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r, g, b, a;
    
    if (colorSpace == kCGColorSpaceModelMonochrome) {
        r = components[0];
        g = components[0];
        b = components[0];
        a = components[1];
    }
    else if (colorSpace == kCGColorSpaceModelRGB) {
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    } 
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255),
            lroundf(a * 255)];
}

@end
