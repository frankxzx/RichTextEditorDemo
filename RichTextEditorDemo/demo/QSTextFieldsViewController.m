//
//  QSTextFieldsViewController.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/15.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSTextFieldsViewController.h"

@interface QSTextFieldsViewController ()

@property(nonatomic,strong,readwrite) QMUITextField *textField1;
@property(nonatomic,strong,readwrite) QMUITextField *textField2;

@end

@implementation QSTextFieldsViewController

- (void)didInitialized {
    [super didInitialized];
    self.enablesSubmitButtonAutomatically = YES;
    BeginIgnoreAvailabilityWarning
    [self loadViewIfNeeded];
    EndIgnoreAvailabilityWarning
}

- (void)initSubviews {
    [super initSubviews];
    self.textField1 = [[QMUITextField alloc] init];
    self.textField1.backgroundColor = UIColorWhite;
    self.textField1.textInsets = UIEdgeInsetsMake(self.textField1.textInsets.top, 16, self.textField1.textInsets.bottom, 16);
    self.textField1.returnKeyType = UIReturnKeyDone;
    self.textField1.enablesReturnKeyAutomatically = self.enablesSubmitButtonAutomatically;
    [self.textField1 addTarget:self action:@selector(handleTextFieldTextDidChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField1];
    
    self.textField2 = [[QMUITextField alloc] init];
    self.textField2.qmui_borderPosition = QMUIImageBorderPositionTop;
    self.textField2.backgroundColor = UIColorWhite;
    self.textField2.textInsets = UIEdgeInsetsMake(self.textField2.textInsets.top, 16, self.textField2.textInsets.bottom, 16);
    self.textField2.returnKeyType = UIReturnKeyDone;
    self.textField2.enablesReturnKeyAutomatically = self.enablesSubmitButtonAutomatically;
    [self.textField2 addTarget:self action:@selector(handleTextFieldTextDidChangeEvent:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField2];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat textFieldHeight = 56;
    self.textField1.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), CGRectGetWidth(self.view.bounds), textFieldHeight);
    self.textField2.frame = CGRectMake(0, CGRectGetMaxY(self.textField1.frame), CGRectGetWidth(self.view.bounds), textFieldHeight);
    [self.titleView.titleLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.textField1 becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
}

#pragma mark - Submit Button Enables

- (void)setEnablesSubmitButtonAutomatically:(BOOL)enablesSubmitButtonAutomatically {
    _enablesSubmitButtonAutomatically = enablesSubmitButtonAutomatically;
    self.textField1.enablesReturnKeyAutomatically = _enablesSubmitButtonAutomatically;
    self.textField1.enablesReturnKeyAutomatically = _enablesSubmitButtonAutomatically;
    if (_enablesSubmitButtonAutomatically) {
        [self updateSubmitButtonEnables];
    }
}

- (void)updateSubmitButtonEnables {
    self.submitButton.enabled = [self shouldEnabledSubmitButton];
}

- (BOOL)shouldEnabledSubmitButton {
    if (self.shouldEnableSubmitButtonBlock) {
        return self.shouldEnableSubmitButtonBlock(self);
    }
    
    if (self.enablesSubmitButtonAutomatically) {
        NSInteger textLength = self.textField1.text.qmui_trim.length;
        return 0 < textLength && textLength <= self.textField1.maximumTextLength;
    }
    
    if (self.enablesSubmitButtonAutomatically) {
        NSInteger textLength = self.textField2.text.qmui_trim.length;
        return 0 < textLength && textLength <= self.textField2.maximumTextLength;
    }
    
    return YES;
}

- (void)handleTextFieldTextDidChangeEvent:(QMUITextField *)textField {
    if (self.textField1 == textField || self.textField2 == textField) {
        [self updateSubmitButtonEnables];
    }
}

- (void)addSubmitButtonWithText:(NSString *)buttonText block:(void (^)(QMUIDialogViewController *dialogViewController))block {
    [super addSubmitButtonWithText:buttonText block:block];
    [self updateSubmitButtonEnables];
}

#pragma mark - <QMUIModalPresentationContentViewControllerProtocol>

- (CGSize)preferredContentSizeInModalPresentationViewController:(QMUIModalPresentationViewController *)controller limitSize:(CGSize)limitSize {
    CGFloat textFieldHeight = 56;
    return CGSizeMake(limitSize.width, CGRectGetHeight(self.headerView.frame) + textFieldHeight + textFieldHeight + (!self.footerView.hidden ?  CGRectGetHeight(self.footerView.frame) : 0));
}

@end
