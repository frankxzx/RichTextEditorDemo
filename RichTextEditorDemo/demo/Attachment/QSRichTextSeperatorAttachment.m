//
//  QSRichTextSeperatorAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/15.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextSeperatorAttachment.h"
#import "DTCoreTextConstants.h"
#import "DTHTMLElement.h"
#import "NSString+HTML.h"

@implementation QSRichTextSeperatorAttachment

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options
{
    self = [super initWithElement:element options:options];
    
    if (self)
    {
        // get base URL
        NSURL *baseURL = [options objectForKey:NSBaseURLDocumentOption];
//        NSString *src = [element.attributes objectForKey:@"src"];
        
        // content URL
//        _contentURL = [NSURL URLWithString:src relativeToURL:baseURL];
    }
    
    return self;
}

#pragma mark - DTTextAttachmentHTMLEncoding

- (NSString *)stringByEncodingAsHTML
{
    NSMutableString *retString = [NSMutableString string];
    
    [retString appendString:@"<span"];
    
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

    [styleString appendFormat:@"display:block;"];
    [styleString appendFormat:@"width:100%;"];
    [styleString appendFormat:@"height:0.5px;"];
    [styleString appendFormat:@"background-color:#454242;"];
    
    // add local style for size, since sizes might vary quite a bit
    if ([styleString length])
    {
        [retString appendFormat:@" style=\"%@\"", styleString];
    }
    
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
    
    [retString appendString:@" />"];
    
    return retString;
}

@end
