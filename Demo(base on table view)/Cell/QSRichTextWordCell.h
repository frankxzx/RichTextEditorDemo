//
//  QSRichTextWordCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import "QSRichTextView.h"

@interface QSRichTextWordCell : QSRichTextCell

@property(nonatomic, strong, readonly) QSRichTextView * textView;

- (void)renderRichText:(NSAttributedString *)text;

@end
