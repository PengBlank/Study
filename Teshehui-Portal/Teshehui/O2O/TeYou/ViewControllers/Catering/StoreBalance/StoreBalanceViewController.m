//
//  StoreBalanceViewController.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "StoreBalanceViewController.h"
#import "StoreBalanceTableViewCell.h"
#import "PrepayViewController.h"    // 充值
#import "ConsumeViewController.h"   // 账单

#import "DefineConfig.h"            // 宏
#import "UIView+Common.h"
#import "MJExtension.h"             // mj数据解析
#import "METoast.h"                 // 提示
#import "UIColor+expanded.h"

#import "HYUserInfo.h"              // 用户信息头文件
#import "StoreBalanceRequest.h"     // 实体店余额页面 网络请求
#import "StoreBalanceInfo.h"        // 数据

@interface StoreBalanceViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIView *promptView; // 没数据时提示view

@property (nonatomic, strong) StoreBalanceRequest *sbRequest;   // 网络请求
@property (nonatomic, strong) NSMutableArray  *sbInfoArray;     // 数据

@end

@implementation StoreBalanceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadStroBalanceViewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.sbInfoArray = [NSMutableArray array];
    self.title = @"实体店余额";
    
    [self createUI];
    [self loadStroBalanceViewData];
}
// 创建UI
- (void)createUI
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    self.myTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone; // cell线
    self.myTableView.showsVerticalScrollIndicator = NO; // 垂直滚动条
    [self.view addSubview:self.myTableView];
    
}
// 没数据时提示View
- (void)createPromptView
{
    CGRect viewRect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
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
    [label setText:@"暂无实体店余额!"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:15]];
    [label setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.promptView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.promptView];
}

#pragma mark - UITableViewDataSource
// cell数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 5;
    return self.sbInfoArray.count;
}
// cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    StoreBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[StoreBalanceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addPrepayButtonTarget:self Action:@selector(preBtnClick:) Index:indexPath.row];
        [cell addBillButtonTarget:self Action:@selector(billBtnClick:) Index:indexPath.row];
    }
    
    StoreBalanceInfo *sbInfo = self.sbInfoArray[indexPath.row];
    [cell refreshUIDataWithModel:sbInfo];
    
    return cell;
}

#pragma mark - UiTableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 166;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 20);
//    UIView *view = [[UIView alloc] initWithFrame:rect];
//    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 18, 17)];
//    [image setImage:[UIImage imageNamed:@"inform"]];
//    [view addSubview:image];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, self.view.frame.size.width-27, 10)];
//    [label setFont:[UIFont systemFontOfSize:12]];
////    [label sizeToFit];
//    [label setTextColor:[UIColor colorWithHexString:@"8b8b8b"]];
//    [label setText:@" : 如商家不可充值并消费,请联系客服400-806-6528"];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [view addSubview:label];
//    
//    return view;
//}


#pragma make - 按钮点击事件
// 充值按钮
- (void)preBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    StoreBalanceInfo *sbInfo = self.sbInfoArray[index];
    
    PrepayViewController *vc = [[PrepayViewController alloc] init];
    vc.merId = sbInfo.merId; // 传入商家id
    vc.comeType = 2; // 进入路径
    
    [self.navigationController pushViewController:vc animated:YES];
}
// 账单按钮
- (void)billBtnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    StoreBalanceInfo *sbInfo = self.sbInfoArray[index];
    
    ConsumeViewController *vc = [[ConsumeViewController alloc] init];
    vc.merId = sbInfo.merId; // 传入商家id
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma makr - 网络请求
- (void)loadStroBalanceViewData
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        
        DebugNSLog(@"网络异常");
        [self.myTableView configBlankPage:EaseBlankPageTypeNoNetwork hasData:NO hasError:[[NSError alloc] init] reloadButtonBlock:^(id sender) {
            [weakSelf loadStroBalanceViewData];
        }];
        return;
    }
    [HYLoadHubView show]; //??
    
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
                
                // 将字典数组转为模型数组
                weakSelf.sbInfoArray = [StoreBalanceInfo objectArrayWithKeyValuesArray:dictArray];
                
                [weakSelf.myTableView reloadData]; // 刷新
                
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"无法连接服务器"];
            [weakSelf createPromptView]; // 无数据提示框
        }
        [HYLoadHubView dismiss]; // load
        if (weakSelf.sbInfoArray.count == 0) {
            [weakSelf createPromptView]; // 无数据提示框
        }else
        {
            [weakSelf.promptView removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
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
