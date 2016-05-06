//
//  HYRPRecordHeaderView.m
//  Teshehui
//
//  Created by HYZB on 15/3/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYRPRecordHeaderView.h"
#import "UIImage+Addition.h"

@interface HYRPRecordHeaderView ()

@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *countDescLab;
@property (nonatomic, strong) UILabel *totalLab;
@property (nonatomic, strong) UILabel *totalDescLab;

@end

@implementation HYRPRecordHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        imageview.image = [UIImage imageNamed:@"t_jilu_top"];
        [self addSubview:imageview];
        
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"我收到的", @"我发出的"]];
        UIFont *font = [UIFont systemFontOfSize:18.0f];
        NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                               forKey:NSFontAttributeName];
        [segmentedControl setTitleTextAttributes:attributes
                                        forState:UIControlStateNormal];
        segmentedControl.frame = TFRectMake(24, 20, 234, 30);
        segmentedControl.tintColor = [UIColor colorWithRed:254.0/255.0
                                                     green:246.0/255.0
                                                      blue:228.0/255.0
                                                     alpha:1.0];
        segmentedControl.backgroundColor = [UIColor colorWithRed:235.0/255.0
                                                           green:56.0/255.0
                                                            blue:37.0/255.0
                                                           alpha:1.0];
        segmentedControl.selectedSegmentIndex = 0;
        [segmentedControl addTarget:self
                             action:@selector(onSegmentChanged:)
                   forControlEvents:UIControlEventValueChanged];
        [self addSubview:segmentedControl];
        
        _countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, CGRectGetMidX(frame), 24)];
        _countLab.textColor = [UIColor colorWithRed:253.0/255.0
                                              green:236.0/255.0
                                               blue:53.0/255.0
                                              alpha:1.0];
        _countLab.backgroundColor = [UIColor clearColor];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.font = [UIFont systemFontOfSize:20];
        _countLab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_countLab];
        
        _totalLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), 90, CGRectGetMidX(frame), 24)];
        _totalLab.textColor = [UIColor colorWithRed:253.0/255.0
                                              green:236.0/255.0
                                               blue:53.0/255.0
                                              alpha:1.0];
        _totalLab.backgroundColor = [UIColor clearColor];
        _totalLab.textAlignment = NSTextAlignmentCenter;
        _totalLab.font = [UIFont systemFontOfSize:20];
        _totalLab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_totalLab];
        
        _countDescLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, CGRectGetMidX(frame), 24)];
        _countDescLab.textColor = [UIColor whiteColor];
        _countDescLab.backgroundColor = [UIColor clearColor];
        _countDescLab.textAlignment = NSTextAlignmentCenter;
        _countDescLab.font = [UIFont systemFontOfSize:18];
        _countDescLab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;;
        [self addSubview:_countDescLab];
        
        _totalDescLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(frame), 120, CGRectGetMidX(frame), 24)];
        _totalDescLab.textColor = [UIColor whiteColor];
        _totalDescLab.backgroundColor = [UIColor clearColor];
        _totalDescLab.textAlignment = NSTextAlignmentCenter;
        _totalDescLab.font = [UIFont systemFontOfSize:18];
        _totalDescLab.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin;;
        [self addSubview:_totalDescLab];
    }
    
    return self;
}

#pragma mark private methods
- (void)onSegmentChanged:(UISegmentedControl *)seg
{
    if ([self.delegate respondsToSelector:@selector(didSwitchRedpacketRecordType:)])
    {
        [self.delegate didSwitchRedpacketRecordType:(seg.selectedSegmentIndex==0)];
    }
}

@end
