//
//  UIBarButtonItem+qs.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/22.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "UIBarButtonItem+qs.h"
#import <QMUIKit/QMUIKit.h>

@interface UIBarButtonItem ()

@property(nonatomic, strong) UIImage *disableImage;
@property(nonatomic, strong) UIImage *originalImage;
@property(nonatomic, strong) UIImage *selectedImage;

@end

@implementation UIBarButtonItem (qs)

+(UIBarButtonItem *)qs_setBarButtonItemWithImage:(UIImage *)iconImage
                                   selectedImage:(UIImage *)selectedImage
                                          target:(id)target
                                          action:(SEL)selector {
    UIBarButtonItem *item = [QMUIToolbarButton barButtonItemWithImage:iconImage.originalImage target:target action:selector];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorGray} forState:UIControlStateDisabled];
    item.originalImage = iconImage.originalImage;
    item.disableImage = [iconImage qmui_imageWithAlpha:0.9];
    item.selectedImage = selectedImage;
    return item;
}

+(UIBarButtonItem *)qs_setBarButtonItemWithImage:(UIImage *)iconImage
                                          target:(id)target
                                          action:(SEL)selector {
    return [UIBarButtonItem qs_setBarButtonItemWithImage:iconImage selectedImage:iconImage target:target action:selector];
}

static char kOriginalImage;
-(void)setOriginalImage:(UIImage *)originalImage {
     objc_setAssociatedObject(self, &kOriginalImage, originalImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)originalImage {
    return (UIImage *)objc_getAssociatedObject(self, &kOriginalImage);
}

static char kDisableImage;
-(void)setDisableImage:(UIImage *)disableImage {
    objc_setAssociatedObject(self, &kDisableImage, disableImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)disableImage {
    return (UIImage *)objc_getAssociatedObject(self, &kDisableImage);
}

static char kSelectedImage;
-(void)setSelectedImage:(UIImage *)selectedImage {
    objc_setAssociatedObject(self, &kSelectedImage, selectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImage *)selectedImage {
    return (UIImage *)objc_getAssociatedObject(self, &kSelectedImage);
}

-(void)qs_setEnable:(BOOL)isEnable {
    if (isEnable) {
        [self setImage:self.originalImage];
    } else {
        [self setImage: self.disableImage];
    }
    self.enabled = isEnable;
}

-(void)qs_setSelected:(BOOL)isSelected {
    if (isSelected) {
        [self setImage:self.selectedImage];
    } else {
        [self setImage: self.originalImage];
    }
}

@end

@implementation UIImage (qs)

-(UIImage *)originalImage {
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
