//
//  HYAfterSaleDetailViewController.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYAfterSaleDetailViewController.h"
#import "UIColor+hexColor.h"
#import "HYAfterSaleStatusView.h"
#import "HYAfterSaleDetailInfoCell.h"
#import "HYAfterSaleDetailOrderCell.h"
#import "HYAfterSaleDetailPhotoCell.h"
#import "HYAfterSaleAddressCell.h"
#import "HYAfterSaleHandleView.h"
#import "HYAfterSaleLogisticsViewController.h"
#import "HYMallAfterSaleDetailRequest.h"
#import "UIAlertView+BlocksKit.h"
#import "HYAfterSaleCancelRequest.h"
#import "HYAfterSaleDelReqeust.h"
#import "HYMallApplyAfterSaleServiceViewController.h"
#import "PhotoBrowserDelegate.h"

UIKIT_EXTERN NSString *const kAfterSaleListDidChange;

@interface HYAfterSaleDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate,
HYAfterSaleHandleDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYAfterSaleStatusView *statusView;
@property (nonatomic, strong) HYAfterSaleHandleView *handleView;

//REQUESTS
@property (nonatomic, strong) HYMallAfterSaleDetailRequest *detailRequest;
@property (nonatomic, strong) HYAfterSaleCancelRequest *cancelRequest;
@property (nonatomic, strong) HYAfterSaleDelReqeust *delRequest;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) PhotoBrowserDelegate *browserDelegate;

@end

@implementation HYAfterSaleDetailViewController

- (void)dealloc
{
    [_detailRequest cancel];
    [_cancelRequest cancel];
    [_delRequest cancel];
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithHexColor:@"f5f5f5" alpha:1];
    self.view = view;
    
    //tableview
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self registerCellsWithTable:tableview];
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    HYAfterSaleStatusView *statusView = [[HYAfterSaleStatusView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.25 * frame.size.width)];
    self.tableView.tableHeaderView = statusView;
    self.statusView = statusView;
    if (self.saleInfo) {
        self.statusView.saleInfo = self.saleInfo;
    }
    
    HYAfterSaleHandleView *handleview = [[HYAfterSaleHandleView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 44)];
    [self.view addSubview:handleview];
    handleview.delegate = self;
    self.handleView = handleview;
    if (self.saleInfo) {
        self.handleView.saleInfo = self.saleInfo;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"售后服务详情";
    [self loadDetailData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 3 + (self.saleInfo.useDetail.proof.count > 0);
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 8)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if ((self.saleInfo.useDetail.proof == nil || self.saleInfo.useDetail.proof.count == 0)
        && section > 1)
    {
        section += 1;
    }
    if (section == 0)
    {
        HYAfterSaleDetailInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
        [self configureInfoCell:infoCell];
        return infoCell;
    }
    else if (section == 1)
    {
        HYAfterSaleDetailOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
        [self configureOrderCell:orderCell];
        return orderCell;
    }
    else if (section == 2)
    {
        HYAfterSaleDetailPhotoCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        [self configurePhotoCell:photoCell];
        return photoCell;
    }
    else if (section == 3)
    {
        HYAfterSaleAddressCell *addressCell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
        [self configureAddressCell:addressCell];
        return addressCell;
    }
    //default
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
}

- (void)configureInfoCell:(HYAfterSaleDetailInfoCell *)infoCell
{
    infoCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 136);
    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    infoCell.saleInfo = self.saleInfo;
}

- (void)configureOrderCell:(HYAfterSaleDetailOrderCell *)orderCell
{
    orderCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 144);
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderCell.saleInfo = self.saleInfo;
}

- (void)configurePhotoCell:(HYAfterSaleDetailPhotoCell *)photoCell
{
    photoCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
    photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    photoCell.saleInfo = self.saleInfo;
    __weak typeof(self) weakSelf = self;
    photoCell.photoClick = ^(NSInteger idx)
    {
        MWPhotoBrowser *browser = [weakSelf.browserDelegate createBrowser];
        [browser setCurrentPhotoIndex:idx];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
        [self presentViewController:nav
                           animated:YES
                         completion:nil];
    };
}

- (void)configureAddressCell:(HYAfterSaleAddressCell *)addressCell
{
    addressCell.selectionStyle = UITableViewCellSelectionStyleNone;
    addressCell.frame = CGRectMake(0, 0, self.view.frame.size.width, 130);
    addressCell.saleInfo = self.saleInfo;
}

#pragma mark  - private
- (void)registerCellsWithTable:(UITableView *)tableView
{
    [tableView registerClass:[HYAfterSaleDetailInfoCell class] forCellReuseIdentifier:@"infoCell"];
    [tableView registerClass:[HYAfterSaleDetailOrderCell class] forCellReuseIdentifier:@"orderCell"];
    [tableView registerClass:[HYAfterSaleDetailPhotoCell class] forCellReuseIdentifier:@"photoCell"];
    [tableView registerClass:[HYAfterSaleAddressCell class] forCellReuseIdentifier:@"addressCell"];
}

