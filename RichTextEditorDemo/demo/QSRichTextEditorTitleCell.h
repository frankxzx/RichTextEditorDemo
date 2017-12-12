//
//  QSRichTextEditorTitleCell.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>
#import "QSRichEditorViewController.h"
#import "QSRichTextEditorCell.h"
#import <YYText/YYText.h>

@interface QSRichTextEditorTitleCell : QSRichTextEditorCell

@property(nonatomic, weak) id<QSRichEditorViewControllerDelegate> cellDelegate;
@property(nonatomic, strong) YYTextView *titleTextView;

@end

