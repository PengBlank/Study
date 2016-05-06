//
//  HYMyDesirePoolViewController.m
//  Teshehui
//
//  Created by Kris on 15/11/6.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyDesirePoolViewController.h"
#import "HYTableViewFooterView.h"
#import "MJRefresh.h"
#import "UIImage+Addition.h"
#import "HYMyDesireDetailViewController.h"
#import "HYMakeWishPoolViewController.h"
#import "HYMyDesirePoolModel.h"
#import "HYMyDesirePoolRequest.h"
#import "HYMyDesirePoolResponse.h"
#import "HYUserInfo.h"
#import "HYMyDesireCell.h"
#import "HYMyDesireDeleteRequest.h"
#import "HYLoadHubView.h"
#import "HYDeleteResultShowView.h"

#import "HYUmengMobClick.h"

#define kMyDesireCellID @"MyDesireCellID"

@interface HYMyDesirePoolViewController ()
<UITableViewDataSource,
UITableViewDelegate,
HYMyDesireCellDelegate,
UIAlertViewDelegate,
UIScrollViewDelegate
>
{
    NSInteger _pageNo;
    NSString *_pageSize;
    
    BOOL _hasMore;
    
    HYMyDesirePoolRequest *_desirePollReq;
    HYMyDesireDeleteRequest *_desireDeleteReq;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *deleteReturnMessage;
@property (nonatomic, strong) UIButton *goToMakeWishBtn;
@property (nonatomic, strong) UIView *noDataView;

@property (nonatomic, assign) BOOL isLoading;


@end

@implementation HYMyDesirePoolViewController

- (void)dealloc 
{
    [_desirePollReq cancel];
    _desirePollReq = nil;
    
    [_desireDeleteReq cancel];
    _desireDeleteReq = nil;
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"帮我买";
    
    
    _pageSize = @"20";
    _isLoading = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    _pageNo = 1;
    [self loadOrderData];
}

- (void)loadOrderData
{
    
    if (!_desirePollReq) {
        _desirePollReq = [[HYMyDesirePoolRequest alloc] init];
    }
    
    _desirePollReq.userId = [HYUserInfo getUserInfo].userId;
   // _desirePollReq.status = @"0";
    _desirePollReq.pageNo = [NSString stringWithFormat:@"%ld", _pageNo];
    _desirePollReq.pageSize = _pageSize;
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_desirePollReq sendReuqest:^(id result, NSError *error)
    {
        
        [HYLoadHubView dismiss];
        HYMyDesirePoolResponse *response = (HYMyDesirePoolResponse *)result;
        [weakSelf.dataList removeAllObjects];
        [weakSelf.dataList addObjectsFromArray:response.dataList];
        
        if (weakSelf.dataList.count) {
            
            if (!weakSelf.goToMakeWishBtn) {
                
                [weakSelf createGoToMakeWishBtn];
            }
            weakSelf.goToMakeWishBtn.hidden = NO;
            weakSelf.noDataView.hidden = YES;
            
            if (!weakSelf.tableView) {
                
                [weakSelf createTableView];
            }
            weakSelf.tableView.hidden = NO;
            
            if (weakSelf.dataList.count == 20) {
                
                if (!weakSelf.tableView.footer) {
                    
                    weakSelf.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(myDesirePoolLoadMoreData)];
                }
            }
        } else {
            
            if (!weakSelf.noDataView) {
                
                [weakSelf createShowImageViewWhenNoData];
            }
            
            weakSelf.goToMakeWishBtn.hidden = YES;
            weakSelf.noDataView.hidden = NO;
            weakSelf.tableView.hidden = YES;
        }
        [weakSelf.tableView reloadData];
    }];
    
}

- (void)myDesirePoolLoadMoreData
{

    if (!_isLoading) {
        [self loadDesirePoolLoadMoreData];
    }
    
}

- (void)loadDesirePoolLoadMoreData {
    
    _isLoading = YES;
    _pageNo++;
    
    if (!_desirePollReq) {
        _desirePollReq = [[HYMyDesirePoolRequest alloc] init];
    }
    
    _desirePollReq.userId = [HYUserInfo getUserInfo].userId;
    _desirePollReq.pageNo = [NSString stringWithFormat:@"%ld", _pageNo];
    _desirePollReq.pageSize = _pageSize;
    [HYLoadHubView show];
    
    __weak typeof(self) weakSelf = self;
    [_desirePollReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        [weakSelf.tableView.footer endRefreshing];
        HYMyDesirePoolResponse *response = (HYMyDesirePoolResponse *)result;
        
        if (response.dataList.count < 20) {
            weakSelf.tableView.footer.hidden = YES;
        } else {
            weakSelf.tableView.footer.hidden = NO;
        }
        
        [weakSelf.dataList addObjectsFromArray:response.dataList];
        [weakSelf.tableView reloadData];
        _isLoading = NO;
    }];
}

- (void)createTableView
{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    _tableView = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HYMyDesireCell" bundle:nil] forCellReuseIdentifier:kMyDesireCellID];
}

