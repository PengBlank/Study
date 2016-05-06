//
//  HYCategoryViewController.m
//  Teshehui
//
//  Created by RayXiang on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYCategoryViewController.h"
#import "HYTabbarViewController.h"
#import "HYCategoryCell.h"
#import "HYCategorySubCell.h"
#import "HYGoodCategoryRequest.h"
#import "HYLoadHubView.h"
#import "HYNullView.h"
#import "HYShoppingCarView.h"
#import "HYTableViewFooterView.h"
#import "HYMallCartViewController.h"
#import "HYMallCartViewController.h"
#import "HYMallHomeItemsInfo.h"
#import "HYMallProductListViewController.h"
#import "HYAppDelegate.h"
#import "UIImageView+WebCache.h"
#import "HYVisitObjectReq.h"
#import "HYAnalyticsManager.h"

@interface HYCategoryViewController ()
<HYBuyCarViewDelegate, HYCategorySubCellDelegate>
{
    BOOL _isLoading;
    BOOL _hasMore;
    CGFloat _prevContentOffsetY;
}

//@property (nonatomic, strong) UITableView *tableView;

//数据
@property (nonatomic, strong) HYGoodCategoryRequest *categoryReqeust;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, strong) HYNullView *nullView;

@property (strong, nonatomic) IBOutlet UITableView *cateTable;
@property (strong, nonatomic) IBOutlet UITableView *subTable;

@end

@implementation HYCategoryViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_categoryReqeust cancel];
    _categoryReqeust = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"分类";
        self.leftItemType = NoneItemBar;
        _hasMore = YES;
        _pageNumber = 1;
        if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.extendedLayoutIncludesOpaqueBars = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cateTable registerNib:[UINib nibWithNibName:@"HYCategoryCell" bundle:nil]
         forCellReuseIdentifier:@"category"];
    [_cateTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_subTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_cateTable setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    [_subTable setContentInset:UIEdgeInsetsMake(0, 0, 49, 0)];
    [_cateTable setTableFooterView:
     [[UIView alloc] initWithFrame:CGRectZero]];
    [_subTable setTableFooterView:
     [[UIView alloc] initWithFrame:CGRectZero]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.baseViewController setTabbarShow:YES];
    self.baseViewController.navigationItem.rightBarButtonItem = nil;
    self.baseViewController.navigationItem.leftBarButtonItem = nil;
    
    [self checkNeedUpdateData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.categoryArray)
    {
        [self loadCategoryList];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [HYLoadHubView dismiss];
}

#pragma mark - Overloaded
- (IBAction)backToHomeViewController:(id)sender
{
    [self.baseViewController setCurrentSelectIndex:0];
}

#pragma mark private methods
- (void)checkNeedUpdateData
{
    NSTimeInterval time = [[NSUserDefaults standardUserDefaults] doubleForKey:kBrandDataUpdateTime];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    if (nowTime-time > (24*60*60))
    {
        _hasMore = NO;
        _pageNumber = 1;
        [_categoryArray removeAllObjects];
        
        [self loadCategoryList];
        [[NSUserDefaults standardUserDefaults] setDouble:nowTime forKey:kBrandDataUpdateTime];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)loadCategorySublist:(HYMallCategoryInfo *)cate
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _categoryReqeust = [[HYGoodCategoryRequest alloc] init];
        _categoryReqeust.level = 2;
        _categoryReqeust.category_id = cate.cate_id;
        __weak typeof(self) b_self = self;
        [_categoryReqeust sendReuqest:^(id result, NSError *error)
         {
             HYMallCategoryInfo *data = nil;
             if ([result isKindOfClass:[HYGoodCategoryResponse class]])
             {
                 data = [(HYGoodCategoryResponse *)result category];
             }
             cate.subcategories = data.subcategories;
             [b_self updateSubcategory:cate];
         }];
    }
}

- (void)updateSubcategory:(HYMallCategoryInfo *)cate
{
    [HYLoadHubView dismiss];
    _isLoading = NO;
    [self.subTable reloadData];
    [_subTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                     atScrollPosition:UITableViewScrollPositionTop
                             animated:YES];
}

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
    _hasMore = ([array.subcategories count]>0);
    
    if (_hasMore)
    {
        [self.cateTable setHidden:NO];
        self.subTable.hidden = NO;
        [_nullView setHidden:YES];
        
        if (!_categoryArray)
        {
            _categoryArray = [[NSMutableArray alloc] init];
        }
        
        [_categoryArray addObjectsFromArray:array.subcategories];
        [self.cateTable reloadData];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [_cateTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:_cateTable didSelectRowAtIndexPath:path];
        [_subTable reloadData];
    }
    else if ([self.categoryArray count] <= 0)
    {
        _hasMore = YES;
        _pageNumber = 1;
        
        [self.cateTable setHidden:YES];
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
        [self.cateTable setHidden:NO];
        [_nullView setHidden:YES];
    }
}

#pragma mark - TableView datasource
- (HYMallCategoryInfo *)categoryForPath:(NSIndexPath *)path
{
    if (path.row < [self.categoryArray count])
    {
        HYMallCategoryInfo *category = [self.categoryArray objectAtIndex:path.row];
        return category;
    }
    return nil;
    
}

