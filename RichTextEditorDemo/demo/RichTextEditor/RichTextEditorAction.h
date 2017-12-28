//
//  RichTextEditorAction.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DTCoreText/DTCoreText.h>
#import "QSRichEditorFontStyle.h"

@interface HyperlinkModel: NSObject

@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *link;

@end

@protocol RichTextEditorAction <NSObject>

- (void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style;
- (void)formatDidToggleBold;
- (void)formatDidToggleItalic;
- (void)formatDidToggleUnderline;
- (void)formatDidToggleStrikethrough;
- (void)formatDidChangeTextAlignment:(CTTextAlignment)alignment;
- (void)decreaseTabulation;
- (void)increaseTabulation;
- (void)toggleListType:(DTCSSListStyleType)listType;
- (void)insertHyperlink:(HyperlinkModel *)link;
- (void)replaceCurrentSelectionWithPhoto;

-(void)formatDidToggleBlockquote;
-(void)insertVideo;
-(void)insertAudio;
-(void)insertSeperator;

-(void)richTextEditorOpenMoreView;
-(void)richTextEditorCloseMoreView;

@end
