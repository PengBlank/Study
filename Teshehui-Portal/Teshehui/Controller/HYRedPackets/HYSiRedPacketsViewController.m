//
//  HYSiRedPacketsViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSiRedPacketsViewController.h"
#import "HYUpdateToOfficialUserViewController.h"
#import "HYAccountLoginViewController.h"
#import "HYPaymentViewController.h"
#import "HYLoadHubView.h"
#import "HYAppDelegate.h"
#import "HYGetPersonRequest.h"
#import "HYGetPersonResponse.h"
#import "HYUserInfo.h"
#import "HYNavigationController.h"
#import "HYAppDelegate.h"

@interface HYSiRedPacketsViewController ()
{
    HYGetPersonRequest* _getUserInfoReq;
}

@property (weak, nonatomic) IBOutlet UIImageView *baseView;
@property (weak, nonatomic) IBOutlet UIImageView *circleLight;
@property (weak, nonatomic) IBOutlet UIImageView *redPocket;
@property (weak, nonatomic) IBOutlet UIImageView *redLeft;
@property (weak, nonatomic) IBOutlet UIImageView *redRight;
@property (weak, nonatomic) IBOutlet UIButton *congfirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;

@end

@implementation HYSiRedPacketsViewController

+ (void)showWithPoints:(NSString *)points completeBlock:(void (^)(void))completeBlock
{
    HYSiRedPacketsViewController *vc = [[HYSiRedPacketsViewController alloc]initWithNibName:@"HYSiRedPacketsViewController" bundle:nil];
    vc.cashCard = points;
    vc.completeBlock = completeBlock;
    UIViewController *root = [(HYAppDelegate *)[UIApplication sharedApplication].delegate window].rootViewController;
    [root presentViewController:vc animated:YES completion:nil];
}

- (void)dealloc
{
    [_getUserInfoReq cancel];
    _getUserInfoReq = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    //button在xib中无法拉伸
    UIImage *bgImg = [[UIImage imageNamed:@"redPackets_btn"]stretchableImageWithLeftCapWidth:20 topCapHeight:10];
    [_congfirmBtn setBackgroundImage:bgImg forState:UIControlStateNormal];
    [_congfirmBtn setTitle:@"确   定"
                  forState:UIControlStateNormal];
    [_congfirmBtn addTarget:self
                     action:@selector(pop)
           forControlEvents:UIControlEventTouchUpInside];
    _congfirmBtn.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    
    _circleLight.animationImages = @[[UIImage imageNamed:@"redPackets_circle1"],
                                     [UIImage imageNamed:@"redPackets_circle2"],
                                     [UIImage imageNamed:@"redPackets_circle3"],
                                     [UIImage imageNamed:@"redPackets_circle4"],
                                     [UIImage imageNamed:@"redPackets_circle5"],
                                     [UIImage imageNamed:@"redPackets_circle6"],
                                     [UIImage imageNamed:@"redPackets_circle7"],
                                     [UIImage imageNamed:@"redPackets_circle8"],
                                     [UIImage imageNamed:@"redPackets_circle9"],
                                     [UIImage imageNamed:@"redPackets_circle10"],
                                     [UIImage imageNamed:@"redPackets_circle11"]];
    _circleLight.animationDuration = 5.0f;
    _circleLight.animationRepeatCount = MAXFLOAT;
    [_circleLight startAnimating];
    
    _redLeft.hidden = YES;
    _redRight.hidden = YES;
    
    //现金券
    if (_cashCard)
    {
        _cashLabel.text = [NSString stringWithFormat:@"￥%@",_cashCard];
    }else
    {
        _cashLabel.text = [NSString stringWithFormat:@"￥"];
    }
    
    _cashLabel.textAlignment = NSTextAlignmentCenter;
    _cashLabel.textColor = [UIColor colorWithRed:0.52 green:0.15 blue:0.09 alpha:1.0f];
    _cashLabel.hidden = YES;
    
    long long time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC));

    dispatch_after(time, dispatch_get_main_queue(), ^{
        [self beginMyAnimating];
    });
    
    [self updateUserInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HYLoadHubView dismiss];
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    nav.canDragBack = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    HYNavigationController *nav = (HYNavigationController *)self.navigationController;
    nav.canDragBack = YES;
}

