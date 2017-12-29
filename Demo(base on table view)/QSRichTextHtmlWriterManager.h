//
//  QSRichTextHtmlWriterManager.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRichTextHtmlWriter.h"

@interface QSRichTextHtmlWriterManager : NSObject

@property(nonatomic, strong) NSMutableArray <id <QSRichTextHtmlWriter>> *htmlWriters;

+ (instancetype)sharedInstance;

@end
