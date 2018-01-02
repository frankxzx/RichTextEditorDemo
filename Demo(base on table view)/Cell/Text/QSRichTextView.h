//
//  QSRichTextView.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <YYText/YYText.h>

@class QSRichTextView;
@protocol QSRichTextViewDelegate <NSObject>

- (void)qsTextFieldDeleteBackward:(QSRichTextView *)textView;
- (void)qsTextView:(QSRichTextView *)textView newHeightAfterTextChanged:(CGFloat)newHeight;

@end

@interface QSRichTextView : YYTextView

@property (nonatomic,weak) id <QSRichTextViewDelegate> qs_delegate;

@end
