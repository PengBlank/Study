//
//  HYFolwerDetailViewController.m
//  Teshehui
//
//  Created by ichina on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerSubListViewController.h"
#import "HYFlowerDetailViewController.h"

#import "HYFolwerDetailCell.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"

#import "HYMallSearchGoodsRequest.h"
#import "HYMallSearchGoodResponse.h"

#import "HYTableViewFooterView.h"

@interface HYFlowerSubListViewController ()
{
    NSInteger _pageNumber;
    BOOL _isLoading;
    BOOL _hasMore;
    
    HYMallSearchGoodsRequest *_detailTypeListRequest;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *flowersList;
@property (nonatomic, strong) HYNullView* nullView;
@end

@implementation HYFlowerSubListViewController

- (void)dealloc
{
    [_detailTypeListRequest cancel];
    _detailTypeListRequest = nil;
    
    [self.getActiveDataReq cancel];
    self.getActiveDataReq = nil;
    
    [HYLoadHubView dismiss];
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _pageNumber = 1;
        _hasMore = YES;
        _isLoading = NO;
    }
    
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = self.categoryName;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.view.frame.size.width,
                                                                           self.view.frame.size.height)
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.showsVerticalScrollIndicator = NO;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    _nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;

    [self loadFlowerList];
}

#pragma mark setter/getter
- (NSMutableArray *)flowersList
{
    if (!_flowersList)
    {
        _flowersList = [[NSMutableArray alloc] init];
    }
    
    return _flowersList;
}

#pragma mark private methods
- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self loadFlowerList];
    }
    else
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

-(void)loadFlowerList
{
    if (!_isLoading)
    {
        [HYLoadHubView show];
        
        _isLoading = YES;
        
        if (self.getActiveDataReq)
        {
            self.getActiveDataReq.pageNo = _pageNumber;
            
            __weak typeof(self) bself = self;
            [self.getActiveDataReq sendReuqest:^(id result, NSError *error){
                
                NSArray *array = nil;
                
                if ([result isKindOfClass:[HYActivityGoodsResponse class]])
                {
                    array = [(HYActivityGoodsResponse *)result goodsArray];
                }
                
                [bself updateViewWithData:array
                                    error:error];
            }];
        }
        else
        {
            _detailTypeListRequest = [[HYMallSearchGoodsRequest alloc] initReqWithCategoryId:self.categoryID];
            _detailTypeListRequest.businessType = BusinessType_Flower;
            _detailTypeListRequest.pageNo = _pageNumber;
            _detailTypeListRequest.pageSize = 10;
            
            __weak typeof(self) b_self = self;
            [_detailTypeListRequest sendReuqest:^(id result, NSError *error) {
                
                NSArray *array = nil;
                if ([result isKindOfClass:[HYMallSearchGoodResponse class]])
                {
                    HYMallSearchGoodResponse *resp = (HYMallSearchGoodResponse *)result;
                    array = resp.searchGoodArray;
                }
                
                [b_self updateViewWithData:array
                                     error:error];
            }];
        }
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    _hasMore = ([array count] > 0);
    
    if (_hasMore)
    {
        _pageNumber++;
        
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
        [self.flowersList addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if([self.flowersList count] <= 0)
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        if (error)
        {
            _nullView.descInfo = @"鲜花列表获取失败，请稍后再试";
        }
        else
        {
            _nullView.descInfo = @"暂无鲜花分类信息";
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.flowersList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FolwerListCellId = @"FolwerListCellId";
    HYFolwerDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:FolwerListCellId];
    if(!cell)
    {
        cell = [[HYFolwerDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:FolwerListCellId];
        [cell setHiddenLine:YES];
    }
    
    if (indexPath.row < [self.flowersList count])
    {
        HYFlowerListSummary* cellInfo = (HYFlowerListSummary*)[self.flowersList objectAtIndex:indexPath.row];
        [cell setFlowerData:cellInfo];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row < [self.flowersList count])
    {
        HYFlowerListSummary *flower = (HYFlowerListSummary*)[self.flowersList objectAtIndex:indexPath.row];
        HYFlowerDetailViewController* showDetail = [[HYFlowerDetailViewController alloc]init];
        showDetail.produceID = flower.productId;
        showDetail.title = flower.productName;
        showDetail.headImgUrl = flower.productPicUrl;
        [self.navigationController pushViewController:showDetail animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset)
    {
        [self reloadMoreData];
    }
}

@end
