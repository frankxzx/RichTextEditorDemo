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
            return @"QSRichTextWordCell";
            
        case QSRichTextCellTypeSeparator:
            return @"QSRichTextSeparatorCell";
            
        case QSRichTextCellTypeImage:
            return @"QSRichTextImageCell";
            
        case QSRichTextCellTypeVideo:
            return @"QSRichTextVideoCell";
    }
}

@end
