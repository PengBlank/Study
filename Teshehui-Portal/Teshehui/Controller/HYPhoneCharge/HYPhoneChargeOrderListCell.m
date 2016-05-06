//
//  HYPhoneChargeOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYPhoneChargeOrderListCell.h"
#import "HYPhoneChargeOrderListModel.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kMargin 5
#define kColor [UIColor colorWithWhite:0.4 alpha:1.0]
#define kLabelFont [UIFont systemFontOfSize:15]

typedef NS_ENUM(NSInteger, OrderStatus) // 订单状态
{
    kOrderStatusWatingPay  = 10,
    kOrderStatusUncomplete = 20,
    kOrderStatusComplete   = 30,
    kOrderStatusClose      = 40,
    kOrderStatusSomePay    = 60,
};

@interface HYPhoneChargeOrderListCell ()

@property (nonatomic, strong) UIView *topV;
@property (nonatomic, strong) UIView *middleV;
@property (nonatomic, strong) UIView *bottomV;

@property (nonatomic, strong) UILabel *orderLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *chargeNum;
@property (nonatomic, strong) UILabel *data;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *point;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) UIView *middleViewLineView;

@property (nonatomic, assign) RechargeType type;
@property (nonatomic, assign) OrderStatus  status;

@end

@implementation HYPhoneChargeOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupCell];
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *phoneChargeOrderListCellID = @"phoneChargeOrderListCellID";
    HYPhoneChargeOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneChargeOrderListCellID];
    if (!cell)
    {
        cell = [[HYPhoneChargeOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:phoneChargeOrderListCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorLeftInset = 0;
    }
    
    return cell;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    _topV.frame = CGRectMake(0, 0, kWidth, 40);
//    _middleV.frame = CGRectMake(0, CGRectGetMaxY(_topV.frame)+4, kWidth, 120);
////    _middleV.backgroundColor = [UIColor blueColor];
//    _bottomV.frame = CGRectMake(0, CGRectGetMaxY(_middleV.frame)+4, kWidth, 50);
////    _bottomV.backgroundColor = [UIColor redColor];
//}

- (void)setupCell
{
    [self setupTopView];
    
    [self setupMiddleView];
    
    [self setupBottomView];
}

- (void)setupTopView
{
    UIView *topV = [[UIView alloc] init];
    [self.contentView addSubview:topV];
    _topV = topV;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.frame = CGRectMake(0, 0, kWidth, 5);
    topLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [topV addSubview:topLine];
    
    CGFloat y = CGRectGetMaxY(topLine.frame)+5;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, y+8, 15, 15)];
    [imageV setImage:[UIImage imageNamed:@"mallOrder_order"]];
    [topV addSubview:imageV];
    
    UILabel *orderLabel = [[UILabel alloc] init];
    _orderLabel = orderLabel;
    orderLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    orderLabel.textColor = kColor;
    orderLabel.font = kLabelFont;
    orderLabel.frame = CGRectMake(CGRectGetMaxX(imageV.frame)+5, y, TFScalePoint(220), 30);
//    orderLabel.text = @"订单号码:M3904390343";
    [topV addSubview:orderLabel];
    
    UILabel *statusLabel = [[UILabel alloc] init];
    _statusLabel = statusLabel;
    _statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.textColor = kColor;
    statusLabel.font = kLabelFont;
    statusLabel.frame = CGRectMake(kWidth-80, y, 70, 30);
//    statusLabel.text = @"已完成";
    [topV addSubview:statusLabel];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    lineV.frame = CGRectMake(kMargin, CGRectGetMaxY(orderLabel.frame)+4, kWidth-10, 0.5);
    [topV addSubview:lineV];
    
    _topV.frame = CGRectMake(0, 0, kWidth, CGRectGetMaxY(lineV.frame));
}

- (void)setupMiddleView
{
    UIView *middleV = [[UIView alloc] init];
    [self.contentView addSubview:middleV];
    _middleV = middleV;
    
    UILabel *chargeNum = [[UILabel alloc] init];
    _chargeNum = chargeNum;
    chargeNum.textColor = kColor;
    chargeNum.font = kLabelFont;
    chargeNum.frame = CGRectMake(kMargin, 5, 200, 20);
//    chargeNum.text = @"充值号码:183 0000 1234";
    [middleV addSubview:chargeNum];
    
    CGFloat width = 230;
    
    UILabel *data = [[UILabel alloc] init];
    _data = data;
    data.textColor = kColor;
    data.font = kLabelFont;
    data.frame = CGRectMake(kMargin, CGRectGetMaxY(chargeNum.frame)+5, width, 20);
//    data.text = @"流量:70M";
    [middleV addSubview:data];

    UILabel *time = [[UILabel alloc] init];
    _time = time;
    time.textColor = kColor;
    time.font = kLabelFont;
    time.frame = CGRectMake(kMargin, CGRectGetMaxY(data.frame)+5, width, 20);
//    time.text = @"创建时间:2015-11-27 11:32:55";
    [middleV addSubview:time];

    UILabel *price = [[UILabel alloc] init];
    _price = price;
    price.textColor = kColor;
    price.font = kLabelFont;
    price.frame = CGRectMake(kMargin, CGRectGetMaxY(time.frame)+5, width, 20);
//    price.text = @"订单金额:￥9.50";
    [middleV addSubview:price];
    
    UILabel *point = [[UILabel alloc] init];
    _point = point;
    point.textColor = kColor;
    point.font = kLabelFont;
    point.frame = CGRectMake(kMargin, CGRectGetMaxY(price.frame)+5, width, 20);
//    point.text = @"赠现金券:9.50";
    [middleV addSubview:point];
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    lineV.frame = CGRectMake(kMargin, CGRectGetMaxY(point.frame)+4, kWidth-10, 0.5);
    [middleV addSubview:lineV];
    _middleViewLineView = lineV;
}

