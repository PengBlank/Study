//
//  HYMallOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderHandleCell.h"
#import "HYMallReturnsInfo.h"

@interface HYMallOrderHandleCell ()
{
    NSInteger _status;
    UIButton *_leftBtn;
    UIButton *_rightBtn;
}
@end

@implementation HYMallOrderHandleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _status = -1;
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(ScreenRect.size.width-174, 10, 74, 28);
        [_leftBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                       forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_leftBtn setTitle:@""
                  forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                            forState:UIControlStateNormal];
        [_leftBtn addTarget:self
                     action:@selector(handleOrder:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(ScreenRect.size.width-84, 10, 74, 28);
        [_rightBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_rightBtn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1.0]
                        forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"mall_order_handle_btn_bg"]
                            forState:UIControlStateNormal];
        [_rightBtn addTarget:self
                     action:@selector(handleOrder:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightBtn];
    }
    return self;
}

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

//退换货的状态值
//退换货状态 0：待商家确认1：商家已确认2：商家拒绝3：买家已寄回商品4：卖家已重新发货5：买家已确认收货6：买家已寄出商品 7 退款中 8 退款已完成

//订单的状态值
/*
10:待付款;11:部分付款;20:待审核;30:待发货;31:部分发货;40:已发货;50:交易完成;-10:申请取消中;-20:已取消;
 */



//订单的状态值
/*
 10:待付款;11:部分付款;20:待审核;30:待发货;31:部分发货;40:已发货;50:交易完成;-10:申请取消中;-20:已取消;
 */
- (void)layoutWithStatus:(NSInteger)status
{
    _status = status;
    
    switch (status)
    {
        case 10:  //待付款
            [_leftBtn setHidden:NO];
            [_leftBtn setTitle:@"取消订单"
                      forState:UIControlStateNormal];
            _leftBtn.tag = Cancel_Order;
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"去付款"
                       forState:UIControlStateNormal];
            _rightBtn.tag = Payment_Order;
            break;
        case 11:  //部分付款
            [_leftBtn setHidden:NO];
            [_leftBtn setTitle:@"取消订单"
                      forState:UIControlStateNormal];
            _leftBtn.tag = Cancel_Order;
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"去付款"
                       forState:UIControlStateNormal];
            _rightBtn.tag = Payment_Order;
            break;
        case 30:  //待发货，买家已付款，等待卖家发货
            [_leftBtn setHidden:YES];

            [_rightBtn setHidden:YES];

            break;
        case 31://部分发货
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:YES];
            break;
        case 40:  //已发货，卖家已发货
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"确认收货"
                       forState:UIControlStateNormal];
            _rightBtn.tag = RecvConfig_Order;
            break;
        case 50:  //交易完成
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"删除订单"
                      forState:UIControlStateNormal];
            _rightBtn.tag = Delete_Order;
            break;
        case 51:  //已退款
            [_leftBtn setHidden:NO];
            [_leftBtn setTitle:@"删除订单"
                      forState:UIControlStateNormal];
            _leftBtn.tag = Delete_Order;
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"查看详情"
                       forState:UIControlStateNormal];
            _rightBtn.tag = CheckDetail;
            break;
        case 100:  //退换货中
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"查看详情"
                       forState:UIControlStateNormal];
            _rightBtn.tag = CheckDetail;
            break;
        case -20:  //已取消，交易已取消
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"删除订单"
                       forState:UIControlStateNormal];
            _rightBtn.tag = Delete_Order;
            break;
        default:
        {
            [_leftBtn setHidden:YES];
            
            [_rightBtn setHidden:NO];
            [_rightBtn setTitle:@"删除订单"
                       forState:UIControlStateNormal];
            _rightBtn.tag = Delete_Order;
        }
            break;
    }
}

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
