//
//  HYFlowSelectView.m
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYFlowSelectView.h"
#import "HYFlowSelectCell.h"
#import "HYFlowSelectViewModel.h"

@interface HYFlowSelectView ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYFlowSelectViewModel *model;

@end

@implementation HYFlowSelectView

- (void)awakeFromNib
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TFScalePoint(320), 300)
                                                         style:UITableViewStylePlain];
    [tableView registerClass:[HYFlowSelectCell class]
      forCellReuseIdentifier:NSStringFromClass([HYFlowSelectCell class])];
    self.tableView.delegate = self.delegate;
    self.tableView = tableView;
    [self addSubview:self.tableView];
}

- (void)bindDataWithViewModel:(id)model
{
//    if ([model isKindOfClass:[HYFlowSelectViewModel class]])
//    {
    _model = model;
        self.tableView.dataSource = model;
        [self.tableView reloadData];
//    }
}

#pragma mark getter & setter


@end
