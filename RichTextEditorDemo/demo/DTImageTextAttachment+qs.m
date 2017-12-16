//
//  DTImageTextAttachment+qs.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/16.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTImageTextAttachment+qs.h"
#import <objc/runtime.h>

@implementation DTImageTextAttachment (qs)

static char kIsCaption;
-(void)setIsCaption:(BOOL)isCaption {
    NSNumber *isCaptionObject = [NSNumber numberWithBool: isCaption];
    objc_setAssociatedObject(self, &kIsCaption, isCaptionObject, OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)isCaption {
    NSNumber *object = objc_getAssociatedObject(self, &kIsCaption);
    return [object boolValue];
}

static char kCaptionText;
-(void)setCaptionText:(NSString *)captionText {
    objc_setAssociatedObject(self, &kCaptionText, captionText, OBJC_ASSOCIATION_COPY);
}

-(NSString *)captionText {
     return (NSString *)objc_getAssociatedObject(self, &kCaptionText);
}

@end
