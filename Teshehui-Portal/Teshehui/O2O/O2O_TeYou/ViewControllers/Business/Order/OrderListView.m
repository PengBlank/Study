//
//  OrderListView.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "OrderListView.h"
#import "ConfirmOrderViewController.h"
#import "SVPullToRefresh.h"
#import "DefineConfig.h"
#import "UITableView+Common.h"
#import "UIView+Common.h"
#import "OrderAllCell.h"
#import "PrepaidCell.h"
#import "GetOrderListRequest.h"
#import "HYUserInfo.h"
#import "MJExtension.h"
@interface OrderListView ()<UITableViewDataSource,UITableViewDelegate>
{
 
//    NSInteger _currentPageIndex;
//    NSInteger _prevPageIndex;
//    NSInteger _nextPageIndex;

}
@property (nonatomic , assign) BOOL                 isNextPage;
@property (nonatomic , assign) NSInteger            type;
@property (nonatomic , assign) NSInteger            currentPageIndex;
@property (nonatomic , copy) ProjectListViewBlock   block;
@property (nonatomic , strong) UITableView          *contentTableView;
@property (nonatomic , strong) NSMutableArray       *dataSource;
@property (nonatomic , strong) GetOrderListRequest  *getOrderListRequest;

@end

@implementation OrderListView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type block:(ProjectListViewBlock)block
{
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        _block = block;
        _dataSource = @[].mutableCopy;
        _currentPageIndex = 1;
        _contentTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
            tableView.rowHeight = 178;
            [self addSubview:tableView];
            
            tableView;
        });
        
            WS(weakSelf);
            [self.contentTableView addInfiniteScrollingWithActionHandler:^{
                weakSelf.isNextPage = YES;
                [weakSelf refreshNextPageData:weakSelf.type];
            }];

        
        [self loadDataWithType:_type];
        
        if (type == 1)
        {
            // 添加通知中心 评论成功时刷新
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithOrderListCommentChanged object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCommentChanged) name:kNotificationWithOrderListCommentChanged object:nil];
        }
    }
    return self;
}

-(void) notifyCommentChanged
{
    [self loadDataWithType:_type];
}

- (void)loadDataWithType:(NSInteger)type{
    
    WS(weakSelf);
    if (kNetworkNotReachability) {
        
        DebugNSLog(@"网络异常");
        [self configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:HasError reloadButtonBlock:^(id sender) {
            [weakSelf loadDataWithType:_type];
        }];
        return;
    }
    
    
    [HYLoadHubView show];
   
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.getOrderListRequest = [[GetOrderListRequest alloc] init];
    self.getOrderListRequest.interfaceURL       = [NSString stringWithFormat:@"%@/tshorder/OrderList",ORDER_API_URL];
    self.getOrderListRequest.interfaceType      = DotNET;
    self.getOrderListRequest.httpMethod         = @"POST";
    
    self.getOrderListRequest.UserId             = userInfo.userId;                               //  用户id
    self.getOrderListRequest.PageIndex          = kDefaultPageIndexStart;
    self.getOrderListRequest.PageSize           = kDefaultPageSize;
    self.getOrderListRequest.Status             = type;
    

    [self.getOrderListRequest sendReuqest:^(id result, NSError *error)
     {
      
         NSArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他为失败
                 NSDictionary *tmpDic = objDic[@"Data"];
                 NSArray    *dataArray = tmpDic[@"Details"];
                 objArray  = [OrderInfo objectArrayWithKeyValuesArray:dataArray];

             }else{
                 
             }
         }
         
         [weakSelf updateBusinessListData:objArray error:error];
     }];

    
}



- (void)refreshNextPageData:(NSInteger)type{

    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.getOrderListRequest = [[GetOrderListRequest alloc] init];
    self.getOrderListRequest.interfaceURL       = [NSString stringWithFormat:@"%@/tshorder/OrderList",ORDER_API_URL];
    self.getOrderListRequest.interfaceType      = DotNET;
    self.getOrderListRequest.httpMethod         = @"POST";
    
    self.getOrderListRequest.UserId             = userInfo.userId;                               //  用户id
    self.getOrderListRequest.PageIndex          = self.currentPageIndex;
    self.getOrderListRequest.PageSize           = kDefaultPageSize;
    self.getOrderListRequest.Status             = type;
    
    WS(weakSelf);
    [self.getOrderListRequest sendReuqest:^(id result, NSError *error)
     {
          NSArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"Result"] intValue];
             if (code == 1) { //状态值为1 代表请求成功  其他为失败
                 NSDictionary *tmpDic = objDic[@"Data"];
                 NSArray    *dataArray = tmpDic[@"Details"];
                 objArray  = [OrderInfo objectArrayWithKeyValuesArray:dataArray];
                 
             }else{
                 
             }
         }
        [weakSelf updateBusinessListData:objArray error:error];
     }];

}

//订单列表数据绑定
- (void)updateBusinessListData:(NSArray *)objArray error:(NSError *)error{

    [self.contentTableView.infiniteScrollingView stopAnimating];
    
    if (!self.isNextPage) {
        [_dataSource removeAllObjects];
    }
    [_dataSource addObjectsFromArray:objArray];
    self.currentPageIndex += 1;
    
    if (objArray.count < kDefaultPageSize) {
        [self.contentTableView setShowsInfiniteScrolling:NO];
        
    }else{
        [self.contentTableView setShowsInfiniteScrolling:YES];
    }
    
    WS(weakSelf);
    if (!self.isNextPage) {
        [HYLoadHubView dismiss];
        [self configBlankPage:EaseBlankPageNoOrder hasData:objArray.count > 0 hasError:error reloadButtonBlock:^(id sender) {
            [weakSelf loadDataWithType:weakSelf.type];
        }];
    }
    [self.contentTableView reloadData];
}

#pragma mark - UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return g_fitFloat(@[@6,@7,@8]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.000001;
}


#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//   
//    if (_type == Project_alreadyPay) {
//        return [PrepaidCell cellHeight];
//    }else{
//        return [OrderAllCell cellHeight];
//    }
//  
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"OrderAllCell";
    static NSString *cellId2 = @"PrepaidCell";

    if (_type == Project_noPay) {
        
            OrderInfo *oInfo = _dataSource[indexPath.section];
            OrderAllCell*cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (cell == nil) {
                cell = [[OrderAllCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
    
            WS(weakSelf);
            [cell setPayAgainBlock:^(OrderInfo *oInfo) {

                oInfo.ActionType = 0;
                if (weakSelf.block) {
                    weakSelf.block(oInfo);
                }
            }];
            
            [cell bindData:oInfo];
            return cell;

       }else{
           
        PrepaidCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId2];
        if (cell == nil) {
            cell = [[PrepaidCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
           
           WS(weakSelf);
           [cell setGoCommentBlock:^(OrderInfo *oInfo) {
               
               oInfo.ActionType = 1;
               if (weakSelf.block) {
                   weakSelf.block(oInfo);
               }
           }];
        
        [cell bindData:_dataSource[indexPath.section]];
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
}


@end
