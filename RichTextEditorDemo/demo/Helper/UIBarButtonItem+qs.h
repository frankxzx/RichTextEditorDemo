//
//  UIBarButtonItem+qs.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (qs)

+(UIBarButtonItem *)qs_setBarButtonItemWithImage:(UIImage *)iconImage
                                   selectedImage:(UIImage *)selectedImage
                                          target:(id)target
                                          action:(SEL)selector;

+(UIBarButtonItem *)qs_setBarButtonItemWithImage:(UIImage *)iconImage
                                          target:(id)target
                                          action:(SEL)selector;

-(void)qs_setEnable:(BOOL)isEnable;
-(void)qs_setSelected:(BOOL)isSelected;

@property(nonatomic, strong, readonly) UIImage *originalImage;

@end

@interface UIImage (qs)

@property(nonatomic, strong, readonly) UIImage *originalImage;

@end
