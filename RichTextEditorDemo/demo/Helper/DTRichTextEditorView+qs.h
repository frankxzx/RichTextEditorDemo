//
//  DTRichTextEditorView+qs.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/12.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTRichTextEditor/DTRichTextEditor.h>
#import "QSRichEditorFontStyle.h"

@interface DTRichTextEditorView (qs)

-(void)qs_setLineSpacing:(CGFloat)space;

-(DTTextAttachment *)qs_attachmentWithRange:(DTTextRange *)range;

-(DTTextRange *)qs_rangeOfAttachment:(DTTextAttachment *)attachment;

-(DTTextRange *)qs_selectedTextRange;

- (DTCoreTextLayoutLine *)currentLine;

- (void)updateTextStyle:(QSRichEditorTextStyle)style inRange:(UITextRange *)range;

-(void)insertAttachment:(DTTextAttachment *)attchment;

@end
