//
//  NSAttributedString+ListStyle.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/5.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QSRichTextListStyle) {
    QSRichTextListStyleNone,
    QSRichTextListStyleCircle,
    QSRichTextListStyleNumber,
};

@interface NSAttributedString (ListStyle)

- (void)updateListStyle:(QSRichTextListStyle)listStyle inRange:(NSRange)range;

@end
