//
//  HYCommentAddOneStepViewController.m
//  Teshehui
//
//  Created by HYZB on 15/10/16.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallApplyAfterSaleServiceViewController.h"
#import "HYCommentAddOneStepViewController.h"
#import "HYCommentAddOneStepCell.h"
#import "HYCommentAddOneStepReq.h"
#import "HYCommentAddOneStepResponse.h"
#import "HYLoadHubView.h"
#import "HYCommentAddSecondStepViewController.h"
#import "MJRefresh.h"

@interface HYCommentAddOneStepViewController ()
<
UITableViewDataSource,
UITableViewDelegate,HYCommentAddOneStepCellDelegate,UIScrollViewDelegate
>
{
    HYCommentAddOneStepReq *_CommentAddOneStepReq;
    
    int _pageNo;
    int _pageSize;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

// @property (nonatomic, strong) UIView *footerView;
// @property (nonatomic, strong) UIActivityIndicatorView *activityLoadView;
// @property (nonatomic, strong) UILabel *freshLabel;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL isCreatFresh;
// @property (nonatomic, assign) BOOL isfreshing;

@end

@implementation HYCommentAddOneStepViewController

-(void)dealloc
{
    [_CommentAddOneStepReq cancel];
    _CommentAddOneStepReq = nil;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发表评价";
    _pageNo = 1;
    _pageSize = 20;
    _isCreatFresh = NO;
   // _isfreshing = NO;
    
    [self getListData];
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
    tableview.rowHeight = TFScalePoint(130);
    [tableview registerClass:[HYCommentAddOneStepCell class] forCellReuseIdentifier:@"HYCommentAddOneStepCell"];
    
    [self.view addSubview:tableview];
    self.tableView = tableview;
    
   // [self creatFooterView];
}

#pragma mark - ----上拉加载----
- (void)creatRefresh
{

    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
            _pageNo ++;
            [self getListData];
        
    }];
    _isCreatFresh = YES;
}

//#pragma mark - FooterView
//- (void)creatFooterView
//{
//    // 上拉加载footerView
//    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//   // _footerView.backgroundColor = [UIColor grayColor];
//    self.tableView.tableFooterView = _footerView;
//    
//    _activityLoadView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(TFScalePoint(110), 10, 20, 20)];
//    _activityLoadView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
//    [_footerView addSubview:_activityLoadView];
//    
//    _freshLabel = [[UILabel alloc] initWithFrame:CGRectMake(TFScalePoint(140), 10, 80, 20)];
//    _freshLabel.font = [UIFont systemFontOfSize:13];
//    [_footerView addSubview:_freshLabel];
//}
//
//- (void)finishLoading{
//    [self.activityLoadView stopAnimating];
//    self.freshLabel.text = @"";
//    self.isfreshing = NO;
//    [self.tableView reloadData];
//}
//
//#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (self.totalCount > 20*_pageNo) {
//        
//        if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
//            if (self.isfreshing) {
//                return;
//            }
//            
//            self.isfreshing = YES;
//            
//            self.freshLabel.text = @"正在加载...";
//            [self.activityLoadView startAnimating];
//            _pageNo ++;
//            [self getListData];
//        }
//    }
//    
//}

#pragma mark tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"HYCommentAddOneStepCell";
    HYCommentAddOneStepCell *cell = [_tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.row < self.dataList.count)
    {
        HYCommentAddOneStepModel *model = _dataList[indexPath.row];
        [cell setGoodsInfo:model];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

#pragma mark private methods
- (void)getListData
{
    
    if (!_CommentAddOneStepReq)
    {
        _CommentAddOneStepReq = [[HYCommentAddOneStepReq alloc]init];
    }
    [_CommentAddOneStepReq cancel];
    
    _CommentAddOneStepReq.pageNo = [NSString stringWithFormat:@"%d",_pageNo];
    _CommentAddOneStepReq.pageSize = [NSString stringWithFormat:@"%d",_pageSize];
    _CommentAddOneStepReq.orderCode = self.orderCode;
    
    [HYLoadHubView show];
    __weak typeof(self) weakSelf = self;
    [_CommentAddOneStepReq sendReuqest:^(HYCommentAddOneStepResponse *result, NSError *error) {
        [HYLoadHubView dismiss];
        
      //  weakSelf.dataList = [result.dataList mutableCopy];
        [weakSelf.dataList addObjectsFromArray:result.dataList];
        
        weakSelf.totalCount = result.totalCount;
        [weakSelf updateViewWithData:weakSelf.dataList];
        
    }];
    
}

- (void)updateViewWithData:(NSArray *)data
{
    [_tableView reloadData];
   // [self finishLoading];
    if (self.totalCount > 20 && _isCreatFresh == NO) {
        [self creatRefresh];
    }
    [self.tableView.footer endRefreshing];
    
}

#pragma mark HYApplyAfterSaleListCell
- (void)didSendCommentWithModel:(HYCommentAddOneStepModel *)model
{
    HYCommentAddSecondStepViewController *vc = [[HYCommentAddSecondStepViewController alloc] init];
    vc.infoModel = model;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark getter and setter
- (NSMutableArray *)dataList
{
    if (!_dataList)
    {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

@end