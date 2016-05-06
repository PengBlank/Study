//
//  HYLuckyWinnerViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyWinnerViewController.h"
#import "UIImage+Addition.h"
#import "HYTableViewFooterView.h"
#import "HYLuckyWinnerCell.h"
#import "HYLoadHubView.h"
#import "HYLuckyCheckOtherReq.h"

@interface HYLuckyWinnerViewController ()<UIAlertViewDelegate>
{
    NSInteger _pageNumber;
    BOOL _hasMore;
    BOOL _isLoading;
    
    HYLuckyCheckOtherReq *_checkOtherReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *winnerList;

@end

@implementation HYLuckyWinnerViewController

- (void)dealloc
{
    [_checkOtherReq cancel];
    _checkOtherReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:frame];
    [self.view addSubview:bgView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageWithNamedAutoLayout:@"lucky_name"]];
    
    if (frame.size.height <= 416)
    {
        titleView.frame = TFRectMake(0, 14, 320, 78);
        frame = TFRectMake(30, 84, 260, frame.size.height-144);
        bgView.image = [UIImage imageWithNamedAutoLayout:@"lucky_bg_3_3_5"];
    }
    else
    {
        titleView.frame = TFRectMake(0, 0, 320, 78);
        frame = TFRectMake(30, 68, 260, 385);
        bgView.image = [UIImage imageWithNamedAutoLayout:@"lucky_bg_3"];
    }

    [self.view addSubview:titleView];

    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"中奖名单";
    [self reloadCardData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_checkOtherReq cancel];
    _checkOtherReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private methods
- (void)loadCardData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _checkOtherReq = [[HYLuckyCheckOtherReq alloc] init];
        _checkOtherReq.version = kLotteryVersion;
        _checkOtherReq.actType = @"getUserCards";
        _checkOtherReq.lotteryCode = kLotteryCode;
        _checkOtherReq.lotteryTypeCode = kLotteryTypeCode;
        _checkOtherReq.ifSort = 1;
        _checkOtherReq.ifLotteryRank = 1;
        _checkOtherReq.page = _pageNumber;
        _checkOtherReq.pageCount = 10;
        _checkOtherReq.queryAll = @"0";
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        _checkOtherReq.queryTime = [NSString stringWithFormat:@"%lf", (time*1000)];
        
        __weak typeof(self) bself = self;
        [_checkOtherReq sendReuqest:^(id result, NSError *error) {
            HYLuckyCheckOtherResp *resp = (HYLuckyCheckOtherResp *)result;
            [bself updateViewWithCheckResult:resp
                                       error:error];
        }];
    }
}

- (void)reloadCardData
{
    _pageNumber = 1;
    _hasMore = YES;
    self.winnerList = [[NSMutableArray alloc] init];
    [self loadCardData];
}

- (void)loadMoreData
{
    if (_hasMore && !_isLoading)
    {
        _pageNumber++;
        [self loadCardData];
    }
}

- (void)updateViewWithCheckResult:(HYLuckyCheckOtherResp *)result
                            error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        _hasMore = ([result.items count] > 0);
        if (_hasMore)
        {
            [self.winnerList addObjectsFromArray:result.items];
            [self.tableView reloadData];
        }
    }
    else
    {
        _hasMore = NO;
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:error.domain
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.winnerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYLuckyWinnerCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYLuckyWinnerCell alloc]initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:orderStatusCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < [self.winnerList count])
    {
        HYLuckyStatusInfo *i = [self.winnerList objectAtIndex:indexPath.row];
        [cell setCardInfo:i];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = TFScalePoint(106);
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    if (scrollView.contentSize.height >= scrollView.frame.size.height)
    {
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset)
        {
            [self loadMoreData];
        }
    }
}

@end
