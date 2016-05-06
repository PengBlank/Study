//
//  PrepaidCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/9/22.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "PrepaidCell.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"
#import "UIImageView+WebCache.h"
@implementation PrepaidCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _markImage = [[UIImageView alloc] init];
        [_markImage setImage:IMAGE(@"shopC")];
        [self.contentView addSubview:_markImage];
        
        _leftImage = [[UIImageView alloc] init];
        [self.contentView addSubview:_leftImage];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFont:[UIFont systemFontOfSize:16]];
        [_nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [_nameLabel setTextColor:[UIColor colorWithHexString:@"272727"]];
        [self.contentView addSubview:_nameLabel];
        
//        _payStatusLabel = [[UILabel alloc] init];
//        [_payStatusLabel setFont:[UIFont systemFontOfSize:15]];
//        [_payStatusLabel setTextColor:[UIColor colorWithHexString:@"b80000"]];
//        [self.contentView addSubview:_payStatusLabel];
        
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFont:[UIFont systemFontOfSize:14]];
        [_numberLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_numberLabel];
        
        _payType = [[UILabel alloc] init];
        [_payType setFont:[UIFont systemFontOfSize:14]];
        [_payType setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_payType];
        
        _orderTime = [[UILabel alloc] init];
        [_orderTime setFont:[UIFont systemFontOfSize:15]];
        [_orderTime setTextColor:[UIColor colorWithHexString:@"424242"]];
        [self.contentView addSubview:_orderTime];
        
        _payMoney = [[UILabel alloc] init];
        [_payMoney setFont:[UIFont systemFontOfSize:15]];
        [_payMoney setTextColor:[UIColor colorWithHexString:@"b80000"]];
        [self.contentView addSubview:_payMoney];
        
        _topLineView = [[UIView alloc] init];
        [_topLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_topLineView];
        
        
        _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBtn setTitleColor:[UIColor colorWithHexString:@"606060"] forState:UIControlStateNormal];
        [_commentBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentBtn];
        
        
        _bottomLineView = [[UIView alloc] init];
        [_bottomLineView setBackgroundColor:[UIColor colorWithHexString:@"e5e5e5"]];
        [self.contentView addSubview:_bottomLineView];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);
    [_markImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(14);
        make.size.mas_equalTo(CGSizeMake(18, 17));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.markImage.mas_right).offset(5);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.centerY.mas_equalTo(weakSelf.markImage.mas_centerY);
    }];
    
//    [_payStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
//        make.centerY.mas_equalTo(weakSelf.markImage.mas_centerY);
//    }];
    
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).mas_equalTo(43);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
    
    
    [_leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.topLineView.mas_bottom).offset(12);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.leftImage.mas_top);
        make.left.mas_equalTo(weakSelf.leftImage.mas_right).offset(10);
    }];
    

    [_orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.leftImage.mas_right).offset(10);
        make.bottom.mas_equalTo(weakSelf.leftImage.mas_bottom);
    }];
    
    [_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.top.mas_equalTo(weakSelf.leftImage.mas_bottom).mas_equalTo(12);
        make.width.mas_equalTo(kScreen_Width - 12.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [_commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bottomLineView.mas_bottom).offset(10);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
        make.size.mas_equalTo(CGSizeMake(74, 28));
        
    }];
    
    [_payType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(weakSelf.commentBtn.mas_centerY);
        make.left.mas_equalTo(weakSelf.leftImage.mas_left);
    }];
    
    [_payMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.payType.mas_right).offset(5);
        make.centerY.mas_equalTo(weakSelf.commentBtn.mas_centerY);
    }];
    
}

- (void)bindData:(OrderInfo *)baseInfo{
    
    if (baseInfo == nil) {
        return;
    }
    
    self.orderInfo = baseInfo;
    
    _nameLabel.text         = baseInfo.MerchantsName;
    _payStatusLabel.text    = baseInfo.Status;
    _numberLabel.text       = baseInfo.O2O_Order_Number;
    _payType.text           = baseInfo.Pay_Way;
    _orderTime.text         = baseInfo.CreateOn;
    
    if (baseInfo.IsComment.integerValue == 1) {
         [_commentBtn setTitle:@"已评价" forState:UIControlStateNormal];
        [_commentBtn.layer setCornerRadius:0];
        [_commentBtn.layer setBorderWidth:0.0f];
    }else{
        [_commentBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [_commentBtn.layer setCornerRadius:5];
        [_commentBtn.layer setBorderWidth:0.8f];
        [_commentBtn.layer setBorderColor:[UIColor colorWithHexString:@"62666c"].CGColor];
    }

    if([baseInfo.Coupon isEqualToString:@"0"] && ![baseInfo.Amount isEqualToString:@"0"]){
        
        _payMoney.text = [NSString stringWithFormat:@"￥%@",baseInfo.Amount];
        
    }else if([baseInfo.Coupon isEqualToString:@"0"] && [baseInfo.Amount isEqualToString:@"0"]){
        
        
        
    }else if (![baseInfo.Coupon isEqualToString:@"0"] && [baseInfo.Amount isEqualToString:@"0"]){
        
        _payMoney.text = [NSString stringWithFormat:@"%@ 现金券",baseInfo.Coupon];
        
    }
    else{
        _payMoney.text = [NSString stringWithFormat:@"￥%@ + %@ 现金券",baseInfo.Amount,baseInfo.Coupon];
    }
    
    NSString *urlStirng = [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h/%@",baseInfo.MerchantsLogo,@"180",@"180"];
    [_leftImage sd_setImageWithURL:[NSURL URLWithString:urlStirng] placeholderImage:IMAGE(@"loading")];


}

- (void)commentBtnClick:(UIButton *)btn{
    
    if ([btn.titleLabel.text isEqualToString:@"去评价"]) {
        if (_goCommentBlock) {
            _goCommentBlock(self.orderInfo);
        }
    }
}

+ (CGFloat)cellHeight{
    //return 127.5;
    return 178;
}

@end
