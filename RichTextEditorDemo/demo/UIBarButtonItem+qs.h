//
//  UIBarButtonItem+qs.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (qs)

+(UIBarButtonItem *)qs_setBarButtonItem:(NSString *)imageName target:(id)target action:(SEL)selector;

-(void)qs_setEnable:(BOOL)isEnable;

@end
