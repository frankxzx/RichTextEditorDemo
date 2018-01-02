//
//  QSRichTextViewModel.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSRichTextModel.h"
#import "UIResponder+qs.h"

@class QSRichTextController;
@interface QSRichTextViewModel : NSObject

@property(nonatomic, strong, readonly) NSMutableArray <QSRichTextModel *>* models;
@property(nonatomic, weak) QSRichTextController *viewController;

-(void)addNewLine:(QSRichTextCellType)cellType;

-(void)updateLayoutAtIndexPath:(NSIndexPath *)indexPath;

-(void)removeLineAtIndexPath:(NSIndexPath *)indexPath;

-(void)removeLinesAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

-(void)removeLineWithModel:(QSRichTextModel *)model;

@end
