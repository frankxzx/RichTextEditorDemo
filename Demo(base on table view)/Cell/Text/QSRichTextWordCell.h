//
//  QSRichTextWordCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextCell.h"
#import "QSRichTextView.h"
#import <YYText/YYText.h>
#import "QSRichTextBar.h"

@protocol QSRichTextWordCellDelegate <QSRichTextViewDelegate, QSRichTextEditorFormat>

-(void)qsTextViewDidChange:(YYTextView *)textView;

@end

@interface QSRichTextWordCell : QSRichTextCell

@property(nonatomic, strong, readonly) QSRichTextView * textView;
@property (nonatomic,weak) id <QSRichTextWordCellDelegate> qs_delegate;

- (void)renderRichText:(NSAttributedString *)text;
- (void)setArticleStyle;
- (void)setBodyTextStyle;
- (void)setImageCaptionStyle;

@end
