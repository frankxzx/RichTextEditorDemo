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
#import "QSArticleUploader.h"
#import "UIImage+ImageCompress.h"

@class QSRichTextController;
@interface QSRichTextViewModel : NSObject

@property(nonatomic, strong, readonly) NSMutableArray <QSRichTextModel *>* models;
@property(nonatomic, weak) QSRichTextController *viewController;

//替换新的行
-(void)replaceLinesWithModel:(QSRichTextModel *)model atIndexPath:(NSIndexPath *)indexPath;

//插入图片注释
-(void)addImageCaptionWithImageModel:(QSRichTextModel *)model;

//插入新的行
-(void)addNewLine:(QSRichTextCellType)cellType;

-(void)addNewLine:(QSRichTextCellType)cellType atBeginIndexPath:(NSIndexPath *)indexPath;

-(void)addNewLinesWithModels:(NSArray <QSRichTextModel *>*) models;

//刷新某一行的高度
-(void)updateLayoutAtIndexPath:(NSIndexPath *)indexPath withCellheight:(CGFloat)newHeight;

//删除行
-(void)removeLineAtIndexPath:(NSIndexPath *)indexPath;

-(void)removeLinesAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths;

-(void)removeLineWithModel:(QSRichTextModel *)model;

-(void)becomeActiveWithModel:(QSRichTextModel *)model;
-(void)becomeActiveLastLine;

@end
