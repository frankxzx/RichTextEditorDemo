//
//  RichTextEditorAction.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/7.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RichTextEditorAction <NSObject>

- (void)formatDidSelectFont:(DTCoreTextFontDescriptor *)font;
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

@end
