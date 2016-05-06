//
//  HYAccountBalanceViewController.m
//  Teshehui
//
//  Created by Kris on 15/8/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYAccountBalanceViewController.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"
#import "HYAccountBalanceCell.h"
#import "HYAccountBalanceReq.h"
#import "HYAccountBalanceResponse.h"
#import "HYUserInfo.h"
#import "HYUserCashAccountInfoRequest.h"
#import "METoast.h"

@interface HYAccountBalanceViewController ()
<
UITableViewDataSource,
UITableViewDelegate
>
{
    HYAccountBalanceReq *_accountBalanceReq;
    HYUserCashAccountInfoRequest *_cashAccountRequest;
    
    int _pageNumber;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) NSMutableArray *banlanceAccountList;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL hasMore;

/// 余额总数
@property (nonatomic, strong) UILabel *balaceLab;

//现金和现金券帐户
@property (nonatomic, strong) HYUserCashAccountInfo *cashAccount;

@end

@implementation HYAccountBalanceViewController

-(void)dealloc
{
    [_accountBalanceReq cancel];
    _accountBalanceReq = nil;
    
    [_cashAccountRequest cancel];
    _cashAccountRequest = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户余额";
    
//    self.balaceLab.text = [NSString stringWithFormat:@"¥%.2f", self.balance];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    /// head
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 120)];
    head.backgroundColor = [UIColor clearColor];
    [self.view addSubview:head];
    
    UIImageView *top = [[UIImageView alloc] initWithFrame:head.bounds];
    top.image = [UIImage imageNamed:@"account_balance_top"];
    [head addSubview:top];
    
    /// 可用余额
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, frame.size.width-80, 20)];
    title.text = @"可用余额（元）";
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont systemFontOfSize:15.0];
    title.textAlignment = NSTextAlignmentCenter;
    [head addSubview:title];
    
    /// 余额有多少
    UILabel *balance = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(title.frame)+10, frame.size.width-40, 30)];
    balance.font = [UIFont systemFontOfSize:35];
    balance.textColor = [UIColor whiteColor];
    balance.textAlignment = NSTextAlignmentCenter;
    [head addSubview:balance];
    self.balaceLab = balance;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, head.frame.size.height, frame.size.width, frame.size.height-head.frame.size.height)
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.rowHeight = TFScalePoint(44);
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    [tableview registerClass:[HYAccountBalanceCell class] forCellReuseIdentifier:@"AccountBalanceID"];
    self.tableView = tableview;
    
    _nullView = [[HYNullView alloc] initWithFrame:tableview.frame];
    _nullView.icon = [UIImage imageNamed:@"null_balace"];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    _pageNumber = 1;
    
    [self loadDate];
}

#pragma mark - table view
#pragma mark - datasoure
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYAccountBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountBalanceID" forIndexPath:indexPath];
    if (indexPath.row < _banlanceAccountList.count)
    {
        [cell setData:_banlanceAccountList[indexPath.row]];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _banlanceAccountList.count;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && _hasMore && !_isLoading)
    {
        [self reloadMoreData];
    }
}

#pragma mark private methods
- (void)loadDate
{
    if (!_cashAccountRequest)
    {
        _cashAccountRequest = [[HYUserCashAccountInfoRequest alloc] init];
    }
    __weak typeof(self) weakSelf = self;
    [_cashAccountRequest sendReuqest:^(id result, NSError *error)
     {
         HYUserCashAccountInfoResponse *response = (HYUserCashAccountInfoResponse *)result;
         if (response.status == 200)
         {
             weakSelf.cashAccount = response.cashAccountInfo;
             CGFloat balance = [weakSelf.cashAccount.balance floatValue];
             weakSelf.balaceLab.text = [NSString stringWithFormat:@"¥%.2f", balance];
             [weakSelf sendRequest];
         }
         else
         {
             [METoast toastWithMessage:response.suggestMsg];
         }
     }];
}

- (void)sendRequest
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        _accountBalanceReq = [HYAccountBalanceReq new];
       _accountBalanceReq.pageNo = [NSString stringWithFormat:@"%d",_pageNumber];
       _accountBalanceReq.pageSize = @"10";
    
       [HYLoadHubView show];
       __weak typeof(self) b_self = self;
       [_accountBalanceReq sendReuqest:^(id result, NSError *error) {
       [HYLoadHubView dismiss];
        NSArray *banlanceAccountList = nil;
        if (result && [result isKindOfClass:[HYAccountBalanceResponse class]])
        {
            HYAccountBalanceResponse *response = (HYAccountBalanceResponse *)result;
            banlanceAccountList = response.accountBalanceInfos;
            if (response.status == 200)
            {
                [b_self updateViewWithData:banlanceAccountList error:error];
            }else
            {
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:response.rspDesc
                                                              delegate:nil
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    _hasMore = ([array count] > 0);
    
    
    if (_hasMore)
    {
        _pageNumber++;
        
        [self.banlanceAccountList addObjectsFromArray:array];
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [self.tableView reloadData];
    }
    else if (array.count<=0 && ![self.banlanceAccountList count])
    {
        [self.tableView setHidden:YES];
        [_nullView setHidden:NO];
        
        [self.tableView reloadData];
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            self.nullView.descInfo = @"亲，暂无余额信息～";
        }
    }
}

- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        [self sendRequest];
    }
    else
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

#pragma mark getter and setter
-(NSMutableArray *)banlanceAccountList
{
    if (!_banlanceAccountList)
    {
        _banlanceAccountList = [NSMutableArray array];
    }
    return _banlanceAccountList;
}
//- (void)reloadOrderData
//{
//    _pageNumber = 1;
//    _hasMore = YES;
//    [_banlanceAccountList removeAllObjects];
//
//    
//    [self sendRequest];
//}
@end
