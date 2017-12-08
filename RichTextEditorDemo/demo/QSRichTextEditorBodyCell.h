//
//  QSRichTextEditorBodyCell.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import <DTRichTextEditor/DTRichTextEditor.h>
#import "QSRichTextEditorCell.h"

@interface QSRichTextEditorBodyCell : QSRichTextEditorCell

@property(nonatomic, strong) DTRichTextEditorView *richEditor;

@end
