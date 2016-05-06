//
//  HYTaxiResponseInfoView.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiResponseInfoView.h"
#import "UIImageView+WebCache.h"
#import "TQStarRatingView.h"
#import "UIAlertView+BlocksKit.h"

@implementation HYTaxiResponseInfoView
{
    IBOutlet UIImageView *_photo;
    IBOutlet UILabel *_name;
    IBOutlet UILabel *_car;
    IBOutlet UILabel *_score;
    IBOutlet UILabel *_orderCount;
    
    IBOutlet UILabel *_dianstance;
    IBOutlet UILabel *_time;
    
    TQStarRatingView *_rating;
}

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithWhite:.9 alpha:1].CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 3.0;
    _photo.layer.cornerRadius = CGRectGetMidX(_photo.bounds);
    _photo.layer.masksToBounds = YES;
    
    _score.backgroundColor = [UIColor colorWithRed:255/255.0 green:184/255.0 blue:90/255.0 alpha:1];
    _score.layer.cornerRadius = 2.0;
    _score.layer.masksToBounds = YES;
    _score.textAlignment = NSTextAlignmentCenter;
    
    _rating = [[TQStarRatingView alloc] initWithStar:[UIImage imageNamed:@"didistar"] hilightedStar:[UIImage imageNamed:@"didistars"] numberOfStar:5 spaceOfStar:3];
    [self addSubview:_rating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _rating.frame = CGRectMake(CGRectGetMinX(_car.frame), CGRectGetMinY(_score.frame)+5, 65, 10);
    
    CGRect frame = _score.frame;
    frame.size.width += 10;
    _score.frame = frame;
    
    frame = _orderCount.frame;
    frame.origin.x += 10;
    _orderCount.frame = frame;
}

- (void)setOrderView:(HYTaxiOrderView *)orderView
{
    _orderView = orderView;
    
    [_photo sd_setImageWithURL:[NSURL URLWithString:orderView.driverHeadPicUrl] placeholderImage:[UIImage imageNamed:@"loading"]];
    _name.text = orderView.driverName;
    _car.text = [NSString stringWithFormat:@"%@ %@", orderView.driverLicence, orderView.driverCarType];
    _score.text = [NSString stringWithFormat:@"%.1f", orderView.driverLevel.floatValue];
    _orderCount.text = [NSString stringWithFormat:@"%@单", orderView.driverOrderCount];
    _rating.rating = orderView.driverLevel.floatValue;
}

- (IBAction)phoneAction:(id)sender
{
    if (_orderView)
    {
        [UIAlertView bk_showAlertViewWithTitle:nil message:[NSString stringWithFormat:@"是否拨打电话%@", _orderView.driverPhone] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex)
        {
            if (buttonIndex == 1)
            {
                NSString *phoneurl = [NSString stringWithFormat:@"tel://%@", _orderView.driverPhone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneurl]];
            }
        }];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
