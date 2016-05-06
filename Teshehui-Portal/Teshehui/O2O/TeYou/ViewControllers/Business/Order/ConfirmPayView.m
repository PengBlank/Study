//
//  ConfirmPayView.m
//  Teshehui
//
//  Created by apple_administrator on 16/1/15.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "ConfirmPayView.h"
#import "ConfirmPayViewController.h"
#import "DefineConfig.h"
#import "CreatOrderRequest.h"
#import "UIColor+expanded.h"
#import "UIImage+Common.h"
#import "NSString+Common.h"
#import "Masonry.h"
#import "METoast.h"
#import "HYUserInfo.h"
#import "PayTextField.h"
#import <QuartzCore/QuartzCore.h>
@interface ConfirmPayView ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    PayTextField  *_moneyTextF;
    PayTextField  *_couponTextF;
    
    UIImageView *_bgImageV;
    UIImageView *_bgImageV2;
    
    UILabel *_titleLabel;
    UIImageView *_mImage;
    UIImageView *_cImage;
    
    UILabel *_moneyLabel;
}

@property (nonatomic,strong) NSString  *C2B_Order_Number;
@property (nonatomic,strong) NSString  *O2O_Order_Number;
@property (nonatomic,strong) NSString  *C2B_Order_ID;
@property (nonatomic,strong) NSString  *payMoney;
@property (nonatomic,strong) NSString  *payCoupon;

@end

@implementation ConfirmPayView

