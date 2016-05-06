//
//  BilliardsOrderCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardsOrderCell.h"
#import "UIColor+expanded.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
@implementation BilliardsOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _topMarkImage = [[UIImageView alloc] init];
        [_topMarkImage      setImage:IMAGE(@"store")];
        [self.contentView addSubview:_topMarkImage];

        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:g_fitSystemFontSize(@[@15,@16,@17])];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_titleLabel];
        
        _tableNo = [[UILabel alloc] init];
        [_tableNo setFont:g_fitSystemFontSize(@[@14,@15,@16])];
        [_tableNo setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_tableNo];
        
        _topLineView = [[UIView alloc] init];
        [_topLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_topLineView];
        
        _logoImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_logoImage];
        
        _orderNo = [[UILabel alloc] init];
        [_orderNo setFont:g_fitSystemFontSize(@[@14,@15,@16])];
        [_orderNo setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_orderNo];
        
        _tablePrice = [[UILabel alloc] init];
        [_tablePrice setFont:g_fitSystemFontSize(@[@13,@14,@15])];
        [_tablePrice setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_tablePrice];

        
        _startTime = [[UILabel alloc] init];
        [_startTime setFont:g_fitSystemFontSize(@[@14,@15,@16])];
        [_startTime setTextColor:[UIColor colorWithHexString:@"606060"]];
        [self.contentView addSubview:_startTime];
        
        _tableStatus = [[UILabel alloc] init];
        [_tableStatus setFont:g_fitSystemFontSize(@[@14,@15,@16])];
        [_tableStatus setTextColor:[UIColor colorWithHexString:@"b80000"]];
        [self.contentView addSubview:_tableStatus];
        
        _bottomLineView = [[UIView alloc] init];
        [_bottomLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_bottomLineView];
        _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
       
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
        [_buyButton.titleLabel setFont:g_fitSystemFontSize(@[@12,@13,@14])];
        [_buyButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buyButton.layer setCornerRadius:5];
        [_buyButton.layer setBorderWidth:0.8f];
        [_buyButton.layer setBorderColor:[UIColor colorWithHexString:@"606060"].CGColor];
        [self.contentView addSubview:_buyButton];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);

    [_topMarkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(17.5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    

    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).mas_equalTo(50);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];

    [_logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom).offset(15);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(ScaleWIDTH(60), ScaleWIDTH(60)));
    }];
    
    [_startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.logoImage.mas_right).offset(10);
        make.bottom.mas_equalTo(weakSelf.logoImage.mas_bottom);
    }];
    

    [_orderNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.logoImage.mas_top);
        make.left.mas_equalTo(weakSelf.logoImage.mas_right).offset(10);
    }];
    
    [_tableNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.logoImage.mas_right).offset(10);
        make.centerY.mas_equalTo(weakSelf.logoImage.mas_centerY);
    }];
    
    [_tableStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-12.5);
        make.centerY.mas_equalTo(weakSelf.topMarkImage.mas_centerY);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.topMarkImage.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf.topMarkImage.mas_centerY);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.logoImage.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
        make.top.mas_equalTo(weakSelf.bottomLineView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(75, g_fitFloat(@[@25,@28,@30])));
        
    }];

}

