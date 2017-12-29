//
//  QSRichTextController.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextController.h"
#import "QSRichTextViewModel.h"
#import "QSRichTextWordCell.h"
#import "QSRichTextImageCell.h"
#import "QSRichTextVideoCell.h"
#import "QSRichTextSeparatorCell.h"
#import "QSRichTextAddCoverCell.h"
#import "QSRichTextBar.h"

@interface QSRichTextController ()

@property(nonatomic, strong) QSRichTextViewModel *viewModel;
@property(nonatomic, strong) QSRichTextBar *toolBar;

@end

@implementation QSRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addImage = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addTextCell)];
    UIBarButtonItem *addText = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImagCell)];
    self.navigationItem.rightBarButtonItems = @[addImage, addText];
}

-(void)addTextCell {
    [self.viewModel addNewLine];
    [self.tableView reloadData];
}

-(void)addImagCell {
    [self.viewModel addNewLine];
    [self.tableView reloadData];
}

-(void)addCell:(QSRichTextCellType)cellType {
    
}

-(void)removeCell:(QSRichTextCellType)cellType {
    
}

-(UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    
    QSRichTextCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        Class cellClass = NSClassFromString(identifier);
        cell = [((QSRichTextCell *)[cellClass alloc])initForTableView:tableView withReuseIdentifier:identifier];
    }
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QSRichTextModel *model = self.models[indexPath.row];
    QSRichTextCell *cell = [self qmui_tableView:tableView cellWithIdentifier:model.reuseID];
    
    switch (model.cellType) {
        case QSRichTextCellTypeText:
            break;
        
        case QSRichTextCellTypeImage:
            <#statements#>
            break;
        
        case QSRichTextCellTypeVideo:
            <#statements#>
            break;
            
        default:
            break;
    }
    
    return  cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QSRichTextModel *model = self.models[indexPath.row];
    return model.layout.cellHeight;
}

-(NSArray <QSRichTextModel *>*)models {
    return self.viewModel.models;
}

@end

