//
//  DTTextPlaceholderAttachment.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/20.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTTextPlaceholderAttachment.h"
#import <QMUIKit/QMUIKit.h>

static UIEdgeInsets const kInsets = {16, 20, 16, 20};

@implementation DTTextPlaceholderAttachment

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options
{
    self = [super initWithElement:element options:options];
    
    if (self)
    {
        self.displaySize = CGSizeMake(SCREEN_WIDTH - 40, 60);
    }
    
    return self;
}

#pragma mark - DTTextAttachmentHTMLEncoding

- (NSString *)stringByEncodingAsHTML
{
    NSMutableString *retString = [NSMutableString string];
    
    [retString appendString:@"<cover></cover>"];
    
    return retString;
}

@end

@implementation DTTextTitleAttachment

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options
{
    self = [super initWithElement:element options:options];
    
    if (self)
    {
        self.displaySize = CGRectInsetEdges(CGRectMake(0, 0, SCREEN_WIDTH, 120), kInsets).size;
    }
    
    return self;
}

#pragma mark - DTTextAttachmentHTMLEncoding

- (NSString *)stringByEncodingAsHTML
{
    NSMutableString *retString = [NSMutableString string];
    
    [retString appendString:@"<richTextEditorTitle></richTextEditorTitle>"];

    return retString;
}

@end
