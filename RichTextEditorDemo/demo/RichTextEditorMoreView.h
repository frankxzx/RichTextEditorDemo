//
//  RichTextEditorMoreView.h
//  DemoApp
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 Drobnik.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichTextEditorToolBar.h"

@interface RichTextEditorMoreView : UIView

@property (weak, nonatomic) id<RichTextEditorAction> actionDelegate;

@end
