//
//  QSRichTextAddCoverCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSRichTextCell.h"

@protocol QSRichTextAddCoverCellDelegate <NSObject>

-(void)didInsertArticleCover:(UIButton *)sender;

@end

@interface QSRichTextAddCoverCell : QSRichTextCell

@property(nonatomic, weak) id <QSRichTextAddCoverCellDelegate> actionDelegate;

@end
