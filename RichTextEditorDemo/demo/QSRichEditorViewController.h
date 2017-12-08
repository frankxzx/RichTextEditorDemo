//
//  QSRichEditorViewController.h
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/5.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

@interface QSRichEditorViewController : QMUICommonTableViewController

@property(nonatomic, strong) UIView *toolView;

@end

@protocol QSRichEditorViewControllerDelegate <NSObject>

-(void)richEditorViewControllerWillInsertAticleCover;
-(void)richEditorViewControllerWillInsertAticleTitle;

@end
