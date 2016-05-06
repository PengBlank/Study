//
//  HYHotelDetailDateInfoCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailDateInfoCell.h"
#import "Masonry.h"

@interface HYHotelDetailDateInfoCell ()

@property (nonatomic, strong) UILabel *checkInLabel;
@property (nonatomic, strong) UILabel *checkOutLabel;

@end

@implementation HYHotelDetailDateInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 13, 18, 18)];
        iconView.image = [UIImage imageNamed:@"flightSearch_date"];
        [self.contentView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(11, 11));
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        UIImageView *assView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-22, 14.5, 10, 15)];
        assView.image = [UIImage imageNamed:@"ico_arrow_list"];
        [self.contentView addSubview:assView];
        [assView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
        
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectZero];
        detail.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        detail.textAlignment = NSTextAlignmentRight;
        detail.backgroundColor = [UIColor clearColor];
        detail.font = [UIFont systemFontOfSize:12];
        detail.text = @"修改";
        [self.contentView addSubview:detail];
        [detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(assView.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        _checkInLabel = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(80, 14, 60, 16)];
        _checkInLabel.textColor = [UIColor grayColor];
        [_checkInLabel setFont:[UIFont systemFontOfSize:13]];
        _checkInLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_checkInLabel];
        
        _checkOutLabel = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(178, 14, 60, 16)];
        _checkOutLabel.textColor = [UIColor grayColor];
        [_checkOutLabel setFont:[UIFont systemFontOfSize:13]];
        _checkOutLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_checkOutLabel];
        
        [_checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.equalTo(_checkOutLabel.mas_width);
        }];
        
        [_checkOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_checkInLabel.mas_right);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(detail.mas_left).offset(5);
        }];
        
//        UIButton *modify = [UIButton buttonWithType:UIButtonTypeCustom];
//        [modify.titleLabel setFont:[UIFont systemFontOfSize:15]];
//        [modify setTitleColor:[UIColor colorWithRed:51.0f/255.0f
//                                              green:147.0f/255.0f
//                                               blue:196.0f/255.0f
//                                              alpha:1.0]
//                     forState:UIControlStateNormal];
//        [modify setTitle:NSLocalizedString(@"modify", nil) forState:UIControlStateNormal];
//        modify.frame = CGRectMake(CGRectGetMinX(assView.frame)-30, 0, 30, 44);
//        [modify addTarget:self
//                   action:@selector(modifyCheckDate:)
//         forControlEvents:UIControlEventTouchUpInside];
//        modify.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        [self.contentView addSubview:modify];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)modifyCheckDate:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(modifyDate)])
    {
        [self.delegate modifyDate];
    }
}

#pragma mark getter
//- (UILabel *)checkInLabel
//{
//    if (!_checkInLabel)
//    {
//        _checkInLabel = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(80, 14, 60, 16)];
//        _checkInLabel.textColor = [UIColor blackColor];
//        [_checkInLabel setFont:[UIFont systemFontOfSize:15]];
//        _checkInLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_checkInLabel];
//    }
//    
//    return _checkInLabel;
//}
//
//- (UILabel *)checkOutLabel
//{
//    if (!_checkOutLabel)
//    {
//        _checkOutLabel = [[UILabel alloc] initWithFrame:TFRectMakeFixWidth(178, 14, 60, 16)];
//        _checkOutLabel.textColor = [UIColor blackColor];
//        [_checkOutLabel setFont:[UIFont systemFontOfSize:15]];
//        _checkOutLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_checkOutLabel];
//    }
//    
//    return _checkOutLabel;
//}

- (void)setCheckInDate:(NSString *)checkInDate
{
    if ([checkInDate length]>5 && checkInDate != _checkInDate)
    {
        _checkInDate = [checkInDate copy];
        self.checkInLabel.text = [NSString stringWithFormat:@"入住 %@", checkInDate];
    }
}

- (void)setCheckOutDate:(NSString *)checkOutDate
{
    if ([checkOutDate length]>5 && checkOutDate != _checkOutDate)
    {
        _checkOutDate = [checkOutDate copy];
        self.checkOutLabel.text = [NSString stringWithFormat:@"离店 %@", checkOutDate];
    }
}

@end
