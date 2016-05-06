//
//  HYMallFavoritesViewController.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallFavoritesViewController.h"
#import "HYProductDetailViewController.h"
#import "HYTableViewFooterView.h"
#import "HYNullView.h"
#import "HYFavoritesCell.h"
#import "METoast.h"

#import "HYGetFavoriteGoodsListRequest.h"
#import "HYCancelFavoriteGoodsRequest.h"
#import "HYUserInfo.h"
#import "HYMallFavouriteItem.h"
#import "HYMallSearchGoodsRequest.h"
#import "HYMallProductListViewController.h"

#import "HYUmengMobClick.h"

@interface HYMallFavoritesViewController ()<HYFavoritesCellDelegate>
{
    BOOL _isLoading;
    BOOL _hasMore;
    NSInteger _pageNumber;
    
    HYCancelFavoriteGoodsRequest *_cancelFavoriteReq;
    HYGetFavoriteGoodsListRequest *_getFavoriteReq;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *favoritesList;
@property (nonatomic, strong) NSMutableArray *deleteArr;
@property (nonatomic, strong) HYNullView *nullView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIAlertView *deleteAlert;
@property (nonatomic, assign) BOOL isSelectAll;

@end

@implementation HYMallFavoritesViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_cancelFavoriteReq cancel];
    _cancelFavoriteReq = nil;
    
    [_getFavoriteReq cancel];
    _getFavoriteReq = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pageNumber = 1;
        _hasMore = YES;
        self.title = @"我的收藏";
        _favoritesList = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                           green:237.0/255.0
                                            blue:237.0/255.0
                                           alpha:1.0];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    
    HYTableViewFooterView *v = [[HYTableViewFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
    tableview.tableFooterView = v;
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - TFScalePoint(40), frame.size.width, TFScalePoint(40))];
    _bottomView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bottomView];
    _bottomView.hidden = YES;
    
    CGFloat btnWidth = _bottomView.frame.size.width / 2;
    CGFloat btnHeight = _bottomView.frame.size.height;
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(btnWidth, 0, btnWidth, btnHeight);
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    deleteBtn.backgroundColor = [UIColor orangeColor];
    [deleteBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:deleteBtn];
    
    UIButton *selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAllBtn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectAllBtn.backgroundColor = [UIColor grayColor];
    [selectAllBtn addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:selectAllBtn];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.canDragBack = NO;
   // _isSelectAll = NO;
    
    [self creareRightBtn];
    
    [self reloadFavoriteList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (NSMutableArray *)deleteArr
{
    if (!_deleteArr) {
        _deleteArr = [[NSMutableArray alloc] init];
    }
    return _deleteArr;
}

#pragma mark - private methods
- (void)creareRightBtn
{
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setFrame:TFRectMake(0, 0, 30, 30)];
    [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightBtn addTarget:self
                  action:@selector(editeBtnDidClicked)
        forControlEvents:UIControlEventTouchDown];
    [_rightBtn setTitleColor:[UIColor grayColor]
                    forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _rightBtn.enabled = NO;
}

- (void)editeBtnDidClicked
{
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        
        
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        _bottomView.hidden = NO;
    } else {
        
        [self.deleteArr removeAllObjects];
        [_rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        _bottomView.hidden = YES;
    }
}

- (void)selectAllBtnClick:(UIButton *)button
{
    [HYUmengMobClick mineCollectionWithType:CollectionViewBtnTypeBottomSelectAll];
    _isSelectAll = YES;
    [self.tableView setContentOffset:CGPointZero];
    // 检查是否全部选中
    for (int i = 0; i < self.favoritesList.count; i++)
    {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
        HYFavoritesCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (!cell.selected)
        {
            
            _isSelectAll = NO;
        }
    }
    
    if (!_isSelectAll)
    {
        
        [self.deleteArr removeAllObjects];
        
        for (int i = 0; i < self.favoritesList.count; i++)
        {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        [self.deleteArr addObjectsFromArray:self.favoritesList];
    }
    else
    {
        [self.deleteArr removeAllObjects];
        for (NSUInteger i = 0; i < self.favoritesList.count; i++)
        {

            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        
    }
    
}

- (void)deleteClick:(UIButton *) button {
    
    [HYUmengMobClick mineCollectionWithType:CollectionViewBtnTypeBottomDelete];
    if (self.tableView.editing && self.deleteArr.count > 0) {
        
        _deleteAlert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确认将这%ld个宝贝删除吗", (unsigned long)self.deleteArr.count] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_deleteAlert show];
        
    } else {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请至少选择一个宝贝" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)reloadMoreData
{
    if (_hasMore && !_isLoading)
    {
        _pageNumber++;
        [(HYTableViewFooterView *)self.tableView.tableFooterView startLoadMore];
        [self reloadFavoriteList];
    }
}

- (void)didClickUpdateEvent:(id)sender
{
    [self.nullView setHidden:YES];
    [self reloadFavoriteList];
}

- (void)reloadFavoriteList
{
    if (!_isLoading)
    {
        _isLoading = YES;
        [HYLoadHubView show];
        
        _getFavoriteReq = [[HYGetFavoriteGoodsListRequest alloc] init];
        _getFavoriteReq.page = _pageNumber;
        _getFavoriteReq.userid = [HYUserInfo getUserInfo].userId;
        
        __weak typeof(self) bself = self;
        [_getFavoriteReq sendReuqest:^(id result, NSError *error) {
            NSArray *array = nil;
            if (!error && [result isKindOfClass:[HYGetFavoriteGoodsListResponse class]])
            {
                array = [(HYGetFavoriteGoodsListResponse *)result goodsList];
            }
            
            [bself updateViewWithData:array error:error];
        }];
    }
}


- (void)updateViewWithData:(NSArray *)array error:(NSError *)error
{
    _isLoading = NO;
    [HYLoadHubView dismiss];
    
    _hasMore = ([array count]>0);
    
    if (_hasMore)
    {
        _rightBtn.enabled  = YES;
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [self.favoritesList addObjectsFromArray:array];
        [self.tableView reloadData];
    }
    else if ([self.favoritesList count] <= 0)
    {
        _rightBtn.enabled = NO;
        [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
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
                str = @"您还没有收藏过宝贝";
            }
            self.nullView.descInfo = str;
            self.nullView.icon = [UIImage imageNamed:@"myCollect"];
            ;
        }
    }
    else
    {
        [self.tableView setHidden:NO];
        [_nullView setHidden:YES];
        
        [(HYTableViewFooterView *)self.tableView.tableFooterView stopLoadMore];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _deleteAlert && buttonIndex == 1) {
        
        //删除
        for (NSInteger i = 0; i < self.deleteArr.count; i++) {
            
            [self didDeleteFavoriteWithGoods:self.deleteArr[i]];
        }
    }
}


#pragma mark - HYFavoritesCellDelegate

- (void)didSelectStoreWithGoods:(HYMallFavouriteItem *)goodsInfo
{
    if (goodsInfo.storeId.length > 0)
    {
        HYMallSearchGoodsRequest *req = [[HYMallSearchGoodsRequest alloc] initReqWithStoreId:goodsInfo.storeId];
        req.searchType = @"10";
        
        HYMallProductListViewController *vc = [[HYMallProductListViewController alloc] init];
        vc.title = goodsInfo.storeName;
        vc.getSearchDataReq = req;
        
        [self.navigationController pushViewController:vc
                                             animated:YES];
    }
}

- (void)didDeleteFavoriteWithGoods:(HYMallFavouriteItem *)goodsinfo
{
    [HYLoadHubView show];
    
    _cancelFavoriteReq = [[HYCancelFavoriteGoodsRequest alloc] init];
    _cancelFavoriteReq.goods_id = goodsinfo.productId;
    _cancelFavoriteReq.userid = [HYUserInfo getUserInfo].userId;
    
    __weak typeof(self) b_self = self;
    [_cancelFavoriteReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        
        if (!error && [HYCancelFavoriteGoodsResponse class])
        {
            HYCancelFavoriteGoodsResponse *response = (HYCancelFavoriteGoodsResponse *)result;
            if (response.status == 200)
            {
                NSInteger index = 0;
                for (HYMallFavouriteItem *obj in b_self.favoritesList)
                {
                    if ([goodsinfo.productId isEqualToString:obj.productId])
                    {
                        [b_self.favoritesList removeObject:obj];
                        [b_self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index]
                                        withRowAnimation:UITableViewRowAnimationLeft];
                        
                        break;
                    };
                    
                    index++;
                }
                
                if (b_self.favoritesList.count == 0) {
                    
                    b_self.rightBtn.enabled = NO;
                    [b_self.rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    
                    [b_self.nullView setHidden:NO];
                    [b_self.tableView setHidden:YES];
                    [b_self.nullView setNeedTouch:NO];
                    NSString *str = @"您还没有收藏过宝贝";
                    b_self.nullView.descInfo = str;
                    b_self.nullView.icon = [UIImage imageNamed:@"myCollect"];
                    ;
                }
            }
            else
            {
                [METoast toastWithMessage:@"删除收藏失败"];
            }
        }
        else
        {
            [METoast toastWithMessage:@"删除收藏失败"];
        }
    }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.favoritesList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYFavoritesCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYFavoritesCell alloc]initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:orderStatusCellId];
        
        cell.delegate = self;
    }
    
    if (indexPath.section < [self.favoritesList count])
    {
        HYMallFavouriteItem *goods = [self.favoritesList objectAtIndex:indexPath.section];
        [cell setGoodsinfo:goods];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
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
    return 120.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.tableView.editing) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (indexPath.section < [self.favoritesList count] && tableView.editing == NO)
    {
        HYMallFavouriteItem *goods = [self.favoritesList objectAtIndex:indexPath.section];
        
        HYProductDetailViewController *vc = [[HYProductDetailViewController alloc] init];
        vc.goodsId = goods.productId;
        [self.navigationController pushViewController:vc
                                             animated:YES];
    } else if (tableView.editing == YES) {
        
        [self.deleteArr addObject:[self.favoritesList objectAtIndex:indexPath.section]];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.deleteArr removeObject:[self.favoritesList objectAtIndex:indexPath.section]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [HYUmengMobClick mineCollectionWithType:CollectionViewBtnTypeDelete];
        HYMallFavouriteItem *goods = [self.favoritesList objectAtIndex:indexPath.section];
        
        [self didDeleteFavoriteWithGoods:goods];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.tableView.editing) {
        
        //加载更多
        float scrollOffset = scrollView.contentOffset.y;
        float maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if (scrollOffset >= maximumOffset)
        {
            [self reloadMoreData];
        }
    }
}

@end
