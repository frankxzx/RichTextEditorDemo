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
@import AFNetworking;

@interface QSRichTextViewModel()

@property(nonatomic, strong) NSMutableArray <QSRichTextModel *>* models;

@end

@implementation QSRichTextViewModel

-(void)addImageCaptionWithImageModel:(QSRichTextModel *)model {
    NSInteger index = [self.models indexOfObject:model];
    QSRichTextModel *captionModel = [[QSRichTextModel alloc]initWithCellType:QSRichTextCellTypeImageCaption];
    [self.models insertObject:captionModel atIndex:index+1];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index + 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

//当插入图片，图片注释，视频，分隔符，代码块时默认添加空的一行
-(void)addNewLine:(QSRichTextCellType)cellType {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.models.count - 1 inSection:0];
    [self addNewLine:(QSRichTextCellType)cellType atBeginIndexPath:indexPath];
}

-(void)addNewLine:(QSRichTextCellType)cellType atBeginIndexPath:(NSIndexPath *)indexPath {
    QSRichTextModel *model = [[QSRichTextModel alloc]initWithCellType:cellType];
    QSRichTextModel *emptyLine = [[QSRichTextModel alloc]initWithCellType:QSRichTextCellTypeText];
    
    //正常插两行
    void (^addNewLineWithEmptyTextLine)(void) = ^{
        [self addNewLinesWithModels:@[model, emptyLine] atBeginIndexPath:indexPath];
    };
    
    //当上一行文本行 还没来得及输入内容时，直接将其替换
    void (^replaceLastLineWithEmptyTextLineAtIndexPath)(NSIndexPath *) = ^(NSIndexPath *indexPath) {
        [self replaceLinesWithModel:model atIndexPath:indexPath];
        [self addNewLinesWithModels:@[emptyLine] atBeginIndexPath:indexPath];
    };
    
    void (^replaceLastLineWithEmptyTextLine)(void) = ^{
        replaceLastLineWithEmptyTextLineAtIndexPath(indexPath);
    };
    
    switch (cellType) {
        case QSRichTextCellTypeImage: {

            //新生成的 textView 响应, 光标位置移动
            [self becomeActiveWithModel:emptyLine];
            [self.tableView qmui_scrollToBottom];
            
            NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"test_image" ofType:@"jpeg"];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            UIImage *compressImage = [UIImage compressImage:image compressRatio:1 maxCompressRatio:0.8];
            NSData *uploadData = UIImageJPEGRepresentation(compressImage, 1);
            
            model.uploadData = UIImageJPEGRepresentation(compressImage.qmui_grayImage, 1);
            
            if ([self isLastLineEmpty]) {
                replaceLastLineWithEmptyTextLine();
            } else {
                addNewLineWithEmptyTextLine();
            }
            
            QiniuFile *file = [[QiniuFile alloc]initWithFileData:uploadData];
            NSString *uuID = [NSUUID UUID].UUIDString;
            model.uploadID = uuID;
            [QSArticleUploader sharedUploader].accessToken = @"Vxc1Zxa8jfgt-eu-zVy875_jIl7umwzaICxpW1v8:kg1HvDl3SMZs0fIqGwYDKAmD81s=:eyJzY29wZSI6InFzLXBsYXRmb3JtIiwiZGVhZGxpbmUiOjE1MTU1NzgxNTB9";
            [[QSArticleUploader sharedUploader]insertUploadWithFile:file withFileIndex:uuID];
            
            [[QSArticleUploader sharedUploader] setOneSucceededHandler:^(NSString *fileIndex, NSDictionary * _Nonnull info) {
                model.uploadData = uploadData;
                QMUILog(@"success fileIndex: %@, info:%@",fileIndex, info);
                [self updateCellAtIndexPath:[NSIndexPath indexPathForRow:[self.models indexOfObject:model] inSection:0]];
            }];
            
            [[QSArticleUploader sharedUploader] setOneFailedHandler:^(NSString *fileIndex, NSError * _Nullable error) {
                QMUILog(@"fail fileIndex: %@, error:%@",fileIndex, error);
            }];
            
            [[QSArticleUploader sharedUploader] setOneProgressHandler:^(NSString *fileIndex, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                QMUILog(@"uploading fileIndex: %@, didSend byte: %lld, total byte: %lld",fileIndex, bytesSent, totalBytesSent);
            }];
            
            [[QSArticleUploader sharedUploader]startUpload];
            
            break;
        }
        case QSRichTextCellTypeVideo:
        case QSRichTextCellTypeImageCaption:
        {
            if ([self isLastLineEmpty]) {
                replaceLastLineWithEmptyTextLine();
            } else {
                addNewLineWithEmptyTextLine();
            }
            //新生成的 textView 响应, 光标位置移动
            [self becomeActiveWithModel:emptyLine];
            [self.tableView qmui_scrollToBottom];
            break;
        }
            
        case QSRichTextCellTypeSeparator:
        {
            //上方已经有分割线，则不进行响应
            if ([self isLastLineEmpty]) { return; }
            addNewLineWithEmptyTextLine();
            [self becomeActiveWithModel:emptyLine];
            break;
        }
            
        case QSRichTextCellTypeTextBlock:
        {
            QSRichTextView *textView = self.viewController.currentTextView;
            if (textView) {
                NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
                QSRichTextModel *currentModel = self.models[indexPath.row];
                switch (currentModel.cellType) {
                    case QSRichTextCellTypeText:
                        currentModel.cellType = QSRichTextCellTypeTextBlock;
                        break;
                    case QSRichTextCellTypeTextBlock:
                        currentModel.cellType = QSRichTextCellTypeText;
                        break;
                    default:
                        break;
                }
                
                [self updateCellAtIndexPath:indexPath];
                [self becomeActiveWithModel:currentModel];
            }
            break;
        }
            
        case QSRichTextCellTypeCodeBlock:
        {
            QSRichTextView *textView = self.viewController.currentTextView;
            if (textView) {
                NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
                QSRichTextModel *currentModel = self.models[indexPath.row];
                switch (currentModel.cellType) {
                    case QSRichTextCellTypeText:
                        currentModel.cellType = QSRichTextCellTypeCodeBlock;
                        break;
                    case QSRichTextCellTypeCodeBlock:
                        currentModel.cellType = QSRichTextCellTypeText;
                        break;
                    default:
                        break;
                }
                
                [self updateCellAtIndexPath:indexPath];
                [self becomeActiveWithModel:currentModel];
            }
            break;
        }
            
        case QSRichTextCellTypeListCellNone:
        case QSRichTextCellTypeListCellNumber:
        case QSRichTextCellTypeListCellCircle:
        {
            QSRichTextView *textView = self.viewController.currentTextView;
            if (textView) {
                NSIndexPath *indexPath = [self.tableView qmui_indexPathForRowAtView:textView];
                QSRichTextModel *currentModel = self.models[indexPath.row];
                currentModel.cellType = cellType;
                [self updateCellAtIndexPath:indexPath];
                [self becomeActiveWithModel:currentModel];
            }
            break;
        }
            
        case QSRichTextCellTypeText:
        case QSRichTextCellTypeTitle:
        case QSRichTextCellTypeCover:
            [self addNewLinesWithModels:@[model]];
            break;
    }
}

