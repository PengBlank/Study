//
//  HYLuckyCardListViewController.m
//  Teshehui
//
//  Created by HYZB on 15/3/6.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYLuckyCardListViewController.h"
#import "HYTableViewFooterView.h"
#import "HYLuckyCardCell.h"
#import "UIImage+Addition.h"
#import "HYMyCardHeaderView.h"
#import "HYLoadHubView.h"
#import "HYLuckyCheckOtherReq.h"

@interface HYLuckyCardListViewController ()
{
    UIImageView *_bgView;
    HYMyCardHeaderView *_myCardView;
    
    NSInteger _pageNumber;
    BOOL _hasMore;
    BOOL _isLoading;
    
    HYLuckyCheckOtherReq *_checkOtherReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cardsList;

@end

@implementation HYLuckyCardListViewController

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
    
    if (frame.size.height <= 416)
    {
        frame = TFRectMake(30, 104, 260, frame.size.height-160);
        _myCardView = [[HYMyCardHeaderView alloc] initWithFrame:TFRectMake(0, -4, 320, 80)];
        [self.view addSubview:_myCardView];
        bgView.image = [UIImage imageWithNamedAutoLayout:@"kj_co_3_5"];
    }
    else
    {
        frame = TFRectMake(30, 114, 260, 355);
        _myCardView = [[HYMyCardHeaderView alloc] initWithFrame:TFRectMake(0, 0, 320, 90)];
        [self.view addSubview:_myCardView];
        bgView.image = [UIImage imageWithNamedAutoLayout:@"kj_co"];
    }

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
    self.title = @"瞄瞄别人";
    
    _myCardView.mineCards = self.mineCards;
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
        _checkOtherReq.ifSort = 0;
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
    self.cardsList = [[NSMutableArray alloc] init];
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
    
    _hasMore = ([result.items count] > 0);
    if (_hasMore)
    {
        [self.cardsList addObjectsFromArray:result.items];
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYLuckyCardCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYLuckyCardCell alloc]initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:orderStatusCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row < [self.cardsList count])
    {
        HYLuckyStatusInfo *i = [self.cardsList objectAtIndex:indexPath.row];
        [cell setCardInfo:i];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = TFScalePoint(60);
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
