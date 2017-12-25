//
//  QSTextFieldsViewController.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/15.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

@interface QSTextFieldsViewController : QMUIDialogViewController

@property(nonatomic, strong, readonly) QMUITextField *textField1;
@property(nonatomic, strong, readonly) QMUITextField *textField2;

/// 是否自动控制提交按钮的enabled状态，默认为YES，则当输入框内容为空时禁用提交按钮
@property(nonatomic, assign) BOOL enablesSubmitButtonAutomatically;
@property(nonatomic, copy) BOOL (^shouldEnableSubmitButtonBlock)(QSTextFieldsViewController *dialogViewController);

@end
