//
//  QSRichTextHtmlWriterManager.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextHtmlWriterManager.h"

@implementation QSRichTextHtmlWriterManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static QSRichTextHtmlWriterManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+(NSString *)htmlString {
    QSRichTextHtmlWriterManager *manager = [QSRichTextHtmlWriterManager sharedInstance];
    NSMutableString *output = [NSMutableString string];
    [output appendString:manager.header];
    [output appendString:manager.tags];
    return output;
}

-(NSString *)css {
    NSString *path = [[NSBundle mainBundle]pathForResource:@"RichTextStyle" ofType:@"css"];
    NSString *css = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    return css;
}

//html header 包含 css 样式
-(NSString *)header {
    NSMutableString *header = [NSMutableString string];
    [header appendFormat:@"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html40/strict.dtd\">\n<html>\n<head>\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />\n<meta http-equiv=\"Content-Style-Type\" content=\"text/css\" />\n<meta name=\"Generator\" content=\"QS HTML Writer\" />\n<style type=\"text/css\">\n%@</style>\n</head>\n<body>\n", self.css];
    return header;
}

//html 标签
-(NSString *)tags {
    NSMutableString *tags = [NSMutableString string];
    
    for (id <QSRichTextHtmlWriter> writer in self.htmlWriters) {
        NSString *html = [writer stringByEncodingAsHTML];
        [tags appendString:html];
    }
    
    return tags;
}

@end
