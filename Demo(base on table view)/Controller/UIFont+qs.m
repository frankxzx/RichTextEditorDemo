//
//  UIFont+qs.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/9.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "UIFont+qs.h"

@implementation UIFont (qs)

-(BOOL)isBold {
    UIFontDescriptor *fontDescriptor = self.fontDescriptor;
    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
    BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
    return isBold;
}

//-(BOOL)isLarge {
//    UIFontDescriptor *fontDescriptor = self.fontDescriptor;
//    UIFontDescriptorSymbolicTraits fontDescriptorSymbolicTraits = fontDescriptor.symbolicTraits;
//    //BOOL isBold = (fontDescriptorSymbolicTraits & UIFontDescriptorTraitBold) != 0;
////    return <#expression#>
//}

@end
