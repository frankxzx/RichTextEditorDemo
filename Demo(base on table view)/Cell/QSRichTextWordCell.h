//
//  QSRichTextWordCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import <YYText/YYText.h>

@interface QSRichTextWordCell : QSRichTextCell

@property(nonatomic, strong, readonly) YYTextView * textView;

- (void)renderRichText:(NSString *)text;

@end
