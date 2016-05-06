//
//  HYMediaPlayViewController.m
//  Teshehui
//
//  Created by HYZB on 15/9/15.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMediaPlayViewController.h"

@interface HYMediaPlayViewController ()

//@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;

@end

@implementation HYMediaPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(detectOrientation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaPlayerPlaybackFinished:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:self.moviePlayer];
    
//    self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    //播放
    [self.moviePlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

//为了支持iOS6
-(BOOL)shouldAutorotate
{
    return NO;
}

//为了支持iOS6
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)detectOrientation {
    UIDeviceOrientation toInterfaceOrientation = [[UIDevice currentDevice] orientation];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:2];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.view.bounds = CGRectMake(0, 0, ScreenRect.size.height, ScreenRect.size.width);
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.moviePlayer.view.bounds = CGRectMake(0, 0, ScreenRect.size.height, ScreenRect.size.width);
        self.moviePlayer.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        self.view.bounds = CGRectMake(0, 0, ScreenRect.size.height, ScreenRect.size.width);
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.moviePlayer.view.bounds = CGRectMake(0, 0, ScreenRect.size.height, ScreenRect.size.width);
        self.moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        self.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
        self.view.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.moviePlayer.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
        self.moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI);
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortraitUpsideDown];
    }
    else if(toInterfaceOrientation == UIInterfaceOrientationPortrait)
    {
        self.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
        self.view.transform = CGAffineTransformMakeRotation(0);
        
        self.moviePlayer.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
        self.moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
//        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    }
    
    [UIView commitAnimations];
}


/**
 
 *播放完成
 
 *
 
 *@param notification通知对象
 
 */

-(void)mediaPlayerPlaybackFinished:(NSNotification*)notification{
    
//    NSLog(@"播放完成.%li",self.moviePlayer.playbackState);
    
    //[self removeFromParentViewController];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:nil];
    
    self.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
    self.view.transform = CGAffineTransformMakeRotation(0);
    
    self.moviePlayer.view.bounds = CGRectMake(0, 0, ScreenRect.size.width, ScreenRect.size.height);
    self.moviePlayer.view.transform = CGAffineTransformMakeRotation(0);
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    
    [self dismissMoviePlayerViewControllerAnimated];
}

-(void)dealloc{
    
    //移除所有通知监控
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
