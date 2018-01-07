//
//  QSRichTextListCell.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2018/1/7.
//  Copyright © 2018年 frankxzx. All rights reserved.
//

#import "QSRichTextWordCell.h"

@interface QSRichTextListCell : QSRichTextWordCell

@property(nonatomic, assign) NSInteger currentLine;
@property(nonatomic, copy) NSString *prefix;
@property(nonatomic, strong) NSMutableArray <YYTextRange *>*prefixRanges;

-(void)updateListTypeStyle;

@end

@interface QSRichTextListNumberCell: QSRichTextListCell

@end

@interface QSRichTextListCircleCell: QSRichTextListCell

@end