- (instancetype)initWithFrame:(CGRect)frame payType:(NSInteger)type
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreen_Width, type == ConfirmBilliardsPay ? 258 : 200)];
        aView.userInteractionEnabled = YES;
        aView.backgroundColor = [UIColor whiteColor];
        [self addSubview:aView];
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x373737"]];
       // [_titleLabel setNumberOfLines:2];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [aView addSubview:_titleLabel];
        
        UILabel *desLabel = [[UILabel alloc] init];
        [desLabel setText:@"请消费后买单"];
        [desLabel setFont:[UIFont systemFontOfSize:17]];
        [desLabel setTextColor:[UIColor colorWithHexString:@"0xb80000"]];
        [desLabel setTextAlignment:NSTextAlignmentRight];
        [aView addSubview:desLabel];
        
        _bgImageV = [[UIImageView alloc] init];
        [_bgImageV setUserInteractionEnabled:YES];
        [_bgImageV.layer setBorderWidth:.5f];
        [_bgImageV.layer setCornerRadius:3];
        [_bgImageV.layer setBorderColor:[UIColor colorWithHexString:@"0xbfbfbf"].CGColor];
        _bgImageV.tag = 102;
        [aView addSubview:_bgImageV];
        
        _moneyLabel = [[UILabel alloc] init];
        [_moneyLabel setTextColor:[UIColor colorWithHexString:@"0x000000"]];
        [_moneyLabel setText:@"消费额："];
        [_moneyLabel setFont:[UIFont systemFontOfSize:15]];
        [_moneyLabel setTextAlignment:NSTextAlignmentRight];
        [_bgImageV addSubview:_moneyLabel];
        
        _moneyTextF = [[PayTextField alloc] init];
        [_moneyTextF setPlaceholder:@"请输入消费金额"];
        [_moneyTextF setKeyboardType:UIKeyboardTypeDecimalPad];
        [_moneyTextF setReturnKeyType:UIReturnKeyDone];
        _moneyTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_moneyTextF setFont:[UIFont systemFontOfSize:14]];
        _moneyTextF.tag = 100;
        [_bgImageV addSubview:_moneyTextF];
        
         _mImage = [[UIImageView alloc] init];
        [_mImage setImage:[UIImage imageNamed:@"icon-money"]];
        [_bgImageV addSubview:_mImage];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(aView.mas_centerX);
            make.top.mas_equalTo(aView.mas_top).offset(35);
            make.width.mas_equalTo(kScreen_Width - 20);
        }];
        
        [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(15);
            make.centerX.mas_equalTo(aView.mas_centerX);
        }];
        
        [_bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(aView.mas_left).offset(34);
            make.right.mas_equalTo(aView.mas_right).offset(-34);
            make.top.mas_equalTo(desLabel.mas_bottom).offset(43);
            make.height.mas_equalTo(40);
        }];
        
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgImageV.mas_centerY);
            make.left.mas_equalTo(_bgImageV.mas_left).offset(10);
            make.width.mas_equalTo(60);
        }];
        
        [_moneyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgImageV.mas_centerY);
            make.left.mas_equalTo(_moneyLabel.mas_right).offset(10);
            make.right.mas_equalTo(_bgImageV.mas_right).offset(-40);
            make.height.mas_equalTo(kScreen_Width - 75 - 30 - 50);
        }];
        
        [_mImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgImageV.mas_centerY);
            make.right.mas_equalTo(_bgImageV.mas_right).offset(0);
            make.size.mas_equalTo(CGSizeMake(25, 26.5));
        }];
        
        if (type == ConfirmBilliardsPay) {
            
            _bgImageV2 = [[UIImageView alloc] init];
            [_bgImageV2 setUserInteractionEnabled:YES];
            [_bgImageV2.layer setBorderWidth:.5f];
            [_bgImageV2.layer setCornerRadius:3];
            [_bgImageV2.layer setBorderColor:[UIColor colorWithHexString:@"0xbfbfbf"].CGColor];
            _bgImageV2.tag = 103;
            [aView addSubview:_bgImageV2];
            
            UILabel *coupontLabel = [[UILabel alloc] init];
            [coupontLabel setTextColor:[UIColor colorWithHexString:@"0x000000"]];
            [coupontLabel setText:@"现金券："];
            [coupontLabel setFont:[UIFont systemFontOfSize:15]];
            [coupontLabel setTextAlignment:NSTextAlignmentRight];
            [_bgImageV2 addSubview:coupontLabel];
            
            _couponTextF = [[PayTextField alloc] init];
            [_couponTextF setPlaceholder:@"请输入消费现金券"];
            [_couponTextF setKeyboardType:UIKeyboardTypeNumberPad];
            [_couponTextF setReturnKeyType:UIReturnKeyDone];
            _couponTextF.clearButtonMode = UITextFieldViewModeWhileEditing;
            [_couponTextF setFont:[UIFont systemFontOfSize:14]];
            _couponTextF.tag = 101;
            [_bgImageV2 addSubview:_couponTextF];
            
            _cImage = [[UIImageView alloc] init];
            [_cImage setImage:[UIImage imageNamed:@"icon-discount"]];
            [_bgImageV2 addSubview:_cImage];
            
            [_bgImageV2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(aView.mas_left).offset(34);
                make.right.mas_equalTo(aView.mas_right).offset(-34);
                make.top.mas_equalTo(_bgImageV.mas_bottom).offset(10);
                make.height.mas_equalTo(40);
            }];
            
            [coupontLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgImageV2.mas_centerY);
                make.left.mas_equalTo(_bgImageV2.mas_left).offset(10);
                make.width.mas_equalTo(60);
            }];
            
            [_couponTextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgImageV2.mas_centerY);
                make.left.mas_equalTo(coupontLabel.mas_right).offset(10);
                make.right.mas_equalTo(_bgImageV2.mas_right).offset(-40);
                make.height.mas_equalTo(kScreen_Width - 75 - 30 - 60);
            }];
            
            [_cImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_bgImageV2.mas_centerY);
               // make.left.mas_equalTo(_couponTextF.mas_right).offset(5);
                make.right.mas_equalTo(_bgImageV2.mas_right).offset(0);
                make.size.mas_equalTo(CGSizeMake(25, 26.5));
            }];
        }
    }
    return self;
}

- (void)affirmBtnAction{
    if (_ConfirmBlock) {
        _ConfirmBlock(_moneyTextF.text,_couponTextF.text);
    }
}

- (void)setMerName:(NSString *)name withSender:(id)sender{
    _titleLabel.text = name;
    _couponTextF.delegate = sender;
    _moneyTextF.delegate = sender;
    if (self.isChange) {
        [_moneyLabel setText:@"实付现金："];
        [_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_bgImageV.mas_centerY);
            make.left.mas_equalTo(_bgImageV.mas_left).offset(10);
            make.width.mas_equalTo(80);
        }];
    }
}


@end
