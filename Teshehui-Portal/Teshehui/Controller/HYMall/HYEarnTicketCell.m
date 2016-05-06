//
//  HYEarnTicketCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/8.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYEarnTicketCell.h"
#import "UIImage+Addition.h"

@interface HYEarnTicketCell ()
{
    UIButton *_leftView;
    UIButton *_rightView;
}
@end

@implementation HYEarnTicketCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _leftView = [[UIButton alloc] initWithFrame:CGRectZero];
        _leftView.contentMode = UIViewContentModeLeft;
        _leftView.imageView.contentMode = UIViewContentModeLeft;
        [_leftView addTarget:self
                      action:@selector(buttonAction:)
            forControlEvents:UIControlEventTouchUpInside];
        _leftView.exclusiveTouch = YES;
        [self.contentView addSubview:_leftView];
        
        _rightView = [[UIButton alloc] initWithFrame:CGRectZero];
        _rightView.contentMode = UIViewContentModeRight;
        _rightView.imageView.contentMode = UIViewContentModeRight;
        [_rightView addTarget:self
                       action:@selector(buttonAction:)
             forControlEvents:UIControlEventTouchUpInside];
        _rightView.exclusiveTouch = YES;
        [self.contentView addSubview:_rightView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isFull)
    {
        _leftView.frame = self.bounds;
    }
    else
    {
        CGFloat width = (CGRectGetWidth(self.frame)- 10) / 2;
        _leftView.frame = CGRectMake(0, 0, width, self.frame.size.height);
        _rightView.frame = CGRectMake(CGRectGetMaxX(_leftView.frame)+10, 0, width, self.frame.size.height);
    }
}

- (void)updateView:(BOOL)left withBusinessType:(HYBusinessType *)businessType
{
    UIButton *btn = left? _leftView : _rightView;
    if ([businessType.businessTypeCode isEqualToString:BusinessType_MeiQiqi]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"meiweiqiqi_type_icon"]
                             forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_Flight]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"filght_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_DidiTaxi]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"taxi_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_Meituan]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"gourp_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_Flower]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"folwer_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_Yangguang]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"baoxian_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_Hotel]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"hotel_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_MeiQiqi]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"meiweiqiqi_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_PhoneCharge]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"phonecharge_type_icon"]
                       forState:UIControlStateNormal];
    }
    else if ([businessType.businessTypeCode isEqualToString:BusinessType_MovieTicket]) {
        [btn setBackgroundImage:[UIImage imageNamed:@"movieticket_type_icon"]
                       forState:UIControlStateNormal];
    }
    else {
        [btn setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark setter/getter
- (void)setLeftBusinessType:(HYBusinessType *)leftBusinessType
{
    if (_leftBusinessType != leftBusinessType) {
        _leftBusinessType = leftBusinessType;
        [self updateView:YES withBusinessType:leftBusinessType];
    }
}

- (void)setRightBusinessType:(HYBusinessType *)rightBusinessType
{
    if (_rightBusinessType != rightBusinessType) {
        _rightBusinessType = rightBusinessType;
        [self updateView:NO withBusinessType:rightBusinessType];
    }
}

- (void)buttonAction:(UIButton *)btn
{
    if (btn == _leftView)
    {
        [self.delegate didSelectWithEarnType:_leftBusinessType];
    }
    else if (btn == _rightView)
    {
        [self.delegate didSelectWithEarnType:_rightBusinessType];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _isFull = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
