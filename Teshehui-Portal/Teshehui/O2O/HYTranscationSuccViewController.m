//
//  HYTranscationSuccViewController.m
//  Teshehui
//
//  Created by Kris on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYTranscationSuccViewController.h"

@interface HYTranscationSuccViewController ()
@property (weak, nonatomic) IBOutlet UILabel *rmb;
@property (weak, nonatomic) IBOutlet UILabel *tebi;
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@end

@implementation HYTranscationSuccViewController

//-(void)loadView
//{
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    frame.size.height -= 64;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor whiteColor];
//    self.view = view;
//    
//    
//    [self.view addSubview:[[[NSBundle mainBundle]loadNibNamed:@"HYTranscationSuccViewController" owner:self options:nil]lastObject]];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    _rmb.userInteractionEnabled = NO;
    
    NSNumber *amout = [NSNumber numberWithFloat:self.order_amount.floatValue];
    [_rmb setText:[NSString stringWithFormat:@"%@元",amout]];
    
    _tebi.userInteractionEnabled = NO;
    [_tebi setText:[NSString stringWithFormat:@"%d现金券",self.points.intValue]];
    
    [_confirm setBackgroundImage:[[UIImage imageNamed:@"sm_success04"]stretchableImageWithLeftCapWidth:5 topCapHeight:4]
              forState:UIControlStateNormal];
    [_confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)backToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
