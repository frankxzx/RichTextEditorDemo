//
//  QSImageAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSImageAttachment.h"

@implementation QSImageAttachment

- (NSString *)stringByEncodingAsHTML
{
    NSMutableString *retString = [NSMutableString string];
    NSString *urlString;
    
    if (_contentURL)
    {
        
        if ([_contentURL isFileURL])
        {
            NSString *path = [_contentURL path];
            
            NSRange range = [path rangeOfString:@".app/"];
            
            if (range.length)
            {
                urlString = [path substringFromIndex:NSMaxRange(range)];
            }
            else
            {
                urlString = [_contentURL absoluteString];
            }
        }
        else
        {
            urlString = [_contentURL relativeString];
        }
    }
    else
    {
        urlString = [self dataURLRepresentation];
    }
    
    // output tag start
    [retString appendString:@"<img"];
    
    // build style for img/video
    NSMutableString *styleString = [NSMutableString string];
    
    switch (_verticalAlignment)
    {
        case DTTextAttachmentVerticalAlignmentBaseline:
        {
            //                [classStyleString appendString:@"vertical-align:baseline;"];
            break;
        }
        case DTTextAttachmentVerticalAlignmentTop:
        {
            [styleString appendString:@"vertical-align:text-top;"];
            break;
        }
        case DTTextAttachmentVerticalAlignmentCenter:
        {
            [styleString appendString:@"vertical-align:middle;"];
            break;
        }
        case DTTextAttachmentVerticalAlignmentBottom:
        {
            [styleString appendString:@"vertical-align:text-bottom;"];
            break;
        }
    }
    
    if (_originalSize.width>0)
    {
        [styleString appendString:@"width:100%;"];
    }
    
//    if (_originalSize.height>0)
//    {
//        [styleString appendFormat:@"height:%.0fpx;", _originalSize.height];
//    }
    
    // add local style for size, since sizes might vary quite a bit
    if ([styleString length])
    {
        [retString appendFormat:@" style=\"%@\"", styleString];
    }
    
    [retString appendFormat:@" src=\"%@\"", urlString];
    
    // attach the attributes dictionary
    NSMutableDictionary *tmpAttributes = [_attributes mutableCopy];
    
    // remove src,style, width and height we already have these
    [tmpAttributes removeObjectForKey:@"src"];
    [tmpAttributes removeObjectForKey:@"style"];
    [tmpAttributes removeObjectForKey:@"width"];
    [tmpAttributes removeObjectForKey:@"height"];
    
    for (__strong NSString *oneKey in [tmpAttributes allKeys])
    {
        oneKey = [oneKey stringByAddingHTMLEntities];
        NSString *value = [[tmpAttributes objectForKey:oneKey] stringByAddingHTMLEntities];
        [retString appendFormat:@" %@=\"%@\"", oneKey, value];
    }
    
    // end
    [retString appendString:@" />"];
    
    return retString;
}


@end
