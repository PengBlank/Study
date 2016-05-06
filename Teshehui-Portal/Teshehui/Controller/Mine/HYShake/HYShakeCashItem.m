//
//  HYShakeCashItem.m
//  Teshehui
//
//  Created by HYZB on 16/3/25.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYShakeCashItem.h"
#import "HYShakeViewModel.h"

@interface HYShakeCashItem ()

@property (nonatomic, strong) UIImageView *picImgV;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *pointLab;
@property (nonatomic, strong) UILabel *declareLab;
@property (nonatomic, strong) UILabel *cashDescLab;
@property (nonatomic, strong) UILabel *descTitleLab;
@property (nonatomic, strong) UILabel *descLab;

@property (nonatomic, assign) ShakeType shakeType;


@end

@implementation HYShakeCashItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.layer.cornerRadius = 10;
        self.backgroundColor = [UIColor whiteColor];
        self.hidden = YES;
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    _picImgV = [[UIImageView alloc] init];
    [self addSubview:_picImgV];
    
    _priceLab = [[UILabel alloc] init];
    _priceLab.font = [UIFont systemFontOfSize:22];
    _priceLab.textColor = [UIColor redColor];
    [self addSubview:_priceLab];
    
    _pointLab = [[UILabel alloc] init];
    _pointLab.font = [UIFont systemFontOfSize:22];
    _pointLab.textColor = [UIColor redColor];
    [self addSubview:_pointLab];
    
    _declareLab = [[UILabel alloc] init];
    _declareLab.font = [UIFont systemFontOfSize:13];
    _declareLab.textColor = [UIColor colorWithWhite:0.6 alpha:1.0f];
    [self addSubview:_declareLab];
    
    _cashDescLab = [[UILabel alloc] init];
    _cashDescLab.numberOfLines = 0;
    [self addSubview:_cashDescLab];
    
    _descTitleLab = [[UILabel alloc] init];
    _descTitleLab.textColor = [UIColor colorWithRed:233/255.0f green:76/255.0f blue:84/255.0f alpha:1.0f];
    _descTitleLab.font = [UIFont systemFontOfSize:20];
    _descTitleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_descTitleLab];
    
    _descLab = [[UILabel alloc] init];
    _descLab.font = [UIFont systemFontOfSize:15];
    _descLab.numberOfLines = 0;
    [self addSubview:_descLab];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_checkBtn setTitle:@"查看" forState:UIControlStateNormal];
    _checkBtn.layer.cornerRadius = 6;
    _checkBtn.backgroundColor = [UIColor colorWithRed:246/255.0f green:61/255.0f blue:82/255.0f alpha:1.0f];
    [self addSubview:_checkBtn];
    
    _showBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_showBtn setTitle:@"炫耀一下" forState:UIControlStateNormal];
    _showBtn.layer.cornerRadius = 6;
    _showBtn.backgroundColor = [UIColor colorWithRed:246/255.0f green:61/255.0f blue:82/255.0f alpha:1.0f];
    [self addSubview:_showBtn];
}

- (void)layoutSubviews
{
    CGFloat x = 10;
    CGFloat y = 30;
    CGFloat width = self.frame.size.width - 20;
    CGFloat height = 100;
    _picImgV.frame = CGRectMake(x, y, width, height);
    
    _priceLab.frame = CGRectMake(_picImgV.center.x+10, 58, 60, 23);
    
    _pointLab.frame = CGRectMake(_picImgV.center.x+8, 66, 60, 30);
    
    _declareLab.frame = CGRectMake(CGRectGetMinX(_priceLab.frame)-18, CGRectGetMaxY(_priceLab.frame)+5, 80, 20);
    
    _cashDescLab.frame = CGRectMake(10, CGRectGetMaxY(_picImgV.frame)+30, CGRectGetWidth(_picImgV.frame), 80);
    
    _descTitleLab.frame = CGRectMake(10, CGRectGetMaxY(_picImgV.frame)+20, CGRectGetWidth(_picImgV.frame), 23);
    
    _descLab.frame = CGRectMake(10, CGRectGetMaxY(_descTitleLab.frame)+5, CGRectGetWidth(_picImgV.frame), 80);
    
    CGFloat btnY = CGRectGetMaxY(_descLab.frame)+10;
    _checkBtn.frame = CGRectMake(_picImgV.center.x-100, btnY, 90, 40);
    
    _showBtn.frame = CGRectMake(_picImgV.center.x+10, btnY, 90, 40);
}

- (void)setShakeModel:(HYShakeViewModel *)shakeModel
{
    _shakeType = [shakeModel.shakeType integerValue];
//    _shakeType = kShakeTypeToken;
    if (_shakeType == kShakeTypeCash)
    {
        _picImgV.image = [UIImage imageNamed:@"pic_shake_cash"];
        
        _declareLab.hidden = NO;
        _declareLab.text = @"(不可提现哦)";
        
        _cashDescLab.hidden = NO;
        _cashDescLab.text = shakeModel.cuePhrases;
        
        _descTitleLab.hidden = YES;
        _descLab.hidden = YES;
        _pointLab.hidden = YES;
        _priceLab.hidden = NO;
        _priceLab.text = [NSString stringWithFormat:@"%@元", shakeModel.cashCouponAmount];
    }
    else if (_shakeType == kShakeTypeToken)
    {
        _picImgV.image = [UIImage imageNamed:@"pic_shake_point"];
        _declareLab.hidden = YES;
        _cashDescLab.hidden = YES;
        
        if (shakeModel.isSign)
        {
            _descTitleLab.hidden = NO;
            _descTitleLab.text = @"恭喜你，签到成功!!!";
        }
        else
        {
            _descTitleLab.hidden = YES;
        }
        
        _descLab.hidden = NO;
        _descLab.text = shakeModel.cuePhrases;
        _priceLab.hidden = YES;
        _pointLab.hidden = NO;
        _pointLab.text = [NSString stringWithFormat:@"%@元", shakeModel.cashCouponAmount];
    }
    
//    _priceLab.text = @"5元";
//    _declareLab.text = @"(不可提现哦)";
//    _cashDescLab.text = @"运气真得是好，随便摇一摇就能捡到钱，5元现金，快来领取";
//    _descTitleLab.text = @"恭喜你，签到成功!!!";
//    _descLab.text = @"10元现金券正在等待你的领取。";
}

@end
