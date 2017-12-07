//
//  RichTextEditorToolBar.h
//  Demo App
//
//  Created by Xuzixiang on 2017/12/5.
//  Copyright © 2017年 Cocoanetics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTCoreText/DTCoreText.h>

@protocol RichTextEditorAction;

@interface RichTextEditorToolBar: UIToolbar

@property (weak, nonatomic) id<RichTextEditorAction> formatDelegate;

@end
