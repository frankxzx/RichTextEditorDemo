//
//  QSRichTextModel.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextModel.h"

@implementation QSRichTextModel

-(NSString *)reuseID {
    switch (self.cellType) {
        case QSRichTextCellTypeText:
            return @"QSRichTextCellTypeText";
            
        case QSRichTextCellTypeSeparator:
            return @"QSRichTextCellTypeSeparator";
            
        case QSRichTextCellTypeImage:
            return @"QSRichTextCellTypeImage";
            
        case QSRichTextCellTypeVideo:
            return @"QSRichTextCellTypeVideo";
    }
}

@end