- (HYMallCategoryInfo *)selectedCategory
{
    NSIndexPath *path = [_cateTable indexPathForSelectedRow];
    if (path && path.row < _categoryArray.count)
    {
        HYMallCategoryInfo *cate = [_categoryArray objectAtIndex:path.row];
        return cate;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return _categoryArray.count;
    if (tableView == _subTable)
    {
        HYMallCategoryInfo *cate = [self selectedCategory];
        if (cate) {
            return cate.subcategories.count+1;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _cateTable)
    {
        return _categoryArray.count;
    }
    else
    {
        return 1;
    }
    //return _expandCate == section ? 2 : 1;
    //return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTable)
    {
        static NSString *identifier = @"category";
        HYCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        HYMallCategoryInfo *category = [self categoryForPath:indexPath];
        [cell setWithCategory:category];
        return cell;
    }
    else if (tableView == _subTable)
    {
        NSIndexPath *path = [_cateTable indexPathForSelectedRow];
        HYMallCategoryInfo *cate = nil;
        if (path) {
            cate = [self categoryForPath:path];
        }
        if (indexPath.section == 0)
        {
            static NSString *identifier = @"image";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *iv = (UIImageView *)[cell.contentView viewWithTag:1024];
            if (!iv)
            {
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(cell.frame)-20, CGRectGetHeight(cell.frame)-10)];
                iv.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                iv.contentMode = UIViewContentModeScaleAspectFill;
                iv.clipsToBounds = YES;
                //iv.backgroundColor = [UIColor redColor];
                iv.tag = 1024;
                [cell.contentView addSubview:iv];
            }
            iv.frame = CGRectMake(10, 10, CGRectGetWidth(cell.frame)-20, CGRectGetHeight(cell.frame)-10);
            NSURL *URL = [NSURL URLWithString:cate.thumbnail_tetragonal];
            [iv sd_setImageWithURL:URL];
            return cell;
        }
        else
        {
            static NSString *identifier = @"sub";
            HYCategorySubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sub"];
            if (!cell) {
                cell = [[HYCategorySubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            HYMallCategoryInfo *subcate = [cate.subcategories objectAtIndex:indexPath.section-1];
            cell.delegate = self;
            [cell setCategory:subcate];
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTable) {
        return 50;
    }
    else
    {
        if (indexPath.section == 0)
        {
            CGFloat imgHeight = 0;
            if (imgHeight == 0) {
                imgHeight = (CGRectGetWidth(_subTable.frame)-20) * 0.32 + 10;
            }
            return imgHeight;
        }
        else
        {
            HYMallCategoryInfo *cate = [self selectedCategory];
            HYMallCategoryInfo *sub = [cate.subcategories objectAtIndex:indexPath.section - 1];
            NSInteger count = sub.subcategories ? sub.subcategories.count : 1;
            NSInteger row = (count + 2) / 3;
            return row * 40+5;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _subTable)
    {
        if (section == 0) {
            return 0;
        }
        return 40;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section > 0)
    {
        NSIndexPath *path = [_cateTable indexPathForSelectedRow];
        if (path)
        {
            HYMallCategoryInfo *cate = [self categoryForPath:path];
            if (section - 1 < cate.subcategories.count)
            {
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_subTable.frame), 40)];
                view.backgroundColor = [UIColor whiteColor];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.view.frame)-90, 40)];
                label.font = [UIFont systemFontOfSize:13.0];
                label.textColor = [UIColor lightGrayColor];
                HYMallCategoryInfo *sub = [cate.subcategories objectAtIndex:section-1];
                label.text = sub.cate_name;
                [view addSubview:label];
                
                return view;
            }
        }
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _cateTable)
    {
        HYMallCategoryInfo *cate = [self categoryForPath:indexPath];
        if (cate.subcategories.count > 0)
        {
            [self.subTable reloadData];
            [_subTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else
        {
            [self loadCategorySublist:cate];
        }
    }
}

#pragma mark - subCategoryView delegate

- (void)didSelectSubCategory:(HYMallCategoryInfo *)category atIndex:(NSInteger)idx
{
    HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithCategoryId:category.cate_id];
    req.searchType = @"20";
    
    HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
    vc.getSearchDataReq = req;
    vc.title = category.cate_name;
    vc.curSearchCategoryId = category.cate_id;
    [self.baseViewController setTabbarShow:NO];
    [self.navigationController pushViewController:vc animated:YES];
    
    //  详情统计
    [[HYAnalyticsManager sharedManager] beginDetailVisitFromCate:category];
    
    //  列表页统计
    NSInteger pagefrom = self.stgId.length ? 3 : 1;
    [HYAnalyticsManager sendProductListVisitWithType:HYListPageFromCate
                                             keyWord:category.cate_id
                                           boardCode:nil
                                          bannerCode:nil
                                          bannerType:nil
                                            fromPage:pagefrom
                                        additionInfo:nil
                                               stgid:self.stgId];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging)
    {
        CGFloat deltaY = scrollView.contentOffset.y-_prevContentOffsetY;
        
        if (deltaY > 0)
        {
            [self updateTabbarWithShow:NO];
        }
    }
    
    //禁用翻页
    /*
     float scrollOffset = scrollView.contentOffset.y;
     float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
     
     if (scrollOffset >= maximumOffset)
     {
     [self reloadMoreData];
     }*/
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    [self updateTabbarWithShow:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self updateTabbarWithShow:YES];
    }
}

- (void)updateTabbarWithShow:(BOOL)show
{
    [self.baseViewController setTabbarShow:show];
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


//重新加载数据
//在点击nullView的时候调用
- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    
    [self loadCategoryList];
}

#pragma mark - HYBuyCarViewDelegate
- (void)didCheckBuyCarList
{
    HYMallCartViewController *vc = [[HYMallCartViewController alloc] init];
    [self.baseViewController setTabbarShow:NO];
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

@end
