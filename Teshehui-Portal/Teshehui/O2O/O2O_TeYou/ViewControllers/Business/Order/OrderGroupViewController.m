//
//  OrderGroupViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "OrderGroupViewController.h"
#import "BusinessOrderViewController.h"
#import "TravelOrdelViewController.h"
#import "BilliardOrderViewController.h"

#import "GetUnPayOrderRequest.h"

#import "DefineConfig.h"
#import "Masonry.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "UIView+Common.h"
#import "UIImage+Common.h"
#import "NSString+Addition.h"
#import "UIColor+expanded.h"

#import "HYShareInfoReq.h"

typedef NS_ENUM(NSInteger, orderType) {
    /**
     *  发现订单
     */
    founderOrder = 1000,
    /**
     *  旅游订单
     */
    travelOrder,
    /**
     *  桌球订单
     */
    snookerOrder
};

@interface OrderGroupViewController ()
@property (nonatomic,strong)GetUnPayOrderRequest *getUnPayOrderRequest;
@property (nonatomic,assign)BOOL loading;
@end

@implementation OrderGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"商家订单";
    
    NSArray *titles = @[@"实体店订单",@"旅游订单",@"桌球订单"];
    NSArray *images = @[[UIImage imageNamed:@"storeorder"],
                        [UIImage imageNamed:@"travelorder"],
                        [UIImage imageNamed:@"billiards"]];
    CGFloat width = kScreen_Width / 2;
    CGFloat height = ScaleHEIGHT(150);
    WS(weakSelf);
    for (int i = 0; i < 3; i++) {
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [orderBtn setFrame:CGRectMake(width * (i % 2), 10 + (i / 2) * height, width, height)];
        [orderBtn setTag:i + 1000];
        [orderBtn setImage:images[i] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [orderBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.845 alpha:1.000]] forState:UIControlStateHighlighted];
        [orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 25, 0)];
        [self addBottomLayer:orderBtn];
        if (i == 0) {
            [self addRightLayer:orderBtn];
          //  [self addTopLayer:orderBtn];
        }else if (i == 1){
             //[self addTopLayer:orderBtn];
        }else{
            [self addRightLayer:orderBtn];
        }

        [weakSelf.view addSubview:orderBtn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setTag:i + 10000];
        [titleLabel setFrame:CGRectMake(0, g_fitFloat(@[@75,@85,@95]), orderBtn.width, 20)];
        [titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [titleLabel setFont:[UIFont systemFontOfSize:14]];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        titleLabel.text = titles[i];
        [orderBtn addSubview:titleLabel];
    }
    
    [self loadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsOrderListChanged object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDataChanged) name:kNotificationWithBilliardsOrderListChanged object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

- (void)dealloc{
    [self.getUnPayOrderRequest  cancel];
    self.getUnPayOrderRequest = nil;
    [HYLoadHubView dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationWithBilliardsOrderListChanged object:nil];
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}


#pragma mark -- 通知数据改变
- (void)notificationDataChanged{
    
     UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    [btn removeBadgeTips];
     UIButton *btn2 = (UIButton *)[self.view viewWithTag:1001];
     [btn2 removeBadgeTips];
     UIButton *btn3 = (UIButton *)[self.view viewWithTag:1002];
     [btn3 removeBadgeTips];
    
    [self loadData];
}


