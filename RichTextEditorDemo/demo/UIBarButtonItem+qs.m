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

@property(nonatomic, strong) UIImage *originalImage;

@property(nonatomic, strong) UIImage *disableImage;

@end

@implementation UIBarButtonItem (qs)

+(UIBarButtonItem *)qs_setBarButtonItem:(NSString *)imageName target:(id)target action:(SEL)selector {
    UIImage *iconImage = [UIImageMake(imageName) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [QMUIToolbarButton barButtonItemWithImage:iconImage target:target action:selector];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorGray} forState:UIControlStateDisabled];
    item.originalImage = iconImage;
    item.disableImage = [iconImage qmui_imageWithAlpha:0.9];
    return item;
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


-(void)qs_setEnable:(BOOL)isEnable {
    if (isEnable) {
        [self setImage:self.originalImage];
    } else {
        [self setImage: self.disableImage];
    }
    self.enabled = isEnable;
}

@end
