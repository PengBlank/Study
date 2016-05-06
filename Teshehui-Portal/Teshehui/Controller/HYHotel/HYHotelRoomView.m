//
//  HYHotelRoomView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRoomView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"


@interface HYHotelRoomView ()
{

}

@property (nonatomic, strong) CAAnimation *dimingAnimation;
@property (nonatomic, strong) CAAnimation *showMenuAnimation;
@property (nonatomic, strong) CAAnimation *dismissMenuAnimation;
@property (nonatomic, strong) CAAnimation *lightingAnimation;

//@property (nonatomic, strong) HYHotelRoom *roomInfo;
@property (nonatomic, strong) HYHotelSKU *roomSKU;


@end

@implementation HYHotelRoomView

@synthesize delegate = _delegate;

- (id)initWithRoomInfo:(HYHotelSKU *)roomSKU
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (self = [super initWithSize:bounds.size])
    {
        self.backgroundColor = [UIColor clearColor];
        self.dimAlpha = .9;
        
        
        self.roomSKU = roomSKU;
        
        
        //关闭按钮
        UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
        [closeBtn setImage:[UIImage imageNamed:@"icon_close2"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismissView:)
           forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-5);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        //名称
        UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLab.font = [UIFont systemFontOfSize:17.0];
        nameLab.textColor = [UIColor whiteColor];
        nameLab.backgroundColor = [UIColor clearColor];
        nameLab.text = roomSKU.roomRatePlanName;
        [self addSubview:nameLab];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(40);
            make.right.mas_lessThanOrEqualTo(-30);
            
        }];
        
        //图片
        UIImageView *hotelImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        hotelImg.layer.cornerRadius = 2;
        hotelImg.layer.masksToBounds = YES;
        hotelImg.layer.borderColor = [UIColor colorWithWhite:.36 alpha:1].CGColor;
        hotelImg.layer.borderWidth = 2.0;
        [self addSubview:hotelImg];
        [hotelImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.right.mas_equalTo(-30);
            make.top.equalTo(nameLab.mas_bottom).offset(10);
            make.height.equalTo(hotelImg.mas_width).multipliedBy(0.6);
        }];
        if (self.roomSKU.bigLogoUrl.length> 0)
        {
            [hotelImg sd_setImageWithURL:[NSURL URLWithString:self.roomSKU.bigLogoUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
        }
        else
        {
            hotelImg.image = [UIImage imageNamed:@"loading"];
        }
        
        //信息
        UIView *indicate = hotelImg;
        NSMutableArray *infos = [NSMutableArray array];
        
        //面积
        if (self.roomSKU.areaSize.length > 0)
        {
            NSString *info = [NSString stringWithFormat:@"面积 %@平方米", self.roomSKU.areaSize];
            [infos addObject:@{@"info": info,
                               @"icon": @"hotel_icon_1"}];
        }
        
        
        if (self.roomSKU.standardOccupancy != 0)
        {
            NSString *info =[NSString stringWithFormat:@"可住 %ld人", (long)self.roomSKU.standardOccupancy];
            [infos addObject:@{@"info": info,
                               @"icon": @"hotel_icon_2"}];
        }
        
        //楼层
        if (self.roomSKU.floor.length > 0)
        {
            NSString *info = [NSString stringWithFormat:@"楼层 %@", self.roomSKU.floor];
            [infos addObject:@{@"info": info,
                               @"icon": @"hotel_icon_3"}];
        }
        
        //床型
        if (self.roomSKU.bedType.length > 0)
        {
            NSString *info = [NSString stringWithFormat:@"床型 %@", self.roomSKU.bedType];
            [infos addObject:@{@"info": info,
                               @"icon": @"hotel_icon_4"}];
        }
        
        if (self.roomSKU.wifi != 0 || self.roomSKU.broadBand != 0)
        {
            //宽带
            NSString *board = @"";
            switch (self.roomSKU.wifi)
            {
                case 1:
                    board = @"免费wifi";
                    break;
                case 2:
                    board = @"收费wifi";
                    break;
                default:
                    break;
            }
            if (board.length > 0)
            {
                board = [board stringByAppendingString:@" "];
            }
            if (self.roomSKU.broadBand == 1)
            {
                board = [board stringByAppendingString:@"免费有线网络"];
            }
            else if (self.roomSKU.broadBand == 2)
            {
                board = [board stringByAppendingString:@"收费有线网络"];
            }
            [infos addObject:@{@"info": board,
                               @"icon": @"hotel_icon_6"}];
        }
        
        
        //早餐
        if (self.roomSKU.numberOfBreakfast > 0)
        {
            NSString *info = [NSString stringWithFormat:@"%ld早餐", (long)self.roomSKU.numberOfBreakfast];
            [infos addObject:@{@"info": info,
                               @"icon": @"hotel_icon_7"}];
        }
        
        for (NSInteger i = 0; i < infos.count && i < 8; i++)
        {
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectZero];
            icon.image = [UIImage imageNamed:infos[i][@"icon"]];
            [self addSubview:icon];
            [icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(hotelImg.mas_left);
                make.top.equalTo(indicate.mas_bottom).offset(10);
//                make.size.mas_equalTo(CGSizeMake(14, 14));
            }];
            
            UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            infoLabel.textColor = [UIColor whiteColor];
            infoLabel.backgroundColor = [UIColor clearColor];
            infoLabel.font = [UIFont systemFontOfSize:14.0];
            infoLabel.text = infos[i][@"info"];
            [self addSubview:infoLabel];
            [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(icon.mas_right).offset(5);
                make.centerY.equalTo(icon.mas_centerY);
                make.right.mas_lessThanOrEqualTo(-30);
            }];
            
            indicate = icon;
        }
        
        //foot 下单
        UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
        footView.backgroundColor = [UIColor whiteColor];
        [self addSubview:footView];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        UILabel *total = [[UILabel alloc] initWithFrame:CGRectZero];
        total.text = @"总额:";
        total.textColor = [UIColor grayColor];
        total.backgroundColor = [UIColor clearColor];
        total.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:total];
        [total mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.centerY.equalTo(footView.mas_centerY);
        }];
        
        NSString *orderTitle = _roomSKU.isPrePay ? @"立即预付" : @"立即预订";
        UIButton *orderBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [orderBtn setTitle:orderTitle forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(advanceBooking:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:153/255.0 blue:19/255.0 alpha:1];
        orderBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [orderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footView addSubview:orderBtn];
        [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
        UILabel *priceLab = [[UILabel alloc] initWithFrame:CGRectZero];
        priceLab.backgroundColor = [UIColor clearColor];
        priceLab.textColor = [UIColor colorWithRed:224/255.0 green:2/255.0 blue:43/255.0 alpha:1];
        [footView addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(total.mas_right).offset(10);
            make.right.equalTo(orderBtn.mas_left);
            make.top.mas_equalTo(5);
        }];
        
        NSString *price = [NSString stringWithFormat:@"￥%@", @(_roomSKU.averageFee)];
        NSMutableAttributedString *priceattr = [[NSMutableAttributedString alloc] initWithString:price];
        [priceattr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11.0]} range:NSMakeRange(0, 1)];
        [priceattr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} range:NSMakeRange(1, price.length-1)];
        priceLab.attributedText = priceattr;
        
        UILabel *pointLab = [[UILabel alloc] initWithFrame:CGRectZero];
        pointLab.backgroundColor = [UIColor clearColor];
        pointLab.textColor = [UIColor colorWithRed:255/255.0 green:126/255.0 blue:50/255.0 alpha:1];
        pointLab.font = [UIFont systemFontOfSize:12.0];
        pointLab.text = [NSString stringWithFormat:@"赠送现金券:%@", _roomSKU.points];
        [self addSubview:pointLab];
        [pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(priceLab.mas_left);
            make.top.equalTo(priceLab.mas_bottom).offset(3);
            make.right.lessThanOrEqualTo(orderBtn.mas_left);
        }];
    }
    return self;
}

- (void)advanceBooking:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(advanceBookingRoom:)])
    {
        [self.delegate advanceBookingRoom:self.roomSKU];
    }
    
    [self dismissWithAnimation:YES];
}

- (void)dismissView:(UIButton *)btn
{
    [self dismissWithAnimation:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
