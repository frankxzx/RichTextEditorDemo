//
//  DTTextPlaceholderAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/20.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTTextPlaceholderAttachment.h"

@implementation DTTextPlaceholderAttachment

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
    
    [retString appendString:@"<p class='imageDes';"];
    
    NSMutableString *styleString = [NSMutableString string];
    
    [styleString appendFormat:@"font-size:12px;"];
    [styleString appendFormat:@"color: #e2e2e2;"];
    [styleString appendFormat:@"margin:8px;"];
    [styleString appendFormat:@"text-align:center;"];
    
    // add local style for size, since sizes might vary quite a bit
    if ([styleString length])
    {
        [retString appendFormat:@" style=\"%@\"", styleString];
    }
    
    [retString appendString:@">"];
    
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
    
    
    [retString appendString:@"</p>"];
    
    return retString;
}

@end
