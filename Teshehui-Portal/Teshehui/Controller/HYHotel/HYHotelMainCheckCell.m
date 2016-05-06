//
//  HYHotelMainDateCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelMainCheckCell.h"
#import "Masonry.h"

@interface HYHotelMainCheckCell ()
{
    UIImageView *_icon1, *_icon2;
    UILabel *_checkInTimeLabel;
    UILabel *_checkOutTimeLabel;    //离店时间
    UILabel *_totalDaysLabel;
}
@property (nonatomic, strong) UILabel *checkInDateLabel;
@property (nonatomic, strong) UILabel *checkInWeekLabel;
@property (nonatomic, strong) UILabel *checkOutDateLabel;
@property (nonatomic, strong) UILabel *checkOutWeekLabel;

@end

@implementation HYHotelMainCheckCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _totalDaysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalDaysLabel.backgroundColor = [UIColor clearColor];
        _totalDaysLabel.font = [UIFont systemFontOfSize:13.0];
        _totalDaysLabel.textAlignment = NSTextAlignmentCenter;
        _totalDaysLabel.textColor = [UIColor grayColor];
        _totalDaysLabel.text = @"共1晚";
        [self.contentView addSubview:_totalDaysLabel];
        __weak typeof(self) b_self = self;
        [_totalDaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(b_self.contentView.mas_centerY);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(45);
        }];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectZero];
        line1.backgroundColor = [UIColor colorWithWhite:.83 alpha:1];
        [self.contentView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
            make.right.equalTo(_totalDaysLabel.mas_left);
            make.width.mas_equalTo(.5);
        }];
        
        //入住
        UIView *checkIn = [[UIView alloc] initWithFrame:CGRectZero];
        checkIn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:checkIn];
        [checkIn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.contentView.mas_width).offset(-22).dividedBy(2);
        }];
        
        UIImage *icon = [UIImage imageNamed:@"flightSearch_date"];
        
        UIImageView *checkInIcon = [[UIImageView alloc] initWithImage:icon];
        [checkIn addSubview:checkInIcon];
        [checkInIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(7);
        }];
        
        UILabel *checkInLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkInLabel.font = [UIFont systemFontOfSize:13.0];
        checkInLabel.textColor = [UIColor grayColor];
        checkInLabel.backgroundColor = [UIColor clearColor];
        checkInLabel.text = @"入住时间";
        [checkIn addSubview:checkInLabel];
        [checkInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(36);
        }];
        
        UILabel *checkInDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkInDateLabel.font = [UIFont systemFontOfSize:18.0];
        checkInDateLabel.textColor = [UIColor blackColor];
        checkInDateLabel.backgroundColor = [UIColor clearColor];
        checkInDateLabel.text = @"09月03日";
        [checkIn addSubview:checkInDateLabel];
        [checkInDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(25);
            make.width.mas_equalTo(80);
        }];
        self.checkInDateLabel = checkInDateLabel;
        
        UILabel *checkInWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkInWeekLabel.font = [UIFont systemFontOfSize:14.0];
        checkInWeekLabel.textColor = [UIColor blackColor];
        checkInWeekLabel.backgroundColor = [UIColor clearColor];
        checkInWeekLabel.text = @"星期二";
        [checkIn addSubview:checkInWeekLabel];
        self.checkInWeekLabel = checkInWeekLabel;
        [checkInWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkInDateLabel.mas_right);
            make.top.mas_equalTo(30);
            make.right.mas_lessThanOrEqualTo(0);
        }];
        
        //line
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectZero];
        line2.backgroundColor = [UIColor colorWithWhite:.83 alpha:1];
        [self.contentView addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkIn.mas_right);
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
            make.width.mas_equalTo(.5);
        }];
        
        
        //离店
        UIView *checkOut = [[UIView alloc] initWithFrame:CGRectZero];
        checkOut.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:checkOut];
        [checkOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.equalTo(line2.mas_right);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.contentView.mas_width).offset(-22).dividedBy(2);
        }];
        
        UIImageView *checkOutIcon = [[UIImageView alloc] initWithImage:icon];
        [checkOut addSubview:checkOutIcon];
        [checkOutIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(7);
        }];
        
        UILabel *checkOutLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkOutLabel.font = [UIFont systemFontOfSize:13.0];
        checkOutLabel.textColor = [UIColor grayColor];
        checkOutLabel.backgroundColor = [UIColor clearColor];
        checkOutLabel.text = @"离店时间";
        [checkOut addSubview:checkOutLabel];
        [checkOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.mas_equalTo(36);
        }];
        
        UILabel *checkOutDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkOutDateLabel.font = [UIFont systemFontOfSize:18.0];
        checkOutDateLabel.textColor = [UIColor blackColor];
        checkOutDateLabel.backgroundColor = [UIColor clearColor];
        checkOutDateLabel.text = @"09月03日";
        [checkOut addSubview:checkOutDateLabel];
        [checkOutDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(25);
            make.width.mas_equalTo(80);
        }];
        self.checkOutDateLabel = checkOutDateLabel;
        
        UILabel *checkOutWeekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        checkOutWeekLabel.font = [UIFont systemFontOfSize:14.0];
        checkOutWeekLabel.textColor = [UIColor blackColor];
        checkOutWeekLabel.backgroundColor = [UIColor clearColor];
        checkOutWeekLabel.text = @"星期二";
        [checkOut addSubview:checkOutWeekLabel];
        self.checkOutWeekLabel = checkOutWeekLabel;
        [checkOutWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkOutDateLabel.mas_right);
            make.top.mas_equalTo(30);
            make.right.mas_lessThanOrEqualTo(0);
        }];
        
        /*
        // Initialization code
        UILabel *checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 8, 80, 20)];
        checkInLabel.textColor = [UIColor colorWithRed:108.0f/255.0f
                                                 green:108.0f/255.0f
                                                  blue:108.0f/255.0f
                                                 alpha:1.0];
        [checkInLabel setFont:[UIFont systemFontOfSize:15]];
        [checkInLabel setText:NSLocalizedString(@"hotelCheckIn", nil)];
        [self.contentView addSubview:checkInLabel];
        
        UILabel *checkOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 32, 80, 20)];
        checkOutLabel.textColor = [UIColor colorWithRed:108.0f/255.0f
                                                  green:108.0f/255.0f
                                                   blue:108.0f/255.0f
                                                  alpha:1.0];
        [checkOutLabel setText:NSLocalizedString(@"hotelChechOut", nil)];
        [checkOutLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:checkOutLabel];
         */
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark getter

#pragma mark setter
- (void)setCheckInDate:(NSString *)checkInDate
{
    if (checkInDate != _checkInDate)
    {
        _checkInDate = [checkInDate copy];
        self.checkInDateLabel.text = checkInDate;
    }
}

- (void)setCheckOutDate:(NSString *)checkOutDate
{
    if (checkOutDate != _checkOutDate)
    {
        _checkOutDate = [checkOutDate copy];
        self.checkOutDateLabel.text = checkOutDate;
    }
}

- (void)setCheckInweekDay:(NSString *)checkInweekDay
{
    if (checkInweekDay != _checkInweekDay)
    {
        _checkInweekDay = [checkInweekDay copy];
        self.checkInWeekLabel.text = checkInweekDay;
    }
}

- (void)setCheckOutweekDay:(NSString *)checkOutweekDay
{
    if (checkOutweekDay != _checkOutweekDay)
    {
        _checkOutweekDay = [checkOutweekDay copy];
        self.checkOutWeekLabel.text = checkOutweekDay;
    }
}

- (void)setDay:(NSInteger)aday
{
    if (_day != aday)
    {
        _day = aday;
        _totalDaysLabel.text = [NSString stringWithFormat: @"共%ld晚", (long)aday];
    }
}

@end