#pragma mark - 添加按钮
- (void)createGoToMakeWishBtn
{
    _goToMakeWishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goToMakeWishBtn setTitleColor:[UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0] forState:UIControlStateNormal];
    _goToMakeWishBtn.frame = CGRectMake(0, 0, 60, 20);
    [_goToMakeWishBtn setTitle:@"添加" forState:UIControlStateNormal];
    [_goToMakeWishBtn addTarget:self action:@selector(goToMakeWishBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *goToMakeWishItem = [[UIBarButtonItem alloc] initWithCustomView:_goToMakeWishBtn];
    self.navigationItem.rightBarButtonItem = goToMakeWishItem;
}

#pragma mark - 无数据显示界面图片
- (void)createShowImageViewWhenNoData
{

    _noDataView = [[UIView alloc] initWithFrame:self.view.bounds];
    _noDataView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_noDataView];
    
    UIImageView *makeWishImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(100), 0, TFScalePoint(120), 280)];
    makeWishImageView.image = [UIImage imageWithNamedAutoLayout:@"icon_xuyuan"];
    [_noDataView addSubview:makeWishImageView];
    
    UILabel *descLab = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(35), 290, TFScalePoint(250), 60)];
    descLab.numberOfLines = 2;
    NSString *str = @"你有啥想买的东西,快去添加吧~特奢汇小秘书将竭诚为您服务哦!";
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8];
    NSDictionary *attrD = @{NSParagraphStyleAttributeName:style};
    descLab.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attrD];
    descLab.textColor = [UIColor colorWithRed:100/255.0f green:100/255.0f blue:100/255.0f alpha:1.0];
    [_noDataView addSubview:descLab];
    
    UIButton *makeWishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    makeWishBtn.frame = CGRectMake(TFScalePoint(35), 360, TFScalePoint(250), 50);
//    [makeWishBtn setBackgroundImage:[[UIImage imageWithNamedAutoLayout:@"makeWishBtn"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)] forState:UIControlStateNormal];
    makeWishBtn.backgroundColor = [UIColor colorWithRed:246/255.0f green:61/255.0f blue:81/255.0f alpha:1.0f];
    [makeWishBtn setTitle:@"添加" forState:UIControlStateNormal];
//    [makeWishBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [makeWishBtn addTarget:self action:@selector(goToMakeWishBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_noDataView addSubview:makeWishBtn];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYMyDesireCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyDesireCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HYMyDesirePoolModel *model = self.dataList[indexPath.row];
    [cell setCellInfoWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 185;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HYMyDesireDetailViewController *vc = [[HYMyDesireDetailViewController alloc]init];
    HYMyDesirePoolModel *model = self.dataList[indexPath.row];
    vc.desireId = model.d_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - HYMyDesireCellDelegate
- (void)sendDeleteInfo:(NSInteger)deleteId
{
    if (!_desireDeleteReq) {
        _desireDeleteReq = [[HYMyDesireDeleteRequest alloc] init];
    }
    
    _desireDeleteReq.delete_id = deleteId;
    _desireDeleteReq.userId = [HYUserInfo getUserInfo].userId;
    
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [_desireDeleteReq sendReuqest:^(id result, NSError *error) {
        
        [HYLoadHubView dismiss];
        CQBaseResponse *response = (CQBaseResponse *)result;
        weakSelf.deleteReturnMessage = response.jsonDic[@"message"];
        
        if ([weakSelf.deleteReturnMessage isEqualToString:@"Success!"]) {
//            UIAlertView *deleterAlert = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [deleterAlert show];
            
            HYDeleteResultShowView *deleteView = [[HYDeleteResultShowView alloc] init];
            [deleteView setDescLabInfo:@"删除成功"];
            [self.view addSubview:deleteView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [deleteView removeFromSuperview];
            });
        } else {
//            UIAlertView *deleterAlert = [[UIAlertView alloc] initWithTitle:nil message:@"删除失败" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [deleterAlert show];
            
            HYDeleteResultShowView *deleteView = [[HYDeleteResultShowView alloc] init];
            [deleteView setDescLabInfo:@"删除失败"];
            [self.view addSubview:deleteView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [deleteView removeFromSuperview];
            });
        }
        [self loadOrderData];
    }];
    
}

//#pragma mark - UIAlertViewDelegate
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0) {
//        
//        if ([self.deleteReturnMessage isEqualToString:@"Success!"]) {
//            
//            [self loadOrderData];
//        } else {
//            
//        }
//    }
//}

#pragma mark - 懒加载
- (NSMutableArray *)dataList
{
    
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - 去许愿点击事件
- (void)goToMakeWishBtnDidClicked:(UIButton *)btn
{
    [HYUmengMobClick mineWishWithBtnType:WishViewBtnTypeGoToMakeWish];
    HYMakeWishPoolViewController *makeWishPoolVC = [[HYMakeWishPoolViewController alloc] init];
    [self.navigationController pushViewController:makeWishPoolVC animated:YES];
}

@end
