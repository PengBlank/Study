//
//  HYApplyAfterServiceListViewController.m
//  Teshehui
//
//  Created by Kris on 15/10/13.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYApplyAfterServiceListViewController.h"
#import "HYMallApplyAfterSaleServiceViewController.h"
#import "HYApplyAfterSaleListCell.h"
#import "HYApplyAfterSaleServiceListReq.h"
#import "HYApplyAfterSaleServiceListResponse.h"
#import "HYLoadHubView.h"

@interface HYApplyAfterServiceListViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
HYApplyAfterSaleListCellDelegate
>
{
    HYApplyAfterSaleServiceListReq *_applyAfterSaleServiceListReq;
    
    int _pageNo;
    int _pageSize;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *fullDataList;

@end

@implementation HYApplyAfterServiceListViewController

-(void)dealloc
{
    [_applyAfterSaleServiceListReq cancel];
    _applyAfterSaleServiceListReq = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"申请售后";
    _pageNo = 1;
    _pageSize = 20;
    
    [self getListData];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.rowHeight = TFScalePoint(120);
    [tableview registerClass:[HYApplyAfterSaleListCell class] forCellReuseIdentifier:@"HYApplyAfterSaleListCell"];

    [self.view addSubview:tableview];
    self.tableView = tableview;
}

#pragma mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HYApplyAfterSaleListCell";
    HYApplyAfterSaleListCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.dataList.count)
    {
        HYMallOrderItem *returnItem = _dataList[indexPath.row];
        [cell setReturnOrder:returnItem];
        HYMallChildOrder *childOrder = _fullDataList[0];
        [cell setGoodsInfo:childOrder];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark private methods
- (void)getListData
{
    if (!_applyAfterSaleServiceListReq)
    {
        _applyAfterSaleServiceListReq = [[HYApplyAfterSaleServiceListReq alloc]init];
    }
    [_applyAfterSaleServiceListReq cancel];
    
    _applyAfterSaleServiceListReq.pageNo = [NSString stringWithFormat:@"%d",_pageNo];
    _applyAfterSaleServiceListReq.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    _applyAfterSaleServiceListReq.orderCode = self.orderCode;
    
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [_applyAfterSaleServiceListReq sendReuqest:^(HYApplyAfterSaleServiceListResponse *result, NSError *error) {
        [HYLoadHubView dismiss];
        self.fullDataList = [result.dataList mutableCopy];
        [weakSelf updateViewWithData:_fullDataList];
    }];
}

- (void)updateViewWithData:(NSArray *)data
{
    if (data.count > 0)
    {
        HYMallChildOrder *childOrder = data[0];
        _dataList = (NSMutableArray *)childOrder.returnOrderItemPOList;
        [_tableView reloadData];
    }
}

#pragma mark HYApplyAfterSaleListCell
- (void)didRequestReturnGoods:(HYMallOrderItem *)goods withOrderCode:(NSString *)orderCode
{
    HYMallApplyAfterSaleServiceViewController *vc = [[HYMallApplyAfterSaleServiceViewController alloc] init];
    vc.returnGoodsInfo = goods;
    vc.orderCode = orderCode;
    vc.addressInfo = _addressInfo;
    vc.applyCallback = ^{
        [self getListData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark getter and setter
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)fullDataList
{
    if (!_fullDataList)
    {
        _fullDataList = [NSMutableArray array];
    }
    return _fullDataList;
}
@end
