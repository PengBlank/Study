//
//  HYActivityProductListViewController.m
//  Teshehui
//
//  Created by HYZB on 14-8-6.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityProductListViewController.h"
#import "HYActivityGoodsRequest.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"
#import "HYActivityGoodsCell.h"
#import "HYProductDetailViewController.h"
#import "HYMallCartViewController.h"
#import "HYShoppingCarView.h"

@interface HYActivityProductListViewController ()
<HYBuyCarViewDelegate>
{
    NSInteger _pageNumber;
    BOOL _isLoading;
    BOOL _hasMore;
}

@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@end

@implementation HYActivityProductListViewController

- (void)dealloc
{
    [self.getDataReq cancel];
    self.getDataReq = nil;
    
    [HYLoadHubView dismiss];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pageNumber = 1;
        _hasMore = YES;
        _isLoading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           self.view.frame.size.width,
                                                                           self.view.frame.size.height - 64)
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.showsVerticalScrollIndicator = NO;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    _nullView = [[HYNullView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_nullView];
    _nullView.hidden = YES;
    
    [self fetchGoodsFromNet];
    
    //
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - HYBuyCarViewDelegate
- (void)didCheckBuyCarList
{
    HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)fetchGoodsFromNet
{
    if (!_isLoading)
    {
        [HYLoadHubView show];
        
        _isLoading = YES;
        
        self.getDataReq.pageNo = _pageNumber;
        
        __weak typeof(self) bself = self;
        [self.getDataReq sendReuqest:^(id result, NSError *error){
            [HYLoadHubView dismiss];
            
            NSArray *data = nil;
            
            if ([result isKindOfClass:[HYActivityGoodsResponse class]])
            {
                data = [(HYActivityGoodsResponse *)result goodsArray];
            }
            
            [bself updateViewWithActivityData:data
                                        error:error];
        }];
        
    }
}

- (void)updateViewWithActivityData:(NSArray *)array
                             error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    _hasMore = ([array count] > 0);
    
    if (_hasMore)
    {
        _pageNumber++;
        
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
        [self.goodsArray addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if([self.goodsArray count] <= 0)
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        if (error)
        {
            _nullView.descInfo = error.domain;
        }
        else
        {
            _nullView.descInfo = @"商品列表获取失败，请稍后再试";
        }
    }
}

#pragma mark getter and setter

- (NSMutableArray *)goodsArray
{
    if (!_goodsArray)
    {
        _goodsArray = [NSMutableArray array];
    }
    return _goodsArray;
}

/**
 *  Kris 添加的代码注释
 *
 *  @param tableView
 *  @param section
 *
 *  @return
 */
#pragma mark tableview
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodsArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *activityCellId = @"activityCellId";
    HYActivityGoodsCell* cell = [tableView dequeueReusableCellWithIdentifier:activityCellId];
    if(cell == nil)
    {
        cell = [[HYActivityGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:activityCellId];
        //[cell setHaddenLine:YES];
    }
    
    if (indexPath.row < [self.goodsArray count])
    {
        HYActivityGoods* cellInfo = [self.goodsArray objectAtIndex:indexPath.row];
        [cell setGoods:cellInfo];
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
    
    if (indexPath.row < [self.goodsArray count])
    {
        HYActivityGoods* goods = (HYActivityGoods*)[self.goodsArray objectAtIndex:indexPath.row];
        
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = goods.productId;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_isLoading)
    {
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset)
        {
            [self reloadMoreData];
        }
    }
}

#pragma mark private methods

- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self fetchGoodsFromNet];
    }
    else
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}


@end
