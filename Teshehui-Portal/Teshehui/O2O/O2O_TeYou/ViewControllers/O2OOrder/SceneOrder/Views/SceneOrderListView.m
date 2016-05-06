//
//  SceneOrderListView.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneOrderListView.h"
#import "SceneOrderListCell.h"

#import "DefineConfig.h"
#import "UIView+Common.h"
#import "MJExtension.h"         // mj数据解析
#import "METoast.h"             // 提示框
#import "UIColor+expanded.h"
#import "HYUserInfo.h"          // 用户信息头文件
//#import "SVPullToRefresh.h"     // 上啦加载
#import "MJRefresh.h" // 刷新

#import "SceneOrderListRequest.h"
#import "SceneOrderListModel.h"

@interface SceneOrderListView ()<UITableViewDataSource, UITableViewDelegate>
{
    BOOL                        _isNext;  // 加载
    NSInteger                   _type;  // 订单类型(请求时用 0全部1可使用2未付款3无效订单)
    SceneOrderListViewBlock     _block; // 回调block
    UITableView                 *_contentTableView;
    NSMutableArray              *_dataSource;   // 数据
    SceneOrderListRequest       *_SceneRequest;
    NSInteger                   _currentPageIndex;
}
@end

@implementation SceneOrderListView

- (id)initWithFrame:(CGRect)frame Type:(NSInteger)type Block:(SceneOrderListViewBlock)block
{
    if (self = [super initWithFrame:frame]) {
        
        [self createWithType:type Block:block];
    }
    return  self;
}

#pragma mark - 初始化
- (void)createWithType:(NSInteger)type Block:(SceneOrderListViewBlock)block
{
    // 创建一个通知
    NSNotificationCenter  *center = [NSNotificationCenter defaultCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kNotificationWithSceneOrderStatusChanged
                                                  object:nil];
    [center addObserver:self
               selector:@selector(refreshData)
                   name:kNotificationWithSceneOrderStatusChanged
                 object:nil];
    
    _type = type;
    _block = block;
    _dataSource = [NSMutableArray array];
    _currentPageIndex = kDefaultPageIndexStart;
    
    _contentTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _contentTableView.delegate = self;
    _contentTableView.dataSource = self;
    _contentTableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    [self addSubview:_contentTableView];
    
    [self addRefresh];
    [self loadDataWithType:type];
}

#pragma mark - 添加刷新
-(void)addRefresh
{
    WS(weakSelf);
    _contentTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                 refreshingAction:@selector(loadMoreData)];
    _contentTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
}

- (void)refreshData{
    _isNext = NO;
    _currentPageIndex = 1;
    [self loadDataWithType:_type];
}
- (void)loadMoreData{
    _isNext = YES;
    _currentPageIndex += 1;
    [self loadDataWithType:_type];
}
- (void)reset{
    //    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
    //                                                                 refreshingAction:@selector(loadMoreData)];
    [_contentTableView.footer resetNoMoreData];
}

#pragma mark - 网络请求
- (void)loadDataWithType:(NSInteger)type
{
//    NSLog(@"场景订单列表类型 %ld  类型222222%ld",type,_type);
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [_contentTableView.header endRefreshing];
        return;
    }
    [HYLoadHubView show];
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    // 参数
    _SceneRequest                   = [[SceneOrderListRequest alloc] init];
    _SceneRequest.interfaceURL      = [NSString stringWithFormat:@"%@/v4/Scene/GetSceneOrderList",BASEURL];
    _SceneRequest.interfaceType     = DotNET2;
    _SceneRequest.postType          = JSON;
    _SceneRequest.httpMethod        = @"POST";
    
    _SceneRequest.UId               = userInfo.userId?:@""; // 用户id
    _SceneRequest.type              = type; //订单类型(0全部1可使用2未付款3无效订单)
    _SceneRequest.pageIndex         = _currentPageIndex;
    _SceneRequest.pageSize          = kDefaultPageSize;
    
    [_SceneRequest sendReuqest:^(id result, NSError *error)
    {
        
        NSArray *objArray = nil;
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {
                NSMutableArray *dataArray = objDic[@"data"];
//                [SceneOrderListModel objectArrayWithKeyValuesArray:dataArray];
                objArray = [SceneOrderListModel objectArrayWithKeyValuesArray:dataArray];
            }else{
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg?:@"获取订单失败"];
            }
        }else
        {
            [METoast toastWithMessage:@"无法连接服务器"];
        }
        [weakSelf updateSceneOrderListData:objArray error:error];
    }];
    
}

//订单列表数据绑定
- (void)updateSceneOrderListData:(NSArray *)objArray error:(NSError *)error{
    
    if (!_isNext) {
        [_contentTableView.header endRefreshing];
        [_dataSource removeAllObjects];
        if (objArray.count < kDefaultPageSize) {
            _contentTableView.footer = nil;
        }
        [self reset];
    }else
    {
        if (objArray.count > 0) {
            [_contentTableView.footer endRefreshing];
        }else{
            [_contentTableView.footer endRefreshingWithNoMoreData];
        }
    }
    [_dataSource addObjectsFromArray:objArray];

    WS(weakSelf);
    if (!_isNext) {
        [self configBlankPage:EaseBlankPageNoOrder hasData:objArray.count > 0 hasError:error reloadButtonBlock:^(id sender) {
            [weakSelf loadDataWithType:_type];
        }];
    }
    [_contentTableView reloadData];
    [HYLoadHubView dismiss];
}

#pragma mark - UITableView Delegate&DataSource
// section数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}
// cell数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    SceneOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[SceneOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
#pragma mark -- cell里button的点击事件回调
    
    SceneOrderListModel *sceneModel = _dataSource[indexPath.section];
    
    [cell refreshUIWithModel:sceneModel Type:_type ButtonClickBlock:^(BOOL isButton) {
        
        if (_block) {
            _block(sceneModel,nil,YES,nil);
        }
    }];
    
    return cell;
}
// cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return g_fitFloat(@[@147,@157]);
}
// section Header高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
// section Footer高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00000001;
}
// cell点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SceneOrderListModel *sceneModel = _dataSource[indexPath.section];
    NSString *orderNum = sceneModel.o2oTradeNo;
    
    #pragma mark -- cell点击事件回调
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_block) {
        _block(nil,orderNum,NO,sceneModel.btn); // 把支付按钮传过去了
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
