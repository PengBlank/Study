//
//  HYHotelOrderCell.m
//  Teshehui
//
//  Created by ChengQian on 13-12-4.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "HYHotelOrderCell.h"
#import "UIImageView+WebCache.h"
#import "HYUserInfo.h"
#import "HYHotelOrderItemPO.h"
#import "NSDate+Addition.h"
#import "Masonry.h"

@interface HYHotelOrderCell ()
{
    UILabel *_orderNameLab;
    UILabel *_statusLab;
    UILabel *_hotelNameLab;
    UILabel *_checkInTimeLab;
    UILabel *_priceLab;
    UILabel *_pointLab;
    UILabel *_orderNOLab;
    UIImageView *_hotelImgView;
    
    HYHotelOrderItemPO *_orderItemPO;
    CGFloat _org_y;
}

@end

@implementation HYHotelOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _org_y = 0;
        
//        HYUserInfo *user = [HYUserInfo getUserInfo];
        //if (user.userType == Enterprise_User)
        {
            _orderNameLab = [[UILabel alloc]initWithFrame:CGRectMake(116, 10, TFScalePoint(190), 20)];
            _orderNameLab.backgroundColor = [UIColor clearColor];
            _orderNameLab.textColor = [UIColor darkTextColor];
            _orderNameLab.font = [UIFont systemFontOfSize:16.0f];
            [self.contentView addSubview:_orderNameLab];
            _org_y = 30;
        }
        
        _hotelImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _hotelImgView.layer.cornerRadius = 3.0;
        _hotelImgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_hotelImgView];
        [_hotelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(100, 100));
        }];
        
        _hotelNameLab = [[UILabel alloc] initWithFrame:CGRectMake(116, _org_y+6, TFScalePoint(140), 16)];
        _hotelNameLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_hotelNameLab setFont:[UIFont systemFontOfSize:16]];
        _hotelNameLab.backgroundColor = [UIColor clearColor];
        _hotelNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_hotelNameLab];
        [_hotelNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelImgView.mas_right).offset(12);
            make.top.equalTo(_hotelImgView.mas_top).offset(3);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *oLab = [[UILabel alloc] initWithFrame:CGRectMake(116, _org_y+50, 76, 16)];
        oLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [oLab setFont:[UIFont systemFontOfSize:13]];
        oLab.backgroundColor = [UIColor clearColor];
        oLab.textAlignment = NSTextAlignmentLeft;
        oLab.text = @"订单编号:";
        [self.contentView addSubview:oLab];
        [oLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hotelNameLab.mas_left);
            make.top.equalTo(_hotelNameLab.mas_bottom).offset(10);
        }];
        
        _orderNOLab = [[UILabel alloc] initWithFrame:CGRectMake(192, _org_y+50, 200, 16)];
        _orderNOLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_orderNOLab setFont:[UIFont systemFontOfSize:13]];
        _orderNOLab.backgroundColor = [UIColor clearColor];
        _orderNOLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_orderNOLab];
        [_orderNOLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(oLab.mas_left);
            make.top.equalTo(oLab.mas_bottom);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
        
        UILabel *tLab = [[UILabel alloc] initWithFrame:CGRectMake(116, _org_y+74, 76, 16)];
        tLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [tLab setFont:[UIFont systemFontOfSize:13]];
        tLab.backgroundColor = [UIColor clearColor];
        tLab.textAlignment = NSTextAlignmentLeft;
        tLab.text = @"入住时间:";
        [self.contentView addSubview:tLab];
        [tLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_orderNOLab.mas_left);
            make.top.equalTo(_orderNOLab.mas_bottom);
        }];
        _checkInTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(192, _org_y+74, 240, 18)];
        _checkInTimeLab.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        [_checkInTimeLab setFont:[UIFont systemFontOfSize:13]];
        _checkInTimeLab.backgroundColor = [UIColor clearColor];
        _checkInTimeLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_checkInTimeLab];
        [_checkInTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tLab.mas_right);
            make.top.equalTo(tLab.mas_top);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
        
        //价格
