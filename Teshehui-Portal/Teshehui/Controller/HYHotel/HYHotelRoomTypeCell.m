//
//  HYHotelRoomTypeCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRoomTypeCell.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface HYHotelRoomTypeCell ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *iconView;

@end

@implementation HYHotelRoomTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *assView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-22, 42, 10, 15)];
        assView.image = [UIImage imageNamed:@"ico_arrow_list"];
        //assView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        assView.tag = 100;
        [self.contentView addSubview:assView];
        [assView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 15));
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.mas_equalTo(-10);
        }];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 60, 60)];
        [self.contentView addSubview:_iconView];
        [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(12);
        }];
        
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = [UIFont systemFontOfSize:16.0];
        _nameLab.backgroundColor = [UIColor clearColor];
        _nameLab.numberOfLines = 2;
        [self.contentView addSubview:_nameLab];
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_iconView.mas_right).offset(5);
            make.top.equalTo(_iconView.mas_top).offset(3);
            make.right.equalTo(assView.mas_left);
        }];
        
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.font = [UIFont systemFontOfSize:14.0];
        _descLab.backgroundColor = [UIColor clearColor];
        _descLab.textColor = [UIColor colorWithWhite:.4 alpha:1];
        [self.contentView addSubview:_descLab];
        [_descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLab.mas_left);
            make.top.equalTo(_nameLab.mas_bottom).offset(3);
            make.right.equalTo(assView.mas_left);
        }];
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.numberOfLines = 0;
        
//        _breakfastLab = [[UILabel alloc] initWithFrame:CGRectMake(80, 34, 32, 16)];
//        _breakfastLab.textColor = [UIColor grayColor];
//        _breakfastLab.backgroundColor = [UIColor clearColor];
//        [_breakfastLab setFont:[UIFont systemFontOfSize:14]];
//        [self.contentView addSubview:_breakfastLab];
        
//        _badInfoLab = [[UILabel alloc] initWithFrame:CGRectMake(112, 34, 120, 16)];
//        _badInfoLab.textColor = [UIColor grayColor];
//        _badInfoLab.textAlignment = NSTextAlignmentLeft;
//        _badInfoLab.backgroundColor = [UIColor clearColor];
//        [_badInfoLab setFont:[UIFont systemFontOfSize:14]];
//        [self.contentView addSubview:_badInfoLab];
       
//        _priceIconLab = [[UILabel alloc] initWithFrame:CGRectMake(235, 13, 20, 20)];
//        _priceIconLab.textColor = [UIColor colorWithRed:253.0f/255.0f
//                                                 green:127.0f/255.0f
//                                                  blue:0.0f/26.0f
//                                                 alpha:1.0];
//        _priceIconLab.text = @"￥";
//        _priceIconLab.backgroundColor = [UIColor clearColor];
//        [_priceIconLab setFont:[UIFont systemFontOfSize:14]];
//        [self.contentView addSubview:_priceIconLab];
//        
//        _priceLab = [[UILabel alloc] initWithFrame:CGRectMake(250, 12, 55, 20)];
//        _priceLab.textColor = [UIColor colorWithRed:253.0f/255.0f
//                                              green:127.0f/255.0f
//                                               blue:0.0f/26.0f
//                                              alpha:1.0];
//        _priceLab.backgroundColor = [UIColor clearColor];
//        [_priceLab setFont:[UIFont boldSystemFontOfSize:18]];
//        [self.contentView addSubview:_priceLab];
//        
//        _pointIconLab = [[UILabel alloc] initWithFrame:CGRectMake(235, 33, 14, 14)];
//        _pointIconLab.textColor = [UIColor whiteColor];
//        _pointIconLab.text = @"送";
//        _pointIconLab.textAlignment = NSTextAlignmentCenter;
//        _pointIconLab.backgroundColor = [UIColor colorWithRed:253.0f/255.0f
//                                                       green:127.0f/255.0f
//                                                        blue:0.0f/26.0f
//                                                       alpha:1.0];
//        [_pointIconLab setFont:[UIFont boldSystemFontOfSize:12]];
//        [self.contentView addSubview:_pointIconLab];
//        
//        _pointLab = [[UILabel alloc] initWithFrame:CGRectMake(252, 33, 262, 14)];
//        _pointLab.textColor = [UIColor colorWithRed:253.0f/255.0f
//                                              green:127.0f/255.0f
//                                               blue:0.0f/26.0f
//                                              alpha:1.0];
//        _pointLab.backgroundColor = [UIColor clearColor];
//        [_pointLab setFont:[UIFont systemFontOfSize:12]];
//        [self.contentView addSubview:_pointLab];
//        
//        //booking
//        UIImage *normalImg = [[UIImage imageNamed:@"reserve_normal_bg"] stretchableImageWithLeftCapWidth:5
//                                                                                            topCapHeight:0];
//        UIImage *highlightedImg = [[UIImage imageNamed:@"reserve_press_bg"] stretchableImageWithLeftCapWidth:5
//                                                                                                topCapHeight:0];
//        UIImage *disabledImg = [[UIImage imageNamed:@"reserve_disable_bg"] stretchableImageWithLeftCapWidth:5
//                                                                                               topCapHeight:0];
//        
//        UIButton *reserveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [reserveBtn setTitleColor:[UIColor whiteColor]
//                         forState:UIControlStateNormal];
//        [reserveBtn setBackgroundImage:normalImg
//                              forState:UIControlStateNormal];
//        [reserveBtn setBackgroundImage:highlightedImg
//                              forState:UIControlStateHighlighted];
//        [reserveBtn setBackgroundImage:disabledImg
//                              forState:UIControlStateDisabled];
//        [reserveBtn setTitle:NSLocalizedString(@"reserve", nil) forState:UIControlStateNormal];
//        reserveBtn.frame = CGRectMake(230, 54, 60, 30);
//        [reserveBtn addTarget:self
//                       action:@selector(advanceBooking:)
//             forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:reserveBtn];
//        self.reserveBtn = reserveBtn;
        
        UIImageView * _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, 320, 1.0)];
        _lineView.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:2
                                                                                     topCapHeight:0];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)advanceBooking:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(advanceBookingRoom:)])
    {
        [self.delegate advanceBookingRoom:self.roomInfo];
    }
}

- (void)setIsExpanded:(BOOL)isExpanded
{
    [super setIsExpanded:isExpanded];
    UIView *ass = [self.contentView viewWithTag:100];
    if (isExpanded)
    {
        ass.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        ass.transform = CGAffineTransformIdentity;
    }
}

- (void)setRoomInfo:(HYHotelSKU *)roomInfo
{
    if (roomInfo != _roomInfo)
    {
        _roomInfo = roomInfo;
        
        self.nameLab.text = roomInfo.roomTypeName;
        
        NSString *desc = @"";
        if (roomInfo.areaSize.length > 0)
        {
            desc = [desc stringByAppendingFormat:@"面积:%@", roomInfo.areaSize];
        }
        if (roomInfo.bedType.length > 0)
        {
            desc = [desc stringByAppendingFormat:@" 床型:%@", roomInfo.bedType];
        }
        self.descLab.text = desc;
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:roomInfo.midLogoUrl]
                       placeholderImage:[UIImage imageNamed:@"default_room_logo_120"]];
    }
}
@end
