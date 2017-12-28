//
//  DTTextAttachment+qs.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/28.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "DTTextAttachment+qs.h"
#import <objc/runtime.h>

@implementation DTTextAttachment (qs)

static char kRange;
-(void)setRange:(DTTextRange *)range {
    objc_setAssociatedObject(self, &kRange, range, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(DTTextRange *)range {
    return (DTTextRange *)objc_getAssociatedObject(self, &kRange);
}

@end
