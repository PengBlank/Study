//
//  HYActivityTemplateViewController.m
//  Teshehui
//
//  Created by HYZB on 14-8-4.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYActivityTemplateViewController.h"
#import "HYActivityTableViewCell.h"
#import "HYLoadHubView.h"
#import "HYGetActivityListRequest.h"
#import "HYNullView.h"
#import "HYActivityProductListViewController.h"
#import "HYShoppingCarView.h"
#import "HYMallCartViewController.h"



@interface HYActivityTemplateViewController ()
<HYBuyCarViewDelegate>
{
    NSInteger _pageNumber;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) HYNullView *nullView;

@end

@implementation HYActivityTemplateViewController

- (void)dealloc
{
    [self.getDataReq cancel];
    self.getDataReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
    }
    return self;
}

- (void)loadView
{
    _pageNumber = 1;
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.rowHeight = 160;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    [self loadActivityList];
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
    [self loadActivityList];
}

- (void)loadActivityList
{
    [HYLoadHubView show];
    
    if (self.getDataReq)
    {
        self.getDataReq.pageNo = _pageNumber;
        
        __weak typeof(self) bself = self;
        [self.getDataReq sendReuqest:^(id result, NSError *error){
            [HYLoadHubView dismiss];
            
            NSArray *data = nil;
            NSString *title;
            if ([result isKindOfClass:[HYGetActivityListResponse class]])
            {
                data = [(HYGetActivityListResponse *)result categoryArray];
            }
            
            [bself updateViewWithActivityData:data error:error title:title];
        }];
    }
}

- (void)updateViewWithActivityData:(NSArray *)dataList
                             error:(NSError *)error
                             title:(NSString *)title
{
    if (title)
    {
        self.title = title;
    }
    
    if ([dataList count] > 0)
    {
        self.dataSource = dataList;
        [self.tableView reloadData];
    }
    else  //没有数据的情况
    {
        self.tableView.hidden = YES;
        self.nullView.hidden = NO;
        
        if (error)
        {
            _nullView.descInfo = error.domain;
        }
        else
        {
            _nullView.descInfo = @"暂无鲜花信息";
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
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flowerCellId = @"flowerCellId";
    HYActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flowerCellId];
    if (cell == nil)
    {
        cell = [[HYActivityTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:flowerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.evenIndex = (indexPath.row%2);
    if (self.dataSource.count > indexPath.row)
    {
        HYProductListSummary *cate = [self.dataSource objectAtIndex:indexPath.row];
        [cell setWithCategory:cate];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (self.dataSource.count > indexPath.row)
//    {
//        HYProductListSummary *cate = [self.dataSource objectAtIndex:indexPath.row];
//        
//        HYActivityProductListViewController *list = [[HYActivityProductListViewController alloc] init];
//        list.CategoryID = cate.productId;
//        list.CategoryName = cate.productName;
//        [self.navigationController pushViewController:list animated:YES];
//    }
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

@end
