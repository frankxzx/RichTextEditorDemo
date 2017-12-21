//
//  DTRichTextEditorView+qs.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/12.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTRichTextEditor/DTRichTextEditor.h>
#import "RichTextEditorAction.h"

@interface DTRichTextEditorView (qs)

-(DTTextAttachment *)qs_attachmentWithRange:(DTTextRange *)range;

-(DTTextRange *)qs_rangeOfAttachment:(DTTextAttachment *)attachment;

-(DTTextRange *)qs_selectedTextRange;

- (DTCoreTextLayoutLine *)currentLine;

- (void)updateTextStyle:(QSRichEditorTextStyle)style inRange:(UITextRange *)range;

- (NSAttributedString *)attributedStringForTextRange:(DTTextRange *)textRange wrappingAttachment:(DTTextAttachment *)attachment inParagraph:(BOOL)inParagraph;

@end
