//
//  QSRichTextViewModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextViewModel.h"
#import "QSRichTextController.h"
#import "QSRichTextWordCell.h"

@interface QSRichTextViewModel()

@property(nonatomic, strong) NSMutableArray <QSRichTextModel *>* models;

@end

@implementation QSRichTextViewModel

-(void)addImageCaptionWithImageModel:(QSRichTextModel *)model {
//    NSInteger index = [self.models indexOfObject:model];
//    QSRichTextModel *captionModel = [[QSRichTextModel alloc]initWithCellType:QSRichTextCellTypeImageCaption];
//    [self.models insertObject:captionModel atIndex:index];
}

-(void)addNewLine:(QSRichTextCellType)cellType {

    QSRichTextModel *model = [[QSRichTextModel alloc]init];
    model.cellType = cellType;
    
    if ([model shouldAddNewLine]) {
        QSRichTextModel *emptyLine = [[QSRichTextModel alloc]init];
        emptyLine.cellType = QSRichTextCellTypeText;
        [self addNewLinesWithModels:@[model, emptyLine]];
        [self becomeActiveWithModel:emptyLine];
    } else {
        [self addNewLinesWithModel:model];
    }
}

-(void)addNewLinesWithModel:(QSRichTextModel *) model {
    [self addNewLinesWithModels:@[model]];
}

-(void)addNewLinesWithModels:(NSArray <QSRichTextModel *>*) models {
    NSInteger count = self.models.count;
    [self.models addObjectsFromArray:models];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:[self insertIndexPathsAtIndexPath:[NSIndexPath indexPathForRow:count - 1 inSection:0] count:models.count] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

-(void)updateLayoutAtIndexPath:(NSIndexPath *)indexPath withCellheight:(CGFloat)newHeight {
    if (!indexPath) { return; }
    QSRichTextModel *model = self.models[indexPath.row];
    model.cellHeight = newHeight;
    UITableView *tableView = self.viewController.tableView;
    [tableView.qmui_indexPathHeightCache invalidateHeightAtIndexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)removeLineAtIndexPath:(NSIndexPath *)indexPath {
    [self removeLinesAtIndexPaths:@[indexPath]];
}

//删除图片时 连带删除注释
-(void)removeLineWithModel:(QSRichTextModel *)model {
    
    NSInteger index = [self.models indexOfObject:model];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:index+1 inSection:0];
    
    if (model.cellType == QSRichTextCellTypeImage && model != self.models.lastObject) {
        if (self.models[index+1].cellType == QSRichTextCellTypeImageCaption) {
             [self removeLinesAtIndexPaths:@[previousIndexPath, indexPath]];
            return;
        }
    }
    
    if (model.cellType == QSRichTextCellTypeImage ) {
        model.captionModel = nil;
    }
    [self removeLineAtIndexPath:indexPath];
}

-(void)removeLinesAtIndexPaths:(NSArray <NSIndexPath *>*)indexPaths {
    
    NSMutableArray <QSRichTextModel *>* models = [NSMutableArray array];
    for (NSIndexPath *indexPath in indexPaths) {
        [models addObject:self.models[indexPath.row]];
    }
    
    [self.models removeObjectsInArray:models];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

-(void)becomeActiveWithModel:(QSRichTextModel *)model {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.models indexOfObject:model] inSection:0];
    QSRichTextWordCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell becomeFirstResponder];
}

-(NSArray<QSRichTextModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

-(UITableView *)tableView {
    return self.viewController.tableView;;
}

-(BOOL)isBodyEmpty {
    int i = 0;
    for (QSRichTextModel *model in self.models) {
        if (model.cellType == QSRichTextCellTypeText) {
            i++;
            if (i >= 2) {
                return NO;
            }
        }
    }
    return YES;
}

-(NSArray <NSIndexPath *>*)insertIndexPathsAtIndexPath:(NSIndexPath *)indexPath
                                                 count:(NSInteger)count {
    NSMutableArray <NSIndexPath *>*indexPaths = [NSMutableArray array];
    for (int i = 1; i <= count; i++) {
        NSIndexPath *newVal = [NSIndexPath indexPathForRow:indexPath.row+i inSection:indexPath.section];
        [indexPaths addObject:newVal];
    }
    return indexPaths;
}

@end
