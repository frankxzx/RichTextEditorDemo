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
    UITableView *tableView = self.viewController.tableView;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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

@end
