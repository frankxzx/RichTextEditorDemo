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

@interface QSRichTextController () <QSRichTextWordCellDelegate, QSRichTextImageViewDelegate, QSRichTextVideoViewDelegate>

@property(nonatomic, strong) QSRichTextViewModel *viewModel;
@property(nonatomic, strong) NSIndexPath *currentEditingIndexPath;

@end

@implementation QSRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.viewModel addNewLine:QSRichTextCellTypeCover];
    [self.viewModel addNewLine:QSRichTextCellTypeTitle];
    [self.viewModel addNewLine:QSRichTextCellTypeText];
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
            [((QSRichTextWordCell *)cell) setBodyTextStyle];
            ((QSRichTextWordCell *)cell).qs_delegate = self;
            break;
        
        case QSRichTextCellTypeImage:
            ((QSRichTextImageCell *)cell).attchmentImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            ((QSRichTextImageCell *)cell).attchmentImageView.actionDelegate = self;
            break;
        
        case QSRichTextCellTypeVideo:
            ((QSRichTextVideoCell *)cell).thumbnailImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            ((QSRichTextVideoCell *)cell).videoView.actionDelegate = self;
            break;
            
        case QSRichTextCellTypeImageCaption:
            ((QSRichTextWordCell *)cell).qs_delegate = self;
            [((QSRichTextWordCell *)cell) setImageCaptionStyle];
            break;
            
        case QSRichTextCellTypeTitle:
            ((QSRichTextWordCell *)cell).qs_delegate = self;
            [((QSRichTextWordCell *)cell) setArticleStyle];
            
        case QSRichTextCellTypeCover:
        case QSRichTextCellTypeSeparator:
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
        case QSRichTextCellTypeTitle:
        case QSRichTextCellTypeText:
        case QSRichTextCellTypeImageCaption:
            return [self.tableView qmui_heightForCellWithIdentifier:model.reuseID cacheByIndexPath:indexPath configuration:^(id cell) {
                [cell renderRichText:model.attributedString];
            }];
            
        case QSRichTextCellTypeImage:
            return [self.tableView qmui_heightForCellWithIdentifier:model.reuseID cacheByIndexPath:indexPath configuration:^(id cell) {
                ((QSRichTextImageCell *)cell).attchmentImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            }];
            
        case QSRichTextCellTypeVideo:
            return [self.tableView qmui_heightForCellWithIdentifier:model.reuseID cacheByIndexPath:indexPath configuration:^(id cell) {
                ((QSRichTextVideoCell *)cell).thumbnailImage = [UIImage qmui_imageWithColor:[UIColor qmui_randomColor] size:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT / 4) cornerRadius:0];
            }];
            
        case QSRichTextCellTypeSeparator:
            return 1;
            
        case QSRichTextCellTypeCover:
            return 120;
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
#pragma mark QSRichTextWordCellDelegate

-(void)qsTextViewDidChange:(YYTextView *)textView {
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
    QSRichTextModel *model = self.viewModel.models[indexPath.row];
    model.attributedString = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    self.currentEditingIndexPath = indexPath;
}

- (void)qsTextFieldDeleteBackward:(QSRichTextView *)textView {
    
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
    NSInteger index = indexPath.row;
    if (index > 0 && self.models[index-1].cellType == QSRichTextCellTypeImage) {
        NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:index - 1 inSection:0];
        [self.viewModel removeLinesAtIndexPaths:@[previousIndexPath, indexPath]];
    } else {
        [self.viewModel removeLineAtIndexPath:indexPath];
    }
}

-(void)qsTextView:(QSRichTextView *)textView newHeightAfterTextChanged:(CGFloat)newHeight {
    [self.viewModel updateLayoutAtIndexPath:self.currentEditingIndexPath];
}

#pragma mark -
#pragma mark QSRichTextImageViewDelegate
-(void)editorViewDeleteImage:(QSRichTextImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:imageView];
    QSRichTextModel *model = self.viewModel.models[indexPath.row];
    [self.viewModel removeLineWithModel:model];
}

-(void)editorViewEditImage:(QSRichTextImageView *)imageView {
    
}

-(void)editorViewCaptionImage:(QSRichTextImageView *)imageView {
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:imageView];
     QSRichTextModel *model = self.viewModel.models[indexPath.row];
    if (model.captionModel) {
        //TODO: 响应已插入的图片注释
        return;
    } else {
        //关联一下
        [self.viewModel addNewLine:QSRichTextCellTypeImageCaption];
        model.captionModel = self.viewModel.models[indexPath.row+1];
    }
}

-(void)editorViewReplaceImage:(QSRichTextImageView *)imageView {
    
}

#pragma mark -
#pragma mark QSRichTextVideoViewDelegate
-(void)editorViewPlayVideo:(QSRichTextVideoView *)sender {
    
}

-(void)editorViewDeleteVideo:(QSRichTextVideoView *)sender {
    NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:sender];
    [self.viewModel removeLineAtIndexPath:indexPath];
}

#pragma mark -
#pragma mark QSRichTextEditorFormat
-(void)insertSeperator {
    [self.viewModel addNewLine:QSRichTextCellTypeSeparator];
}

-(void)insertVideo {
    [self.viewModel addNewLine:QSRichTextCellTypeVideo];
}

-(void)insertPhoto {
    [self.viewModel addNewLine:QSRichTextCellTypeImage];
}

@end
