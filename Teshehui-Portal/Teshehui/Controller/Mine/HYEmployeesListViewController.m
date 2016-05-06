//
//  HYEmployeesListViewController.m
//  Teshehui
//
//  Created by HYZB on 14-7-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeesListViewController.h"
#import "HYEmployeeListTableViewCell.h"
#import "HYEmployeesOrderViewController.h"
#import "HYTableViewFooterView.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYUserInfo.h"

#import "HYGetMyEmployeesListRequest.h"

@interface HYEmployeesListViewController ()
{
    HYGetMyEmployeesListRequest *_request;
    
    BOOL _isLoading;
    BOOL _hasMore;
    NSInteger _pageNumber;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *employeeList;
@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYEmployeesListViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_request cancel];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"员工列表";
        _hasMore = YES;
        _pageNumber = 1;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    //frame.size.height -= 48;
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    [self.view addSubview:tableview];
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 48)];
    tableview.tableFooterView = v;
    
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getMyEmployeeList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods
- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    [self getMyEmployeeList];
}

- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self getMyEmployeeList];
    }
    else
    {
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

- (void)getMyEmployeeList
{
    if (!_isLoading)
    {
        _isLoading = YES;
        
        [HYLoadHubView show];
        
        _request = [[HYGetMyEmployeesListRequest alloc] init];
        _request.page = _pageNumber;
        _request.user_id = [[HYUserInfo getUserInfo] userId];
        
        __weak typeof(self) b_self = self;
        [_request sendReuqest:^(id result, NSError *error) {
            
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYGetMyEmployeesListResponse class]])
            {
                array = [(HYGetMyEmployeesListResponse *)result employees];
            }
            
            [b_self updateViewWithData:array error:error];
        }];
    }
}

- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    _isLoading = NO;
    
    [HYLoadHubView dismiss];
    
    if (!_employeeList)
    {
        _employeeList = [[NSMutableArray alloc] init];
    }
    
    _hasMore = ([array count] > 0);
    
    if (_hasMore)
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        _pageNumber++;
        
        [_employeeList addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if ([_employeeList count] <= 0)
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
                str = @"暂无数据，敬请期待";
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

#pragma mark setter/getter
- (HYNullView *)nullView
{
    if (!_nullView)
    {
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        _nullView = [[HYNullView alloc] initWithFrame:frame];
        _nullView.needTouch = YES;
        [_nullView addTarget:self
                      action:@selector(didClickUpdateEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nullView];
    }
    
    return _nullView;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.employeeList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    HYEmployeeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HYEmployeeListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row < [self.employeeList count])
    {
        HYEmployee *e = [self.employeeList objectAtIndex:indexPath.row];
        [cell setEmployee:e];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row < [self.employeeList count])
    {
        HYEmployee *e = [self.employeeList objectAtIndex:indexPath.row];
        HYEmployeesOrderViewController *vc = [[HYEmployeesOrderViewController alloc] init];
        vc.employee = e;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollOffset = scrollView.contentOffset.y;
    float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (scrollOffset >= maximumOffset && !_isLoading)
    {
        [self reloadMoreData];
    }
}

@end
