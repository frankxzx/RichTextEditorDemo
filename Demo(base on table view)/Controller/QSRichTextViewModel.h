//
//  QSRichTextViewModel.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRichTextModel.h"

@interface QSRichTextViewModel : NSObject

@property(nonatomic, strong, readonly) NSMutableArray <QSRichTextModel *>* models;

-(void)addNewLine;

@end
