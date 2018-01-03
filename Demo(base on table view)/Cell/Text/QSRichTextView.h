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
@property(nonatomic, assign) BOOL shouldRejectSystemScroll;// 如果在 handleTextChanged: 里主动调整 contentOffset，则为了避免被系统的自动调整覆盖，会利用这个标记去屏蔽系统对 setContentOffset: 的调用

- (void)qmui_scrollCaretVisibleAnimated:(BOOL)animated;

@end
