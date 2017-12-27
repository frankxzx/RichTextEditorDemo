//
//  DTTextBlockAttachment.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/19.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@interface DTTextBlockAttachment : DTTextAttachment <DTTextAttachmentHTMLPersistence>

@property(nonatomic, copy) NSString *text;
@property(nonatomic, weak) UIView *textView;

@end
