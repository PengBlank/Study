//
//  HYHotelInfoSwitchCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelInfoSwitchCell.h"

@interface HYHotelInfoSwitchCell ()
{
    UILabel *_trafficInfoLabel;
    UILabel *_hotelInfoLabel;
    UIImageView *_selectView;
}

@end

@implementation HYHotelInfoSwitchCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)/2, 44)];
        _selectView.userInteractionEnabled = YES;
        _selectView.backgroundColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
        _selectView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
        [self.contentView addSubview:_selectView];
        
        _trafficInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMidX(self.frame), self.frame.size.height)];
        _trafficInfoLabel.textColor = [UIColor darkGrayColor];
        _trafficInfoLabel.textAlignment = NSTextAlignmentCenter;
        [_trafficInfoLabel setFont:[UIFont systemFontOfSize:16]];
        _trafficInfoLabel.backgroundColor = [UIColor clearColor];
        _trafficInfoLabel.text = NSLocalizedString(@"traffic_info", nil);
        _trafficInfoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_trafficInfoLabel];
        
        _hotelInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame), 0, CGRectGetMidX(self.frame), self.frame.size.height)];
        _hotelInfoLabel.textColor = [UIColor darkGrayColor];
        _hotelInfoLabel.textAlignment = NSTextAlignmentCenter;
        [_hotelInfoLabel setFont:[UIFont systemFontOfSize:16]];
        _hotelInfoLabel.backgroundColor = [UIColor clearColor];
        _hotelInfoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight;
        _hotelInfoLabel.text = NSLocalizedString(@"hotel_Introduction", nil);
        [self.contentView addSubview:_hotelInfoLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateStatus:(NSInteger)index
{
    CGPoint point = (index==0) ? CGPointMake(CGRectGetMidX(self.frame)/2, 22) : CGPointMake(CGRectGetMidX(self.frame)*3/2, 22);
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         _selectView.center = point;
                     }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    CGFloat widthPerItem = frame.size.width / 2;
    NSUInteger itemIndex = floor(location.x / widthPerItem);
    [self updateStatus:itemIndex];
    
    //延时 0.4秒调用，等待动画播放完
    [self performSelector:@selector(sendMessgeIndex:)
               withObject:[NSNumber numberWithInteger:itemIndex]
               afterDelay:0.4];
}

- (void)sendMessgeIndex:(NSNumber *)index
{
    if ([self.delegate respondsToSelector:@selector(swithShowInfo:)])
    {
        BOOL i = (index.intValue==0);
        [self.delegate swithShowInfo:i];
    }
}

@end
