//
//  HYFlowerOrderListCell.m
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerOrderListCell.h"
#import "UIImageView+WebCache.h"
#import "HYUserInfo.h"
#import "HYPaymentViewController.h"
#import "HYFolwerDetailCell.h"
#import "HYFlowerDetailViewController.h"
#import "METoast.h"
#import "HYFlowerOrderSummary.h"
#import "HYUserInfo.h"

@interface HYFlowerOrderListCell ()

@property (nonatomic, strong) UIImageView *flowerImage;
@property (nonatomic, strong) UILabel *flowerNameLab;
@property (nonatomic, strong) UILabel *flowerDescLab;
@property (nonatomic, strong) UILabel *flowerPointLab;
@property (nonatomic, strong) UILabel *flowerPriceLab;
@property (nonatomic, strong) UIImageView *lineView2;

@end


@implementation HYFlowerOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _org_y = 0;
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        
        if (user.userType == Enterprise_User)
        {
            _order_name_Label = [[UILabel alloc]initWithFrame:CGRectMake(10,10, TFScalePoint(300), 16)];
            _order_name_Label.backgroundColor = [UIColor clearColor];
            _order_name_Label.textColor = [UIColor darkTextColor];
            _order_name_Label.font = [UIFont systemFontOfSize:12.0f];
            [self.contentView addSubview:_order_name_Label];
            _org_y = 20;
        }
        
        _order_sn = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+10, TFScalePoint(300), 16)];
        _order_sn.backgroundColor = [UIColor clearColor];
        _order_sn.textColor = [UIColor darkTextColor];
        _order_sn.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_order_sn];
        
        _order_amout = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+30, TFScalePoint(300), 16)];
        _order_amout.backgroundColor = [UIColor clearColor];
        _order_amout.textColor = [UIColor darkTextColor];
        _order_amout.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_order_amout];
        
        _order_time = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+50, TFScalePoint(300), 16)];
        _order_time.backgroundColor = [UIColor clearColor];
        _order_time.textColor = [UIColor darkGrayColor];
        _order_time.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_order_time];
        
        _order_status = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+70, TFScalePoint(300), 16)];
        _order_status.backgroundColor = [UIColor clearColor];
        _order_status.textColor = [UIColor darkTextColor];
        _order_status.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_order_status];
        
        _messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+90, TFScalePoint(300), 16)];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor darkTextColor];
        _messageLabel.font = [UIFont systemFontOfSize:12.0f];
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.numberOfLines = 0;
        [self.contentView addSubview:_messageLabel];
        
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, _org_y+110, TFScalePoint(300), 20)];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.textColor = [UIColor darkTextColor];
        _addressLabel.font = [UIFont systemFontOfSize:12.0f];
        _addressLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _addressLabel.numberOfLines = 2;
        [self.contentView addSubview:_addressLabel];
        
        UIImageView *_lineView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bounds), TFScalePoint(320), 1.0)];
        _lineView1.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:0];
        _lineView1.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:_lineView1];
 
        _lineView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_addressLabel.frame)+10,  TFScalePoint(320), 1.0)];
        _lineView2.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:0];
        [self.contentView addSubview:_lineView2];
        
        /*_goodsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, _org_y+140,TFScalePoint(320), 120)
                                                  style:UITableViewStylePlain];
        _goodsTable.backgroundColor = [UIColor clearColor];
        _goodsTable.backgroundView = nil;
        _goodsTable.scrollEnabled = NO;
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.tableHeaderView = _lineView1;
        _goodsTable.tableFooterView = _lineView2;
        [self.contentView addSubview:_goodsTable];*/
        
        //鲜花图片
        _flowerImage = [[UIImageView alloc] initWithFrame:
                        CGRectMake(10,
                                   CGRectGetMaxY(_lineView2.frame) + 10,
                                   100,
                                   100)];
        [self.contentView addSubview:_flowerImage];
        
        //鲜花名称
        _flowerNameLab = [[UILabel alloc] initWithFrame:
                          CGRectMake(CGRectGetMaxX(_flowerImage.frame) + 5,
                                     CGRectGetMaxY(_lineView2.frame) + 17.5,
                                     CGRectGetWidth(ScreenRect)-CGRectGetMaxX(_flowerImage.frame) - 5-80,
                                     16)];
        _flowerNameLab.backgroundColor = [UIColor clearColor];
        _flowerNameLab.textColor = [UIColor colorWithRed:16.0/255.0
                                             green:16.0/255.0
                                              blue:16.0/255.0
                                             alpha:1.0];
        _flowerNameLab.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_flowerNameLab];
        
        _flowerPriceLab = [[UILabel alloc]initWithFrame:
                           CGRectMake(CGRectGetWidth(ScreenRect)-10-70,
                                      CGRectGetMaxY(_lineView2.frame) + 14.5,
                                      70,
                                      20)];
        _flowerPriceLab.backgroundColor = [UIColor colorWithRed:237.0/255.0
                                                    green:86.0/255.0
                                                     blue:101.0/255.0
                                                    alpha:1.0];
        _flowerPriceLab.textColor = [UIColor whiteColor];
        _flowerPriceLab.textAlignment = NSTextAlignmentCenter;
        _flowerPriceLab.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_flowerPriceLab];
        
        //鲜花说明
        _flowerDescLab = [[UILabel alloc] initWithFrame:
                          CGRectMake(CGRectGetMinX(_flowerNameLab.frame),
                                     CGRectGetMaxY(_flowerPriceLab.frame)+5,
                                     CGRectGetWidth(ScreenRect)-CGRectGetMinX(_flowerNameLab.frame)-20,
                                     60)];
        _flowerDescLab.numberOfLines = 0;
        _flowerDescLab.backgroundColor = [UIColor clearColor];
        _flowerDescLab.textColor = [UIColor colorWithRed:116.0/255.0
                                            green:114.0/255.0
                                             blue:114.0/255.0
                                            alpha:1.0];
        _flowerDescLab.font = [UIFont systemFontOfSize:10.0f];
        [self.contentView addSubview:_flowerDescLab];
        
        //现金券
        _flowerPointLab = [[UILabel alloc]initWithFrame:
                           CGRectMake(CGRectGetMinX(_flowerNameLab.frame),
                                      CGRectGetMinY(_flowerImage.frame) + 90,
                                      CGRectGetWidth(ScreenRect)-122.5,
                                      16)];
        _flowerPointLab.backgroundColor = [UIColor colorWithRed:246.0/255.0
                                                    green:248.0/255.0
                                                     blue:242.0/255.0
                                                    alpha:1.0];
        _flowerPointLab.textColor = [UIColor colorWithRed:47.0/255.0
                                              green:46.0/255.0
                                               blue:46.0/255.0
                                              alpha:1.0];
        _flowerPointLab.font = [UIFont systemFontOfSize:8.0f];
        _flowerPointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_flowerPointLab];
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.frame = CGRectMake(26, _org_y+265, TFScalePoint(120), 30);
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping2_normal"] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping2_press"] forState:UIControlStateNormal];
        [_payBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [_payBtn addTarget:self
                    action:@selector(payEvent:)
          forControlEvents:UIControlEventTouchUpInside];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_payBtn];
        _payBtn.hidden = YES;
        
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(ScreenRect.size.width-TFScalePoint(146), _org_y+265, TFScalePoint(120), 30);
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping1_normal"] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping1_press"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_cancelBtn];
        _cancelBtn.hidden = YES;
        
        _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _delBtn.frame = CGRectMake(ScreenRect.size.width-TFScalePoint(90), _org_y+54, TFScalePoint(80), 30);
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping2_normal"]
                           forState:UIControlStateNormal];
        [_delBtn setBackgroundImage:[UIImage imageNamed:@"store_buttom_shopping2_press"]
                           forState:UIControlStateNormal];
        [_delBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_delBtn addTarget:self
                    action:@selector(deleteOrder:)
          forControlEvents:UIControlEventTouchUpInside];
        _delBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:_delBtn];
    }
    return self;
}

