//
//  RichTextEditorAction.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, QSRichEditorTextStyle) {
    QSRichEditorTextStylePlaceholder,
    QSRichEditorTextStyleNormal,
    QSRichEditorTextStyleLarger
};

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
- (void)applyHyperlinkToSelectedText:(NSURL *)url;
- (void)replaceCurrentSelectionWithPhoto:(UIImage *)image;

-(void)formatDidToggleBlockquote;
-(void)insertVideo;
-(void)insertAudio;
-(void)insertHyperlink;
-(void)insertSeperator;

-(void)richTextEditorOpenMoreView;
-(void)richTextEditorCloseMoreView;

@end
