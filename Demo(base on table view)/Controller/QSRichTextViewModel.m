//
//  QSRichTextViewModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextViewModel.h"
#import "QSRichTextController.h"

@interface QSRichTextViewModel()

@property(nonatomic, strong) NSMutableArray <QSRichTextModel *>* models;

@end

@implementation QSRichTextViewModel

-(void)addNewLine:(QSRichTextCellType)cellType {
    QSRichTextModel *model = [[QSRichTextModel alloc]init];
    model.cellType = cellType;
    model.attributedString = [[NSMutableAttributedString alloc]initWithString:@"大爷就是大爷， 大爷就是大爷 大爷就是大爷很好 🧟‍♂️  🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ hhh  franknknknkn"];
    [self.models addObject:model];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.models.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

-(void)updateLayoutAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath) { return; }
    UITableView *tableView = self.viewController.tableView;
    [tableView.qmui_indexPathHeightCache invalidateHeightAtIndexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
}

-(void)addEmptyTextViewLine {
    QSRichTextModel *model = [[QSRichTextModel alloc]init];
    model.cellType = QSRichTextCellTypeText;
    [self.models addObject:model];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.models.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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

-(NSArray<QSRichTextModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

-(UITableView *)tableView {
    return self.viewController.tableView;;
}

@end
