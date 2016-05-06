//
//  SceneOrderDetailViewController.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneOrderDetailViewController.h"
#import "SceneOrderDetailListView.h"
#import "SceneOrderDetailRequest.h"
#import "SceneOrderDetailModel.h"

#import "UIColor+expanded.h"
#import "DefineConfig.h"
#import "UIView+Common.h"
#import "MJExtension.h"         // mj数据解析
#import "METoast.h"             // 提示框
#import "HYUserInfo.h"          // 用户信息头文件

#import "RefundViewController.h"        // 退款页面
#import "SceneConsumDetailController.h" // 套餐详情
#import "HYHotelMapViewController.h"    // 地图
#import "TYCustomAlertView.h"           // 提示框
#import "SceneCancelOrderRequest.h"     // 取消订单
#import "HYLocationManager.h"           // 定位用

@interface SceneOrderDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic, strong)   SceneOrderDetailRequest *sceneOrderDetailRequest;
@property (nonatomic, strong)   SceneOrderDetailModel   *sceneOrderDetailModel; // 数据模型
@property (nonatomic, strong)   SceneCancelOrderRequest *cancelOrderRequest;    // 取消订单
@property (nonatomic, strong)   NSString *cityName;
@property (nonatomic, strong)   UIScrollView *myScrollView;

@end

@implementation SceneOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self loadDataWithOrderNum:self.orderNum];
    
    /**获取定位信息**/
    [[HYLocationManager sharedManager] getCacheAddressInfo:^(HYLocateState state, HYLocateResultInfo *result){
        WS(weakSelf);
        if (state == HYLocateSuccess){
            weakSelf.cityName = result.city;
        }else{
            weakSelf.cityName = @"";
        }
    }];
    
}

