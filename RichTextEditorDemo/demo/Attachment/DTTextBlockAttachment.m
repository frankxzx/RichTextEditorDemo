//
//  DTTextBlockAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/19.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTTextBlockAttachment.h"

@implementation DTTextBlockAttachment


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
    
    [retString appendString:@"<p class='block';"];
    
    NSMutableString *styleString = [NSMutableString string];
    
    [styleString appendFormat:@"padding:20px;"];
    [styleString appendFormat:@"border-radius: 3px;"];
    [styleString appendFormat:@"background-color:#F0F0F0;"];
    [styleString appendFormat:@"border-style:solid;"];
    [styleString appendFormat:@"border-width: 1px;"];
    [styleString appendFormat:@"border-color: #E0E0E0;"];
    [styleString appendFormat:@"font-size: 18px;"];
    [styleString appendFormat:@"color: #656565;"];
    
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
    
    [retString appendFormat:@"%@", self.text];
    [retString appendString:@"</p>"];
    
    return retString;
}

@end
