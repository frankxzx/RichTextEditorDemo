//
//  DTImageTextAttachment+qs.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/16.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>
#import <DTRichTextEditor/DTRichTextEditor.h>

@interface DTImageTextAttachment (qs)

@property(nonatomic, assign) BOOL isCaption;
@property(nonatomic, copy) NSString *captionText;
@property(nonatomic, strong) DTTextRange *captionRange;

@end

