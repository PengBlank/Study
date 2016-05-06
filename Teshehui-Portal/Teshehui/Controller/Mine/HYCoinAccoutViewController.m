//
//  HYCoinAccoutViewController.m
//  Teshehui
//
//  Created by Kris on 15/5/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCoinAccoutViewController.h"
#import "HYHYMallOrderListFilterView.h"
#import "HYTableViewFooterView.h"
#import "HYMallOrderSummary.h"
#import "HYMallOrderListStatusCell.h"
#import "HYCoinAccountRequest.h"
#import "HYCoinAccountResponse.h"
#import "HYMallOrderReturnListRequest.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYBaseLineCell.h"
#import "HYCoinAccountCell.h"
#import "NSDate+Addition.h"
#import "HYShareInfoReq.h"
#import "UMSocial.h"

@interface HYCoinAccoutViewController ()
<UMSocialUIDelegate>
{
    HYHYMallOrderListFilterView *_filterView;
    HYCoinAccountRequest *_coinAccReq;
    NSInteger _pageNumber;
    NSInteger _pageSize;
    
    HYShareInfoReq *_shareRequest;
}
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) int filterType;
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) HYCoinAccountCell *cell;
@property (nonatomic, strong) NSMutableDictionary *sortDataList;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *keysArray;

@property (nonatomic, assign) BOOL isShare; //控制分享

@end

@implementation HYCoinAccoutViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_coinAccReq cancel];
    _coinAccReq = nil;
    
    [_shareRequest cancel];
    _shareRequest = nil;
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
    
    _filterView = [[HYHYMallOrderListFilterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 34)];
    _filterView.conditions = @[@"全部", @"支出", @"收入"];
    _filterView.userInteractionEnabled = YES;
    [_filterView addTarget:self
                    action:@selector(filterOrder:)
          forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_filterView];
    
    //tableview
    frame.origin.y += 34;
    frame.size.height -= 34;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    _nullView = [[HYNullView alloc] initWithFrame:frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    self.isShare = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self sortData];
    [self reloadOrderData];
    self.title = @"现金券账单";
    
    UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [share setTitle:@"分享" forState:UIControlStateNormal];
    [share setTitleColor:[UIColor colorWithRed:161.0/255.0
                                         green:0
                                          blue:0
                                         alpha:1.0]
                forState:UIControlStateNormal];
    share.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [share addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:share];
    self.navigationItem.rightBarButtonItem = item;
}

- (BOOL)canDragBack
{
    if (_isShare) {
        return NO;
    }
    return YES;
}


#pragma mark setter/getter
-(NSMutableDictionary *)sortDataList
{
    if (!_sortDataList) {
        _sortDataList = [NSMutableDictionary dictionary];
    }
    return _sortDataList;
}



- (NSMutableArray *)keysArray
{
    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    return _keysArray;
}

#pragma mark - private methods

- (void)shareAction:(UIButton *)btn
{
    if (!_isShare)
    {
        if (!_shareRequest)
        {
            _shareRequest = [[HYShareInfoReq alloc] init];
        }
        _shareRequest.type = @"1";
        [HYLoadHubView show];
        _isShare = YES;
        __weak typeof(self) b_self = self;
        [_shareRequest sendReuqest:^(HYShareInfoResp* res, NSError *error)
         {
             [HYLoadHubView dismiss];
             if (res.status == 200)
             {
                 NSData *imgData = nil;
                 if (res.imgurl)
                 {
                     imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:res.imgurl]];
                 }
                 else
                 {
                     imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"share_icon"], 1);
                 }
                 
                 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;  //使用app类型的时候分享到会话无法跳转
                 [UMSocialData defaultData].extConfig.title = res.title;
                 [UMSocialData defaultData].extConfig.wechatSessionData.url = res.url;
                 [UMSocialData defaultData].extConfig.wechatTimelineData.url = res.url;
                 
                 [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
                 [UMSocialData defaultData].extConfig.qqData.url = res.url;
                 [UMSocialData defaultData].extConfig.qzoneData.title = res.title;
                 [UMSocialData defaultData].extConfig.qzoneData.url = res.url;
                 [UMSocialData defaultData].extConfig.qqData.title = res.title;
                 
                 [UMSocialSnsService presentSnsIconSheetView:self
                                                      appKey:uMengAppKey
                                                   shareText:[NSString stringWithFormat:@"%@%@", res.msg, res.url]
                                                  shareImage:imgData
                                             shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,nil]
                                                    delegate:self];
             }
             else
             {
                 b_self.isShare = NO;
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:res.rspDesc
                                                                delegate:nil
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
}

