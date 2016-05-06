//
//  HYFlowerMainViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-5-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerMainViewController.h"
#import "HYNullView.h"
#import "HYFlowerMainTableViewCell.h"
#import "HYFlowerSubListViewController.h"

#import "HYMenuView.h"
#import "HYLoadHubView.h"

#import "HYFlowerTypeListRequest.h"
#import "HYGetProtocolReq.h"
#import "HYEarnCashTicketAlertView.h"



@interface HYFlowerMainViewController ()<HYMenuViewDelegate>
{
    HYGetProtocolReq *_getProtocolReq;// 说明文字请求
    HYFlowerTypeListRequest *_categoryReqeust;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *typesList;

@property (nonatomic, strong) HYNullView *nullView;
@property (nonatomic, strong) UIBarButtonItem *menuItemBar;
@property (nonatomic, strong) HYMenuView *menuView;


@property (nonatomic, strong) HYEarnCashTicketAlertView *alertV;

@end

@implementation HYFlowerMainViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    [_menuView setMenuViewShow:NO animation:NO];
    _menuView = nil;
    
    [_getProtocolReq cancel];
    _getProtocolReq = nil;
    
    [_categoryReqeust cancel];
    _categoryReqeust = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.rowHeight = CGRectGetWidth(frame)/2;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"鲜花全球购";
    
    HYEarnCashTicketAlertView *alertV = [[HYEarnCashTicketAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertV = alertV;
    [alertV.agreedBtn addTarget:self action:@selector(cancelAlert:) forControlEvents:UIControlEventTouchUpInside];
    [alertV show];
    
    self.navigationItem.rightBarButtonItem = self.menuItemBar;
    
    [self getProtocolDetail];
    
    [self getFlowerTypeListWithCategoryId:@"1"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_menuView setMenuViewShow:NO animation:NO];
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

#pragma mark setter/getter
- (UIBarButtonItem *)menuItemBar
{
    if (!_menuItemBar)
    {
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [mBtn setImage:[UIImage imageNamed:@"menuIcon_normal"]
              forState:UIControlStateNormal];
        [mBtn setImage:[UIImage imageNamed:@"menuIcon_press"]
              forState:UIControlStateHighlighted];
        [mBtn setFrame:CGRectMake(0, 0, 48, 30)];
        [mBtn addTarget:self
                 action:@selector(clickMenuEvent:)
       forControlEvents:UIControlEventTouchUpInside];
        
        _menuItemBar = [[UIBarButtonItem alloc] initWithCustomView:mBtn];
    }
    
    return _menuItemBar;
}

- (HYMenuView *)menuView
{
    if (!_menuView)
    {
        CGRect frame = [[UIScreen mainScreen] bounds];
        _menuView = [[HYMenuView alloc] initWithFrame:frame];
        _menuView.delegate = self;
    }
    
    return _menuView;
}

#pragma mark private methods
/**
 * 取消弹窗提示
 */
- (void)cancelAlert:(UIButton *)btn
{
    [_alertV dismiss];
}

- (void)getProtocolDetail
{
    if (!_getProtocolReq)
    {
        _getProtocolReq = [[HYGetProtocolReq alloc] init];
    }
    _getProtocolReq.copywriting_key = @"flower_tips";
    
    [HYLoadHubView show];
    __weak typeof(self) bself = self;
    [_getProtocolReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        NSString *content = nil;
        if ([result isKindOfClass:[HYGetProtocolResp class]])
        {
            HYGetProtocolResp *resp = (HYGetProtocolResp *)result;
            content = resp.resTips;
        }
        
        if (!error)
        {
            [bself.alertV.contentWebV loadHTMLString:content
                                 baseURL:nil];
        }
    }];
}

- (void)clickMenuEvent:(id)sender
{
    self.menuView.dataSource = self.typesList;
    [self.menuView setMenuViewShow:YES animation:YES];
}

//获取首页的类型数据
- (void)getFlowerTypeListWithCategoryId:(NSString *)categoryId
{
    _categoryReqeust = [[HYFlowerTypeListRequest alloc] init];
    _categoryReqeust.level = @"4";
    _categoryReqeust.categoryId = categoryId;
    
    [HYLoadHubView show];
    
    __weak typeof(self) bself = self;
    [_categoryReqeust sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         
         NSArray *types = nil;
         if ([result isKindOfClass:[HYFlowerTypeListResponse class]])
         {
             HYFlowerTypeListResponse *resp = (HYFlowerTypeListResponse *)result;
             types = resp.flowerInfo.children;
         }
         
         [bself updateViewWithData:types
                             error:error];
     }];
}

- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
}

//更新界面数据
- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (array > 0)
    {
        self.tableView.hidden = NO;
        self.nullView.hidden = YES;
        
        self.typesList = array;
        [self.tableView reloadData];
    }
    else if([self.typesList count] <= 0)
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

#pragma mark HYMenuViewDelegate
- (void)didSelectedMenuItem:(id)item
{
//    HYFlowerTypeInfo *type = [self.typesList objectAtIndex:self.menuView.currentIndex];
//    [self getFlowerTypeListWithCategoryId:type.categoryId];
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.menuView.currentIndex < [self.typesList count])
    {
        HYFlowerTypeInfo *type = [self.typesList objectAtIndex:self.menuView.currentIndex];
        return [type.children count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *flowerCellId = @"flowerCellId";
    HYFlowerMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:flowerCellId];
    if (cell == nil)
    {
        cell = [[HYFlowerMainTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:flowerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.menuView.currentIndex < [self.typesList count])
    {
        HYFlowerTypeInfo *type = [self.typesList objectAtIndex:self.menuView.currentIndex];
        
        if (indexPath.row < [type.children count])
        {
            HYFlowerTypeInfo *item = (HYFlowerTypeInfo*)[type.children objectAtIndex:indexPath.row];
            cell.evenIndex = (indexPath.row%2);
            [cell setItem:item];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.menuView.currentIndex < [self.typesList count])
    {
        HYFlowerTypeInfo *type = [self.typesList objectAtIndex:self.menuView.currentIndex];
        
        if (indexPath.row < [type.children count])
        {
            HYFlowerTypeInfo *item = (HYFlowerTypeInfo*)[type.children objectAtIndex:indexPath.row];
            HYFlowerSubListViewController* detailvc = [[HYFlowerSubListViewController alloc]init];
            detailvc.categoryID = item.categoryId;
            detailvc.categoryName = item.categoryName;
            [self.navigationController pushViewController:detailvc animated:YES];
        }
    }
}

@end