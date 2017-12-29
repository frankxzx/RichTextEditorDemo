//
//  QSRichTextController.m
//  Demo(base on table view)
//
//  Created by Xuzixiang on 2017/12/29.
//  Copyright © 2017年 frankxzx. All rights reserved.
//

#import "QSRichTextController.h"
#import "QSRichTextModel.h"

typedef NS_ENUM(NSInteger, QSRichTextCellType)
{
    QSRichTextCellTypeText = 0,
    QSRichTextCellTypeImage,
    QSRichTextCellTypeVideo,
};

@interface QSRichTextController ()

@property(nonatomic, strong) NSMutableArray <QSRichTextModel *>models;

@end

@implementation QSRichTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)addCell:(QSRichTextCellType)cellType {
    
}

-(void)removeCell:(QSRichTextCellType)cellType {
    
}

-(UITableViewCell *)qmui_tableView:(UITableView *)tableView cellWithIdentifier:(NSString *)identifier {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
}

@end

