//
//  HYMallHomeTextAdsCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/5.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeTextAdsCell.h"
#import "Masonry.h"
#import "UIColor+hexColor.h"
#import "HYMallHomeItem.h"
#import "UIView+MJExtension.h"

@interface HYMallHomeTextAdsCell ()
{
    NSTimer *_timer;
}

@property (nonatomic, strong) UILabel *adsLab;
@property (nonatomic, strong) UILabel *adsNameLab;


@end

@implementation HYMallHomeTextAdsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, frame.size.height)];
        lab.font = [UIFont systemFontOfSize:15.0];
        lab.text = @"特报";
        [self.contentView addSubview:lab];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, 10, 1, frame.size.height-20)];
        line.backgroundColor = [UIColor colorWithWhite:.95 alpha:1];
        [self.contentView addSubview:line];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(line.frame) + 5, 0, 14, frame.size.height)];
        icon.image = [UIImage imageNamed:@"icon_home_ads"];
        icon.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:icon];
        
        UILabel *adsNameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 5, 0, CGRectGetWidth(frame)-CGRectGetMaxX(icon.frame), frame.size.height/2)];
        adsNameLab.font = [UIFont systemFontOfSize:14.0];
        adsNameLab.textColor = [UIColor colorWithHexColor:@"555555" alpha:1];
        adsNameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:adsNameLab];
        self.adsNameLab = adsNameLab;
        
        UILabel *adsLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(icon.frame) + 5, CGRectGetMaxY(adsNameLab.frame), CGRectGetWidth(frame)-CGRectGetMaxX(icon.frame), frame.size.height/2)];
        adsLab.font = [UIFont systemFontOfSize:14.0];
        adsLab.textColor = [UIColor redColor];
        adsLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:adsLab];
        self.adsLab = adsLab;
        
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, .5)];
//        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView3.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView3];
    }
    return self;
}

- (void)setBoard:(HYMallHomeBoard *)board
{
    if (_board != board) {
        _board = board;
        [self setItems:board.programPOList];
    }
}

- (void)setItems:(NSArray *)items
{
    if (_items != items)
    {
        _items = items;
        
        if (items.count > 0)
        {
            _currentIdx = 0;
            HYMallHomeItem *item = [items objectAtIndex:0];
            [self setCurrentItem:item];
            if (items.count > 1) {
                [self startTimming];
            }
        }
    }
}

- (void)startTimming
{
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)timerAction:(NSTimer *)timer
{
    CGRect frame = self.adsLab.frame;
    frame.origin.y = self.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        self.adsLab.frame = frame;
        self.adsNameLab.mj_y = self.frame.size.height;
    } completion:^(BOOL finished) {
        self.adsNameLab.mj_y = -self.adsNameLab.frame.size.height;
        self.adsLab.mj_y = -self.adsLab.frame.size.height;
        _currentIdx = [self.items indexOfObject:self.currentItem];
        _currentIdx += 1;
        if (_currentIdx == self.items.count)
        {
            _currentIdx = 0;
        }
        [self setCurrentItem:[self.items objectAtIndex:_currentIdx]];
        [UIView animateWithDuration:.3 animations:^{
            self.adsNameLab.mj_y = 0;
            self.adsLab.mj_y = self.frame.size.height/2;
        } completion:nil];
    }];
}

- (void)setCurrentItem:(HYMallHomeItem *)currentItem
{
    _currentItem = currentItem;
    self.adsLab.text = currentItem.advertMessage;
    self.adsNameLab.text = currentItem.name;
}

//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    [super willMoveToSuperview:newSuperview];
//}

@end
