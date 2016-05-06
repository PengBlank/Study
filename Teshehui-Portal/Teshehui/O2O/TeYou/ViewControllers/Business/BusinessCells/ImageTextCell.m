//
//  ImageTextCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "ImageTextCell.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"
#import "UIImage+Common.h"
#import "UIColor+expanded.h"
@implementation ImageTextCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    
        _imageV  = [[UIImageView alloc] init];
        [_imageV setImage:IMAGE(@"address")];
        [self.contentView addSubview:_imageV];
        
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setNumberOfLines:0];
        [_contentLabel setTextColor:[UIColor colorWithHexString:@"0x272727"]];
        [self.contentView addSubview:_contentLabel];
        
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_phoneBtn];
        
    }
    return self;
}


- (void)buttonClick:(UIButton *)btn{
    if (btn.tag == 10) {
        if (_delegate && [_delegate respondsToSelector:@selector(ClickPhoneCallback)]) {
            [_delegate ClickPhoneCallback];
        }
    }else{
        if (_delegate && [_delegate respondsToSelector:@selector(ClickPayMoneyCallback)]) {
            [_delegate ClickPayMoneyCallback];
        }
    }
    
}

- (void)bindDataWithSectionTwo:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index{
    
    if (baseInfo == nil) {
        return;
    }
    
    switch (index) {

        case 0:
        {
            _imageV.hidden = NO;
            _phoneBtn.tag = 11;
            
//            if (baseInfo.IsBankEnable) { //检测商家有没有和特奢汇绑定银行卡  如果没有就不给付款入口
//                _phoneBtn.hidden = NO;
//                [_phoneBtn setTitle:@"付款" forState:UIControlStateNormal];
//                [_phoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
//            }else{
                _phoneBtn.hidden = YES;
//            }
            [_imageV setImage:IMAGE(@"shops")];
            [_contentLabel setText:@"商家详情"];
            [_contentLabel setFont:[UIFont boldSystemFontOfSize:18]];
            
            WS(weakSelf);
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
                make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(20, 18));
            }];
            
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imageV.mas_right).offset(5);
                make.centerY.mas_equalTo(_imageV.mas_centerY);
            }];
            
            [_phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
                make.centerY.mas_equalTo(_imageV.mas_centerY);
                make.width.mas_equalTo(@58);
                make.height.mas_equalTo(@25);
            }];
            
            
        }
            break;
            
        default:
            break;
    }
}

- (void)bindDataWithDetailSection1:(BusinessdetailInfo *)baseInfo{
    
    _imageV.hidden = NO;
    _phoneBtn.hidden = NO;
    _phoneBtn.tag = 10;
    [_phoneBtn setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [_contentLabel setText:baseInfo.Address];
    [_contentLabel setFont:[UIFont systemFontOfSize:14]];
    
    WS(weakSelf);
    [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(13, 20));
    }];
    
    [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageV.mas_right).offset(5);
        make.right.mas_equalTo(_phoneBtn.mas_left).offset(-5);
        make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
        
    }];
    
    [_phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(0);
        make.centerY.mas_equalTo(_imageV.mas_centerY);
        make.width.mas_equalTo(weakSelf.contentView.mas_height);
        make.height.mas_equalTo(weakSelf.contentView.mas_height);
    }];
    
    if (!_linview) {
        _linview = [[UIView alloc] init];
        [_linview setBackgroundColor:[UIColor colorWithHexColor:@"f2f2f2" alpha:1]];
        [self.contentView addSubview:_linview];
    }
    
    [_linview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_phoneBtn.mas_left).offset(-2);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(1);
    }];
}


- (void)bindData:(BusinessdetailInfo *)baseInfo andIndex:(NSInteger)index{
    
    if (baseInfo == nil) {
        return;
    }
    
    switch (index) {
        case 0:
        {
            _imageV.hidden = YES;
            _phoneBtn.hidden = YES;
            _contentLabel.text = baseInfo.MerchantsName;
            [_contentLabel setFont:[UIFont boldSystemFontOfSize:18]];
            
            WS(weakSelf);
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
                make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-10);
                make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
            }];
        }
            break;
        case 1:
        {
            _imageV.hidden = NO;
            _phoneBtn.hidden = NO;
            _phoneBtn.tag = 10;
            [_phoneBtn setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
            [_contentLabel setText:baseInfo.Address];
            [_contentLabel setFont:[UIFont systemFontOfSize:14]];
    
            WS(weakSelf);
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
                make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(13, 20));
            }];
            
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imageV.mas_right).offset(5);
                make.right.mas_equalTo(_phoneBtn.mas_left).offset(-5);
                make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
              
            }];
            
            [_phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(0);
                make.centerY.mas_equalTo(_imageV.mas_centerY);
                make.width.mas_equalTo(weakSelf.contentView.mas_height);
                make.height.mas_equalTo(weakSelf.contentView.mas_height);
            }];
            
            if (!_linview) {
                _linview = [[UIView alloc] init];
                [_linview setBackgroundColor:[UIColor colorWithHexColor:@"f2f2f2" alpha:1]];
                [self.contentView addSubview:_linview];
            }
            
            [_linview mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_phoneBtn.mas_left).offset(-2);
                make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(10);
                make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-10);
                make.width.mas_equalTo(1);
            }];

        }
            break;
        case 2:
        {
            _imageV.hidden = NO;
            _phoneBtn.tag = 11;
            
//            if (baseInfo.IsBankEnable) { //检测商家有没有和特奢汇绑定银行卡  如果没有就不给付款入口
//                _phoneBtn.hidden = NO;
//                [_phoneBtn setTitle:@"付款" forState:UIControlStateNormal];
//                [_phoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0xb80000"]] forState:UIControlStateNormal];
//            }else{
                _phoneBtn.hidden = YES;
//            }
            [_imageV setImage:IMAGE(@"shops")];
            [_contentLabel setText:@"商家详情"];
            [_contentLabel setFont:[UIFont boldSystemFontOfSize:18]];

            WS(weakSelf);
            [_imageV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
                make.centerY.mas_equalTo(weakSelf.contentView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(20, 18));
            }];
            
            [_contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_imageV.mas_right).offset(5);
                make.centerY.mas_equalTo(_imageV.mas_centerY);
            }];
            
            [_phoneBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-kPaddingLeftWidth);
                make.centerY.mas_equalTo(_imageV.mas_centerY);
                make.width.mas_equalTo(@58);
                make.height.mas_equalTo(@25);
            }];


        }
            break;
            
        default:
            break;
    }
}

@end
