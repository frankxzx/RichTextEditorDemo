//
//  NSAttributedString+qs.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/9.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import <YYText/YYText.h>

@interface NSAttributedString (qs)

+ (NSMutableAttributedString *)yy_attachmentStringWithContent:(id)content
                                                  contentMode:(UIViewContentMode)contentMode
                                               attachmentSize:(CGSize)attachmentSize
                                                  alignToFont:(UIFont *)font
                                                    alignment:(YYTextVerticalAlignment)alignment
                                                     userInfo:(NSDictionary *)userInfo;

@end
