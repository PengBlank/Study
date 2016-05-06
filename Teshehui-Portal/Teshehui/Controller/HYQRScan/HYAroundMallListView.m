//
//  HYAroundMallListView.m
//  Teshehui
//
//  Created by RayXiang on 14-7-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallListView.h"
#import "UIView+GetImage.h"
#import "UIView+Style.h"
#import "HYQRCodeGetCityListResponse.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"

@implementation HYAroundMallListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.0];
        
        //tableview
//        CGRect newFrame = frame;
//        newFrame.origin.y =  newFrame.origin.y + 32;
//        frame = newFrame;
        
        UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                              style:UITableViewStyleGrouped];
        //tableview.delegate = self;
        //tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.sectionFooterHeight = 10;
        tableview.sectionHeaderHeight = 0;
        tableview.backgroundColor = [UIColor clearColor];
        tableview.backgroundView = nil;
        tableview.rowHeight = 71;
        _tableView = tableview;
        [self addSubview:tableview];
        
        HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:TFRectMake(0, 0, 320, 48)];
        tableview.tableFooterView = v;
        
        HYNullView *nullView = [[HYNullView alloc] initWithFrame:self.tableView.frame];
        nullView.hidden = YES;
        [self addSubview:nullView];
        self.nullView = nullView;
    }
    return self;
}

- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)setWithCity:(HYCityForQRCode *)city
{
    if (city)
    {
        [self setCity:city.region_use];
    }
}

- (void)setCity:(NSString *)city
{
    if (city.length > 0)
    {
        NSString *cityTitle = [NSString stringWithFormat:@"城市:%@", city];
        [_cityBtn setTitle:cityTitle forState:UIControlStateNormal];
    } else {
        [_cityBtn setTitle:@"选择城市" forState:UIControlStateNormal];
    }
}

- (void)showTable
{
    self.nullView.hidden = YES;
    self.tableView.hidden = NO;
    [self.tableView reloadData];
}
- (void)showNullViewWithInfo:(NSString *)info needTouch:(BOOL)touch
{
    self.tableView.hidden = YES;
    self.nullView.descInfo = info;
    self.nullView.needTouch = touch;
    self.nullView.hidden = NO;
}
- (void)setLoadMore:(BOOL)loadMore
{
    HYTableViewFooterView *footer = (HYTableViewFooterView *)self.tableView.tableFooterView;
    if ([footer isKindOfClass:[HYTableViewFooterView class]])
    {
        if (loadMore)
        {
            [footer startLoadMore];
        } else {
            [footer stopLoadMore];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
