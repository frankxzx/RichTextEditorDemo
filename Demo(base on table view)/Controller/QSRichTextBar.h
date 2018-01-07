//
//  QSRIchTextBar.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSRichEditorFontStyle.h"
#import "QSRichTextHyperlink.h"
#import "UIBarButtonItem+qs.h"

typedef NS_ENUM(NSUInteger, QSRichTextListStyleType) {
    QSRichTextListTypeNone,
    QSRichTextListTypeCircle,
    QSRichTextListTypeDecimal
};

@protocol QSRichTextEditorFormat;
@interface QSRichTextBar : UIToolbar

@property (weak, nonatomic) id<QSRichTextEditorFormat> formatDelegate;

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

-(void)setListType:(QSRichTextListStyleType)listType;

@end

@protocol QSRichTextEditorFormat <NSObject>

- (void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style;
- (void)formatDidToggleBold;
- (void)formatDidToggleItalic;
- (void)formatDidToggleStrikethrough;
- (void)formatDidChangeTextAlignment:(NSTextAlignment)alignment;
- (void)formatDidToggleListStyle:(QSRichTextListStyleType)listType;
- (void)formatDidToggleBlockquote;

-(void)insertPhoto;
-(void)insertVideo;
-(void)insertAudio;
-(void)insertSeperator;
-(void)insertHyperlink;

-(void)richTextEditorOpenMoreView;
-(void)richTextEditorCloseMoreView;

@end