- (void)checkHandleType:(HYAfterSaleHandleType)type
{
    if (type == HYAfterSaleFillLogis)
    {
        HYAfterSaleLogisticsViewController *logic = [[HYAfterSaleLogisticsViewController alloc] init];
        logic.saleInfo = self.saleInfo;
        logic.callback = ^{
            [self loadDetailData];
        };
        [self.navigationController pushViewController:logic animated:YES];
    }
    else if (type == HYAfterSaleCancel) {
        [UIAlertView bk_showAlertViewWithTitle:@"提示"
                                       message:@"确定取消申请吗?"
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@[@"确定"]
                                       handler:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 1) {
                [self cancelOrder];
            }
        }];
    }
    else if (type == HYAfterSaleEdit) {
        HYMallApplyAfterSaleServiceViewController *change = [[HYMallApplyAfterSaleServiceViewController alloc] init];
        change.isChange = YES;
        change.saleInfo = self.saleInfo;
        change.updateCallback = ^{
            [self loadDetailData];
        };
        [self.navigationController pushViewController:change animated:YES];
    }
    else if (type == HYAfterSaleDelete) {
        [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"确定删除售后单吗?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self delOrder];
            }
        }];
    }
}


#pragma mark - REQUEST
- (void)loadDetailData
{
    if (self.saleInfo && !_isLoading)
    {
        if (!_detailRequest)
        {
            _detailRequest = [[HYMallAfterSaleDetailRequest alloc] init];
        }
        _detailRequest.flowCode = self.saleInfo.returnFlowCode;
        [HYLoadHubView show];
        _isLoading = YES;
        __weak typeof(self) weakSelf = self;
        [_detailRequest sendReuqest:^(id result, NSError *error)
        {
            HYMallAfterSaleInfo *detail = nil;
            if ([result isKindOfClass:[HYMallAfterSaleDetailResponse class]])
            {
                HYMallAfterSaleDetailResponse *response = (HYMallAfterSaleDetailResponse *)result;
                if (response.status == 200)
                {
                    detail = response.afterSaleInfo;
                }
            }
            [weakSelf updateWithDetailInfo:detail error:error];
        }];
    }
}

- (void)updateWithDetailInfo:(HYMallAfterSaleInfo *)detailInfo error:(NSError *)err
{
    [HYLoadHubView dismiss];
    self.isLoading = NO;
    if (!err)
    {
        self.saleInfo = detailInfo;
        [self.tableView reloadData];
        self.statusView.saleInfo = self.saleInfo;
        self.handleView.saleInfo = self.saleInfo;
    }
    else
    {
        //提示
        [UIAlertView bk_alertViewWithTitle:@"提示" message:err.domain];
    }
}

- (void)cancelOrder
{
    if (!_isLoading)
    {
        if (!_cancelRequest)
        {
            _cancelRequest = [[HYAfterSaleCancelRequest alloc] init];
        }
        _cancelRequest.flowCode = self.saleInfo.returnFlowCode;
        __weak typeof(self) weakSelf = self;
        _isLoading = YES;
        [HYLoadHubView show];
        [_cancelRequest sendReuqest:^(id result, NSError *error) {
            [weakSelf updateWithCancelResponse:result err:error];
        }];
    }
}

- (void)delOrder
{
    if (!_isLoading) {
        if (!_delRequest) {
            _delRequest = [[HYAfterSaleDelReqeust alloc] init];
        }
        _delRequest.flowCode = self.saleInfo.returnFlowCode;
        __weak typeof(self) weakSelf = self;
        _isLoading = YES;
        [HYLoadHubView show];
        [_delRequest sendReuqest:^(id result, NSError *error) {
            [weakSelf updateWithDelResponse:result err:error];
        }];
    }
}

- (void)updateWithCancelResponse:(CQBaseResponse*)result err:(NSError *)err
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    if (result.status == 200)
    {
        [self postChange];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[UIAlertView bk_alertViewWithTitle:@"提示" message:result.rspDesc] show];
    }
}

- (void)updateWithDelResponse:(CQBaseResponse*)result err:(NSError *)err
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    if (result.status == 200) {
        [self postChange];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [[UIAlertView bk_alertViewWithTitle:@"提示" message:result.rspDesc] show];
    }
}

- (void)postChange
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kAfterSaleListDidChange object:nil];
}

- (PhotoBrowserDelegate *)browserDelegate
{
    if (!_browserDelegate) {
        _browserDelegate = [[PhotoBrowserDelegate alloc] init];
    }
    NSMutableArray *urls = [NSMutableArray array];
    for (HYMallAfterSaleProof *proof in self.saleInfo.useDetail.proof) {
        [urls addObject:proof.imageUrl];
    }
    _browserDelegate.photoURLs = urls;
    return _browserDelegate;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
