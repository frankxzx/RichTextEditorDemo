//
//  QSRichTextController.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>
#import "QSRichTextView.h"
#import "QSRichTextBar.h"

@interface QSRichTextController :QMUICommonTableViewController

@property(nonatomic, weak) QSRichTextView *currentTextView;
@property(nonatomic, strong) QSRichTextBar *toolBar;

@end
