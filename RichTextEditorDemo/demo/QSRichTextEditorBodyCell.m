//
//  QSRichTextEditorBodyCell.m
//  RichTextEditorDemo
//
//  Created by Xuzixiang on 2017/12/8.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextEditorBodyCell.h"

@interface QSRichTextEditorBodyCell()

@end

@implementation QSRichTextEditorBodyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    [self.contentView addSubview:self.richEditor];
}

-(DTRichTextEditorView *)richEditor {
    if (!_richEditor) {
        _richEditor = [[DTRichTextEditorView alloc]init];
        _richEditor.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _richEditor.defaultFontSize = 16;
        _richEditor.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(20, 18, 20, 18);
    }
    return _richEditor;
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize resultSize = CGSizeMake(size.width, 0);
    
//    if (self.isFullScreen) {
//        resultSize.height = self.parentTableView.qmui_height;
//    } else {
        resultSize.height = [QSRichTextEditorBodyCell cellRect].size.height;
//    }
    return resultSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.richEditor.frame = self.contentView.bounds;
    self.richEditor.attributedTextContentView.frame = self.richEditor.bounds;
}

+(CGRect)cellRect {
    return CGRectMake(0, 0, SCREEN_WIDTH, 400);
}

@end
