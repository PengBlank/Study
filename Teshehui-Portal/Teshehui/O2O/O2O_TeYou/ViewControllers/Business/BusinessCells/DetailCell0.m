//
//  DetailCell0.m
//  Teshehui
//
//  Created by apple_administrator on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "DetailCell0.h"
#import "Masonry.h"
#import "DefineConfig.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"

@implementation DetailCell0

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kScreen_Width - 60, 30)];
        [_titleLabel setFont:[UIFont systemFontOfSize:16]];
      //  [_titleLabel setText:@"小肥羊"];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"0x343434"]];
        [self.contentView addSubview:_titleLabel];

        _addressIcon  = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 13, 20)];
        [_addressIcon setImage:IMAGE(@"address")];
        [self.contentView addSubview:_addressIcon];
        
        _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15, kScreen_Width - 85, 35)];
        [_addressLabel setFont:[UIFont systemFontOfSize:13]];
        [_addressLabel setCenterY:_addressIcon.centerY];
        [_addressLabel setNumberOfLines:2];
        [_addressLabel setTextColor:[UIColor colorWithHexString:@"0x606060"]];
        [self.contentView addSubview:_addressLabel];
        
        _phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneBtn setFrame:CGRectMake(kScreen_Width - 50, 20, 40, 40)];
//        [_phoneBtn setCenterY:self.contentView.centerY];
        [_phoneBtn setImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
        [_phoneBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_phoneBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_phoneBtn];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width - 55, 10, 1, 60)];
       // [_lineView setCenterY:_phoneBtn.centerY];
        [_lineView setBackgroundColor:[UIColor colorWithHexString:@"0xf2f2f2"]];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)buttonClick{
    
    if (_delegate && [_delegate respondsToSelector:@selector(ClickPhoneCallback)]) {
        [_delegate ClickPhoneCallback];
    }
}

-  (void)bindDataWithDetailSection0:(BusinessdetailInfo *)info{
    
    if (info == nil)
        return;
    
    [_titleLabel setText:info.MerchantsName];
    [_addressLabel setText:info.Address];
//     _starView.rating = info.AverageStars;
//    if (info.AverageStars == 0) {
//        _scoreLabel.hidden = YES;
//    } else {
//        [_scoreLabel setText:[NSString stringWithFormat:@"%.1f",info.AverageStars]];
//    }
}

@end
