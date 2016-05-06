//
//  RefundViewController.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/11.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "RefundViewController.h"
#import "UITableView+Common.h"
#import "DefineConfig.h"
#import "RefundCell.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "Masonry.h"
#import "METoast.h"
#import "UIView+Common.h"

#import "TYCustomAlertView.h" // 提示框
#import "SceneRefundRequest.h" // 退款
#import "SceneRefundReasonRequest.h" // 退款理由

@interface RefundViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView    *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;   // 动态获取的理由
@property (nonatomic,strong) NSMutableArray *reasonArray; // 写死的理由
@property (nonatomic,strong) UIButton       *submitBtn;
@property (nonatomic,strong) NSString       *submitReason; // 退款原因
@property (nonatomic,strong) SceneRefundRequest         *sceneRefundRequest;    // 退款请求头
@property (nonatomic,strong) SceneRefundReasonRequest   *reasonRequest;         // 理由请求头

@end

@implementation RefundViewController

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45.0f;
        _tableView.backgroundColor = UIColorFromRGB(245, 245, 245);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

//- (NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [[NSMutableArray alloc] init];
//    }
//    return _dataArray;
//}

- (NSMutableArray *)reasonArray{
    if (!_reasonArray) {
        _reasonArray = [[NSMutableArray alloc] initWithObjects:
                      @"不想要了",
                      @"买多了",
                      @"买错了",
                      @"预约不到位置",
                      @"餐厅评价不好",
                      @"计划有变",nil];
    }
    
    return _reasonArray;
}

- (UIButton *)submitBtn{
    
    if (!_submitBtn) {
        
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setFrame:CGRectMake(0, kScreen_Height - kNavBarHeight - 50, kScreen_Width, 50)];
        [_submitBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [_submitBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_submitBtn];
    }
    
    return _submitBtn;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"申请退款";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitBtn];
    
    self.dataArray = [NSMutableArray array];
    [self loadDataWithReason];
    
}


#pragma mark - 提交退款
- (void)submitBtnBtnAction
{
    if (self.submitReason.length == 0) {
        [METoast toastWithMessage:@"请选择退款理由"];
        return;
    }
    // 提示框
    TYCustomAlertView *alertView = [[TYCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-g_fitFloat(@[@40,@70]), 122) WithType:Type_Default];
    [alertView setTitle:@"提示" Color:[UIColor colorWithHexString:@"343434"] Font:16];
    [alertView setMsg:@"您确定要申请退款吗？" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    [alertView setLineColor:[UIColor colorWithHexString:@"c7c7c7"]];
    [alertView setButtonTitle_Left:@"确定" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    [alertView setButtonTitle_Rigth:@"取消" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    // 按钮点击回调事件
    WS(weakSelf);
    [alertView buttonClickBlock:^(TYCAlertViewBtnTag tag) {
        if (tag == ButtonTag_OkBtn)
        {// 确认按钮
            [weakSelf refundRequest];
        }
    }];
    [alertView show];
}
#pragma mark - 网络请求
#pragma mark -- 原因
-(void)loadDataWithReason
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        return;
    }
    [HYLoadHubView show];
    
    self.reasonRequest                 = [[SceneRefundReasonRequest alloc] init];
    self.reasonRequest.interfaceURL    = [NSString stringWithFormat:@"%@/v4/Scene/GetRefundReason",BASEURL];
    self.reasonRequest.interfaceType   = DotNET2;
    self.reasonRequest.postType        = JSON;
    self.reasonRequest.httpMethod      = @"POST";
    
    [self.reasonRequest sendReuqest:^(id result, NSError *error) {
        if(result)
        {
            [weakSelf.dataArray removeAllObjects];
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0)
            {
                NSArray *objArr = objDic[@"data"];
                if (![objArr isKindOfClass:[NSNull class]] && objArr.count>0)
                {
                    for (NSDictionary *reasonDic in objArr)
                    {
                        NSString *reason = reasonDic[@"reason"];
                        [weakSelf.dataArray addObject:reason];
                    }
                }
                [weakSelf.tableView reloadData];
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
             [METoast toastWithMessage:@"服务器请求异常"];
        }
        [HYLoadHubView dismiss];
    }];
}

#pragma mark -- 退款请求
- (void)refundRequest
{
    
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        return;
    }
    [HYLoadHubView show];
    
    self.sceneRefundRequest                 = [[SceneRefundRequest alloc] init];
    self.sceneRefundRequest.interfaceURL    = [NSString stringWithFormat:@"%@/v4/TSHOrder/ApplyRebate",ORDER_API_URL];
    self.sceneRefundRequest.interfaceType   = DotNET2;
    self.sceneRefundRequest.postType        = JSON;
    self.sceneRefundRequest.httpMethod      = @"POST";
    
    self.sceneRefundRequest.o2oOrderNo      = self.o2oOrderNo;
    self.sceneRefundRequest.packageName     = self.packageName;
    self.sceneRefundRequest.reason          = self.submitReason;
    
    [self.sceneRefundRequest sendReuqest:^(id result, NSError *error) {
        
        if(result)
        {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
                if(weakSelf.refreshBlock)
                {// 退款成功 刷新上个页面数据
                    weakSelf.refreshBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else
            {
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
            }
        }else
        {
            [METoast toastWithMessage:@"服务器请求异常"];
        }
        [HYLoadHubView dismiss];
    }];
}

#pragma mark - tableview Delegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
//        return self.reasonArray.count;
        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.000001;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section != 0) {
        
        UIView *bView = [[UIView alloc] init];
        bView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 0, 200, 40)];
        [titleLabel setText:@"退款理由"];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [bView addSubview:titleLabel];
        return bView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section != 0) {
        
        UIView *bView = [[UIView alloc] init];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5, 0, kScreen_Width - 25, 130)];
        [titleLabel setNumberOfLines:0];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [titleLabel setFont:[UIFont systemFontOfSize:13]];
        NSString *text = @"温馨提示：\n1、当客服审核通过后，退款将在3-5个工作日内原路退回到您的付款账户。\n2、如果您使用了现金券，我们会在商品退款成功后，返还现金券。";
        // 更改行高
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineHeightMultiple = 1.5;
        NSDictionary *attrDic = @{NSParagraphStyleAttributeName:paraStyle};
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attrDic];
        
        [bView addSubview:titleLabel];
        return bView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"RefundCell";
    RefundCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RefundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        [cell setUserInteractionEnabled:NO];
    }else
    {
        [cell setUserInteractionEnabled:YES];
    }
    
    [cell bindData:self.bindData reasonArray:self.dataArray indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        self.submitReason = self.dataArray[indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12.5];
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:12.5 hasSectionLine:NO];
}

-(void)dealloc
{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [_sceneRefundRequest cancel];
    _sceneRefundRequest = nil;
    [_reasonRequest cancel];
    _reasonRequest = nil;
}

@end