#pragma mark - 网络请求
#pragma mark -- 获取数据
-(void)loadDataWithOrderNum:(NSString *)orderNum
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        return;
    }
    [HYLoadHubView show];
    
    _sceneOrderDetailRequest                = [[SceneOrderDetailRequest alloc] init];
    _sceneOrderDetailRequest.interfaceURL   = [NSString stringWithFormat:@"%@/v4/Scene/GetSceneOrderDetail",BASEURL];
    _sceneOrderDetailRequest.interfaceType  = DotNET2;
    _sceneOrderDetailRequest.postType       = JSON;
    _sceneOrderDetailRequest.httpMethod     = @"POST";
    
    _sceneOrderDetailRequest.orderNum       = orderNum;
    
    [_sceneOrderDetailRequest sendReuqest:^(id result, NSError *error) {
        
        NSDictionary *dataSource = nil;
        if(result)
        {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {
                dataSource = objDic[@"data"];
                
            }else{
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg?:@"获取订单失败"];
            }
        }else
        {
            [METoast toastWithMessage:@"服务器请求异常"];
        }
        [weakSelf createUIViewWithModel:dataSource Error:error];
    }];
}
#pragma mark -- 取消订单请求
-(void)cancelTheOrderRequest
{
    WS(weakSelf);
    if (kNetworkNotReachability) {
        [METoast toastWithMessage:@"网络出错，请稍后重试"];
        return;
    }
    
    [self.payButton setTitle:@"取消中" forState:UIControlStateNormal];
    [HYLoadHubView show];
    
    self.cancelOrderRequest                 = [[SceneCancelOrderRequest alloc] init];
    self.cancelOrderRequest.interfaceURL    = [NSString stringWithFormat:@"%@/v4/TSHOrder/CancelOrder",ORDER_API_URL];
    self.cancelOrderRequest.interfaceType   = DotNET2;
    self.cancelOrderRequest.postType        = JSON;
    self.cancelOrderRequest.httpMethod      = @"POST";
    
    self.cancelOrderRequest.o2oOrderNo      = self.sceneOrderDetailModel.o2oTradeNo;
    self.cancelOrderRequest.packageName     = self.sceneOrderDetailModel.packageName;
    
    [self.cancelOrderRequest sendReuqest:^(id result, NSError *error) {
        if(result)
        {
            NSDictionary *objDic = [result jsonDic];
            int code = [objDic[@"code"] intValue];
            if (code == 0) {
                // 取消成功
                NSString *msg = objDic[@"msg"];
                [METoast toastWithMessage:msg];
                // 需要刷新 通知
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithSceneOrderStatusChanged object:nil];
                [weakSelf loadDataWithOrderNum:weakSelf.orderNum]; // 刷新数据
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

#pragma mark - 创建UIVIew
-(void)createUIViewWithModel:(NSDictionary *)dataDic Error:(NSError *)error
{
    WS(weakSelf);
    [HYLoadHubView dismiss];
    self.sceneOrderDetailModel = [SceneOrderDetailModel objectWithKeyValues:dataDic];
    
    NSArray *arr = @[];
    
    if(![dataDic isKindOfClass:[NSNull class]] && dataDic != nil)
    {
        arr = [dataDic allKeys];
    }
    [self.view configBlankPage:EaseBlankPageNoOrder hasData:arr.count > 0 hasError:error reloadButtonBlock:^(id sender) {
        [weakSelf loadDataWithOrderNum:weakSelf.orderNum];
    }];
    
    // 有数据就才创建
    if (arr.count >0) {
        if (self.myScrollView) {
            // 申请退款回来后 会有两个scrollView覆盖
            [self.myScrollView removeFromSuperview];
        }
        self.myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.myScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 667-68-49);
        self.myScrollView.showsHorizontalScrollIndicator = NO;
        self.myScrollView.showsVerticalScrollIndicator = NO;
        self.myScrollView.bounces = YES;
        [self.view addSubview:self.myScrollView];
        
        NSInteger status = [self.sceneOrderDetailModel.status integerValue];
        
        SceneOrderDetailListView *view = [[SceneOrderDetailListView alloc] initWithFrame:self.myScrollView.frame WithStatus:status Block:^(NSInteger type) {

            switch (type)
            {//1000第一个view进入套餐详情 1001取消订单的那个按钮 1002电话 1003地址
                case 1000:
                {// 套餐详情
                    [weakSelf packageDetails];
                }
                    break;
                case 1001:
                {// 取消订单
                    [weakSelf cancelTheOrder];
                }
                    break;
                case 1011:
                {// 退款
                    [weakSelf refund];
                }
                    break;
                case 1002:
                {// 电话
                    [weakSelf phone];
                }
                    break;
                case 1003:
                {// 地图
                    [weakSelf pushTheMapView];
                }
                    break;
                    
                default:
                    break;
            }
        }];
        
        [view refreshUIWithModel:self.sceneOrderDetailModel]; // 刷新数据
        
        [self.myScrollView addSubview:view];
    }
    
}

#pragma mark - 点击事件
#pragma mark -- 套餐详情
-(void)packageDetails
{
    if (self.sceneOrderDetailModel.packId == nil)
    {// 没有
        [METoast toastWithMessage:@"无套餐详情"];
        return;
    }
    SceneConsumDetailController *sceneDetailController = [[SceneConsumDetailController alloc]init];
    sceneDetailController.packId = self.sceneOrderDetailModel.packId;
    sceneDetailController.cityName = self.cityName; // 城市
    
    [self.navigationController pushViewController:sceneDetailController animated:YES];
}
#pragma mark -- 取消订单
-(void)cancelTheOrder
{
    // 提示框
    TYCustomAlertView *alertView = [[TYCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-g_fitFloat(@[@40,@70]), 122) WithType:Type_Default];
    [alertView setTitle:@"提示" Color:[UIColor colorWithHexString:@"343434"] Font:16];
    [alertView setMsg:@"您确定要取消订单吗？" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    [alertView setLineColor:[UIColor colorWithHexString:@"c7c7c7"]];
    [alertView setButtonTitle_Left:@"确定" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    [alertView setButtonTitle_Rigth:@"取消" Color:[UIColor colorWithHexString:@"343434"] Font:14];
    // 按钮点击回调事件
    [alertView buttonClickBlock:^(TYCAlertViewBtnTag tag) {
        if (tag == ButtonTag_OkBtn)
        {// 确认按钮
            WS(weakSelf);
            [weakSelf cancelTheOrderRequest];
        }
    }];
    [alertView show];
}


#pragma mark -- 退款
-(void)refund
{
    /** 套餐名称，数量，金额＋现金券*/
    NSString *name = self.sceneOrderDetailModel.packageName;
    NSString *count = [NSString stringWithFormat:@"%@份",self.sceneOrderDetailModel.packageCount];
    NSString *des = [NSString stringWithFormat:@"¥%@+%@现金券",self.sceneOrderDetailModel.amount,self.sceneOrderDetailModel.coupon];
    NSArray *arr = @[name, count, des];
    
    RefundViewController *vc = [[RefundViewController alloc] init];
    vc.bindData = arr;
    vc.o2oOrderNo = self.sceneOrderDetailModel.o2oTradeNo;
    vc.packageName = self.sceneOrderDetailModel.packageName;
    vc.refreshBlock = ^(){
        [self loadDataWithOrderNum:self.orderNum]; // 退款成功返回来 刷新数据
        // 发送通知 刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithSceneOrderStatusChanged object:nil];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- 电话
-(void)phone
{
    if (self.sceneOrderDetailModel.merchantMobile.length == 0) {
        [METoast toastWithMessage:@"暂时无法联系商家"];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"拨打电话"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:self.sceneOrderDetailModel.merchantMobile otherButtonTitles:nil, nil];
    [sheet showInView:self.view];
}
// actionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSString *s = [actionSheet buttonTitleAtIndex:buttonIndex];;
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",s];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

#pragma mark -- 地图
-(void)pushTheMapView
{
    CGFloat longitude = self.sceneOrderDetailModel.longitude;
    CGFloat latitude = self.sceneOrderDetailModel.latitude;
    NSString *merchantname = self.sceneOrderDetailModel.merchantName; // 商家名
    if(longitude == 0 && latitude == 0)
    {
        [METoast toastWithMessage:@"该商户没有录入地理信息，无法定位"];
        return;
    }else
    {
        HYHotelMapViewController *map   = [[HYHotelMapViewController alloc] init];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake(latitude, longitude);
        map.annotationTitle             = merchantname;
        map.showAroundShops             = NO;
        map.location                    = location;
        map.coorType                    = HYCoorBaidu;
        [self.navigationController pushViewController:map animated:YES];
    }
}

#pragma mark - 返回
- (void)backToRootViewController:(id)sender{
    if (self.comeType == 1) {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
    [_sceneOrderDetailRequest cancel];
    _sceneOrderDetailRequest = nil;
    [_cancelOrderRequest cancel];
    _cancelOrderRequest = nil;
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
