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
#import "IQKeyboardManager.h"

@interface QSRichTextController () <QSRichTextViewDelegate, QSRichTextImageViewDelegate>

@property(nonatomic, strong) QSRichTextViewModel *viewModel;
@property(nonatomic, strong) QSRichTextBar *toolBar;

@end

@implementation QSRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addImage = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addTextCell)];
    UIBarButtonItem *addText = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImagCell)];
    self.navigationItem.rightBarButtonItems = @[addImage, addText];
    [IQKeyboardManager sharedManager].enable = YES;
}

-(void)addTextCell {
    [self.viewModel addNewLine:QSRichTextCellTypeText];
}

-(void)addImagCell {
    [self.viewModel addNewLine:QSRichTextCellTypeImage];
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
            [(QSRichTextWordCell *)cell renderRichText:model.attributedString];
            ((QSRichTextWordCell *)cell).textView.qs_delegate = self;
            break;
        
        case QSRichTextCellTypeImage:
            ((QSRichTextImageCell *)cell).attchmentImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            ((QSRichTextImageCell *)cell).attchmentImageView.actionDelegate = self;
            break;
        
//        case QSRichTextCellTypeVideo:
//            <#statements#>
//            break;
            
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
    switch (model.cellType) {
        case QSRichTextCellTypeText:
            return [self.tableView qmui_heightForCellWithIdentifier:model.reuseID cacheByIndexPath:indexPath configuration:^(id cell) {
                [cell renderRichText:model.attributedString];
            }];
            
        case QSRichTextCellTypeImage:
            return [self.tableView qmui_heightForCellWithIdentifier:model.reuseID cacheByIndexPath:indexPath configuration:^(id cell) {
                ((QSRichTextImageCell *)cell).attchmentImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            }];
            
        default:
            return 0;
    }
}

-(QSRichTextViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[QSRichTextViewModel alloc]init];
        _viewModel.viewController = self;
    }
    return _viewModel;
}

-(NSArray <QSRichTextModel *>*)models {
    return self.viewModel.models;
}

#pragma mark -
#pragma mark QSRichTextViewDelegate
- (void)qsTextFieldDeleteBackward:(QSRichTextView *)textView {
    
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
    
    NSInteger index = indexPath.row;
    if (index > 0 && self.models[index-1].cellType == QSRichTextCellTypeImage) {
        <#statements#>
    }
    [self.viewModel removeLineAtIndex:index];
}

#pragma mark -
#pragma mark QSRichTextImageViewDelegate
-(void)editorViewDeleteImage:(QSRichTextImageView *)imageView {
    
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:imageView];
    [self.viewModel removeLineAtIndex:indexPath.row];
}

@end

