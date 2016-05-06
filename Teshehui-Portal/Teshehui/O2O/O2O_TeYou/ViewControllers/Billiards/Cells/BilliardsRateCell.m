//
//  BilliardsRateCell.m
//  Teshehui
//
//  Created by apple_administrator on 15/12/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "BilliardsRateCell.h"
#import "UIColor+expanded.h"
#import "DefineConfig.h"
#import "Masonry.h"
@implementation BilliardsRateCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_titleLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_titleLabel];
        
        _desLabel = [[UILabel alloc] init];
        [_desLabel setFont:[UIFont systemFontOfSize:11]];
        [_desLabel setTextColor:[UIColor colorWithHexString:@"a7a7a7"]];
        [self.contentView addSubview:_desLabel];

        _costLabel = [[UILabel alloc] init];
        [_costLabel setFont:[UIFont systemFontOfSize:13]];
        [_costLabel setTextColor:[UIColor colorWithHexString:@"343434"]];
        [self.contentView addSubview:_costLabel];

        _originalLabel = [[UILabel alloc] init];
        [_originalLabel setFont:[UIFont systemFontOfSize:11]];
        [_originalLabel setTextColor:[UIColor colorWithHexString:@"a7a7a7"]];
        [self.contentView addSubview:_originalLabel];

        
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor colorWithHexString:@"a7a7a7"]];
        [self.contentView addSubview:_lineView];

        [_titleLabel setText:@"开台时段会员价:"];
        [_desLabel setText:@"不同时段有不同折扣"];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).offset(5);
        make.left.mas_equalTo(weakSelf.contentView.mas_left).offset(15);
       // make.height.mas_equalTo(20);
    }];

    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).offset(-8);
       // make.height.mas_equalTo(20);
    }];

    [_costLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).offset(-5);
        make.top.mas_equalTo(weakSelf.titleLabel.mas_top);
       // make.height.mas_equalTo(20);
    }];

    [_originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.costLabel.mas_right);
        make.centerY.mas_equalTo(weakSelf.desLabel.mas_centerY);
    }];
  
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.originalLabel.mas_left);
        make.right.mas_equalTo(weakSelf.originalLabel.mas_right);
        make.centerY.mas_equalTo(weakSelf.originalLabel.mas_centerY);
        make.width.mas_equalTo(weakSelf.originalLabel.mas_width);
        make.height.mas_equalTo(0.5);
    }];
    
}



@end
