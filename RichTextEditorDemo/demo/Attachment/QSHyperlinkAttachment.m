//
//  QSHyperlinkAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/15.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSHyperlinkAttachment.h"
#import "DTCoreTextConstants.h"
#import "DTHTMLElement.h"
#import "NSString+HTML.h"

@implementation QSHyperlinkAttachment

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
    
    [retString appendString:@"<a "];
    
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
    
    [retString appendFormat:@"href=\"http://%@\"", self.hyperLinkURL.absoluteString];
    
    [retString appendString:@">"];
    [retString appendString:self.title];
    [retString appendString:@"</a>"];
    
    return retString;
}

@end
