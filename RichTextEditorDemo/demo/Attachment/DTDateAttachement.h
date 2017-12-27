//
//  DTDateAttachement.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/25.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@interface DTDateAttachement : DTTextAttachment <DTTextAttachmentHTMLPersistence>

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, copy) NSString *dateString;

@end
