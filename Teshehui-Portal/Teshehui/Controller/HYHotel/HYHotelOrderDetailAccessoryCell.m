//
//  HYHotelOrderDetailAccessoryCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelOrderDetailAccessoryCell.h"
#import "Masonry.h"

@implementation HYHotelOrderDetailAccessoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_icon];
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _infoLabl = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabl.backgroundColor = [UIColor clearColor];
        _infoLabl.font = [UIFont systemFontOfSize:14.0];
        _infoLabl.textColor = [UIColor colorWithWhite:.4 alpha:1];
        [self.contentView addSubview:_infoLabl];
        [_infoLabl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_lessThanOrEqualTo(0);
        }];
    }
    return self;
}

- (void)updateConstraints
{
    if (!_icon.image)
    {
        [_infoLabl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
        }];
    }
    else
    {
        [_infoLabl mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_icon.mas_right).offset(10);
        }];
    }
    [super updateConstraints];
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews]
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
