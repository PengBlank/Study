//
//  BusinessOrderViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessOrderViewController.h"
#import "ConfirmOrderViewController.h"
#import "PostCommentViewController.h"
#import "CheckUserCommentRequest.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "OrderListView.h"
#import "OrderInfo.h"
#import "DefineConfig.h"
#import "HYUserInfo.h"
#import "Masonry.h"
#import "METoast.h"


@interface BusinessOrderViewController ()<iCarouselDataSource,iCarouselDelegate>
{
    CheckUserCommentRequest *_checkRequest;
}
@property (strong, nonatomic) XTSegmentControl          *mySegmentControl;
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (strong, nonatomic) NSArray                   *segmentItems;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;
@property (nonatomic, assign) BOOL              canComent;

@end

@implementation BusinessOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"实体店订单";
    
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
  DebugNSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

#pragma mark iCarousel M


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _segmentItems.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    
    WS(weakSelf);
    
    [view removeFromSuperview];
    view = nil;
    
    if (!view) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        OrderListView *listView = [[OrderListView alloc] initWithFrame:view.bounds type:index block:^(OrderInfo *baseInfo) {
            
            
            if (baseInfo.ActionType == 0) { //去支付
                
                ConfirmOrderViewController *tmpCtrl = [[ConfirmOrderViewController alloc] init];
                tmpCtrl.orderInfo = baseInfo;
                tmpCtrl.pageType = NO;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                
            }else{ //去评价
                
                PostCommentViewController *tmpCtrl = [[PostCommentViewController alloc] init];
                tmpCtrl.MerId = baseInfo.MerchantId;
                tmpCtrl.MerName = baseInfo.MerchantsName;
                tmpCtrl.money = baseInfo.Amount;
                tmpCtrl.coupon = baseInfo.Coupon;
                tmpCtrl.orderDate = baseInfo.CreateOn;
                tmpCtrl.orderId = baseInfo.O2O_Order_Number;
                tmpCtrl.orderType = BusinessComment;
                [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
            }
            
        }];
        [view addSubview:listView];
    }
    

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

- (void)checkUserComentYesOrNo:(OrderInfo *)info{
    
    [HYLoadHubView show];
    HYUserInfo *userinfo = [HYUserInfo getUserInfo];
    _checkRequest = [[CheckUserCommentRequest alloc] init];
    _checkRequest.interfaceURL = [NSString stringWithFormat:@"%@/Merchants/CheckUserComment",BASEURL];
    _checkRequest.httpMethod = @"GET";
    _checkRequest.MerId = info.MerchantId;
    _checkRequest.UserId = userinfo.userId;
    
    
    WS(weakSelf);
    [_checkRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         if(result){
             NSDictionary *objDic = [result jsonDic];
             weakSelf.canComent = [objDic[@"Result"] intValue];
             
             if (weakSelf.canComent) {
                 
                 PostCommentViewController *tmpCtrl = [[PostCommentViewController alloc] init];
                 tmpCtrl.MerId = info.MerchantId;
                 tmpCtrl.MerName = info.MerchantsName;
                 tmpCtrl.money = info.Amount;
                 tmpCtrl.coupon = info.Coupon;
                 tmpCtrl.orderDate = info.CreateOn;
                 [weakSelf.navigationController pushViewController:tmpCtrl animated:YES];
                 
             }else{
                 NSString *msg = objDic[@"Remark"];
                 [METoast toastWithMessage:msg ? msg : @"暂不能评论"];
                 return ;
             }
         }else{
             [METoast toastWithMessage:@"服务器异常，暂不能评论"];
             return ;
         }
         
     }];
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
