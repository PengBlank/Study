//
//  BilliardOrderViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardOrderViewController.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "BilliardsOrderListView.h"
#import "OrderInfo.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "HYBuyDrinksViewController.h"
#import "HYOrderPayViewController.h"
#import "HYHistoryOrderViewController.h"
#import "PostCommentViewController.h"
#import "OrderGroupViewController.h"
@interface BilliardOrderViewController ()<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl          *mySegmentControl;
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (strong, nonatomic) NSArray                   *segmentItems;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;
@end

@implementation BilliardOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"桌球订单";
    
    _segmentItems = @[@"待付款",@"已付款"];
    //添加myCarousel
    _myCarousel = ({
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
    
    //    //添加滑块
    WS(weakSelf)
    __weak typeof(_myCarousel) weakCarousel = _myCarousel;
    _mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44) Items:_segmentItems selectedBlock:^(NSInteger index) {
        
        if (index == weakSelf.oldSelectedIndex) {
            return;
        }
        [weakCarousel scrollToItemAtIndex:index animated:NO];
    }];
    self.icarouselScrollEnabled = NO;
    [self.view addSubview:_mySegmentControl];
    
   
}

- (void)dealloc{
    _myCarousel.dataSource = nil;
    _myCarousel.delegate = nil;
    [HYLoadHubView dismiss];
    DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark iCarousel M
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _segmentItems.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    WS(weakSelf);
    view = [[UIView alloc] initWithFrame:carousel.bounds];
    BilliardsOrderListView *listView = [[BilliardsOrderListView alloc] initWithFrame:view.bounds type:index block:^(BilliardsOrderInfo *baseInfo) {
        
        if(baseInfo.actionType == 0){ //购买酒水
            
            HYBuyDrinksViewController *buyDrinks = [[HYBuyDrinksViewController alloc] init];
            buyDrinks.orderInfo = baseInfo;
            buyDrinks.backRefresh = YES;
            [weakSelf.navigationController pushViewController:buyDrinks animated:YES];
            
        }else if(baseInfo.actionType == 1){ //去支付
            
            HYOrderPayViewController *orderPay = [[HYOrderPayViewController alloc] init];
            orderPay.orderInfo = baseInfo;
            orderPay.backRefresh = YES;
            [weakSelf.navigationController pushViewController:orderPay animated:YES];
//
        }else if(baseInfo.actionType == 2){ //跳转订单详情
            
            HYHistoryOrderViewController *tmpCtrl = [[HYHistoryOrderViewController alloc] init];
            tmpCtrl.billiardsOrderInfo = baseInfo;
            [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
            
        }else{ //去评价&分享
            
            PostCommentViewController *tmpCtrl = [[PostCommentViewController alloc] init];
            tmpCtrl.MerId = baseInfo.MerchantId;
            tmpCtrl.MerName = baseInfo.MerchantName;
            tmpCtrl.money = baseInfo.OrderAmount;
            tmpCtrl.coupon = baseInfo.OrderCoupon;
            tmpCtrl.orderDate = baseInfo.EndTime;
            tmpCtrl.orderId = baseInfo.OrderNum ? : baseInfo.PcOrderNum;
            tmpCtrl.orderType = BilliardsComment;
            [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
        }
    }];
    
    [view addSubview:listView];
    return view;
}

- (void)carouselDidScroll:(iCarousel *)carousel{
    
    if (_mySegmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [_mySegmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (_mySegmentControl) {
        _mySegmentControl.currentIndex = carousel.currentItemIndex;
    }
    if (_oldSelectedIndex != carousel.currentItemIndex) {
        _oldSelectedIndex = carousel.currentItemIndex;
    }
}


- (void)setIcarouselScrollEnabled:(BOOL)icarouselScrollEnabled{
    _myCarousel.scrollEnabled = icarouselScrollEnabled;
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