- (void)bindData:(BilliardsOrderInfo *)baseInfo type:(NSInteger)type{
    self.orderInfo = baseInfo;
    
    if (baseInfo== nil) {
        return;
    }
    
    _titleLabel.text  = baseInfo.MerchantName;
    
    NSString *urlStirng = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",baseInfo.MerchantLogo,@"180",@"180"];
    [_logoImage sd_setImageWithURL:[NSURL URLWithString:urlStirng] placeholderImage:[UIImage imageNamed:@"loading"]];
  
    _tableNo.text       = baseInfo.TableName;
    _orderNo.text       = baseInfo.PcOrderNum; //统一显示桌球本地订单号。
    
    if (type == 1) { //已付款tab
        
        if (baseInfo.PayStatus.integerValue == 4) {
            _buyButton.enabled = NO;
            [_buyButton setTitle:@"已评价" forState:UIControlStateNormal];
            [_buyButton.layer setCornerRadius:0];
            [_buyButton.layer setBorderWidth:0.0f];
        }else{
            _buyButton.enabled = YES;
            [_buyButton setTitle:@"去评价" forState:UIControlStateNormal];
            [_buyButton.layer setCornerRadius:5];
            [_buyButton.layer setBorderWidth:0.8f];
            [_buyButton.layer setBorderColor:[UIColor colorWithHexString:@"62666c"].CGColor];
        }
        
        CGFloat money = baseInfo.OrderAmount.floatValue;
        CGFloat coupon = baseInfo.OrderCoupon.floatValue;
        
        if(coupon == 0 && money != 0){
            
            _tablePrice.text  = [NSString stringWithFormat:@"%@ ￥%@",baseInfo.PayType,baseInfo.OrderAmount];
            
        }else if (coupon != 0 && money == 0){
            
            _tablePrice.text  = [NSString stringWithFormat:@"%@ %@现金券",baseInfo.PayType,baseInfo.OrderCoupon];
            
        }else if (coupon != 0 && money != 0){
            _tablePrice.text  = [NSString stringWithFormat:@"%@ ￥%@ + %@现金券",baseInfo.PayType,baseInfo.OrderAmount,baseInfo.OrderCoupon];
        }
        
        _startTime.text   = baseInfo.StartTime;    //在这个tab里面 _startTime 作为收台时间使用。
        
        WS(weakSelf);
        
        if (!_imageV) {
            
            _imageV = [[UIImageView alloc] init];
            [_imageV setImage:[UIImage imageNamed:@"arrowright"]];
            [self.contentView addSubview:_imageV];
            
            [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.topLineView.mas_bottom).offset(35);
                make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-20);
            }];
        }
        
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: _tablePrice.text? :@""];
        if (str.length > 0) {
            
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(baseInfo.PayType.length + 1,str.length - (baseInfo.PayType.length + 1))];
            
        }
        _tablePrice.attributedText = str;

        
        [_tablePrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.buyButton.mas_centerY);
            make.left.mas_equalTo(weakSelf.logoImage.mas_left);
        }];
        
       
    }else{ //未付款
        
        _startTime.text   = baseInfo.StartTime;
        _tableStatus.text = baseInfo.TableStatus;
        
        if (baseInfo.EndTime.length == 0) {
            
             [_buyButton setTitle:@"购买&呼叫" forState:UIControlStateNormal];
            
             _tablePrice.text  = [NSString stringWithFormat:@"开台价 %@",baseInfo.RateByHourCoupon];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: _tablePrice.text ? : @""];
            if (str.length > 0) {
                
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(4,str.length - 4)];
                
            }
            _tablePrice.attributedText = str;
            
        }else{
            
             [_buyButton setTitle:@"去支付" forState:UIControlStateNormal];
            
            CGFloat money = baseInfo.OrderAmount.floatValue;
            CGFloat coupon = baseInfo.OrderCoupon.floatValue;
            
            if(coupon == 0 && money != 0){
                
                _tablePrice.text  = [NSString stringWithFormat:@"消费金额 ￥%@",baseInfo.OrderAmount];
                
            }else if (coupon != 0 && money == 0){
                
                _tablePrice.text  = [NSString stringWithFormat:@"消费金额 %@现金券",baseInfo.OrderCoupon];
                
            }else if (coupon != 0 && money != 0){
                _tablePrice.text  = [NSString stringWithFormat:@"消费金额 ￥%@ + %@现金券",baseInfo.OrderAmount,baseInfo.OrderCoupon];
            }else{
                 _tablePrice.text  = @"消费金额 ";
            }
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: _tablePrice.text ? : @""];
            if (str.length > 0) {
                
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"b80000"] range:NSMakeRange(5,str.length - 5)];
                
            }
            _tablePrice.attributedText = str;
        }

        WS(weakSelf);
        [_tablePrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf.buyButton.mas_centerY);
            make.left.mas_equalTo(weakSelf.logoImage.mas_left);
        }];
    }
    
}

- (void)btnClick:(UIButton *)btn{
    
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"购买&呼叫"]) {
        if (_buyBtnClickBlock) {
            _buyBtnClickBlock(self.orderInfo);
        }
    }else if([title isEqualToString:@"去支付"]){
        if (_payBtnClickBlock) {
            _payBtnClickBlock(self.orderInfo);
        }
    }else{
        if (_commentBtnClickBlock) {
            _commentBtnClickBlock(self.orderInfo);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setCellHighlightColor:selected];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self setCellHighlightColor:highlighted];
}

- (void)setCellHighlightColor:(BOOL)selected{
  
    [_topLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
}


@end
