//
//  QSRichTextWordCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import "QSRichTextView.h"

@protocol QSRichTextWordCellDelegate <QSRichTextViewDelegate>

@end

@interface QSRichTextWordCell : QSRichTextCell

@property(nonatomic, strong, readonly) QSRichTextView * textView;
@property (nonatomic,weak) id <QSRichTextWordCellDelegate> qs_delegate;

- (void)renderRichText:(NSAttributedString *)text;

@end
