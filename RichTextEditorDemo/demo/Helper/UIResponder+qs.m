//
//  UIResponder+qs.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/28.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "UIResponder+qs.h"

@implementation UIResponder (qs)

static __weak id currentFirstResponder;
+(id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}
-(void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end
