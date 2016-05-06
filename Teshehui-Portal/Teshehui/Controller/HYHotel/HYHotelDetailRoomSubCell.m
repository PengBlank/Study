//
//  HYHotelDetailRoomSubCell.m
//  Teshehui
//
//  Created by RayXiang on 14-11-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailRoomSubCell.h"


@interface HYHotelDetailRoomSubCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *pointLabel;
@property (nonatomic, strong) UIButton *checkBtn;

@end

@implementation HYHotelDetailRoomSubCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        UIImageView * _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-1, 320, 1.0)];
        _lineView.image = [[UIImage imageNamed:@"line_cell_top"]
                           stretchableImageWithLeftCapWidth:2 topCapHeight:0];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_lineView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 180, 35)];
        titleLabel.font = [UIFont systemFontOfSize:14.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.numberOfLines = 0;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 17, 80, 20)];
        _priceLabel.font = [UIFont systemFontOfSize:18.0];
        _priceLabel.backgroundColor = [UIColor clearColor];
        _priceLabel.textColor = [UIColor colorWithRed:190.0f/255.0
                                               green:17.0f/255.0f
                                                blue:40.0f/255.0f
                                               alpha:1.0];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_priceLabel];
        
        _pointLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, CGRectGetMaxY(_priceLabel.frame), 100, 12)];
        _pointLabel.font = [UIFont systemFontOfSize:10.0];
        _pointLabel.backgroundColor = [UIColor clearColor];
        _pointLabel.textAlignment = NSTextAlignmentRight;
        _pointLabel.textColor = [UIColor colorWithRed:255/255.0
                                               green:165/255.0
                                                blue:78/255.0
                                               alpha:1];

        _pointLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_pointLabel];
        
        self.checkBtn = [[UIButton alloc] initWithFrame:CGRectMake(265, 16, 42, 30)];
        UIImage *checkImg = [UIImage imageNamed:@"icon_order_btn"];
        checkImg = [checkImg stretchableImageWithLeftCapWidth:3 topCapHeight:3];
        [self.checkBtn setBackgroundImage:checkImg forState:UIControlStateNormal];
        [self.checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.checkBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [self.checkBtn setUserInteractionEnabled:NO];
        self.checkBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:self.checkBtn];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_titleLabel.frame)+4, 44, 18)];
        icon.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:icon];
        self.icon = icon;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPlan:(HYHotelSKU *)plan
{
    if (plan != _plan)
    {
        _plan = plan;
        
        NSString *title = _plan.roomRatePlanName;
        //title = @"这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的这是用来测试的";
        _titleLabel.text = title;
        
        NSString *price = nil;
        if (_plan.averageFee > 0)
        {
            price = [NSString stringWithFormat:@"¥%@", @(_plan.averageFee)];
        }
        else
        {
            price = @"¥暂无价格";
        }
        
        _priceLabel.textColor = [UIColor redColor];
        
        if ([_priceLabel respondsToSelector:@selector(setAttributedText:)])
        {
            NSMutableAttributedString *price_attr = [[NSMutableAttributedString alloc] initWithString:price];
            [price_attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0], NSFontAttributeName, nil] range:NSMakeRange(0, 1)];
            [price_attr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18.0], NSFontAttributeName, nil] range:NSMakeRange(1, price.length-2)];
            [_priceLabel setAttributedText:price_attr];
        }
        else
        {
            _priceLabel.text = price;
        }
        
        NSString *point = [NSString stringWithFormat:@"送%@现金券", _plan.points];
        _pointLabel.text = point;
        
        if ([_plan.attributeValue1 isEqualToString:HotelRatePlanCrip])
        {
            self.icon.image = [UIImage imageNamed:@"xc_cabin_icon"];
        }
        else if ([_plan.attributeValue1 isEqualToString:HOtelRatePlanElong])
        {
            self.icon.image = [UIImage imageNamed:@"hotel_yl_icon"];
        }
        
        NSString *str = _plan.isPrePay ? @"预付" : NSLocalizedString(@"reserve", nil);
        [self.checkBtn setTitle:str forState:UIControlStateNormal];
        
        
        if (!_plan.status)
        {
            [self.checkBtn setEnabled:NO];
        }
        else
        {
            [self.checkBtn setEnabled:YES];
        }
    }
}

@end