#pragma mark private methods
-(void)updateUserInfo
{
    HYUserInfo *user = [HYUserInfo getUserInfo];
    if (user.userId)
    {
        if (!_getUserInfoReq)
        {
            [_getUserInfoReq cancel];
            _getUserInfoReq = nil;
        }
        _getUserInfoReq = [[HYGetPersonRequest alloc] init];
        _getUserInfoReq.userId = [HYUserInfo getUserInfo].userId;
        
        [HYLoadHubView show];
        __weak typeof(self) b_self = self;
        [_getUserInfoReq sendReuqest:^(id result, NSError *error)
         {
             [HYLoadHubView dismiss];
             HYUserInfo* info = nil;
             if (result && [result isKindOfClass:[HYGetPersonResponse class]])
             {
                 HYGetPersonResponse *response = (HYGetPersonResponse *)result;
                 if (response.status == 200)
                 {
                     info = response.userInfo;
                 }
             }
             [b_self updateViewWithData:info error:error];
         }];
    }
}

- (void)updateViewWithData:(HYUserInfo *)info error:(NSError *)error
{
    if (info)
    {
        [info updateUserInfo];
    }
}

- (void)beginMyAnimating
{
    [_redPocket removeFromSuperview];
    
    _redRight.hidden = NO;
    _redLeft.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0f animations:^{
        CGRect frame = weakSelf.redLeft.frame;
        frame.origin.x -= TFScalePoint(30);
        frame.origin.y += TFScalePoint(30);
        weakSelf.redLeft.frame = frame;
        weakSelf.redLeft.transform = CGAffineTransformMakeRotation(-M_PI_4);
        
        frame = weakSelf.redRight.frame;
        frame.origin.x += TFScalePoint(30);
        frame.origin.y += TFScalePoint(30);
        weakSelf.redRight.frame = frame;
        //把frame写在旋转的后面就成了反转
        weakSelf.redRight.transform = CGAffineTransformMakeRotation(M_PI_4);
    } completion:^(BOOL finished) {
        weakSelf.redPocket = nil;
//        [weakSelf.redLeft removeFromSuperview];
//        [weakSelf.redRight removeFromSuperview];
//        weakSelf.redRight = nil;
//        weakSelf.redLeft = nil;
        weakSelf.cashLabel.hidden = NO;
    }];
//    CGPoint from = _redLeft.center;
//    UIBezierPath *movePath = [UIBezierPath bezierPath];
//    [movePath moveToPoint:from];
//    CGPoint to = CGPointMake(from.x-30, from.y+30);
//    [movePath addLineToPoint:to];
//    
//    CABasicAnimation *moveAnim = [CABasicAnimation animationWithKeyPath:@"position"];
//    moveAnim.fromValue = [NSValue valueWithCGPoint:from];
//    moveAnim.toValue = [NSValue valueWithCGPoint:to];
//    moveAnim.duration = 1.0f;
//    moveAnim.removedOnCompletion = NO;
//    moveAnim.fillMode = kCAFillModeForwards;
//    
//    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
//    transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//    
//    //沿着X,Y平面旋转
//    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(-M_PI_4, 0, 0, 1)];
//    transformAnim.duration = 1.0f;
//    transformAnim.cumulative = YES;
//    transformAnim.removedOnCompletion = NO;
//    transformAnim.fillMode = kCAFillModeForwards;
//    
////    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
////    animGroup.animations = @[moveAnim,transformAnim];
////    animGroup.duration = 3.0f;
//
//    
//    [_redLeft.layer addAnimation:moveAnim forKey:nil];
//    [_redLeft.layer addAnimation:transformAnim forKey:nil];
//    
//    //右边红包的动画
//    to = CGPointMake(from.x+30, from.y+30);
//    transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0, 0, 1)];
//    [_redRight.layer addAnimation:moveAnim forKey:nil];
//    [_redRight.layer addAnimation:transformAnim forKey:nil];
}

- (IBAction)backToRootViewController:(id)sender
{
    BOOL needPopRoot = NO;
    NSArray *array = self.navigationController.viewControllers;
    if ([array count] > 1)
    {
        UIViewController *rootCotroller = [self.navigationController.viewControllers objectAtIndex:(array.count-2)];
        needPopRoot = [rootCotroller isKindOfClass:[HYPaymentViewController class]];
    }
    
    if (needPopRoot)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [super backToRootViewController:sender];
    }
}

- (void)pop
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.completeBlock) {
            self.completeBlock();
        }
    }];
}

@end
