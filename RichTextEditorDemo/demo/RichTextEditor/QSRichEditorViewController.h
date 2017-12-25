//
//  QSRichEditorViewController.h
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/5.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QMUIKit/QMUIKit.h>

extern CGFloat const toolBarHeight;
extern CGFloat const editorMoreViewHeight;

@interface QSRichEditorViewController : QMUICommonViewController

@property(nonatomic, strong) UIView *toolView;
@property (nonatomic, retain) NSArray *menuItems;

@end

@protocol QSRichEditorViewControllerDelegate <NSObject>

-(void)richEditorViewControllerWillInsertAticleCover;
-(void)richEditorViewControllerWillInsertAticleTitle;

@end
