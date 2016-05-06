//
//  HYBankHelpInfoViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBankHelpInfoViewController.h"

@interface HYBankHelpInfoViewController ()

@end

@implementation HYBankHelpInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (self.type == CardNumberLast)
    {
        self.title = NSLocalizedString(@"help", nil);
        UIImageView *infoView = [[UIImageView alloc] initWithFrame:CGRectMake(60,
                                                                              100,
                                                                              200,
                                                                              150)];
        infoView.image = [UIImage imageNamed:@"cvv2"];
        [self.view addSubview:infoView];
        
        UILabel *desc1Label = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                        10,
                                                                        140,
                                                                        20)];
        desc1Label.backgroundColor = [UIColor clearColor];
        desc1Label.font = [UIFont systemFontOfSize:16];
        desc1Label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        desc1Label.text = @"卡背面后三位";
        
        [self.view addSubview:desc1Label];
        
        UILabel *desc2Label = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                        40,
                                                                        280,
                                                                        40)];
        desc2Label.backgroundColor = [UIColor clearColor];
        desc2Label.font = [UIFont systemFontOfSize:14];
        desc2Label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        desc2Label.text = @"指信用卡背面的CVV2验证码。是信用卡前面栏附近的后3位代码。位置参考如下图:";
        desc2Label.lineBreakMode = NSLineBreakByCharWrapping;
        desc2Label.numberOfLines = 2;
        [self.view addSubview:desc2Label];
    }
    else
    {
        self.title = NSLocalizedString(@"card_valid_date", nil);
        UIImageView *infoView = [[UIImageView alloc] initWithFrame:CGRectMake(60,
                                                                              80,
                                                                              200,
                                                                              150)];
        infoView.image = [UIImage imageNamed:@"img_bankcard_front"];
        [self.view addSubview:infoView];
        
        UILabel *desc1Label = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                        10,
                                                                       280,
                                                                       40)];
        desc1Label.backgroundColor = [UIColor clearColor];
        desc1Label.font = [UIFont systemFontOfSize:14];
        desc1Label.textColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        desc1Label.text = @"信用卡有效期通常在卡正面的卡号下方，示例如下图:";
        desc1Label.lineBreakMode = NSLineBreakByCharWrapping;
        desc1Label.numberOfLines = 2;
        [self.view addSubview:desc1Label];
        
        UILabel *desc2Label = [[UILabel alloc] initWithFrame:CGRectMake(20,
                                                                       230,
                                                                       280,
                                                                       40)];
        desc2Label.backgroundColor = [UIColor clearColor];
        desc2Label.font = [UIFont systemFontOfSize:16];
        desc2Label.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        desc2Label.text = @"有效期：月/年（例如上图为2019年12月）";
        desc2Label.lineBreakMode = NSLineBreakByCharWrapping;
        desc2Label.numberOfLines = 2;
        [self.view addSubview:desc2Label];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if (!self.view.window)
    {
        self.view = nil;
    }
}

@end