- (void)setOrderListInfo:(HYFlowerOrderSummary *)orderListInfo
{
    if (orderListInfo != _orderListInfo)
    {
        _orderListInfo = orderListInfo;
        
        HYFlowerOrderItem *item = [orderListInfo.orderItemPOList lastObject];
        
        NSNumber *nPrice = [NSNumber numberWithFloat:_orderListInfo.orderPayAmount.floatValue];
        _order_sn.text = [NSString stringWithFormat:@"订单编号: %@",_orderListInfo.orderCode];
        _order_amout.text = [NSString stringWithFormat:@"订单总价: ¥%@+赠送:%ld现金券    总数:%ld",
                             nPrice,
                             _orderListInfo.orderTbAmount.integerValue,
                             item.quantity.integerValue];
//        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[_orderListInfo.shippingTime floatValue]];
        NSArray *shippingTimeComps = [_orderListInfo.shippingTime componentsSeparatedByString:@" "];
        if (shippingTimeComps.count > 1)
        {
            _order_time.text = [NSString stringWithFormat:@"送花时间: %@",shippingTimeComps[0]];
        }
        else
        {
            _order_time.text = [NSString stringWithFormat:@"送花时间: %@",_orderListInfo.shippingTime];
        }
        
        _messageLabel.frame = CGRectMake(10, _org_y+90, TFScalePoint(300), orderListInfo.userMessageHeight);
        _messageLabel.text = [NSString stringWithFormat:@"祝福语: %@",orderListInfo.remark];
        
        _addressLabel.frame = CGRectMake(10, _org_y+(90+orderListInfo.userMessageHeight), TFScalePoint(300), orderListInfo.addressHeight);
        _addressLabel.text = [NSString stringWithFormat:@"收货地址: %@",[orderListInfo.address addressDesc]];
        _lineView2.frame = CGRectMake(0, CGRectGetMaxY(_addressLabel.frame)+10,  TFScalePoint(320), 1.0);
        
        HYFlowerOrderItem *orderItem = [_orderListInfo.orderItemPOList lastObject];
        [self.flowerImage sd_setImageWithURL:[NSURL URLWithString:orderItem.pictureBigUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        self.flowerImage.frame = CGRectMake(10,
                                            CGRectGetMaxY(_lineView2.frame) + 10,
                                            100,
                                            100);
        self.flowerNameLab.text = orderItem.productName;
        self.flowerNameLab.frame = CGRectMake(CGRectGetMaxX(_flowerImage.frame) + 5,
                                              CGRectGetMaxY(_addressLabel.frame) + 17.5,
                                              CGRectGetWidth(ScreenRect)-CGRectGetMaxX(_flowerImage.frame) - 5-80,
                                              16);
        NSNumber *pPrice = [NSNumber numberWithFloat:orderItem.price.floatValue];
        self.flowerPriceLab.text = [NSString stringWithFormat:@"¥%@", pPrice];
        self.flowerDescLab.text = orderItem.productDesc;
        self.flowerPointLab.text = [NSString stringWithFormat:@"赠送现金券:%ld", orderItem.points.integerValue];
        self.flowerPriceLab.frame = CGRectMake(CGRectGetWidth(ScreenRect)-10-70,
                                               CGRectGetMaxY(_lineView2.frame) + 14.5,
                                               70,
                                               20);
        _flowerDescLab.frame = CGRectMake(CGRectGetMinX(_flowerNameLab.frame),
                                          CGRectGetMaxY(_flowerPriceLab.frame)+5,
                                          CGRectGetWidth(ScreenRect)-CGRectGetMinX(_flowerNameLab.frame)-20,
                                          60);
        _flowerPointLab.frame = CGRectMake(CGRectGetMinX(_flowerNameLab.frame),
                                           CGRectGetMinY(_flowerImage.frame) + 90,
                                           CGRectGetWidth(ScreenRect)-122.5,
                                           16);
        
    }
    
    NSInteger orderstatus = [orderListInfo.status intValue];
    
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (user.userType == Enterprise_User)
    {
        NSString *userName = orderListInfo.buyerNick;
        
        if (orderListInfo.isEnterprise.intValue==0 && [userName length] <= 0)
        {
            userName = @"当前账号";
        }
        
        _order_name_Label.text = [NSString stringWithFormat:@"下单人：%@", userName];
    }
    
    if (orderstatus == 1)  //未支付
    {
        [_delBtn setHidden:YES];
        
        if (orderListInfo.orderType.intValue == 0) //自己的订单可以去支付或者取消
        {
            _payBtn.hidden = NO;
            _payBtn.frame = CGRectMake(26,
                                       _org_y+(225+orderListInfo.userMessageHeight+orderListInfo.addressHeight),
                                       TFScalePoint(120),
                                       30);
            _cancelBtn.hidden = NO;
            _cancelBtn.frame = CGRectMake(ScreenRect.size.width-TFScalePoint(146),
                                          _org_y+(225+orderListInfo.userMessageHeight+orderListInfo.addressHeight),
                                          TFScalePoint(120),
                                          30);
        }

        _order_status.text = @"订单状态: 未支付";
    }
    else
    {
        _payBtn.hidden = YES;
        _cancelBtn.hidden = YES;
        [_delBtn setHidden:YES];
        
        /*
         * 企业员工可以删除任何订单，包括对公单
         */
        BOOL canDel = (user.userType != Enterprise_User);

        if (orderstatus == -99)
        {
            _order_status.text =  @"订单状态: 已删除";
        }
        else if (orderstatus == 2)
        {
            _order_status.text =  @"订单状态: 已支付";
        }
        else if (orderstatus == 3)
        {
            _order_status.text =  @"订单状态: 配送中";
        }
        else if (orderstatus == 4)
        {
            _order_status.text =  @"订单状态: 已签收";
        }
        else if (orderstatus == 5)
        {
            _order_status.text =  @"订单状态: 订单完成";
            
            if (canDel)
            {
                [_delBtn setHidden:NO];
            }
        }
        else if (orderstatus == 6)
        {
            _order_status.text =  @"订单状态: 订单取消";
            if (canDel)
            {
                [_delBtn setHidden:NO];
            }
        }
        else if (orderstatus == 7)
        {
            _order_status.text =  @"订单状态: 已退货";
            if (canDel)
            {
                [_delBtn setHidden:NO];
            }
        }
    }
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter  alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}

-(void)payEvent:(id)sender
{
    HYAlipayOrder *order = [[HYAlipayOrder alloc] init];
    order.partner = PartnerID;
    order.seller = SellerID;
    
    NSMutableString* nameStr = [[NSMutableString alloc]initWithCapacity:0];
    [nameStr appendString:@"【特奢汇鲜花】订单编号:"];
    
    order.tradeNO = _orderListInfo.orderCode; //订单号（由商家自行制定）
    order.productName = [NSString stringWithFormat:@"%@%@",nameStr,_orderListInfo.orderCode]; //商品标题
    order.productDescription = [NSString stringWithFormat:@"%@%@",nameStr,_orderListInfo.orderCode]; //商品描述
    
    if (_orderListInfo.orderCash.floatValue > 0)
    {
        order.amount = _orderListInfo.orderCash; //商品价格
    }
    else
    {
        order.amount = _orderListInfo.orderPayAmount; //商品价格
    }

    HYPaymentViewController* payVC = [[HYPaymentViewController alloc]init];
    payVC.navbarTheme = HYNavigationBarThemeRed;
    payVC.alipayOrder = order;
    payVC.type = Pay_Flower;
    payVC.amountMoney = _orderListInfo.orderPayAmount;
    payVC.payMoney = order.amount;
    payVC.orderID = _orderListInfo.orderId;
    payVC.orderCode = _orderListInfo.orderCode;
    
    __weak typeof(self) bself = self;
    
    payVC.payCallback = ^(BOOL succ, NSError *error){
        //刷新订单列表
        [bself.pushViewController reloadOrderList];
    };
    
    [self.pushViewController.navigationController pushViewController:payVC animated:YES];
}

- (void)deleteOrder:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"确定删除该订单?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"删除", nil];
    alert.tag = 10;
    [alert show];
}

-(void)cancel:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                   message:@"你确定取消该订单吗?"
                                                  delegate:self
                                         cancelButtonTitle:@"点错了"
                                         otherButtonTitles:@"取消订单",nil];
    alert.tag = 11;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != alertView.cancelButtonIndex)
    {
        if (alertView.tag == 10)
        {
            [self.pushViewController deleteOrderAndCell:self];
        }
        else
        {
            [HYLoadHubView show];
            
            _cancelOrderRequest = [[HYFlowerCancelOrderRequest alloc] init];
            _cancelOrderRequest.orderNo = self.orderListInfo.orderCode;
            HYUserInfo* userInfo = [HYUserInfo getUserInfo];
            _cancelOrderRequest.userID = userInfo.userId;
            
            __weak typeof (self)b_self = self;
            [_cancelOrderRequest sendReuqest:^(id result, NSError *error) {
                BOOL succ = NO;
                if (result && [result isKindOfClass:[HYFlowerCancelOrderResponse class]])
                {
                    HYFlowerCancelOrderResponse *response = ( HYFlowerCancelOrderResponse *)result;
                    succ = (response.status == 200);
                }
                
                [b_self cancelResult:succ error:error];
            }];
        }
    }
}
-(void)cancelResult:(BOOL)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    
    if (error)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:error.domain
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        [METoast toastWithMessage:@"订单已经成功取消"];
        
        self.orderListInfo.status = @"6";
        NSIndexPath *index = [self.pushViewController.tableView indexPathForCell:self];
        [self.pushViewController.tableView reloadSections:[NSIndexSet indexSetWithIndex:index.section]
                                         withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_cancelOrderRequest cancel];
    _cancelOrderRequest = nil;
}
@end
