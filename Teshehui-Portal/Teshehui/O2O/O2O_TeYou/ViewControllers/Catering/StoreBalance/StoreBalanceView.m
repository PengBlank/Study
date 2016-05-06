//
//  StoreBalanceView.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/16.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "StoreBalanceView.h"
#import "StoreBalanceTableViewCell.h"

#import "StoreBalanceInfo.h"        // 数据
#import "StoreBalanceRequest.h"     // 实体店余额页面 网络请求
#import "DefineConfig.h"            // 宏
#import "HYUserInfo.h"              // 用户信息头文件
#import "METoast.h"
#import "MJExtension.h"             // mj数据解析
#import "MJRefresh.h"               // 刷新

#import "UIColor+expanded.h"
#import "UIView+Common.h"

@interface StoreBalanceView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView           *myTableView;
@property (nonatomic, strong) UIView                *promptView; // 没数据时提示view

@property (nonatomic, copy) BalanceListViewBlock    block;
@property (nonatomic, assign) NSInteger             type; // 0是普通商家 1是桌球商家
@property (nonatomic ,strong) NSMutableArray        *sbInfoArray;
@property (nonatomic, strong) StoreBalanceRequest   *sbRequest;   // 网络请求

@end

@implementation StoreBalanceView

-(id)initWithFrame:(CGRect)frame Type:(NSInteger)type Block:(BalanceListViewBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.block = block;
        self.sbInfoArray = [NSMutableArray array];
        
        [self createTableView];
        [self loadDataWithType:type];
    }
    return self;
}
#pragma mark - 创建UI
#pragma mark -- TableView
- (void)createTableView
{
    self.myTableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // cell线
    self.myTableView.showsVerticalScrollIndicator = NO; // 垂直滚动条
    [self addSubview:self.myTableView];
    [self addRefresh];
}

#pragma mark - 刷新
-(void)addRefresh
{
    WS(weakSelf);
    self.myTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshData];
    }];
}
- (void)refreshData{
    [self loadDataWithType:self.type];
}

#pragma mark - UITableView Delegate&DataSource
// cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sbInfoArray.count;
}
// cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    StoreBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[StoreBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WS(weakSelf);
    [cell refreshUIDataWithModel:self.sbInfoArray[indexPath.row] WithBlock:^(StoreBalanceInfo *model, NSInteger buttonTag) {
        [weakSelf cellBlockWith:model Tag:buttonTag];
    }];
    
    return cell;
}
// heightForCell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 166;
}
#pragma mark - cell按钮回调
-(void)cellBlockWith:(StoreBalanceInfo *)model Tag:(NSInteger)tag
{
    if (tag == 1000)
    {// 充值按钮
        if (self.block) {
            self.block(model,self.type,prepayButtonType); // 数据、余额类型、按钮类型
        }
    }else
    {// 账单按钮
        if (self.block) {
            self.block(model,self.type,billButton); // 数据、余额类型、按钮类型
        }
    }
}

#pragma mark - 网络请求
-(void)loadDataWithType:(NSInteger)type
{
    if (type == 0) {
        [self businessBalanceData];
    }else
    {
        [self billiardsBalanceData];
    }
}
#pragma mark -- 普通商家
-(void)businessBalanceData
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.myTableView.header endRefreshing];
        return;
    }
    [HYLoadHubView show]; //
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    // 默认参数
    self.sbRequest                       = [[StoreBalanceRequest alloc] init];
    self.sbRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Member/BalanceList",BASEURL];
    self.sbRequest.interfaceType = DotNET2;
    self.sbRequest.postType      = JSON;
    self.sbRequest.httpMethod    = @"POST";
    
    self.sbRequest.UId           = userInfo.userId ? :@""; // 用户id
    
    [self.sbRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) //状态值为0 代表请求成功  其他为失败
            {
                NSArray *dictArray = objDic[@"data"];
                [weakSelf.sbInfoArray removeAllObjects];
                // 将字典数组转为模型数组
                weakSelf.sbInfoArray = [StoreBalanceInfo objectArrayWithKeyValuesArray:dictArray];
                
                if (weakSelf.sbInfoArray.count == 0) {
                    [weakSelf createPromptViewWithString:@"暂无实体店余额!"]; // 无数据提示框
                }else
                {
                    [weakSelf.promptView removeFromSuperview];
                }
                [weakSelf.myTableView reloadData]; // 刷新
                
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"无法连接服务器"];
            [weakSelf createPromptViewWithString:@"无法连接服务器"]; // 无数据提示框
        }
        [HYLoadHubView dismiss]; // load
        [weakSelf.myTableView.header endRefreshing];
    }];
}
#pragma mark -- 桌球商家
-(void)billiardsBalanceData
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.myTableView.header endRefreshing];
        return;
    }
    [HYLoadHubView show]; //??
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    // 默认参数
    self.sbRequest                       = [[StoreBalanceRequest alloc] init];
    self.sbRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/GetMerchantBalanceList",BILLIARDS_API_URL];
    self.sbRequest.interfaceType = DotNET2;
    self.sbRequest.postType      = JSON;
    self.sbRequest.httpMethod    = @"POST";
    
    self.sbRequest.UId           = userInfo.number ? :@""; // 用户id
    self.sbRequest.isBilliards   = YES;
    
    [self.sbRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) //状态值为0 代表请求成功  其他为失败
            {
                NSArray *dictArray = objDic[@"data"];
                [weakSelf.sbInfoArray removeAllObjects];
                // 将字典数组转为模型数组
                weakSelf.sbInfoArray = [StoreBalanceInfo objectArrayWithKeyValuesArray:dictArray];
                if (weakSelf.sbInfoArray.count == 0) {
                    [weakSelf createPromptViewWithString:@"暂无实体店余额!"]; // 无数据提示框
                }else
                {
                    [weakSelf.promptView removeFromSuperview];
                }
                [weakSelf.myTableView reloadData]; // 刷新
                
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"无法连接服务器"];
            [weakSelf createPromptViewWithString:@"无法连接服务器"]; // 无数据提示框
        }
        [HYLoadHubView dismiss]; // load
        
        [weakSelf.myTableView.header endRefreshing];
    }];
}
#pragma mark -- 没数据View
- (void)createPromptViewWithString:(NSString *)str
{
    CGRect viewRect = CGRectMake(0, 0, self.myTableView.frame.size.width, self.myTableView.frame.size.height);
    self.promptView = [[UIView alloc] initWithFrame:viewRect];
    self.promptView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    CGRect imageRect = CGRectMake(0, 94, 90, 90);
    UIImageView *image = [[UIImageView alloc] initWithFrame:imageRect];
    [image setCenterX:self.promptView.centerX];
    [image setClipsToBounds:YES];
    [image setImage:[UIImage imageNamed:@"not-available"]];
    [self.promptView addSubview:image];
    
    CGRect labelRect = CGRectMake(0, imageRect.origin.y+90, self.promptView.frame.size.width, 35);
    UILabel *label = [[UILabel alloc] initWithFrame:labelRect];
    [label setCenterX:self.promptView.centerX];
    [label setText:str];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.promptView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    [self.myTableView addSubview:self.promptView];

}

@end
