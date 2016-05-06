//
//  BilliardsOrderListView.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardsOrderListView.h"
#import "BilliardsOrderCell.h"
#import "BilliardsOrderListRequest.h"
#import "SVPullToRefresh.h"
#import "DefineConfig.h"
#import "UITableView+Common.h"
#import "UIView+Common.h"
#import "HYUserInfo.h"
#import "MJExtension.h"
#import "DefineConfig.h"
//#import "TravelQRView.h"
#import "NSString+Addition.h"
#import "METoast.h"
#import "UIColor+expanded.h"
#import "Masonry.h"
#import "UIUtils.h"
@interface BilliardsOrderListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong ) BilliardsOrderListRequest *orderListRequest;
@property (nonatomic ,assign) BOOL                 isNextPage;
@property (nonatomic ,assign) NSInteger            type;
@property (nonatomic ,assign) NSInteger            currentPageIndex;
@property (nonatomic ,copy  ) ProjectListViewBlock block;
@property (nonatomic ,strong) UITableView          *contentTableView;
@property (nonatomic ,strong) NSMutableArray       *dataSource;

@end

@implementation BilliardsOrderListView

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
            [self addSubview:tableView];
            
            tableView;
        });
        
        WS(weakSelf);
        [self.contentTableView addInfiniteScrollingWithActionHandler:^{
            weakSelf.isNextPage = YES;
            [weakSelf refreshNextPageData:weakSelf.type];
        }];
        [self.contentTableView setShowsInfiniteScrolling:NO];
        
        
       [self loadDataWithType:_type];
        
        if (type == 0) {
             [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsCloseTable object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDataChanged) name:kNotificationWithBilliardsCloseTable object:nil];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsOrderListChanged object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDataChanged) name:kNotificationWithBilliardsOrderListChanged object:nil];
        }else{
            // 添加通知中心 评论成功时刷新
            [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsOrderCommentChanged object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDataChanged) name:kNotificationWithBilliardsOrderCommentChanged object:nil];
        }
        

    }
    return self;
}

- (void)notificationDataChanged{
     [self loadDataWithType:_type];
}

//- (void)refreshOrderData{
//    
//    [self loadDataWithType:_type];
////    [_contentTableView reloadData];
////     DebugNSLog(@"刷新了数据");
//}
//
//- (void)notifyCommentChanged{
//     [self loadDataWithType:_type];
//}

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
    
    self.orderListRequest               = [[BilliardsOrderListRequest alloc] init];
    self.orderListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetOrderList",BILLIARDS_API_URL];
    self.orderListRequest.interfaceType = DotNET2;
    self.orderListRequest.postType      = JSON;
    self.orderListRequest.httpMethod    = @"POST";

    self.orderListRequest.UId           = userInfo.userId;//  用户id
    self.orderListRequest.pageIndex     = kDefaultPageIndexStart;
    self.orderListRequest.pageSize      = kDefaultPageSize;
    self.orderListRequest.Status        = type;

    [self.orderListRequest sendReuqest:^(id result, NSError *error)
     {
         
         NSArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 
                 NSMutableArray   *dataArray = objDic[@"data"];
                 [BilliardsOrderInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"DiscountList" : @"DiscountInfo"};
                 }];
                 objArray  = [BilliardsOrderInfo objectArrayWithKeyValuesArray:dataArray];
                 
             }else{
                 NSString *msg = objDic[@"msg"];
                 [ METoast toastWithMessage:msg ? : @"获取订单失败"];
             }
         }else{
             [METoast toastWithMessage:@"服务器请求异常"];
         }
         
         [weakSelf updateBusinessListData:objArray error:error];
     }];
    
}

