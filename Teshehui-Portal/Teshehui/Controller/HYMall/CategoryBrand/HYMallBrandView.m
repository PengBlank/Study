//
//  HYMallBrandView.m
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallBrandView.h"
#import "HYMallBrandCellBtn.h"
#import "HYMallBrandModel.h"
#import "HYMallBrandCell.h"
#import "HYMallBrandCellHeader.h"
#import "Masonry.h"

@interface HYMallBrandView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSArray<HYMallBrandModel *> *modelList;

@end

@implementation HYMallBrandView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
        
        UITableView *table = [[UITableView alloc] initWithFrame:self.bounds
                                                          style:UITableViewStylePlain];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [table registerClass:[HYMallBrandCell class]
           forCellReuseIdentifier:@"HYMallBrandCell"];
        [self addSubview:table];
        self.tableView = table;
    }
    
    return self;
}

/*
- (void)bindDataWithViewModel:(HYChargeSelectViewModel *)model
{
    if ([model isKindOfClass:[HYChargeSelectViewModel class]])
    {
        self.viewModel = model;
        [self setupPriceButton];
    }
}
 */
#pragma mark public methods
-(void)reloadTableView
{
    [_tableView reloadData];
}

#pragma mark method from superclass
//- (void)tapAction:(UITapGestureRecognizer *)tap
//{
//    
//}

#pragma mark setter & getter
-(void)setUserInterfaceDelegate:(HYMallBrandViewController *)userInterfaceDelegate
{
    if (userInterfaceDelegate != _userInterfaceDelegate)
    {
        _userInterfaceDelegate = userInterfaceDelegate;
        
        _tableView.dataSource = _userInterfaceDelegate;
        _tableView.delegate = _userInterfaceDelegate;
    }
}

@end
