//
//  CQSwithControl.m
//  Teshehui
//
//  Created by ChengQian on 13-10-30.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQSwithControl.h"

@interface CQSwithControl ()
{
    double startTime;
    BOOL isAnimating;
}
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *knobImageView;

@property (nonatomic, strong) UILabel *onLabel;
@property (nonatomic, strong) UILabel *offLabel;

@end

@implementation CQSwithControl

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    // use the default values if CGRectZero frame is set
    CGRect initialFrame;
    if (CGRectIsEmpty(frame)) {
        initialFrame = CGRectMake(0, 0, 50, 30);
    }
    else {
        initialFrame = frame;
    }
    self = [super initWithFrame:initialFrame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 *	Setup the individual elements of the switch and set default values
 */
- (void)setup {
    
    // default values
    self.on = NO;

    // background
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_bgImageView];
    
    // knob
    _knobImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width/2 - 2, self.frame.size.height-2)];
    [self addSubview:_knobImageView];
    
    _onLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height)];
    _onLabel.font = [UIFont systemFontOfSize:14];
    _onLabel.backgroundColor = [UIColor clearColor];
    _onLabel.textAlignment = NSTextAlignmentCenter;
    _onLabel.textColor = [UIColor whiteColor];
    [self addSubview:_onLabel];
    
    _offLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, self.frame.size.height)];
    _offLabel.font = [UIFont systemFontOfSize:14];
    _offLabel.backgroundColor = [UIColor clearColor];
    _offLabel.textAlignment = NSTextAlignmentCenter;
    _offLabel.textColor = [UIColor whiteColor];
    [self addSubview:_offLabel];
    
    isAnimating = NO;
}
#pragma mark Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    // start timer to detect tap later in endTrackingWithTouch:withEvent:
    startTime = [[NSDate date] timeIntervalSince1970];
    
    // make the knob larger and animate to the correct color
    isAnimating = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        if (self.on) {
            CGFloat point_x = 1+_knobImageView.frame.size.width/2;
            _knobImageView.center = CGPointMake(point_x, _knobImageView.center.y);
        }
        else {
            CGFloat point_x = self.frame.size.width/2+1+_knobImageView.frame.size.width/2;
            _knobImageView.center = CGPointMake(point_x, _knobImageView.center.y);
        }
    } completion:^(BOOL finished) {
        isAnimating = NO;
    }];
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    // Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    // update the switch to the correct visuals depending on if
    // they moved their touch to the right or left side of the switch
    if (lastPoint.x > self.bounds.size.width * 0.5)
        [self showOn:YES];
    else
        [self showOff:YES];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    // capture time to see if this was a tap action
    double endTime = [[NSDate date] timeIntervalSince1970];
    double difference = endTime - startTime;
    BOOL previousValue = self.on;
    
    // determine if the user tapped the switch or has held it for longer
    if (difference <= 0.2) {
        [self setOn:!self.on animated:YES];
    }
    else {
        // Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        
        // update the switch to the correct value depending on if
        // their touch finished on the right or left side of the switch
        if (lastPoint.x > self.bounds.size.width * 0.5)
            [self setOn:YES animated:YES];
        else
            [self setOn:NO animated:YES];
    }
    
    if (previousValue != self.on)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    
    // just animate back to the original value
    if (self.on)
        [self showOn:YES];
    else
        [self showOff:YES];
}



#pragma mark Setters
- (void)setOnText:(NSString *)onText
{
    _onLabel.text = onText;
}

- (void)setOffText:(NSString *)offText
{
    _offLabel.text = offText;
}

- (void)setBgImage:(UIImage *)bgImage
{
    _bgImageView.image = bgImage;
}

- (void)setKnobImage:(UIImage *)knobImage
{
    _knobImageView.image = knobImage;
}

/*
 * Set (without animation) whether the switch is on or off
 */
- (void)setOn:(BOOL)isOn {
    [self setOn:isOn animated:NO];
}


/*
 * Set the state of the switch to on or off, optionally animating the transition.
 */
- (void)setOn:(BOOL)isOn animated:(BOOL)animated {
    _on = isOn;
    
    if (isOn) {
        [self showOn:animated];
    }
    else {
        [self showOff:animated];
    }
}


#pragma mark Getters

/*
 *	Detects whether the switch is on or off
 *
 *	@return	BOOL YES if switch is on. NO if switch is off
 */
- (BOOL)isOn {
    return self.on;
}


#pragma mark State Changes


/*
 * update the looks of the switch to be in the on position
 * optionally make it animated
 */
- (void)showOn:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.height - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking)
            {
                
            }
//                _knobImageView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _knobImageView.frame.origin.y, activeKnobWidth, _knobImageView.frame.size.height);
            else
            {
                
            }
//                _knobImageView.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), _knobImageView.frame.origin.y, normalKnobWidth, _knobImageView.frame.size.height);
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking)
            _knobImageView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), _knobImageView.frame.origin.y, activeKnobWidth, _knobImageView.frame.size.height);
        else
            _knobImageView.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), _knobImageView.frame.origin.y, normalKnobWidth, _knobImageView.frame.size.height);
    }
}


/*
 * update the looks of the switch to be in the off position
 * optionally make it animated
 */
- (void)showOff:(BOOL)animated {
    CGFloat normalKnobWidth = self.bounds.size.width/2 - 2;
    CGFloat activeKnobWidth = normalKnobWidth + 5;
    if (animated) {
        isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
            if (self.tracking) {
//                _knobImageView.frame = CGRectMake(1, _knobImageView.frame.origin.y, activeKnobWidth, _knobImageView.frame.size.height);
            }
            else {
//                _knobImageView.frame = CGRectMake(1, _knobImageView.frame.origin.y, normalKnobWidth, _knobImageView.frame.size.height);
            }
        } completion:^(BOOL finished) {
            isAnimating = NO;
        }];
    }
    else {
        if (self.tracking) {
            _knobImageView.frame = CGRectMake(1, _knobImageView.frame.origin.y, activeKnobWidth, _knobImageView.frame.size.height);
        }
        else {
            _knobImageView.frame = CGRectMake(1, _knobImageView.frame.origin.y, normalKnobWidth, _knobImageView.frame.size.height);
        }
    }
}

@end