#pragma mark -- 加载未付款订单数量
- (void)loadData{
    
    [HYLoadHubView show];
    HYUserInfo *userInfo                    = [HYUserInfo getUserInfo];
    self.getUnPayOrderRequest               = [[GetUnPayOrderRequest alloc] init];
    self.getUnPayOrderRequest.interfaceURL  = [NSString stringWithFormat:@"%@/OrderCommon/MyUnPayOrder",ORDER_API_URL_V3];
    self.getUnPayOrderRequest.interfaceType = DotNET2;
    self.getUnPayOrderRequest.postType      = JSON;
    self.getUnPayOrderRequest.httpMethod    = @"POST";
    self.getUnPayOrderRequest.UId           = userInfo.userId;//  用户id

    WS(weakSelf);
    [self.getUnPayOrderRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             CGFloat width = kScreen_Width / 2;
             CGFloat height = ScaleHEIGHT(150);
             int code = [objDic[@"code"] intValue];
             if (code == 0) { //状态值为0
                 NSDictionary *objKeyValue = objDic[@"data"];
                 NSInteger businessOrderCount = [objKeyValue[@"ShopOrder"] integerValue];
                 NSInteger travelOrderCount = [objKeyValue[@"TravelOrder"] integerValue];
                 NSInteger billiardsOrderCount = [objKeyValue[@"BilliardsOrder"] integerValue];
                 
                 if (businessOrderCount > 0) {
                     UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:1000];
                    [btn addBadgeTip:[NSString stringWithFormat:@"%@",@(businessOrderCount)] withCenterPosition:CGPointMake(width/2 + 20, height/2 - 32.5)];
                 }
                 
                 if (travelOrderCount > 0) {
                     UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:1001];
                     [btn addBadgeTip:[NSString stringWithFormat:@"%@",@(travelOrderCount)] withCenterPosition:CGPointMake(width/2 + 20, height/2 - 32.5)];
                 }
                 
                 if (billiardsOrderCount > 0) {
                     UIButton *btn = (UIButton *)[weakSelf.view viewWithTag:1002];
                     [btn addBadgeTip:[NSString stringWithFormat:@"%@",@(billiardsOrderCount)] withCenterPosition:CGPointMake(width/2 + 20, height/2 - 32.5)];
                 }

             }
         }
     }];
}

#pragma mark -- 画线
- (void)addTopLayer:(UIButton *)orderBtn{
    CALayer *bottomBorder = [CALayer layer];
   // float y =orderBtn.frame.origin.y;
    float width=orderBtn.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, 0, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    [orderBtn.layer addSublayer:bottomBorder];
}

- (void)addBottomLayer:(UIButton *)orderBtn{
    CALayer *bottomBorder = [CALayer layer];
    float height=orderBtn.frame.size.height-1.0f;
    float width=orderBtn.frame.size.width;
    bottomBorder.frame = CGRectMake(0.0f, height, width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    [orderBtn.layer addSublayer:bottomBorder];
}

- (void)addLeftLayer:(UIButton *)orderBtn{
    CALayer *bottomBorder = [CALayer layer];
    float x =orderBtn.frame.origin.x;
    float y =orderBtn.frame.origin.y;
    float height =orderBtn.frame.size.height;
    bottomBorder.frame = CGRectMake(x, y, 1,height);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    [orderBtn.layer addSublayer:bottomBorder];
}

- (void)addRightLayer:(UIButton *)orderBtn{
    CALayer *bottomBorder = [CALayer layer];
    float x =orderBtn.frame.size.width - 1;
   
    float height =orderBtn.frame.size.height;
    bottomBorder.frame = CGRectMake(x, 0, 1,height);
    bottomBorder.backgroundColor = [UIColor colorWithWhite:0.875 alpha:1.000].CGColor;
    [orderBtn.layer addSublayer:bottomBorder];
}


#pragma mark -- 按钮点击事件
- (void)orderBtnAction:(UIButton *)btn{
    
    switch (btn.tag) {
        case founderOrder:
        {
            BusinessOrderViewController *tmpCtrl = [[BusinessOrderViewController alloc] init];
            [self.navigationController pushViewController:tmpCtrl animated:YES];
        }
            break;
        case travelOrder:
        {
            TravelOrdelViewController *tmpCtrl = [[TravelOrdelViewController alloc] init];
            [self.navigationController pushViewController:tmpCtrl animated:YES];
        }
            break;
        case snookerOrder:
        {
            BilliardOrderViewController *tmpCtrl = [[BilliardOrderViewController alloc] init];
            [self.navigationController pushViewController:tmpCtrl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
