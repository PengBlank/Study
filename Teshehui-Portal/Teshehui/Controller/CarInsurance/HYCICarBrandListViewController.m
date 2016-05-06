//
//  HYCICarBrandListViewController.m
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCICarBrandListViewController.h"
#import "HYCICarBrandListCell.h"
#import "HYCIQueryCarTypeListReq.h"
#import "HYLoadHubView.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"

@interface HYCICarBrandListViewController ()
{
    HYCIQueryCarTypeListReq *_queryCarTypeReq;

    UITextField *_searchTextField;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carTypeList;
@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation HYCICarBrandListViewController

- (void)dealloc
{
    [_queryCarTypeReq cancel];
    _queryCarTypeReq = nil;
    
    [HYLoadHubView dismiss];
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   frame.size.width,
                                                                   44)];
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(16, 5, frame.size.width-120, 34)];
    _searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    _searchTextField.placeholder = @"请输入关键字点击查询";
    _searchTextField.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:_searchTextField];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(frame.size.width-94, 5, 80, 34)];
    [searchBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_on"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 2, 5, 2)]
                         forState:UIControlStateNormal];
//    [searchBtn setBackgroundImage:[UIImage imageNamed:@""]
//                         forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [searchBtn setTitle:@"查询"
               forState:UIControlStateNormal];
    [searchBtn addTarget:self
                  action:@selector(searchBrandListEvent:)
        forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 43, CGRectGetWidth(frame)-16, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
    [headerView addSubview:lineView];
    
    [self.view addSubview:headerView];
    
    frame.origin.y = 44;
    frame.size.height -= 44;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStyleGrouped];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    self.title = @"品牌型号选择";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointMake(0, 44);
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}

#pragma mark private methods
- (void)searchBrandListEvent:(id)sender
{
    [_searchTextField resignFirstResponder];
    
    self.keyWord = _searchTextField.text;
    
    [self reloadData];
}

- (void)reloadData
{
    [self.carTypeList removeAllObjects];
    _pageNumber = 1;
    
    [self loadData];
}

- (void)loadMoreData
{
    if (!_isLoading)
    {
        _pageNumber++;
        [self loadData];
    }
}

- (void)loadData
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _queryCarTypeReq = [[HYCIQueryCarTypeListReq alloc] init];
        
        HYCIQueryCarTypeListParam *param = [[HYCIQueryCarTypeListParam alloc] init];
        param.keyword = self.keyWord;
        param.pageNo = _pageNumber;
        param.pageSize = 20;
        
        _queryCarTypeReq.reqParam = param;
        
        __weak typeof(self) bself = self;
        [_queryCarTypeReq sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYCIQueryCarTypeListResp class]])
            {
                array = [(HYCIQueryCarTypeListResp *)result typeList];
            }
            
            [bself updateViewWithData:array error:error];
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
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        if (!_carTypeList)
        {
            _carTypeList = [[NSMutableArray alloc] init];
        }
        
        [_carTypeList addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if ([self.carTypeList count] <= 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        [self.tableView setHidden:YES];
        [self.nullView setHidden:NO];
        
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
                str = @"无符合条件的车型品牌";
            }
            self.nullView.descInfo = str;
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.carTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *carBrandListCellId = @"carBrandListCellId";
    HYCICarBrandListCell *cell = [tableView dequeueReusableCellWithIdentifier:carBrandListCellId];
    
    if (!cell)
    {
        cell = [[HYCICarBrandListCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:carBrandListCellId];
    }
    
    if (indexPath.row < [self.carTypeList count])
    {
        HYCICarBrandInfo *typeInfo = [self.carTypeList objectAtIndex:indexPath.row];
        [cell setTypeInfo:typeInfo];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    if(indexPath.row == totalRow -1)
    {
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.carTypeList count] &&
        [self.delegate respondsToSelector:@selector(didSelectCarBrandType:)])
    {
        HYCICarBrandInfo *typeInfo = [self.carTypeList objectAtIndex:indexPath.row];
        [self.delegate didSelectCarBrandType:typeInfo];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //加载更多
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset)
    {
        [self loadMoreData];
    }
}

@end