-(void)didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    _isShare = NO;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    _isShare = NO;
}

- (void)filterOrder:(id)sender
{
    if ([sender isKindOfClass:[HYHYMallOrderListFilterView class]])
    {
        HYHYMallOrderListFilterView *filter = (HYHYMallOrderListFilterView *)sender;

        switch (filter.currentIndex)
        {
            case 0: //所有
                self.filterType = (int)filter.currentIndex;
                break;
            case 1: //收入
                self.filterType = (int)filter.currentIndex;
                break;
            case 2: //支出
                self.filterType = (int)filter.currentIndex;
                break;
            default:
                break;
        }
        [self reloadOrderData];
    }
}

- (void)reloadOrderData
{
    _pageNumber = 1;
    _hasMore = YES;
    [_sortDataList removeAllObjects];
    [_keysArray removeAllObjects];
    
    [self loadOrderData];
}

- (void)loadOrderData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _coinAccReq = [[HYCoinAccountRequest alloc] init];
        
        _coinAccReq.page = _pageNumber;
        _coinAccReq.num_per_page = 20;
        _coinAccReq.tradeType = self.filterType;
        
        __weak typeof(self) b_self = self;
        [_coinAccReq sendReuqest:^(id result, NSError *error) {
            
            NSArray *msgDataList = nil;
            if (result && [result isKindOfClass:[HYCoinAccountResponse class]])
            {
                HYCoinAccountResponse *response = (HYCoinAccountResponse *)result;
                msgDataList = response.msgDataList;
            }
            
            [b_self updateViewWithData:msgDataList error:error];
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
        [self sortDataWithData:array];
        _pageNumber++;
        
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [self.tableView reloadData];
    }
    else if (array.count <= 0 && ![self.sortDataList count])
    {
        [self.tableView setHidden:YES];
        [_nullView setHidden:NO];
        
        if ([error.domain isEqualToString:@"网络请求出现异常"])
        {
            [self.nullView setNeedTouch:YES];
            self.nullView.descInfo = @"由于网络原因加载失败，请点击重新加载";
        }
        else
        {
            [self.nullView setNeedTouch:NO];
            NSString *str = error.domain;
            if ([str length] <= 0)
            {
                str = @"亲，暂无现金券账单信息～";
            }
            self.nullView.descInfo = str;
        }
    }
}

- (void)sortDataWithData:(NSArray *)data
{
    for (HYCoinAccount *obj in data)
    {
        NSString *key = nil;
        if (obj.createdDate.isThisMonth)
        {
            key =  @"本月";
        }else if (obj.createdDate.isThisYear)
        {
            key = [NSString stringWithFormat:@"%d月", (int)[obj.createdDate getMonth]];
        }else
        {
            key = [NSString stringWithFormat:@"%d年%d月", (int)[obj.createdDate getYears], (int)[obj.createdDate getMonth]];
        }
        NSMutableArray *array = [self.sortDataList objectForKey:key];
        if (!array)
        {
            array = [NSMutableArray array];
            [self.sortDataList setObject:array forKey:key];
            [self.keysArray addObject:key];
        }
        [array addObject:obj];
    }
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

//- (void)reloadMoreData
//{
//    _pageNumber ++;
//    [self loadOrderData];
//}

- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        //        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self loadOrderData];
    }
    else
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}


#pragma mark - table view
#pragma mark - datasoure
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CoinAccountIdentifier";
    HYCoinAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYCoinAccountCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSString *key = [self.keysArray objectAtIndex:indexPath.section];
    NSArray *objs = [self.sortDataList objectForKey:key];
    HYCoinAccount *obj = objs[indexPath.row];
    
    cell.coinData = obj;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *keys = _keysArray;
    NSArray *objs = [_sortDataList objectForKey:[keys objectAtIndex:section]];
    return objs.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [self.keysArray objectAtIndex:indexPath.section];
    NSArray *objs = [self.sortDataList objectForKey:key];
    HYCoinAccount *obj = objs[indexPath.row];
    return [obj cellHeight];
//    return [(HYCoinAccountCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath] cellHeight];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = _keysArray[section];
    return str;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[_sortDataList allKeys]count];
    return count;
}


@end
