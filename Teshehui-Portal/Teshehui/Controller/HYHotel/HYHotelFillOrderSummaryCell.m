//
//  HYHotelOrderSummaryCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillOrderSummaryCell.h"
#import "Masonry.h"
#import "PTDateFormatrer.h"

@interface HYHotelFillOrderSummaryCell ()

@property (nonatomic, strong) UILabel *hotelNameLabel;
@property (nonatomic, strong) UILabel *checkInLabel;
@property (nonatomic, strong) UILabel *checkOutLabel;
@property (nonatomic, strong) UILabel *daysLabel;
@end

@implementation HYHotelFillOrderSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        /**
         *  酒店名 左10, 上10, 右边30 留给天数, 高度自适应字体
         */
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:16.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:nameLabel];
        self.hotelNameLabel = nameLabel;
        [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-30);
        }];
        
        /**
         *  入住, 离店, 排除天数后等宽布局
         */
        UILabel *labCheckIn = [[UILabel alloc] initWithFrame:CGRectMake(14, 40, 32, 16)];
        labCheckIn.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        labCheckIn.text = NSLocalizedString(@"hotelCheckIn", nil);
        [labCheckIn setFont:[UIFont systemFontOfSize:13]];
        labCheckIn.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labCheckIn];
        self.checkInLabel = labCheckIn;
        
        UILabel *labCheckOut = [[UILabel alloc] initWithFrame:CGRectMake(120, 40, 32, 16)];
        labCheckOut.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        labCheckOut.text = NSLocalizedString(@"hotelChechOut", nil);
        [labCheckOut setFont:[UIFont systemFontOfSize:13]];
        labCheckOut.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:labCheckOut];
        self.checkOutLabel = labCheckOut;
        
        [labCheckIn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.top.equalTo(nameLabel.mas_bottom).offset(5);
            make.width.equalTo(labCheckOut.mas_width);
            make.right.equalTo(labCheckOut.mas_left);
        }];
        [labCheckOut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.top.equalTo(labCheckIn.mas_top);
        }];
        
        UILabel *daysLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        daysLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        daysLabel.backgroundColor = [UIColor clearColor];
        daysLabel.font = [UIFont systemFontOfSize:11.0];
        daysLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:daysLabel];
        self.daysLabel = daysLabel;
        [daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(30);
            make.right.mas_equalTo(0);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter/getter
- (void)setHotelName:(NSString *)hotelName
{
    if (hotelName != _hotelName)
    {
        _hotelName = [hotelName copy];
        self.hotelNameLabel.text = hotelName;
    }
}

- (void)setCheckInDate:(NSString *)checkInDate
{
    if ([checkInDate length]>5 && checkInDate != _checkInDate)
    {
        _checkInDate = [checkInDate copy];
        self.checkInLabel.text = [NSString stringWithFormat:@"入住时间:%@", checkInDate];
    }
}

- (void)setCheckOutDate:(NSString *)checkOutDate
{
    if ([checkOutDate length]>5 && checkOutDate != _checkOutDate)
    {
        _checkOutDate = [checkOutDate copy];
        self.checkOutLabel.text = [NSString stringWithFormat:@"离店时间:%@", checkOutDate];
    }
    
    //时间
    {
        NSString *formate = @"yyyy-MM-dd";
        NSDate *indate = [PTDateFormatrer dateFromString:_checkInDate format:formate];
        NSDate *outDate = [PTDateFormatrer dateFromString:_checkOutDate format:formate];
        if (indate && outDate)
        {
            NSCalendar *calender = [NSCalendar currentCalendar];
            NSDateComponents *days = [calender components:NSCalendarUnitDay fromDate:indate toDate:outDate options:0];
            self.daysLabel.text = [NSString stringWithFormat:@"%ld晚", (long)days.day];
        }
    }
}

//- (UILabel *)checkInLabel
//{
//    if (!_checkInLabel)
//    {
//        _checkInLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 60, 16)];
//        _checkInLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
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
//        _checkOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 40, 60, 16)];
//        _checkOutLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
//        [_checkOutLabel setFont:[UIFont systemFontOfSize:15]];
//        _checkOutLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_checkOutLabel];
//    }
//    
//    return _checkOutLabel;
//}

@end