//在最后插入新的行
-(void)addNewLinesWithModels:(NSArray <QSRichTextModel *>*) models {
    //最后一行索引
    NSInteger count = self.models.count;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count - 1 inSection:0];
    [self addNewLinesWithModels:models atBeginIndexPath:indexPath];
}

//在指定的索引插入新的行
-(void)addNewLinesWithModels:(NSArray <QSRichTextModel *>*)models atBeginIndexPath:(NSIndexPath *)indexPath {
    NSArray <NSIndexPath *>*indexPaths = [self insertIndexPathsAtIndexPath:indexPath count:models.count];
    NSRange range = NSMakeRange(indexPaths.firstObject.row, indexPaths.count);
    [self.models insertObjects:models atIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
    UITableView *tableView = self.viewController.tableView;
    [tableView beginUpdates];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
}

//更新 cell 高度
-(void)updateLayoutAtIndexPath:(NSIndexPath *)indexPath withCellheight:(CGFloat)newHeight {
    if (!indexPath) { return; }
    QSRichTextModel *model = self.models[indexPath.row];
    model.cellHeight = newHeight;
    UITableView *tableView = self.viewController.tableView;
    [tableView.qmui_indexPathHeightCache invalidateHeightAtIndexPath:indexPath];
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

-(void)replaceLinesWithModel:(QSRichTextModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [self.models replaceObjectAtIndex:indexPath.row withObject:model];
    [self updateCellAtIndexPath:indexPath];
}

-(void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *tableView = self.viewController.tableView;
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
}

//删除图片时 连带删除注释
-(void)removeLineAtIndexPath:(NSIndexPath *)indexPath {
    [self removeLinesAtIndexPaths:@[indexPath]];
}

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
    [self becomeActiveAtIndexPath:indexPath];
}

-(void)becomeActiveLastLine {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.models.count - 1 inSection:0];
    [self becomeActiveAtIndexPath:indexPath];
}

-(void)becomeActiveAtIndexPath:(NSIndexPath *)indexPath {
    QSRichTextCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[QSRichTextBaseWordCell class]]) {
        ((QSRichTextBaseWordCell *)cell).textView.inputAccessoryView = self.viewController.toolBar;
        ((QSRichTextBaseWordCell *)cell).textView.selectedRange = NSMakeRange(((QSRichTextBaseWordCell *)cell).textView.attributedText.length, 0);
        [cell becomeFirstResponder];
    }
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

-(BOOL)isLastLineEmpty {
    NSInteger lastLineIndex = self.models.count - 1;
    if (lastLineIndex < 2) {
        return NO;
    }
    QSRichTextModel *model = self.models[lastLineIndex];
    if (model.cellType != QSRichTextCellTypeText) {
        return NO;
    }
    return model.attributedString.length == 0;
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
