//
//  HYMallOrderDetailHandleView.m
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderDetailHandleView.h"
#import "HYMallApplyAfterSaleServiceViewController.h"

@interface HYMallOrderDetailHandleView ()
{
    NSInteger _status;
    
    UIButton *_leftBtn;
    UIButton *_middleBtn;
    UIButton *_rightBtn;
}
@end


@implementation HYMallOrderDetailHandleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            frame.size.width,
                                                                            frame.size.height)];
        bgView.image = [UIImage imageNamed:@"store_bg_tab"];
        [self addSubview:bgView];
        
        _status = -1;
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(TFScalePoint(20), 6, TFScalePoint(90), TFScalePoint(28));
        [_leftBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                       forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                            forState:UIControlStateNormal];
        [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_leftBtn addTarget:self
                     action:@selector(handleOrder:)
           forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.tag = Logistics;
        [self addSubview:_leftBtn];
        
        _middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _middleBtn.frame = CGRectMake(TFScalePoint(120), 6, TFScalePoint(90), TFScalePoint(28));
        [_middleBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                       forState:UIControlStateNormal];
        [_middleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_middleBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                            forState:UIControlStateNormal];
        [_middleBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [_middleBtn addTarget:self
                     action:@selector(handleOrder:)
           forControlEvents:UIControlEventTouchUpInside];
        _middleBtn.tag = ApplyAfterSaleService;
        [self addSubview:_middleBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(TFScalePoint(220), 6, TFScalePoint(90), TFScalePoint(28));
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rightBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                        forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                             forState:UIControlStateNormal];
        [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [_rightBtn addTarget:self
                      action:@selector(handleOrder:)
            forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.tag = Commend;
        [self addSubview:_rightBtn];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark setter/getter
- (void)setOrderInfo:(HYMallOrderSummary *)orderInfo
{
    if (orderInfo != _orderInfo)
    {
        _orderInfo = orderInfo;
    }
    
    [self layoutWithStatus:orderInfo.status];
}

#pragma mark - private methods
- (void)handleOrder:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(handleOrderWithEventType:eventType:)])
    {
        [self.delegate handleOrderWithEventType:self.orderInfo
                                      eventType:(int)sender.tag];
    }
}

- (void)layoutWithStatus:(NSInteger)status
{
    if (_status != status)
    {
        _status = status;
        switch (status)
        {
            case -10:
            case -20:
            case 10:  //待付款
            case 11:  //部分付款
            case 30:   //待发货，买家已付款，等待卖家发货
            case 31:
                self.hidden = YES;
                break;
            case 40:  //已发货，卖家已发货
                [_leftBtn setHidden:YES];
                
                [_middleBtn setHidden:NO];
                [_middleBtn setTitle:@"查看物流"
                          forState:UIControlStateNormal];
                _middleBtn.tag = Logistics;
                
                [_rightBtn setHidden:NO];
                [_rightBtn setTitle:@"确认收货"
                           forState:UIControlStateNormal];
                _rightBtn.tag = RecvConfig_Order;
                break;
            case 50:  //交易成功
                [_leftBtn setHidden:NO];
                [_middleBtn setHidden:NO];
                [_rightBtn setHidden:NO];
                
                [_leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                _leftBtn.tag = Logistics;
                
                [_middleBtn setTitle:@"申请售后" forState:UIControlStateNormal];
                _middleBtn.tag = ApplyAfterSaleService;
                
                [_rightBtn setTitle:@"去评价" forState:UIControlStateNormal];
                _rightBtn.tag = Commend;
                break;
            default:
                break;
        }
    }
}

//订单的状态值
/*
 10:待付款;11:部分付款;20:待审核;30:待发货;31:部分发货;40:已发货;50:交易完成;-10:申请取消中;-20:已取消;
 */



/*
 取消订单
 付款
 提醒发货
 查看物流
 确认收货
 评价
 删除订单
 追加评价
 */

@end
