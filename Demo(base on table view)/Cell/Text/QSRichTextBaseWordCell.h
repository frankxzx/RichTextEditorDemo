//
//  QSRichTextBaseWordCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/4.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import <QMUIKit/QMUIKit.h>
#import "QSRichTextView.h"
#import <YYText/YYText.h>
#import "QSRichTextBar.h"

@protocol QSRichTextWordCellDelegate <QSRichTextViewDelegate, QSRichTextEditorFormat>

-(void)qsTextViewDidChange:(QSRichTextView *)textView;

@end

@interface QSRichTextBaseWordCell : QSRichTextCell

@property (nonatomic, strong, readonly) QSRichTextView * textView;
@property (nonatomic, weak) id <QSRichTextWordCellDelegate> qs_delegate;

- (void)renderRichText:(NSAttributedString *)text;
- (void)setBodyTextStyleWithPlaceholder:(BOOL)isFirstLine;
- (void)makeUI;

@end