- (void)setupBottomView
{
    UIView *bottomV = [[UIView alloc] init];
    [self.contentView addSubview:bottomV];
    _bottomV = bottomV;
    
    UILabel *descLabel = [[UILabel alloc] init];
    _descLabel = descLabel;
    descLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    descLabel.font = kLabelFont;
    descLabel.frame = CGRectMake(kMargin, 10, TFScalePoint(300), 30);
//    descLabel.text = @"失败的订单将自动返还支付金额";
    [bottomV addSubview:descLabel];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn = cancelBtn;
    [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitleColor:kColor forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(kWidth-160, 10, 70, 30);
    cancelBtn.titleLabel.font = kLabelFont;
    [cancelBtn setBackgroundImage:[[UIImage imageNamed:@"button_orderlist_phonecharge"]stretchableImageWithLeftCapWidth:2 topCapHeight:2]
                         forState:UIControlStateNormal];
    [bottomV addSubview:cancelBtn];
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _payBtn = payBtn;
    [payBtn setTitle:@"去付款" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(payBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [payBtn setTitleColor:kColor forState:UIControlStateNormal];
    payBtn.frame = CGRectMake(CGRectGetMaxX(cancelBtn.frame)+5, 10, 70, 30);
    payBtn.titleLabel.font = kLabelFont;
    [payBtn setBackgroundImage:[[UIImage imageNamed:@"button_orderlist_phonecharge"]stretchableImageWithLeftCapWidth:2 topCapHeight:2]
                         forState:UIControlStateNormal];
    [bottomV addSubview:payBtn];
}

- (void)setModel:(HYPhoneChargeOrderListModel *)model
{
    _model = model;
    
    _orderLabel.text = [NSString stringWithFormat:@"订单号码: %@", model.orderCode];
    
    _status = model.orderStatus;
    switch (_status) {
        case kOrderStatusClose:
            _statusLabel.text = @"已关闭";
            
            _payBtn.hidden = NO;
            _descLabel.hidden = YES;
            _cancelBtn.hidden = YES;
            [_payBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
        case kOrderStatusComplete:
            _statusLabel.text = @"已完成";
            
            _cancelBtn.hidden = YES;
            _descLabel.hidden = YES;
            _payBtn.hidden = NO;
            [_payBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            break;
        case kOrderStatusSomePay:
            _statusLabel.text = @"部分付款";
            
            _payBtn.hidden = NO;
            _cancelBtn.hidden = NO;
            _descLabel.hidden = YES;
            [_payBtn setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        case kOrderStatusUncomplete:
            _statusLabel.text = @"未完成";
            
            _descLabel.text = @"正在充值中,若充值失败将自动返还支付金额";
            _descLabel.hidden = NO;
            _payBtn.hidden = YES;
            _cancelBtn.hidden = YES;
            break;
        case kOrderStatusWatingPay:
            _statusLabel.text = @"待付款";
            _descLabel.hidden = YES;
            _payBtn.hidden = NO;
            _cancelBtn.hidden = NO;
            [_payBtn setTitle:@"去付款" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    NSString *headSub = [model.rechargeTelephone substringWithRange:NSMakeRange(0, 3)];
    NSString *middleSub = [model.rechargeTelephone substringWithRange:NSMakeRange(3, 4)];
    NSString *tailSub = [model.rechargeTelephone substringWithRange:NSMakeRange(7, 4)];
    _chargeNum.text = [NSString stringWithFormat:@"充值号码: %@ %@ %@", headSub, middleSub, tailSub];
    
    _type = model.rechargeType;
    switch (_type) {
        case kRechargeTypePhoneNum:
            _data.text = [NSString stringWithFormat:@"面值       : %@", model.productName];
            break;
        case kRechargeTypedata:
            _data.text = [NSString stringWithFormat:@"流量       : %ldM", (long)model.rechargeFlow];
            break;
        default:
            break;
    }
    
    _time.text = [NSString stringWithFormat:@"创建时间: %@", model.createTimeStr];
    _price.text = [NSString stringWithFormat:@"订单金额:￥ %@", model.orderTradeAmount];
    
    if (model.cashCoupon.length > 0)
    {
        _point.text = [NSString stringWithFormat:@"赠现金券: %@", model.cashCoupon];
        _middleViewLineView.frame = CGRectMake(kMargin, CGRectGetMaxY(_point.frame)+4, kWidth-10, 0.5);
    }
    else
    {
        _point.text = @"";
        _middleViewLineView.frame = CGRectMake(kMargin, CGRectGetMaxY(_price.frame)+4, kWidth-10, 0.5);
    }
    
    _middleV.frame = CGRectMake(0, CGRectGetMaxY(_topV.frame), kWidth, CGRectGetMaxY(_middleViewLineView.frame));
    
    _bottomV.frame = CGRectMake(0, CGRectGetMaxY(_middleV.frame), kWidth, 50);
}

- (void)cancelBtnDidClicked:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(cancelBtnAction:)])
    {
        [self.delegate cancelBtnAction:_model];
    }
}

- (void)payBtnDidClicked:(UIButton *)btn
{
    if (_status == kOrderStatusComplete || _status == kOrderStatusClose)
    {
        if ([self.delegate respondsToSelector:@selector(deleteAction:)])
        {
            [self.delegate deleteAction:_model];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(payAction:)])
        {
            [self.delegate payAction:_model];
        }
    }
}


@end
