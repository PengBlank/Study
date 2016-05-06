//
//  HYHotelTrafficCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelTrafficCell.h"

@interface HYHotelTrafficCell ()

@property (strong, nonatomic) UILabel *distanceLabel;
@property (strong, nonatomic) UILabel *traDescLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;

@end

@implementation HYHotelTrafficCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel_trf_arrow"]];
        _arrowImageView.frame = CGRectMake(280, 12, 10, 10);
        [self.contentView addSubview:_arrowImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)addExpandView:(UIView *)view
{
    if (view)
    {
        [self changeArrowWithUp:YES];
        UIView *pre = [self.contentView viewWithTag:111];
        [pre removeFromSuperview];
        
        CGRect frame = view.frame;
        frame.origin.x = 5;
        frame.origin.y = 32;
        view.frame = frame;
        view.tag = 111;
        [self.contentView addSubview:view];
    }
}

- (void)removeExpandView
{
    [self changeArrowWithUp:NO];
    UIView *pre = [self.contentView viewWithTag:111];
    [pre removeFromSuperview];
}

- (void)setDistance:(NSString *)distance
{
    if (distance != _distance)
    {
        _distance = [distance copy];
        self.distanceLabel.text = [NSString stringWithFormat:@"%@公里", distance];
    }
}

- (void)setTraDesc:(NSString *)traDesc
{
    if (traDesc != _traDesc)
    {
        _traDesc = [traDesc copy];
        self.traDescLabel.text = traDesc;
    }
}

- (void)changeArrowWithUp:(BOOL)up
{
    [UIView animateWithDuration:0.2 animations:^{
        if (up) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
            
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }}];
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(156, 9, 120, 16)];
        _distanceLabel.textColor = [UIColor colorWithRed:51.0f/255.0f
                                                   green:147.0f/255.0f
                                                    blue:196.0f/255.0f
                                                   alpha:1.0];
        [_distanceLabel setFont:[UIFont systemFontOfSize:14]];
        _distanceLabel.backgroundColor = [UIColor clearColor];
        _distanceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_distanceLabel];
    }
    
    return _distanceLabel;
}

- (UILabel *)traDescLabel
{
    if (!_traDescLabel)
    {
        _traDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 6, 150, 18)];
        _traDescLabel.textColor = [UIColor blackColor];
        [_traDescLabel setFont:[UIFont systemFontOfSize:14]];
        _traDescLabel.backgroundColor = [UIColor clearColor];
        _traDescLabel.textAlignment = NSTextAlignmentLeft;
        _traDescLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _traDescLabel.numberOfLines = 10;
        [self.contentView addSubview:_traDescLabel];
    }
    
    return _traDescLabel;
}
@end
