//
//  HYFlightSwitchView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-25.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlightSwitchView.h"

@interface HYFlightSwitchView ()
{
    NSInteger _index;
    UILabel *_singleLab;
    UILabel *_roundTrip;
    
}

@property (nonatomic, strong) UIView *selectView;
@end

@implementation HYFlightSwitchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _index = 0;
        UIView *verticalLine = [UIView new];
        verticalLine.frame = TFRectMake(160, 8, 1, 29);
        verticalLine.backgroundColor = [UIColor colorWithRed:242.0f/255.0f
                                                       green:242.0f/255.0f
                                                        blue:242.0f/255.0f
                                                       alpha:1.0];
        [self addSubview:verticalLine];
        
        self.backgroundColor = [UIColor whiteColor];
        
        _singleLab = [[UILabel alloc] initWithFrame:TFRectMake(30, 12, 100, 18)];
        _singleLab.textColor = [UIColor colorWithRed:40.0f/255.0f
                                               green:181.0f/255.0f
                                                blue:245.0f/255.0f
                                               alpha:1.0];
        [_singleLab setFont:[UIFont systemFontOfSize:15]];
        _singleLab.backgroundColor = [UIColor clearColor];
        _singleLab.textAlignment = NSTextAlignmentCenter;
        _singleLab.text = @"单程";
        [self addSubview:_singleLab];
        
        _roundTrip = [[UILabel alloc] initWithFrame:TFRectMake(190, 12, 100, 18)];
        _roundTrip.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        [_roundTrip setFont:[UIFont systemFontOfSize:15]];
        _roundTrip.backgroundColor = [UIColor clearColor];
        _roundTrip.textAlignment = NSTextAlignmentCenter;
        _roundTrip.text = @"往返";
        [self addSubview:_roundTrip];
        
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(50, frame.size.height-2, frame.size.width/2-100, 2)];
        _selectView.backgroundColor = [UIColor colorWithRed:40.0f/255.0f
                                                      green:181.0f/255.0f
                                                       blue:245.0f/255.0f
                                                      alpha:1.0];
        [self addSubview:_selectView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)updateStatus:(NSInteger)index
{
    if (index != _index)
    {
        _index = index;
        
        if (index == 1)
        {
            _roundTrip.textColor = [UIColor colorWithRed:40.0f/255.0f
                                                   green:181.0f/255.0f
                                                    blue:245.0f/255.0f
                                                   alpha:1.0];
            _singleLab.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        }
        else
        {
            _singleLab.textColor = [UIColor colorWithRed:40.0f/255.0f
                                                   green:181.0f/255.0f
                                                    blue:245.0f/255.0f
                                                   alpha:1.0];
            _roundTrip.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        }
        
        CGPoint point = (index==0) ? CGPointMake(self.frame.size.width/4,
                                                 _selectView.center.y) : CGPointMake(self.frame.size.width*0.75,
                                                                                     _selectView.center.y);
        __weak typeof (self) weakSelf = self;
        [UIView animateWithDuration:0.3
                         animations:^{
                             weakSelf.selectView.center = point;
                         }];
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    CGRect frame = [self frame];
    CGFloat widthPerItem = frame.size.width / 2;
    NSUInteger itemIndex = floor(location.x / widthPerItem);
    [self updateStatus:itemIndex];
    
//    //延时 0.4秒调用，等待动画播放完
//    [self performSelector:@selector(sendMessgeIndex:)
//               withObject:[NSNumber numberWithInt:itemIndex]
//               afterDelay:0.4];
}

@end
