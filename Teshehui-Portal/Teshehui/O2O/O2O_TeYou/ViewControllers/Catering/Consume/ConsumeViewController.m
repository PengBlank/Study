//
//  ConsumeViewController.m
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "ConsumeViewController.h"
#import "ConsumeCell.h"

#import "DefineConfig.h"        // 宏
#import "UIView+Common.h"
#import "MJExtension.h"         // mj数据解析
#import "METoast.h"             // 提示框
#import "UIColor+expanded.h"
#import "MJRefresh.h"               // 刷新

#import "HYUserInfo.h"          // 用户信息头文件
#import "ConsumeRequest.h"      // 网络请求
#import "ConsumeInfo.h"         // model

@interface ConsumeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) ConsumeRequest *consumeRequest;
@property (nonatomic, strong) NSMutableArray  *consumeInfoArray;     // 数据

@end

@implementation ConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.consumeInfoArray = [NSMutableArray array];
    self.title = @"账单";
    
    [self createUI];
    [self loadDataWithType:self.type];
}

- (void)createUI
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.myTableView  = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 分割线
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview: self.myTableView];
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

#pragma mark - UITableViewDataSource
// cell数量
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
// section数量
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
//    return 10;
    return self.consumeInfoArray.count;
}
// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    ConsumeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[ConsumeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    ConsumeInfo *cInfo = self.consumeInfoArray[indexPath.section];
    [cell refreshUIDataWithModel:cInfo];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.00001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    [view setBackgroundColor:[UIColor colorWithHexString:@"f1f1f1"]];
    return view;
}

#pragma mark - 网络请求
-(void)loadDataWithType:(NSInteger)type
{
    if (type == 0)
    {//0为普通商家
        [self loadBusinessData];
    }else
    {//1为桌球商家
        [self loadbilliardsData];
    }
}
#pragma mark -- 普通商家网络
- (void)loadBusinessData
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.myTableView.header endRefreshing];
        return;
    }
    [HYLoadHubView show]; 
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    // 默认参数
    self.consumeRequest                  = [[ConsumeRequest alloc] init];
    self.consumeRequest.interfaceURL  = [NSString stringWithFormat:@"%@/v4/Member/ConsumeList",BASEURL];
    self.consumeRequest.interfaceType = DotNET2;
    self.consumeRequest.postType      = JSON;
    self.consumeRequest.httpMethod    = @"POST";
    
    self.consumeRequest.UId           = userInfo.userId;
    self.consumeRequest.merId         = self.merId ? :@"";
    self.consumeRequest.mobile        = userInfo.mobilePhone; // 手机号
    
    [self.consumeRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) //状态值为0 代表请求成功  其他为失败
            {
                NSArray *dictArray = objDic[@"data"];
                
                weakSelf.consumeInfoArray = [ConsumeInfo objectArrayWithKeyValuesArray:dictArray];
                [weakSelf.myTableView reloadData];
                
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"服务器请求异常"];
        }
        [HYLoadHubView dismiss]; // load
        [weakSelf.myTableView.header endRefreshing];
    }];

}

#pragma mark -- 桌球网络
-(void)loadbilliardsData
{
    
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        [self.myTableView.header endRefreshing];
        return;
    }
    [HYLoadHubView show];
    
    HYUserInfo *userInfo = [HYUserInfo getUserInfo];
    
    // 默认参数
    self.consumeRequest                  = [[ConsumeRequest alloc] init];
    self.consumeRequest.interfaceURL  = [NSString stringWithFormat:@"%@/Share/ConsumeList",BILLIARDS_API_URL];
    self.consumeRequest.interfaceType = DotNET2;
    self.consumeRequest.postType      = JSON;
    self.consumeRequest.httpMethod    = @"POST";
    
    self.consumeRequest.isBilliards   = YES; // 桌球的
    
    self.consumeRequest.UId           = userInfo.userId;
    self.consumeRequest.merId         = self.merId ? :@"";
    self.consumeRequest.mobile        = userInfo.mobilePhone; // 手机号
    
    [self.consumeRequest sendReuqest:^(id result, NSError *error) {
        
        if (result) {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) //状态值为0 代表请求成功  其他为失败
            {
                NSArray *dictArray = objDic[@"data"];
                
                weakSelf.consumeInfoArray = [ConsumeInfo objectArrayWithKeyValuesArray:dictArray];
                [weakSelf.myTableView reloadData];
                
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"服务器请求异常"];
        }
        [HYLoadHubView dismiss]; // load
        [weakSelf.myTableView.header endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_consumeRequest cancel];
    _consumeRequest = nil;
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
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