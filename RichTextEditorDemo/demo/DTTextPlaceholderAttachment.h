//
//  DTTextPlaceholderAttachment.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/20.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

typedef NS_OPTIONS(NSUInteger, RichTextEditorPlaceHolderType) {
    RichTextEditorPlaceHolderTitle,
    RichTextEditorPlaceHolderCover
};

@interface DTTextPlaceholderAttachment : DTTextAttachment

@property(nonatomic, assign) RichTextEditorPlaceHolderType placeholderType;

@end
