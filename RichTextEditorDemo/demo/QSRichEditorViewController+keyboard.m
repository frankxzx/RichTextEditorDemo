//
//  QSRichEditorViewController+keyboard.m
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "QSRichEditorViewController+keyboard.h"

@implementation QSRichEditorViewController (keyboard)

- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
	__weak __typeof(self)weakSelf = self;
	[QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
		[QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
			CGFloat distanceFromBottom = [QMUIKeyboardManager distanceFromMinYToBottomInView:weakSelf.view keyboardRect:keyboardUserInfo.endFrame];
			weakSelf.toolView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - CGRectGetHeight(weakSelf.toolView.bounds), 0);
		} completion:NULL];
	} hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
		[QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
			weakSelf.toolView.layer.transform = CATransform3DIdentity;
		} completion:NULL];
	}];
}

-(void)showKeyboard {
    
}

-(void)hideKeyboard {
    
}

@end
