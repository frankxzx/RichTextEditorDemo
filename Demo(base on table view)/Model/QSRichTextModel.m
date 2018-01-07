//
//  QSRichTextModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextModel.h"

@implementation QSRichTextModel

-(instancetype)initWithCellType:(QSRichTextCellType)cellType {
    if (self = [super init]) {
        self.cellType = cellType;
    }
    return self;
}

-(NSString *)reuseID {
    switch (self.cellType) {
        case QSRichTextCellTypeText:
            return @"QSRichTextWordCell";
            
        case QSRichTextCellTypeSeparator:
            return @"QSRichTextSeparatorCell";
            
        case QSRichTextCellTypeImage:
            return @"QSRichTextImageCell";
            
        case QSRichTextCellTypeVideo:
            return @"QSRichTextVideoCell";
            
        case QSRichTextCellTypeImageCaption:
            return @"QSRichTextImageCaptionCell";
            
        case QSRichTextCellTypeCover:
            return @"QSRichTextAddCoverCell";
            
        case QSRichTextCellTypeTitle:
            return @"QSRichTextTitleCell";
            
        case QSRichTextCellTypeTextBlock:
            return @"QSRichTextBlockCell";
            
        case QSRichTextCellTypeListCellNone:
            return @"QSRichTextListCell";
        case QSRichTextCellTypeListCellCircle:
            return @"QSRichTextListCircleCell";
        case QSRichTextCellTypeListCellNumber:
            return @"QSRichTextListNumberCell";
    }
}

-(BOOL)shouldAddNewLine {
    QSRichTextCellType cellType = self.cellType;
    switch (cellType) {
        case QSRichTextCellTypeImage:
        case QSRichTextCellTypeVideo:
        case QSRichTextCellTypeImageCaption:
        case QSRichTextCellTypeTextBlock:
        case QSRichTextCellTypeSeparator:
        return YES;
            
        default:
            return NO;
    }
}

@end
