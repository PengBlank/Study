//
//  HYFlightOrderPassengerCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightOrderPassengerCell.h"

@interface HYFlightOrderPassengerCell ()
{
    UILabel *_nameLab;
    UILabel *_passengerLab;
    
    UILabel *_ticketNOLab;
    UILabel *_certificateInfoLab;
}
@end

@implementation HYFlightOrderPassengerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 12, 100, 16)];
        _nameLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_nameLab setFont:[UIFont systemFontOfSize:TFScalePoint(14)]];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.text = @"乘机人";
        [self.contentView addSubview:_nameLab];
        
        _passengerLab = [[UILabel alloc] initWithFrame:CGRectMake(bounds.size.width - 80, 12, 70, 16)];
        _passengerLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_passengerLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _passengerLab.backgroundColor = [UIColor clearColor];
        _passengerLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_passengerLab];
        
        UIImageView *line1 = [[UIImageView alloc] initWithFrame:CGRectMake(6, 40, CGRectGetWidth(ScreenRect)-6, 1.0)];
        line1.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                 topCapHeight:0];
        [self addSubview:line1];
        
        _certificateInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 52, 280, 16)];
        _certificateInfoLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_certificateInfoLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _certificateInfoLab.backgroundColor = [UIColor clearColor];
        _certificateInfoLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_certificateInfoLab];
        
        UILabel *_eLab = [[UILabel alloc] initWithFrame:CGRectMake(14, 80, 96, 16)];
        _eLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_eLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _eLab.backgroundColor = [UIColor clearColor];
        _eLab.textAlignment = NSTextAlignmentLeft;
        _eLab.text = @"电子客票号:";
        [self.contentView addSubview:_eLab];
        
        _ticketNOLab = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 140, 16)];
        _ticketNOLab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [_ticketNOLab setFont:[UIFont systemFontOfSize:TFScalePoint(13)]];
        _ticketNOLab.backgroundColor = [UIColor clearColor];
        _ticketNOLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_ticketNOLab];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark setter/getter
- (void)setPassenger:(HYFlightGuest *)passenger
{
    if (passenger != _passenger)
    {
        _passenger = passenger;
        _passengerLab.text = passenger.name;
        
        NSString *cerId = passenger.certificateName;
        
        if (!cerId)
        {
            cerId = @"身份证";
        }
        else
        {
            if (passenger.certificateNumber)
            {
                cerId = [NSString stringWithFormat:@"%@ : %@", cerId, passenger.certificateNumber];
            }
        }
        
        _certificateInfoLab.text = cerId;
    }
}
@end
