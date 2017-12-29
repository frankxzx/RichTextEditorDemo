//
//  QSRichTextViewModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextViewModel.h"

@interface QSRichTextViewModel()

@property(nonatomic, strong) NSMutableArray <QSRichTextModel *>* models;

@end

@implementation QSRichTextViewModel

-(void)addNewLine:(QSRichTextCellType)cellType {
    QSRichTextModel *model = [[QSRichTextModel alloc]init];
    model.cellType = cellType;
    model.attributedString = [[NSMutableAttributedString alloc]initWithString:@"大爷就是大爷， 大爷就是大爷 大爷就是大爷很好 🧟‍♂️  🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ 🧟‍♂️ hhh  franknknknkn"];
    [self.models addObject:model];
}

-(NSArray<QSRichTextModel *> *)models {
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

@end