- (void)refreshNextPageData:(NSInteger)type{
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    self.orderListRequest               = [[BilliardsOrderListRequest alloc] init];
    self.orderListRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetOrderList",BILLIARDS_API_URL];
    self.orderListRequest.interfaceType = DotNET2;
    self.orderListRequest.postType      = JSON;
    self.orderListRequest.httpMethod    = @"POST";

    self.orderListRequest.UId           = userInfo.userId;//  用户id
    self.orderListRequest.pageIndex     = self.currentPageIndex;
    self.orderListRequest.pageSize      = kDefaultPageSize;
    self.orderListRequest.Status        = type;
    
    WS(weakSelf);
    [self.orderListRequest sendReuqest:^(id result, NSError *error)
     {
         NSArray *objArray = nil;
         if(result){
             NSDictionary *objDic = [result jsonDic];
             
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0 代表请求成功  其他为失败
                 
                 NSMutableArray   *dataArray = objDic[@"data"];
                 [BilliardsOrderInfo setupObjectClassInArray:^NSDictionary *{
                     return @{@"DiscountList" : @"DiscountInfo"};
                 }];
                 objArray  = [BilliardsOrderInfo objectArrayWithKeyValuesArray:dataArray];
                
             }else{
                 NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg ? : @"获取订单失败"];
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

//'    if (_type == 0) {
        return 0.000001;
//    }
//    
//    return 48;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    
//    if (_type == 1) {
//        
//        UIView *aView = [[UIView alloc] init];
//        aView.backgroundColor = [UIColor whiteColor];
//        
//        [UIUtils addLineInView:aView top:YES leftMargin:12.5 rightMargin:0];
//        [UIUtils addLineInView:aView top:NO leftMargin:0 rightMargin:0];
//        
//        BilliardsOrderInfo *tmpOInfo = _dataSource[section];
//        
//        UIButton *commnetButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        commnetButton.tag = section;
//        [commnetButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
//        [commnetButton setTitle:tmpOInfo.isComment == 0 ? @"去评价" : @"已评价" forState:UIControlStateNormal];
//        [commnetButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
//        [commnetButton addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [commnetButton.layer setCornerRadius:5];
//        [commnetButton.layer setBorderWidth:0.8f];
//        [commnetButton.layer setBorderColor:[UIColor colorWithHexString:@"606060"].CGColor];
//        [aView addSubview:commnetButton];
//        
//        [commnetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(commnetButton.superview.mas_centerY);
//            make.right.mas_equalTo(commnetButton.superview.mas_right).offset(-12.5);
//            make.size.mas_equalTo(CGSizeMake(60, 28));
//        }];
//        
//        return aView;
//    }
//    
//    return nil;
//}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (_type == 0) {
          return g_fitFloat(@[@(173),@(190),@(195)]);
//    }else{
//        return g_fitFloat(@[@(130),@(190),@(153)]);
//    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId = @"BilliardsOrderCell";

    BilliardsOrderCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell                    = [[BilliardsOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        if (_type == 0) {
            cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        }
    }
    WS(weakSelf);
    [cell setBuyBtnClickBlock:^(BilliardsOrderInfo *orderInfo) {
        orderInfo.actionType = 0; //购买酒水
        if (weakSelf.block) {
            weakSelf.block(orderInfo);
        }
    }];
    
    [cell setPayBtnClickBlock:^(BilliardsOrderInfo *orderInfo) {
        orderInfo.actionType = 1; //去付款
        if (weakSelf.block) {
            weakSelf.block(orderInfo);
        }
    }];
    
    [cell setCommentBtnClickBlock:^(BilliardsOrderInfo *orderInfo){
        orderInfo.actionType = 3;//去评论
        if (self.block) {
            weakSelf.block(orderInfo);
        }
    }];
    
    [cell bindData:_dataSource[indexPath.section] type:_type];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_type == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        BilliardsOrderInfo *tmpOInfo = _dataSource[indexPath.section];
        tmpOInfo.actionType = 2; //订单详情
        WS(weakSelf);
        if (self.block) {
            weakSelf.block(tmpOInfo);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:kPaddingLeftWidth];
}

- (void)commentBtnClick:(UIButton *)btn{
    
    WS(weakSelf);
    BilliardsOrderInfo *tmpOInfo = _dataSource[btn.tag];
    tmpOInfo.actionType = 3;
    if (self.block) {
        weakSelf.block(tmpOInfo);
    }
    
}

@end
