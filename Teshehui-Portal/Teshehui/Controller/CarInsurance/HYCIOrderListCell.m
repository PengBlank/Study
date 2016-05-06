//
//  HYCIOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIOrderListCell.h"

@interface HYCIOrderListCell ()

@property (nonatomic, strong) UILabel *carNOLab;
@property (nonatomic, strong) UILabel *orderIdLab;
@property (nonatomic, strong) UILabel *orderAmoutLab;
@property (nonatomic, strong) UILabel *productTypeLab;
@property (nonatomic, strong) UIButton *handleBtn;  //cancel
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation HYCIOrderListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UILabel *carNODescLab = [[UILabel alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 14, 80, 16)];
        carNODescLab.font = [UIFont systemFontOfSize:15];
        carNODescLab.textColor = [UIColor blackColor];
        carNODescLab.backgroundColor = [UIColor clearColor];
        carNODescLab.textAlignment = NSTextAlignmentRight;
        carNODescLab.text = @"车牌号：";
        [self.contentView addSubview:carNODescLab];
        
        _carNOLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 14, 200, 16)];
        _carNOLab.font = [UIFont systemFontOfSize:15];
        _carNOLab.textColor = [UIColor blackColor];
        _carNOLab.backgroundColor = [UIColor clearColor];
        _carNOLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_carNOLab];
        
        UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 44, ScreenRect.size.width-self.separatorLeftInset, 1)];
        line1View.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                     topCapHeight:0];
        [self.contentView addSubview:line1View];
        
        UILabel *orderIdDescLab = [[UILabel alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 58, 80, 16)];
        orderIdDescLab.font = [UIFont systemFontOfSize:14];
        orderIdDescLab.textColor = [UIColor blackColor];
        orderIdDescLab.backgroundColor = [UIColor clearColor];
        orderIdDescLab.textAlignment = NSTextAlignmentRight;
        orderIdDescLab.text = @"订单号：";
        [self.contentView addSubview:orderIdDescLab];
        
        _orderIdLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 58, 200, 16)];
        _orderIdLab.font = [UIFont systemFontOfSize:15];
        _orderIdLab.textColor = [UIColor blackColor];
        _orderIdLab.backgroundColor = [UIColor clearColor];
        _orderIdLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_orderIdLab];
        
        UILabel *typeDescLab = [[UILabel alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 80, 80, 16)];
        typeDescLab.font = [UIFont systemFontOfSize:15];
        typeDescLab.textColor = [UIColor blackColor];
        typeDescLab.backgroundColor = [UIColor clearColor];
        typeDescLab.textAlignment = NSTextAlignmentRight;
        typeDescLab.text = @"产品：";
        [self.contentView addSubview:typeDescLab];
        
        _productTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 80, 200, 16)];
        _productTypeLab.font = [UIFont systemFontOfSize:15];
        _productTypeLab.textColor = [UIColor blackColor];
        _productTypeLab.backgroundColor = [UIColor clearColor];
        _productTypeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_productTypeLab];
        
        UILabel *amoutDescLab = [[UILabel alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 102, 80, 16)];
        amoutDescLab.font = [UIFont systemFontOfSize:15];
        amoutDescLab.textColor = [UIColor blackColor];
        amoutDescLab.backgroundColor = [UIColor clearColor];
        amoutDescLab.textAlignment = NSTextAlignmentRight;
        amoutDescLab.text = @"支付金额：";
        [self.contentView addSubview:amoutDescLab];
        
        _orderAmoutLab = [[UILabel alloc] initWithFrame:CGRectMake(100, 102, 200, 16)];
        _orderAmoutLab.font = [UIFont systemFontOfSize:15];
        _orderAmoutLab.textColor = [UIColor blackColor];
        _orderAmoutLab.backgroundColor = [UIColor clearColor];
        _orderAmoutLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_orderAmoutLab];
        
        UIImageView *line2View = [[UIImageView alloc] initWithFrame:CGRectMake(self.separatorLeftInset, 132, ScreenRect.size.width-self.separatorLeftInset, 1)];
        line2View.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                     topCapHeight:0];
        [self.contentView addSubview:line2View];
        
        UIView *handleView = [[UIView alloc] initWithFrame:CGRectMake(0, 133, CGRectGetWidth(ScreenRect), 40)];
        handleView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.90 alpha:1];
        [self.contentView addSubview:handleView];
        
        _handleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _handleBtn.frame = CGRectMake(CGRectGetWidth(ScreenRect)-94, 4, 80, 30);
        _handleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [_handleBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_handleBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_handleBtn setBackgroundImage:[[UIImage imageNamed:@"ci_btn_on"]
                                        stretchableImageWithLeftCapWidth:3 topCapHeight:0]
                              forState:UIControlStateNormal];
        [_handleBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_handleBtn setTitleColor:[UIColor whiteColor]
                               forState:UIControlStateNormal];
        [_handleBtn addTarget:self
                             action:@selector(handleIndemnity:)
                   forControlEvents:UIControlEventTouchUpInside];
        [handleView addSubview:_handleBtn];
    }
    return self;
}

- (void)handleIndemnity:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPaymentCIOrder:)])
    {
        [self.delegate didPaymentCIOrder:self.order];
    }
}

#pragma mark setter/getter
- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(84, 5, 70, 30);
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:249.0/255.0
                                                        green:138.0/255.0
                                                         blue:17.0/255.0
                                                        alpha:1.0]
                               forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                             action:@selector(handleIndemnity:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cancelBtn];
    }
    
    return _cancelBtn;
}

- (void)setOrder:(HYCIOrderDetail *)order
{
    if (order != _order)
    {
        _order = order;
        _carNOLab.text = order.carInfo.licenseNo;
        _orderAmoutLab.text = [NSString stringWithFormat:@"%.2f", order.orderTotalAmount.floatValue];
        _productTypeLab.text = order.insuranceInfo.productTypeName;
        _orderIdLab.text = order.orderCode;
    }
    
    switch (order.orderStatus.integerValue)
    {
        case 10:
            _handleBtn.hidden = NO;
            break;
        case 30:
            _handleBtn.hidden = YES;
            break;
        default:
            _handleBtn.hidden = YES;
            break;
    }
}


@end
