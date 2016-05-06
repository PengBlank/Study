//
//  TravelOrdelViewController.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "TravelOrdelViewController.h"
#import "TravelOrderListView.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"

#import "OrderInfo.h"
#import "DefineConfig.h"
#import "Masonry.h"

#import "TravelCodeViewController.h"    // 订单二维码页面
#import "PostCommentViewController.h"   // 评论
#import "GetCommentViewController.h"

@interface TravelOrdelViewController ()<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) XTSegmentControl          *mySegmentControl;
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (strong, nonatomic) NSArray                   *segmentItems;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;

@end

@implementation TravelOrdelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"旅游订单";
    
    _segmentItems = @[@"可用订单",@"历史订单"];
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
    view = [[UIView alloc] initWithFrame:carousel.bounds];
    TravelOrderListView *listView = [[TravelOrderListView alloc] initWithFrame:view.bounds type:index block:^(TravelOrderInfo *baseInfo, NSInteger type, BOOL isButton) {
        // YES 为button 评论
        if (!isButton)
        {
            // 点击cell时 block回调方法
            TravelCodeViewController *codeVC = [[TravelCodeViewController alloc] init];
            codeVC.travelOrderInfo = baseInfo;
            codeVC.travelOrderType = type;  // 0为可用订单 1为历史订单
            
            [weakSelf.navigationController pushViewController:codeVC animated:YES];
        }
        else
        {
            // 评论按钮回调 是否评论 0否 1是
            if ([baseInfo.isComment integerValue] == 0)
            {
                // 跳到评论页面
                PostCommentViewController *postVC = [[PostCommentViewController alloc] init];
                postVC.MerId = baseInfo.merId;
                postVC.MerName = baseInfo.touristName;
                postVC.money = baseInfo.price;
                postVC.orderDate = baseInfo.orderDate;
                postVC.coupon = baseInfo.coupon;
                postVC.orderId = baseInfo.tId; //(tid 就是orderID)
                postVC.orderType = TravelComment;
                [weakSelf.navigationController pushViewController:postVC animated:YES];
            }
//            else
//            {   // 已评论 无事件处理
//                GetCommentViewController *getVC = [[GetCommentViewController alloc] init];
//                [weakSelf.navigationController pushViewController:getVC animated:YES];
//            }
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
