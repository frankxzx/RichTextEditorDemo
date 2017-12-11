//
//  QSRichEditorViewController+keyboard.m
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import "QSRichEditorViewController+keyboard.h"

@implementation QSRichEditorViewController (keyboard)

/**
 *  键盘frame即将发生变化。
 *  这个delegate除了对应系统的willChangeFrame通知外，在iPad下还增加了监听键盘frame变化的KVO来处理浮动键盘，所以调用次数会比系统默认多。需要让界面或者某个view跟随键盘运动，建议在这个通知delegate里面实现，因为willShow和willHide在手机上是准确的，但是在iPad的浮动键盘下是不准确的。另外，如果不需要跟随浮动键盘运动，那么在逻辑代码里面可以通过判断键盘的位置来过滤这种浮动的情况。
 */
- (void)keyboardWillChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    
    /**
    CATransform3DMakeTranslation (CGFloat tx, CGFloat ty, CGFloattz)
    tx：X轴偏移位置，往下为正数。
    ty：Y轴偏移位置，往右为正数。
    tz：Z轴偏移位置，往外为正数。
    */
    
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

/**
 *  键盘即将显示
 */
- (void)keyboardWillShowWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUILog(@"键盘即将显示");
}

/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHideWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUILog(@"键盘即将隐藏");
}

/**
 *  键盘已经显示
 */
- (void)keyboardDidShowWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUILog(@"键盘已经显示");
}

/**
 *  键盘已经隐藏
 */
- (void)keyboardDidHideWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUILog(@"键盘已经隐藏");
}

/**
 *  键盘frame已经发生变化。
 */
- (void)keyboardDidChangeFrameWithUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    QMUILog(@"键盘frame已经发生变化");
}

-(void)showKeyboard {
    
}

-(void)hideKeyboard {
    
}

@end
