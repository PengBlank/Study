//
//  SlashView.m
//  Demo
//
//  Created by jonas on 9/18/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "SlashView.h"
#define DIMDURATION 3
#define ALPHADURATION 2
@implementation SlashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _is4InchScreen = [[UIScreen mainScreen] bounds].size.height > 480;
        
        NSString *imageName = _is4InchScreen ? @"spl_1_568h.jpg": @"spl_1.jpg";
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/0.8, self.frame.size.height/0.8)];
        imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        imageView.image = [UIImage imageNamed:imageName];
        index = 1;
        [self addSubview:imageView];
        
        panelView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-84, self.frame.size.width, 84)];
        panelView.backgroundColor = [UIColor blackColor];
        panelView.alpha = 0.5;
        [self addSubview:panelView];
        progressImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-86, 320/3, 2)];
        progressImage.image = [UIImage imageNamed:@"progress.jpg"];
        progressView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-86,
                                                               self.frame.size.width, 2)];
        progressView.backgroundColor = [UIColor grayColor];
        progressView.alpha = 0.5;
        [self addSubview:progressImage];
        
        
        [self addSubview:progressView];
        
        
        leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 14, 17)];
        leftButton.tag = 1;
        [leftButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:@"arrowLeft"] forState:UIControlStateNormal];
        [panelView addSubview:leftButton];
        leftButton.center = CGPointMake(15, 42);
        
        rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 14, 17)];
        rightButton.tag = 2;
        [rightButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setImage:[UIImage imageNamed:@"arrowRight"] forState:UIControlStateNormal];
        [panelView addSubview:rightButton];
        rightButton.center = CGPointMake(panelView.frame.size.width-15, 42);
        
        
        wordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 277, 64)];
        wordImageView.image = [UIImage imageNamed:@"word1"];
        [panelView addSubview:wordImageView];
        prev = NO;
        next = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)beginAnimate
{
    [imageView scaleWithDuration:DIMDURATION toScale:0.8 delegate:self];
}

-(void)pauseAnimate
{
    [imageView pauseLayer];
}

-(void)resumeAnimate
{
    [imageView resumeLayer];
}

-(void)clickButton:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    [imageView pauseLayer];
    if(btn.tag == 1)
    {
        prev = YES;
        next = NO;
        [imageView stopAnimating];
        [imageView stopLayer];
    }
    else
    {
        next = YES;
        prev = NO;
        [imageView stopAnimating];
        [imageView stopLayer];
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    if(flag && index == 3)
    //    {
    //        [self performSegueWithIdentifier:@"gotoTabViewController" sender:self];
    //    }
    if(flag)
    {
        NSString* animationName = [anim valueForKey:@"AnimationName"];
        if(animationName != nil)
        {
            if([animationName isEqualToString:@"ScaleTransform"])
            {
                if(next)
                {
                    index++;
                    if(index > 3)
                    {
                        index = 1;
                    }
                }
                if(prev)
                {
                    index--;
                    if(index < 1)
                    {
                        index = 3;
                    }
                    prev = NO;
                    next = YES;
                }
                
                NSString *format = _is4InchScreen ? @"spl_%d_568h.jpg": @"spl_%d.jpg";
                NSString *imageName = [NSString stringWithFormat:format, index];
                
                UIImageView* downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/0.8, self.frame.size.height/0.8)];
                downImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                downImageView.image = [UIImage imageNamed:imageName];
                [self insertSubview:downImageView belowSubview:imageView];
                [UIView animateWithDuration:ALPHADURATION animations:^{
                    self->imageView.alpha = 0;
                    self->progressImage.center = CGPointMake(self->progressImage.frame.size.width*(self->index-0.5), self->progressImage.center.y);
                } completion:^(BOOL finished) {
                    self->wordImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"word%d",self->index]];
                    [self->imageView removeFromSuperview];
                    self->imageView = downImageView;
                    
                    //动画结束
                    self.center = CGPointMake(-self.frame.size.width/2, self.center.y);
                    [self pauseAnimate];
                    [self removeFromSuperview];
                }];
            }
        }
    }
}

@end
