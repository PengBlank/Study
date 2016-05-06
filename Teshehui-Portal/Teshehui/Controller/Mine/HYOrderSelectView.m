//
//  HYOrderSelectView.m
//  Teshehui
//
//  Created by 成才 向 on 15/12/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYOrderSelectView.h"
#import "HYImageButton.h"

/// order controllers
#import "HYHotelOrderListViewController.h"
#import "HYMallOrderListViewController.h"
#import "HYFlowerOrderListViewController.h"
#import "HYFlightOrderListViewController.h"
#import "HYMeituanOrderListViewController.h"
#import "HYMallFavoritesViewController.h"
#import "HYCIOrderListViewController.h"
#import "HYMallCartViewController.h"
#import "HYTaxiOrderListViewController.h"
//#import "OrderGroupViewController.h"
#import "BusinessOrderViewController.h"
#import "HYMeiWeiQiQiOrderListViewController.h"
#import "HYMovieTicketOrderListViewController.h"
#import "HYUmengMobClick.h"
#import "HYPhoneChargeOrderListViewController.h"

@interface HYOrderSelectItemConfig : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, weak) Class targetController;

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon target:(Class)target;

@end

@implementation HYOrderSelectItemConfig

+ (instancetype)itemWithTitle:(NSString *)title icon:(NSString *)icon target:(Class)target
{
    HYOrderSelectItemConfig *item = [[HYOrderSelectItemConfig alloc] init];
    item.title = title;
    item.icon = icon;
    item.targetController = target;
    return item;
}

@end

@interface HYOrderSelectView ()
{
    NSArray *_menuItems;
}
@property (nonatomic, strong) UIScrollView *scroll;

@end

@implementation HYOrderSelectView

+ (instancetype)getView
{
    CGRect frame = [UIScreen mainScreen].bounds;
    HYOrderSelectView *view = [[self alloc] initWithFrame:frame];
    
    return view;
}

/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        
        /// 订单类型标题，居中
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, frame.size.width-100, 30)];
        title.font = [UIFont systemFontOfSize:20.0];
        title.text = @"订单类型";
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        
        /// 退出按钮高度
        CGFloat footHeight = 44;
        
        /// scrollView
        self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(title.frame), frame.size.width, frame.size.height-footHeight-CGRectGetMaxY(title.frame))];
        [self addSubview:_scroll];
        
        /// 配置显示内容
        NSArray *itemConfigs = [self menuItems];
        
        CGFloat width = frame.size.width / 3;
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat h = TFScalePoint(120);
        
        for (int i = 0; i < itemConfigs.count; i ++)
        {
            HYOrderSelectItemConfig *itemConfig = [itemConfigs objectAtIndex:i];
            
            NSString *title = itemConfig.title;
            
            HYImageButton *button = [[HYImageButton alloc] initWithFrame:CGRectMake(x, y, width, h)];
            button.tag = 1000 + i;
            [button setTitle:title forState:UIControlStateNormal];
            
            NSString *icon = itemConfig.icon;
            [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
            
            button.spaceInTestAndImage = 10;
            button.titleLabel.font = [UIFont systemFontOfSize:15.0];
            [button setTitleColor:[UIColor colorWithWhite:.5 alpha:1]
                         forState:UIControlStateNormal];
            [button addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.scroll addSubview:button];
            
            /// 布局
            if (i % 3 == 2)
            {
                x = 0;
                y += h;
            }
            else
            {
                x += width;
            }
        }   /// end for
        
        self.scroll.contentSize = CGSizeMake(frame.size.width, y + h);
        
        /// foot
        UIButton *quit = [[UIButton alloc] initWithFrame:CGRectMake(0, frame.size.height - footHeight, frame.size.width, footHeight)];
        [quit setImage:[UIImage imageNamed:@"icon_order_close"] forState:UIControlStateNormal];
        [quit addTarget:self action:@selector(quitAction) forControlEvents:UIControlEventTouchUpInside];
        quit.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        [self addSubview:quit];
    }
    return self;
}

- (void)orderBtnAction:(UIButton *)btn
{
    NSInteger tag = btn.tag - 1000;
    [HYUmengMobClick mineOrderWithType:(int)tag+1];
    UIViewController *controller = nil;
    if (tag < _menuItems.count)
    {
        HYOrderSelectItemConfig *item = [_menuItems objectAtIndex:tag];
        controller = [[item.targetController alloc] init];
    }
    if (self.didGetOrderController && controller)
    {
        self.didGetOrderController(controller);
    }
    
    /// dismis
    [self dismissWithAnimation:YES];
}

- (void)quitAction
{
    [self dismissWithAnimation:YES];
}

- (NSArray<HYOrderSelectItemConfig *> *)menuItems
{
    if (!_menuItems)
    {
        NSMutableArray *items = [NSMutableArray array];
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"商城订单"
                          icon:@"icon_order_mall"
                          target:NSClassFromString(@"HYMallOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"机票订单"
                          icon:@"icon_order_flight"
                          target:NSClassFromString(@"HYFlightOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"打车订单"
                          icon:@"icon_order_didi"
                          target:NSClassFromString(@"HYTaxiOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"实体店订单"
                          icon:@"icon_order_o2o"
                          target:NSClassFromString(@"BusinessOrderViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"场景消费订单"
                          icon:@"ico_senceorder_mine"
                          target:NSClassFromString(@"SceneOrderViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"桌球订单"
                          icon:@"icon_order_zhuoqiu"
                          target:NSClassFromString(@"BilliardOrderViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"旅游订单"
                          icon:@"icon_order_travel"
                          target:NSClassFromString(@"TravelOrdelViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"酒店订单"
                          icon:@"icon_order_hotel"
                          target:NSClassFromString(@"HYHotelOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"电影票订单"
                          icon:@"icon_order_movieTicket"
                          target:NSClassFromString(@"HYMovieTicketOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"手机充值订单"
                          icon:@"icon_orderList_phoneCharge"
                          target:NSClassFromString(@"HYPhoneChargeOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"团购订单"
                          icon:@"icon_order_meituan"
                          target:NSClassFromString(@"HYMeituanOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"鲜花订单"
                          icon:@"icon_order_flower"
                          target:NSClassFromString(@"HYFlowerOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"美味七七订单"
                          icon:@"icon_order_qiqi"
                          target:NSClassFromString(@"HYMeiWeiQiQiOrderListViewController")]];
        
        [items addObject:[HYOrderSelectItemConfig
                          itemWithTitle:@"车险订单"
                          icon:@"icon_order_yangguang"
                          target:NSClassFromString(@"HYCIOrderListViewController")]];
//        [items addObject:[HYOrderSelectItemConfig
//                          itemWithTitle:@"电影票订单"
//                          icon:@"icon_order_movieTicket"
//                          target:NSClassFromString(@"HYMovieTicketOrderListViewController")]];
//        [items addObject:[HYOrderSelectItemConfig
//                          itemWithTitle:@"手机充值订单"
//                          icon:@"icon_orderList_phoneCharge"
//                          target:NSClassFromString(@"HYPhoneChargeOrderListViewController")]];
        _menuItems = items;
    }
    
    return _menuItems;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
