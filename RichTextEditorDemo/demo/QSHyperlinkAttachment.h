//
//  QSHyperlinkAttachment.h
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/15.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <DTCoreText/DTCoreText.h>

@interface QSHyperlinkAttachment : DTTextAttachment  <DTTextAttachmentHTMLPersistence>

@property(nonatomic, copy) NSString *title;

@end
