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

// font
@property(nonatomic, strong) UIBarButtonItem *beginTextEditorButton;
@property(nonatomic, strong) UIBarButtonItem *boldButton;
@property(nonatomic, strong) UIBarButtonItem *italicButton;
@property(nonatomic, strong) UIBarButtonItem *strikeThroughButton;

//目前一共提供了三种样式
@property(nonatomic, strong) UIBarButtonItem *fontStyleButton;

// paragraph alignment
@property(nonatomic, strong) UIBarButtonItem *alignButton;

@property(nonatomic, strong) UIBarButtonItem *blockquoteButton;

// lists
@property(nonatomic, strong) UIBarButtonItem *orderedListButton;

//插入照片
@property(nonatomic, strong) UIBarButtonItem *photoButton;

//展开
@property(nonatomic, strong) UIBarButtonItem *moreButton;

//关闭
@property(nonatomic, strong) UIBarButtonItem *textEditorCloseButton;
@property(nonatomic, strong) UIBarButtonItem *moreViewCloseButton;

-(void)setupTextCountItemWithCount:(NSUInteger)count;

-(void)closeMoreView;

-(void)updateStateWithTypingAttributes:(NSDictionary *)attributes;

-(void)initEditorBarItems;

@end
