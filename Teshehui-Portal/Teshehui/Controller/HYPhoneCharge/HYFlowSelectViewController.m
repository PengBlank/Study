//
//  HYFlowSelectViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYFlowSelectViewController.h"
#import "HYFlowSelectCell.h"
#import "Masonry.h"
#import "HYGetRechargeGoodsRequest.h"
#import "HYGetRechargeGoodsResponse.h"
#import "HYAddRechargeOrderRequest.h"
#import "HYAddRechargeOrderResponse.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "HYPaymentViewController.h"

@interface HYFlowSelectViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    HYGetRechargeGoodsRequest *_getRechargeGoodsRequest;
    HYAddRechargeOrderRequest *_addRechargeOrderRequest;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *additionLab;

@property (nonatomic, strong) NSArray<HYPhoneChargeModel*> *dataSource;

@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYFlowSelectViewController

- (void)dealloc
{
    [_getRechargeGoodsRequest cancel];
    [_addRechargeOrderRequest cancel];
}

-(void)loadView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    self.view = view;
    
    UITableView *table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.rowHeight = 50;
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    self.tableView = table;
    
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 35)];
    table.tableFooterView = foot;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, frame.size.width-20, 20)];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor colorWithWhite:.7 alpha:1];
    label.text = @"全国流量，立即生效，当月失效";
    [foot addSubview:label];
    self.additionLab = label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - functions

#pragma mark -- public
- (void)setPhoneNumber:(NSString *)phoneNumber
{
    if (_phoneNumber != phoneNumber) {
        _phoneNumber = phoneNumber;
        if ([phoneNumber checkPhoneNumberValid]) {
            [self fetchFlowProducts];
        }
        else {
            [self clearPackage];
        }
    }
}

#pragma mark -- private
- (void)clearPackage
{
    self.dataSource = nil;
    [self.tableView reloadData];
}

- (void)fetchFlowProducts
{
    if (!_getRechargeGoodsRequest)
    {
        _getRechargeGoodsRequest = [[HYGetRechargeGoodsRequest alloc]init];
    }
    [_getRechargeGoodsRequest cancel];
    Carrier carrier = [self.phoneNumber checkPhoneNumberCarrier];
    NSInteger typeid = 0;
    if (carrier == CHINA_CMCC) {
        typeid = 1;
    }
    else if (carrier == CHINA_Unicom) {
        typeid = 2;
    }
    else if (carrier == CHINA_Telecom) {
        typeid = 3;
    }
    _getRechargeGoodsRequest.typeId = [NSString stringWithFormat:@"%ld",(long)typeid];
    _getRechargeGoodsRequest.catalogId = [NSString stringWithFormat:@"%d",5];;
    _getRechargeGoodsRequest.mobilePhone = self.phoneNumber;
    WS(weakSelf);
    [HYLoadHubView show];
    [_getRechargeGoodsRequest sendReuqest:^(HYGetRechargeGoodsResponse *result, NSError *error) {
        if ([result isKindOfClass:[HYGetRechargeGoodsResponse class]])
        {
            [weakSelf updateWithGoodsResponse:result];
        }
    }];
}

- (void)updateWithGoodsResponse:(HYGetRechargeGoodsResponse *)response
{
    [HYLoadHubView dismiss];
    if (response.status == 200)
    {
        self.dataSource = response.dataList;
        [self.tableView reloadData];
    }
    else
    {
        [METoast toastWithMessage:response.suggestMsg];
    }
}

- (void)addOrderWithProduct:(HYPhoneChargeModel *)model
{
    if (_isLoading) {
        return;
    }
    
    if (![self.phoneNumber checkPhoneNumberValid]) {
        return;
    }
    
    if (!_addRechargeOrderRequest)
    {
        _addRechargeOrderRequest = [[HYAddRechargeOrderRequest alloc]init];
    }
    [_addRechargeOrderRequest cancel];
    _addRechargeOrderRequest.productCode = model.productCode;
    _addRechargeOrderRequest.rechargeAmount = model.parvalue;
    _addRechargeOrderRequest.orderAmount = model.price;
    _addRechargeOrderRequest.rechargeType = [NSString stringWithFormat:@"%d",5];
    _addRechargeOrderRequest.rechargeTelephone = self.phoneNumber;
    WS(weakSelf);
    [HYLoadHubView show];
    _isLoading = YES;
    [_addRechargeOrderRequest sendReuqest:^(id result, NSError *error) {
        [weakSelf updateWithAddOrderResponse:result];
    }];
}

- (void)updateWithAddOrderResponse:(HYAddRechargeOrderResponse *)response
{
    [HYLoadHubView dismiss];
    self.isLoading = NO;
    if ([response isKindOfClass:[HYAddRechargeOrderResponse class]])
    {
        if (response.status == 200)
        {
            [self.delegate payWithOrder:response.order];
        }
        else
        {
            [METoast toastWithMessage:response.suggestMsg];
        }
    }
}

#pragma mark tableView delegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row < self.dataSource.count)
//    {
//        HYPhoneChargeModel *model = [self.dataSource objectAtIndex:indexPath.row];
//        [self addOrderWithProduct:model];
//    }
//}

#pragma mark tableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuse";
    HYFlowSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              reuse];
    if (!cell) {
        cell = [[HYFlowSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    if (indexPath.row < self.dataSource.count)
    {
        HYPhoneChargeModel *model = [self.dataSource objectAtIndex:indexPath.row];
        cell.chargeModel = model;
    }
    WS(weakSelf);
    cell.chargeCallback = ^(HYPhoneChargeModel *model) {
        if (model) {
            [weakSelf addOrderWithProduct:model];
        }
    };
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) {
        [self.view.superview endEditing:YES];
    }
}


@end
