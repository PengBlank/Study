//
//  HYMovieTicketOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 16/2/24.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMovieTicketOrderListCell.h"
#import "HYMovieTicketOrderListFrame.h"
#import "HYMovieTicketOrderListModel.h"

#define labelFont [UIFont systemFontOfSize:15]
#define kMargin 5

typedef NS_ENUM(NSInteger, MovieTickeorderStatus)
{
    kMovieTickeorderStatusWatingHandle = 1,
    kMovieTickeorderStatusSuccess,
    kMovieTickeorderStatusFail
};

@interface HYMovieTicketOrderListCell ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *orderCodeLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *address;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *countsLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UILabel *PayStatusLabel;
@property (nonatomic, assign) MovieTickeorderStatus status;

@end

@implementation HYMovieTicketOrderListCell

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
    static NSString *MovieTicketCellID = @"MovieTicketCellID";
    HYMovieTicketOrderListCell *MovieTicketCell = [tableView dequeueReusableCellWithIdentifier:MovieTicketCellID];
    if (!MovieTicketCell)
    {
        MovieTicketCell = [[HYMovieTicketOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MovieTicketCellID];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MovieTicketCell.selectionStyle = UITableViewCellSelectionStyleNone;
        MovieTicketCell.separatorLeftInset = 0;
    }
    
    return MovieTicketCell;
};

- (void)setupCell
{
    _topView = [[UIView alloc] init];
    _topView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
    [self.contentView addSubview:_topView];
    
    _picImageView = [[UIImageView alloc] init];
    [_picImageView setImage:[UIImage imageNamed:@"icon_order_movieTicket_redStatus"]];
    [self.contentView addSubview:_picImageView];
    
    _orderCodeLabel = [[UILabel alloc] init];
    _orderCodeLabel.font = labelFont;
//    _orderCodeLabel.text = @"功夫熊猫3  1张";
    [self.contentView addSubview:_orderCodeLabel];
    
    _cityLabel = [[UILabel alloc] init];
    _cityLabel.font = labelFont;
//    _cityLabel.text = @"观影时间 2016-02-01 13:15";
    [self.contentView addSubview:_cityLabel];
    
    _addressLabel = [[UILabel alloc] init];
    _addressLabel.font = labelFont;
//    _addressLabel.text = @"华夏君盛影城平湖店";
    [self.contentView addSubview:_addressLabel];
    
    _address = [[UILabel alloc] init];
    _address.numberOfLines = 2;
    _address.font = labelFont;
    [self.contentView addSubview:_address];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = labelFont;
//    _priceLabel.text = @"￥48.00";
    [self.contentView addSubview:_priceLabel];
    
    _countsLabel = [[UILabel alloc] init];
    _countsLabel.font = labelFont;
//    _countsLabel.text = @"票数:88";
    [self.contentView addSubview:_countsLabel];
    
    _pointLabel = [[UILabel alloc] init];
    _pointLabel.font = labelFont;
//    _pointLabel.text = @"赠现金券: 88";
    [self.contentView addSubview:_pointLabel];
    
    _PayStatusLabel = [[UILabel alloc] init];
    _PayStatusLabel.font = labelFont;
    _PayStatusLabel.textColor = [UIColor redColor];
//    _PayStatusLabel.text = @"下单成功";
    [self.contentView addSubview:_PayStatusLabel];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];

//    self.topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), 5);

//    self.picImageView.frame = CGRectMake(10, (CGRectGetHeight(self.contentView.frame)-5-40)/2, 40, 40);

//    CGFloat y;
//    for (NSInteger i = 0; i < 5; i++)
//    {
//        y = 12;
//        y = y + (i*12 + i*15);
//        
//        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picImageView.frame)+10, y, 2, 15)];
//        lineV.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0f];
//        [self.contentView addSubview:lineV];
//    }
    
//    CGFloat x = CGRectGetMaxX(self.picImageView.frame)+10;
//    CGFloat width = 170;
//    self.orderCodeLabel.frame = CGRectMake(x, 10+kMargin, 230, 15);
//    
//    self.cityLabel.frame = CGRectMake(x, CGRectGetMaxY(self.orderCodeLabel.frame)+kMargin, width, 15);

//    self.addressLabel.frame = CGRectMake(CGRectGetMinX(self.orderCodeLabel.frame), CGRectGetMaxY(self.cityLabel.frame)+kMargin, 230, 15);
    
//    self.priceLabel.frame = CGRectMake(CGRectGetMinX(self.orderCodeLabel.frame), CGRectGetMaxY(self.addressLabel.frame)+kMargin, width, 15);
//    
//    self.countsLabel.frame = CGRectMake(CGRectGetMinX(self.orderCodeLabel.frame), CGRectGetMaxY(self.priceLabel.frame)+kMargin, width, 15);
//    
//    self.pointLabel.frame = CGRectMake(CGRectGetMinX(self.orderCodeLabel.frame), CGRectGetMaxY(self.countsLabel.frame)+kMargin, width, 15);

