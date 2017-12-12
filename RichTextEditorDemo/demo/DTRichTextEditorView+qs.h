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

- (void)updateTextStyle:(QSRichEditorTextStyle)style inRange:(UITextRange *)range;

@end
