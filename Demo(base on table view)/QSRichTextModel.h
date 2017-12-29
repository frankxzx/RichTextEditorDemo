//
//  QSRichTextModel.h
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QSRichTextLayout.h"
#import "QSRichTextHtmlWriter.h"

@interface QSRichTextModel : NSObject <QSRichTextHtmlWriter>

@property(nonatomic, strong) NSMutableAttributedString *attributedString;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) QSRichTextLayout *layout;

@end
