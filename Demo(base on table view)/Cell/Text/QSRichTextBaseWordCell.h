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

-(void)qsTextViewDidChangeText:(QSRichTextView *)textView;

-(void)qsTextViewDidChanege:(QSRichTextView *)textView selectedRange:(NSRange)selectedRange;

-(BOOL)qsTextView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

-(BOOL)qsTextViewShouldBeginEditing:(YYTextView *)textView;

@end

//超链接按钮
@interface QSRichTextLinkButton: QMUILinkButton

@property(nonatomic, strong) QSRichTextHyperlink *link;

@end

@interface QSRichTextBaseWordCell : QSRichTextCell <YYTextViewDelegate>

@property (nonatomic, strong, readonly) QSRichTextView * textView;
@property (nonatomic, weak) id <QSRichTextWordCellDelegate> qs_delegate;

- (void)renderRichText:(NSAttributedString *)text;
- (void)makeUI;

@end