//        UILabel *pLab = [[UILabel alloc] initWithFrame:CGRectMake(116, _org_y+28, 16, 16)];
//        pLab.textColor = [UIColor colorWithRed:255.0f/255.0
//                                         green:154.0f/255.0f
//                                          blue:19.0f/255.0f
//                                         alpha:1.0];
//        [pLab setFont:[UIFont systemFontOfSize:13]];
//        pLab.backgroundColor = [UIColor clearColor];
//        pLab.textAlignment = NSTextAlignmentLeft;
//        pLab.text = @"￥";
//        [self.contentView addSubview:pLab];
        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(130, _org_y+28, 100, 16)];
        _priceLab.textColor = [UIColor colorWithRed:190.0f/255.0
                                              green:17.0f/255.0f
                                               blue:40.0f/255.0f
                                              alpha:1.0];
        [_priceLab setFont:[UIFont systemFontOfSize:15]];
        _priceLab.backgroundColor = [UIColor clearColor];
        _priceLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tLab.mas_left);
            make.top.equalTo(tLab.mas_bottom).offset(5);
            
        }];
        
        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(274, _org_y+28, 46, 16)];
        _pointLab.textColor = [UIColor colorWithRed:255.0f/255.0
                                              green:154.0f/255.0f
                                               blue:64.0f/255.0f
                                              alpha:1.0];
        [_pointLab setFont:[UIFont systemFontOfSize:15]];
        _pointLab.backgroundColor = [UIColor clearColor];
        _pointLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_pointLab];
        [_pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_priceLab.mas_right).offset(3);
            make.right.mas_equalTo(-10);
            make.width.equalTo(_priceLab.mas_width).multipliedBy(2);
            make.top.equalTo(_priceLab.mas_top);
        }];
        
//        UIImageView *statusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(250), _org_y+4, 66, 20)];
//        statusImageView.image = [[UIImage imageNamed:@"person_buttom_orange3_normal"] stretchableImageWithLeftCapWidth:10
//                                                                                                          topCapHeight:10];
        _statusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 66, 20)];
        _statusLab.textColor = [UIColor whiteColor];
        [_statusLab setFont:[UIFont systemFontOfSize:13]];
        _statusLab.backgroundColor = [UIColor colorWithRed:255/255.0 green:152/255.0 blue:54/255.0 alpha:1];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.layer.cornerRadius = 3.0;
        _statusLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_statusLab];
        [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(52);
            make.right.mas_equalTo(-10);
            make.top.equalTo(oLab.mas_top);
            make.height.mas_equalTo(24);
        }];
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

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.imageView.frame = CGRectMake(6, 6, 102, 99);
//}

- (void)setOrder:(HYHotelOrderDetail *)order
{
    if (order != _order)
    {
        _order = order;
        
        _orderItemPO = order.orderItemPOList[0];
        
        _hotelNameLab.text = _orderItemPO.productName;
        NSNumber *orderPayAmountNumber = [NSNumber numberWithFloat:[order.orderPayAmount floatValue]];
        _priceLab.text = [NSString stringWithFormat:@"￥%@",orderPayAmountNumber];
        _pointLab.text = [NSString stringWithFormat:@"赠现金券:%@", _orderItemPO.points];
        _orderNOLab.text = order.orderCode;
        _checkInTimeLab.text = order.startTimeSpanDate;
        [_hotelImgView sd_setImageWithURL:[NSURL URLWithString:[order.orderItemPOList[0] hotelLogo]]
                       placeholderImage:[UIImage imageNamed:@"loading"]];
        
        HYUserInfo *user = [HYUserInfo getUserInfo];
        if (user.userType == Enterprise_User)
        {
            NSString *userName = [order buyerNick];
            if (order.orderType == 0 && [userName length] <= 0)
            {
                userName = @"当前账号";
            }
            
            _orderNameLab.text = [NSString stringWithFormat:@"下单人：%@", userName];
        }
    }
    
    _statusLab.text = order.orderStatusDesc;
}


@end
