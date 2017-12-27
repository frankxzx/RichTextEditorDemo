//
//  DTImageCaptionAttachment.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/18.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@interface DTImageCaptionAttachment : DTTextAttachment <DTTextAttachmentHTMLPersistence>

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) UIFont *titleFont;

@end
