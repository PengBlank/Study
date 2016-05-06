//
//  HYMallCateViewController.m
//  Teshehui
//
//  Created by 成才 向 on 16/3/21.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallCateViewController.h"
#import "HYMallCateCell.h"
#import "HYMallCateSubCell.h"
#import "HYNullView.h"
#import "HYGoodCategoryRequest.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYMallProductListViewController.h"
#import "HYAnalyticsManager.h"
#import "HYMallCateDao.h"

@interface HYMallCateViewController ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger expandRow;

//数据
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, strong) HYGoodCategoryRequest *categoryReqeust;
@property (nonatomic, strong) NSMutableArray *categoryArray;

@end

@implementation HYMallCateViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_categoryReqeust cancel];
    _categoryReqeust = nil;
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:table];
    self.tableView = table;
    
    self.expandRow = -1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.categoryArray = (id)[[[[HYMallCateDao alloc] init] queryEntity] subcategories];
    });
 
    [self.tableView reloadData];
    [self loadCategoryList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellDidClickSubCate:) name:@"kExpandSubCellNotice"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetClickCateNotice:) name:@"kDidClickCate"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kExpandSubCellNotice" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - events
- (void)cellDidClickSubCate:(NSNotification *)notice
{
    UITableViewCell *cell = notice.object;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    if (path)
    {
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop
                                                          animated:YES];
    }
}

- (void)didGetClickCateNotice:(NSNotification *)notice
{
    HYMallCategoryInfo *cate = notice.object;
    if (cate) {
        [self checkCateDetail:cate];
    }
}

#pragma mark - functions
- (void)loadCategoryList
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _categoryReqeust = [[HYGoodCategoryRequest alloc] init];
        _categoryReqeust.level = 4;
        __weak typeof(self) b_self = self;
        [_categoryReqeust sendReuqest:^(id result, NSError *error)
         {
             HYMallCategoryInfo *data = nil;
             if ([result isKindOfClass:[HYGoodCategoryResponse class]])
             {
                 data = [(HYGoodCategoryResponse *)result category];
             }
             
             [b_self updateViewWithData:data error:error];
         }];
    }
}

- (void)updateViewWithData:(HYMallCategoryInfo *)array error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    _isLoading = NO;
    if (array.subcategories.count > 0)
    {
        self.categoryArray = (id)array.subcategories;
        self.nullView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }
    else if (error)
    {
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
    }
    
    if (array)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            HYMallCateDao *dao = [[HYMallCateDao alloc] init];
            [dao saveEntity:array];
        });
    }
}

- (void)checkCateDetail:(HYMallCategoryInfo *)cate
{
    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithCategoryId:cate.cate_id];
    req.searchType = @"20";
    
    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
    vc.getSearchDataReq = req;
    vc.title = cate.cate_name;
    vc.curSearchCategoryId = cate.cate_id;
    [self.navigationController pushViewController:vc animated:YES];
    
    //  详情统计
    [[HYAnalyticsManager sharedManager] beginDetailVisitFromCate:cate];
    
    //  列表页统计
    NSInteger pagefrom = self.stgId.length ? 3 : 1;
    [HYAnalyticsManager sendProductListVisitWithType:HYListPageFromCate
                                             keyWord:cate.cate_id
                                           boardCode:nil
                                          bannerCode:nil
                                          bannerType:nil
                                            fromPage:pagefrom
                                        additionInfo:nil
                                               stgid:self.stgId];
}

#pragma mark - Delegate
#pragma mark -- tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.categoryArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == _expandRow ? 2 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return TFScalePoint(155.0);
    }
    else {
        if (indexPath.section < self.categoryArray.count)
        {
            HYMallCategoryInfo *cate = [self.categoryArray objectAtIndex:indexPath.section];
            if (cate.cachedHeight == 0) {
                int num = (int)((cate.subcategories.count + 2) / 3);
                cate.cachedHeight = num * 38;
            }
            return cate.cachedHeight + cate.cachedHeight2;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        static NSString *reuse = @"main";
        HYMallCateCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell)
        {
            cell = [[HYMallCateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        if (indexPath.section < self.categoryArray.count) {
            HYMallCategoryInfo *cate = [self.categoryArray objectAtIndex:indexPath.section];
            cell.cateInfo = cate;
        }
        return cell;
    }
    else
    {
        static NSString *reuse1 = @"sub";
        HYMallCateSubCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse1];
        if (!cell)
        {
            cell = [[HYMallCateSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse1];
            cell.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        }
        if (indexPath.section < self.categoryArray.count) {
            HYMallCategoryInfo *cate = [self.categoryArray objectAtIndex:indexPath.section];
            cell.cateInfo = cate;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) return;
    
    NSInteger old = _expandRow;
    if (_expandRow != -1)
    {
        _expandRow = -1;
        NSIndexPath *delPath = [NSIndexPath indexPathForRow:1 inSection:old];
        [tableView deleteRowsAtIndexPaths:@[delPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
        
        HYMallCategoryInfo *cate = [self.categoryArray objectAtIndex:old];
        cate.expandIdx = -1;
        cate.cachedHeight2 = 0;
    }
    if (old != indexPath.section)
    {
        _expandRow = indexPath.section;
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationTop];
        
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
