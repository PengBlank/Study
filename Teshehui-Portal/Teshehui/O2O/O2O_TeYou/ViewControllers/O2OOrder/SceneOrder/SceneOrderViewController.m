//
//  SceneOrderViewController.m
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "SceneOrderViewController.h"
#import "XTSegmentControl.h"  // 滑块
#import "iCarousel.h"
#import "SceneOrderListView.h" // 场景订单列表view
#import "SceneOrderDetailViewController.h" // 场景订单详情

#import "DefineConfig.h"
#import "Masonry.h"

#import "RefundViewController.h"
#import "SceneOrderListModel.h"
#import "HYAlipayOrder.h"           // 支付
#import "HYPaymentViewController.h" // 支付页面
#import "PayResultOfSceneCtrl.h"    // 支付成功

@interface SceneOrderViewController ()<iCarouselDataSource,iCarouselDelegate>

@property (nonatomic, strong) XTSegmentControl  *mySegmentControl; //那个滑块的
@property (nonatomic, strong) iCarousel         *myCarousel;
@property (nonatomic, strong) NSArray           *segmentItems;
@property (nonatomic, assign) NSInteger         oldSelectedIndex;

@property (nonatomic, strong) SceneOrderListModel *myModel;

@end

@implementation SceneOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"场景消费订单";
//    self.segmentItems = @[@"全部",@"可使用"];
    self.segmentItems = @[@"全部",@"可使用",@"待付款",@"无效订单"];
    
    [self createUI];
}
#pragma mark - 创建UI
- (void)createUI
{
    // 添加myCarousel
    self.myCarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] init];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 1.0;
        icarousel.scrollSpeed = 1.0;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounceDistance = 0.2;
        [self.view addSubview:icarousel];
        [icarousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, 0, 0));
        }];
        icarousel;
    });
    
    // 添加滑块
    WS(weakSelf);
    __weak typeof(_myCarousel)weakCarousel = _myCarousel;
    self.mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0,kScreen_Width, 44) Items:self.segmentItems selectedBlock:^(NSInteger index) {
        
        if(index == weakSelf.oldSelectedIndex){
            return;
        }
        // 开动画效果的话 items多了 滑块会有卡顿；
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    self.icarouselScrollEnabled = NO;
    [self.view addSubview:self.mySegmentControl];
}

-(void)dealloc
{
    _myCarousel.dataSource = nil;
    _myCarousel.delegate = nil;
    [HYLoadHubView dismiss];
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark iCarousel DataSource&Delegate
// item 的数量
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.segmentItems.count;
}
// item内容
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    [view removeFromSuperview];
    view = nil;
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        WS(weakSelf);
        #pragma mark -- tableViewCell点击block回调
        SceneOrderListView *listView = [[SceneOrderListView alloc] initWithFrame:view.bounds Type:index Block:^(id obj, NSString *orderNum,BOOL isButton, UIButton *btn) {
            if (isButton)
            {// 去支付按钮点击事件
                [weakSelf goPay:obj];
            }else
            {// 点击cell
                [weakSelf tableViewCellClickWithModel:nil OrderNum:orderNum Button:btn];
            }
        }];
        
        [view addSubview:listView];
    }
    
    return view;
}
// 点击滑块
-(void)carouselDidScroll:(iCarousel *)carousel
{
    if (self.mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [self.mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if(self.mySegmentControl)
    {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    if (self.oldSelectedIndex != carousel.currentItemIndex) {
        self.oldSelectedIndex = carousel.currentItemIndex;
    }
}

- (void)setIcarouselScrollEnabled:(BOOL)icarouselScrollEnabled{
    _myCarousel.scrollEnabled = icarouselScrollEnabled;
}

#pragma mark - 回调执行
-(void)tableViewCellClickWithModel:(id)obj OrderNum:(NSString *)orderNum Button:(UIButton *)btn
{
    SceneOrderDetailViewController *vc = [[SceneOrderDetailViewController alloc] init];
    vc.orderNum = orderNum;
    vc.payButton = btn;
    [self.navigationController pushViewController:vc animated:YES];
    
//    RefundViewController *vc = [[RefundViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 去支付
-(void)goPay:(id)obj
{
    // 需要的订单号都在里面
    SceneOrderListModel *model = (SceneOrderListModel *)obj;
    self.myModel = model;
    
    HYAlipayOrder *alOrder = [[HYAlipayOrder alloc] init];
    alOrder.partner = PartnerID;
    alOrder.seller = SellerID;
    alOrder.tradeNO =  model.c2bTradeNo; //订单号 (显示订单号)
    alOrder.productName = [NSString stringWithFormat:@"【特奢汇】场景消费支付: %@", model.c2bTradeNo]; //商品标题 (显示订单号)
    alOrder.productDescription = [NSString stringWithFormat:@"【特奢汇】场景消费支付: %@", model.c2bTradeNo]; //商品描述
    alOrder.amount = [NSString stringWithFormat:@"%0.2ld",[model.amount integerValue]]; //商品价格
    
    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = self.navbarTheme;
    payVC.alipayOrder = alOrder;
    payVC.amountMoney = model.amount;           //付款总额
    payVC.point = [model.coupon integerValue];  //  现金券
    payVC.orderID = model.c2bOrderId;          //用户获取银联支付流水号
    payVC.orderCode = model.c2bTradeNo;        //订单号
    //    payVC.O2O_OrderNo = self.O2O_Order_Number;
    //    payVC.O2O_storeName = self.businessdetailInfo.MerchantsName;
    payVC.type = Pay_O2O_QRScan;
    payVC.O2OpayType = ScenePay; // 场景消费
    
    __weak typeof(self) weakSelf = self;
    [payVC setBusinessPaymentSuccess:^(O2OPayType type) {
        
        [weakSelf pushPaySuccessWithType:type];
        
    }];
    
    [self.navigationController pushViewController:payVC animated:YES];
}
//　回调支付成功
- (void)pushPaySuccessWithType:(O2OPayType)type
{
    PayResultOfSceneCtrl *vc = [[PayResultOfSceneCtrl alloc] init];
    vc.O2O_OrderNo  = self.myModel.o2oTradeNo;
    vc.orderId      = self.myModel.o2oTradeNo;
    
    vc.storeName    = self.myModel.merchantName;
    vc.money        = self.myModel.amount;
    vc.coupon       = self.myModel.coupon;
    vc.packName     = self.myModel.packageName;
    vc.payCode      = self.myModel.validCode;
    vc.comeType     = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


#pragma  mark --
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
