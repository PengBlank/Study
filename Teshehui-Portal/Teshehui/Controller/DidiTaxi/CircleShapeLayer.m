//
//  CircleShapeLayer.m
//  CircularProgressControl
//
//  Created by Carlos Eduardo Arantes Ferreira on 22/11/14.
//  Copyright (c) 2014 Mobistart. All rights reserved.
//

#import "CircleShapeLayer.h"

@interface CircleShapeLayer ()

@property (assign, nonatomic) double initialProgress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
//@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CATextLayer *textLayer;

@end

@implementation CircleShapeLayer

@synthesize percent = _percent;

- (instancetype)init {
    if ((self = [super init]))
    {
        [self setupLayer];
    }
    
    return self;
}

- (void)layoutSublayers {

    self.path = [self drawPathWithArcCenter];
    self.progressLayer.path = [self drawPathWithArcCenter];
    [super layoutSublayers];
}

- (void)setupLayer {
    
    self.path = [self drawPathWithArcCenter];
    self.fillColor = [UIColor clearColor].CGColor;
    self.strokeColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:85/255.0 alpha:1].CGColor;
    self.lineWidth = 2;
    
    self.progressLayer = [CAShapeLayer layer];
    self.progressLayer.path = [self drawPathWithArcCenter];
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:85/255.0 alpha:1].CGColor;
    self.progressLayer.lineWidth = 8;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.lineJoin = kCALineJoinRound;
    [self addSublayer:self.progressLayer];
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.circleLayer.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 50, 50), NULL);
    self.circleLayer.fillColor = [UIColor colorWithRed:255/255.0 green:59/255.0 blue:85/255.0 alpha:1].CGColor;
    [self addSublayer:self.circleLayer];
    
    self.textLayer = [CATextLayer layer];
    self.textLayer.frame = CGRectMake(0, 0, 60, 20);
    self.textLayer.fontSize = 12.0;
    self.textLayer.string = @"00:00";
    self.textLayer.alignmentMode = kCAAlignmentCenter;
    UIFont *syst = [UIFont systemFontOfSize:12.0];
    CGFontRef font = CGFontCreateWithFontName((CFStringRef)syst.fontName);
    self.textLayer.font = font;
    self.textLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.textLayer.contentsScale = [UIScreen mainScreen].scale;
    [self addSublayer:_textLayer];
}

- (CGPathRef)drawPathWithArcCenter {
    
    CGFloat position_y = self.frame.size.height/2;
    CGFloat position_x = self.frame.size.width/2; // Assuming that width == height
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(position_x, position_y)
                                          radius:position_y
                                      startAngle:(-M_PI/2)
                                        endAngle:(3*M_PI/2)
                                       clockwise:YES].CGPath;
    return CGPathCreateWithEllipseInRect(self.bounds, NULL);
}


- (void)setElapsedTime:(NSTimeInterval)elapsedTime {
    _initialProgress = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    _elapsedTime = elapsedTime;
    
    self.progressLayer.strokeEnd = self.percent;
    if (elapsedTime > 0)
    {
        [self startAnimation];
        
        CGFloat angle = M_PI*2 * self.percent - M_PI/2;
        CGFloat radius = self.bounds.size.height/2;
        CGFloat x = radius *cos(angle) + self.bounds.size.width/2;
        CGFloat y =  radius * sin(angle) + self.bounds.size.height/2;
        [self moveLayer:_circleLayer withPosition:CGPointMake(x-25, y-25)];
        [self moveLayer:_textLayer withPosition:CGPointMake(x, y)];
        
        NSInteger minute = elapsedTime / 60;
        NSInteger second = (long)elapsedTime % 60;
        NSString *show = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute, (long)second];
        self.textLayer.string = show;
    }
    else
    {
        _circleLayer.position = CGPointMake(CGRectGetMidX(self.bounds)-25, -25);
        _textLayer.position = CGPointMake(CGRectGetMidX(self.bounds), 0);
    }
}

- (void)moveLayer:(CALayer *)layer withPosition:(CGPoint)position
{
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:layer.position];
    move.toValue = [NSValue valueWithCGPoint:position];
    move.duration = 1;
    layer.actions = @{@"position": move};
    layer.position = position;
}

- (double)percent {
    
    _percent = [self calculatePercent:_elapsedTime toTime:_timeLimit];
    return _percent;
}

- (void)setProgressColor:(UIColor *)progressColor {
//    self.progressLayer.strokeColor = progressColor.CGColor;
}

- (double)calculatePercent:(NSTimeInterval)fromTime toTime:(NSTimeInterval)toTime {
    
    if ((toTime > 0) && (fromTime > 0)) {
        
        CGFloat progress = 0;
        
        progress = fromTime / toTime;
        
        if ((progress * 100) > 100) {
            progress = 1.0f;
        }
        
//        NSLog(@"Percent = %f", progress);
        
        return progress;
    }
    else
        return 0.0f;
}

- (void)startAnimation {
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.fromValue = @(self.initialProgress);
    pathAnimation.toValue = @(self.percent);
    pathAnimation.removedOnCompletion = YES;
    
    [self.progressLayer addAnimation:pathAnimation forKey:nil];
}

@end
