//
//  QSRichTextEditorCoverCell.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "QSRichEditorViewController.h"
#import "QSRichTextEditorCell.h"

@interface QSRichTextEditorCoverCell : QSRichTextEditorCell

@property(nonatomic, weak) id<QSRichEditorViewControllerDelegate> cellDelegate;

@end