//    CGFloat PayX = TFScalePoint(320)-90;
//    self.PayStatusLabel.frame = CGRectMake(PayX, CGRectGetMaxY(self.addressLabel.frame), 80, 30);
//    self.PayStatusLabel.frame = CGRectMake(CGRectGetMaxX(self.addressLabel.frame)+10, CGRectGetMaxY(self.cityLabel.frame), 80, 30);
//}

//- (void)setModel:(HYMovieTicketOrderListModel *)model
//{
//    _model = model;
//    
//    self.orderCodeLabel.text = [NSString stringWithFormat:@"订单号     : %@", _model.orderCode];
//    
//    self.cityLabel.text = [NSString stringWithFormat:@"购票城市 : %@", _model.cityName];
//    
//    self.addressLabel.text = [NSString stringWithFormat:@"影院名称 : %@", _model.cinemaName];
//    
//    self.priceLabel.text = [NSString stringWithFormat:@"单价         : %@元", _model.singlePrice];
//    
//    self.countsLabel.text = [NSString stringWithFormat:@"票数         : %ld张", (long)_model.counts];
//    
//    if (_model.cashCoupon)
//    {
//        self.pointLabel.text = [NSString stringWithFormat:@"赠现金券 : %@", _model.cashCoupon];
//    }
//    
//    _status = model.orderStatus;
//    switch (_status)
//    {
//        case kMovieTickeorderStatusWatingHandle:
//            self.PayStatusLabel.text = @"处理中";
//            break;
//        case kMovieTickeorderStatusSuccess:
//            self.PayStatusLabel.text = @"下单成功";
//            break;
//        case kMovieTickeorderStatusFail:
//            self.PayStatusLabel.text = @"下单失败";
//            [_picImageView setImage:[UIImage imageNamed:@"icon_order_movieTicket_grayStatus"]];
//            [self setupLabelColor];
//            break;
//        default:
//            break;
//    }
//}

- (void)setCellFrame:(HYMovieTicketOrderListFrame *)cellFrame
{
    HYMovieTicketOrderListModel *model = cellFrame.model;
    
    self.topView.frame = cellFrame.topViewFrame;
    
    self.picImageView.frame = cellFrame.picImageViewFrame;
    
    self.orderCodeLabel.frame = cellFrame.orderCodeLabelFrame;
    self.orderCodeLabel.text = [NSString stringWithFormat:@"订单号     : %@", model.orderCode];
    
    self.cityLabel.frame = cellFrame.cityLabelFrame;
    self.cityLabel.text = [NSString stringWithFormat:@"购票城市 : %@", model.cityName];

    self.addressLabel.frame = cellFrame.addressLabelFrame;
    self.addressLabel.text = @"影院名称 : ";
    
    self.address.frame = cellFrame.addressFrame;
    self.address.text = model.cinemaName;

    self.priceLabel.frame = cellFrame.priceLabelFrame;
    self.priceLabel.text = [NSString stringWithFormat:@"单价         : %@元", model.singlePrice];

    self.countsLabel.frame = cellFrame.countsLabelFrame;
    self.countsLabel.text = [NSString stringWithFormat:@"票数         : %ld张", (long)model.counts];

    if (model.cashCoupon.length > 0)
    {
        self.pointLabel.frame = cellFrame.pointLabelFrame;
        self.pointLabel.text = [NSString stringWithFormat:@"赠现金券 : %@", model.cashCoupon];
    }

    self.PayStatusLabel.frame = cellFrame.PayStatusLabelFrame;
    _status = model.orderStatus;
    switch (_status)
    {
        case kMovieTickeorderStatusWatingHandle:
            self.PayStatusLabel.text = @"处理中";
            break;
        case kMovieTickeorderStatusSuccess:
            self.PayStatusLabel.text = @"下单成功";
            break;
        case kMovieTickeorderStatusFail:
            self.PayStatusLabel.text = @"下单失败";
            [_picImageView setImage:[UIImage imageNamed:@"icon_order_movieTicket_grayStatus"]];
            [self setupLabelColor];
            break;
        default:
            break;
    }
}

- (void)setupLabelColor
{
    NSArray *arr = [[NSArray alloc] initWithObjects:self.orderCodeLabel,self.cityLabel,self.addressLabel,self.priceLabel,self.countsLabel,self.pointLabel,self.PayStatusLabel,self.address,nil];
    for (UILabel *label in arr)
    {
        [self setupColorWithLabel:label];
    }
}

- (void)setupColorWithLabel:(UILabel *)label
{
    label.textColor = [UIColor grayColor];
}

@end
