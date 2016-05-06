//
//  HYTranscationFailViewController.m
//  Teshehui
//
//  Created by Kris on 15/5/12.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYTranscationFailViewController.h"
#import "HYQRCodeReaderViewController.h"

@interface HYTranscationFailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *errorMsgLabel;
@property (weak, nonatomic) IBOutlet UIButton *reScan;


@end

@implementation HYTranscationFailViewController

//- (void)loadView
//{
//    CGRect frame = [[UIScreen mainScreen] bounds];
//    frame.size.height -= 64;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor whiteColor];
//    self.view = view;
//    
//   
////    [self.view addSubview:[[[NSBundle mainBundle]loadNibNamed:@"HYTranscationFailViewController" owner:self options:nil]lastObject]];
//}
- (IBAction)reScanAction:(id)sender
{
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    for (id obj in viewcontrollers)
    {
        if ([obj isKindOfClass:[HYQRCodeReaderViewController class]])
        {
            [self.navigationController popToViewController:obj animated:NO];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    _errorMsgLabel.text = self.errorMsg;
    
    [_reScan setBackgroundImage:[[UIImage imageNamed:@"sm_success04"]stretchableImageWithLeftCapWidth:5 topCapHeight:4]
                        forState:UIControlStateNormal];
    [_reScan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

@end
