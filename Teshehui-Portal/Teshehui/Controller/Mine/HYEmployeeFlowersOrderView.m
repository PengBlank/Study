//
//  HYEmployeeFollwerOrderView.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeFlowersOrderView.h"
#import "HYEmployeeFlowerOrderCell.h"
#import "HYFlowerOrderListRequest.h"
#import "HYFlowerOrderListResponse.h"

#import "HYUserInfo.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYTableViewFooterView.h"

@interface HYEmployeeFlowersOrderView ()
{
    HYFlowerOrderListRequest *_requset;
    
    BOOL _isLoading;
    BOOL _loadFinish;
    NSInteger _pageNumber;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *flowersOrderList;

@end

@implementation HYEmployeeFlowersOrderView

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_requset cancel];
    _requset = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _pageNumber = 1;
        _loadFinish = NO;
        
        //tableview
        frame.origin.y = 0;
        UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                              style:UITableViewStylePlain];
        tableview.delegate = self;
        tableview.dataSource = self;
        tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableview.sectionFooterHeight = 10;
        tableview.sectionHeaderHeight = 0;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1.0)];
        lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                       topCapHeight:0];
        tableview.tableHeaderView = lineView;
        
        HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
        tableview.tableFooterView = v;
        
        [self addSubview:tableview];
        self.tableView = tableview;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)relaodData
{
    _pageNumber = 1;
    [self.flowersOrderList removeAllObjects];
    [self.tableView reloadData];
    
    [self loadOrderList];
}

#pragma mark - private methods
- (void)loadOrderList
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        
        _requset = [[HYFlowerOrderListRequest alloc] init];
        _requset.userId = user.userId;
        _requset.employeeId = self.employee.user_id;
        _requset.pageNo = _pageNumber;
        _requset.pageSize = 5;
        _requset.isEnterprise = 1;
        
        __weak typeof(self) b_self = self;
        [_requset sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYFlowerOrderListResponse class]])
            {
                HYFlowerOrderListResponse *respnse = (HYFlowerOrderListResponse *)result;
                array = respnse.orderList;
            }
            [b_self updateTableViewWithOrders:array error:error];
        }];
    }
}

- (void)updateTableViewWithOrders:(NSArray *)orders error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    if (!error)
    {
        if (!self.flowersOrderList)
        {
            self.flowersOrderList = [[NSMutableArray alloc] init];
        }
        if ([orders count] > 0)
        {
            [self.flowersOrderList addObjectsFromArray:orders];
            [self.tableView reloadData];
        }
        else
        {
            _loadFinish = YES;
            [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
        }
    }
    
    if ([self.flowersOrderList count] <= 0)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        CGRect rect = self.frame;
        rect.origin.y = 0;
        HYNullView *v = [[HYNullView alloc] initWithFrame:rect];
        
        if (error)
        {
            v.descInfo = @"鲜花订单查询失败，请稍后再试";
        }
        else
        {
            v.descInfo = @"暂无鲜花订单";
        }
        
        [self addSubview:v];
    }
}

- (void)reloadMoreData
{
    if (!_isLoading && !_loadFinish)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        
        if ([self.flowersOrderList count])
        {
            _pageNumber++;
            [self loadOrderList];
        }
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.flowersOrderList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    HYEmployeeFlowerOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYEmployeeFlowerOrderCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < [self.flowersOrderList count])
    {
        HYFlowerOrderSummary *order = [self.flowersOrderList objectAtIndex:indexPath.row];
        [cell setOrder:order];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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