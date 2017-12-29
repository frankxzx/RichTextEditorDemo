//
//  QSRichTextEditorAction.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HyperlinkModel.h"

@protocol QSRichTextEditorAction <NSObject>

//- (void)formatDidSelectTextStyle:(QSRichEditorTextStyle)style;
- (void)formatDidToggleBold;
- (void)formatDidToggleItalic;
- (void)formatDidToggleUnderline;
- (void)formatDidToggleStrikethrough;
- (void)formatDidChangeTextAlignment:(CTTextAlignment)alignment;
- (void)decreaseTabulation;
- (void)increaseTabulation;
//- (void)toggleListType:(DTCSSListStyleType)listType;
- (void)insertHyperlink:(HyperlinkModel *)link;
- (void)replaceCurrentSelectionWithPhoto;

-(void)formatDidToggleBlockquote;
-(void)insertVideo;
-(void)insertAudio;
-(void)insertSeperator;

-(void)richTextEditorOpenMoreView;
-(void)richTextEditorCloseMoreView;

@end
