//
//  PTCustomTitleViewController.m
//  Putao
//
//  Created by ChengQian on 12-11-15.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "HYCustomTitleViewController.h"
#import "MobClick.h"

@interface HYCustomTitleViewController ()

@end

@implementation HYCustomTitleViewController

@synthesize needCustomTitle = _needCustomTitle;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.needCustomTitle = YES;
    }
    return self;
}


- (id)init
{
    
    self = [super init];
    
    if (self) {
       self.needCustomTitle = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
//
    if (self.needCustomTitle)
    {
        UILabel *t = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//        t.shadowColor = [UIColor blackColor];
//        t.shadowOffset = CGSizeMake(0.5, 0.5);
        t.textColor = [UIColor whiteColor];
        t.font = [UIFont systemFontOfSize:19];
        //t.minimumFontSize = 12;
        //t.adjustsFontSizeToFitWidth = YES;
        t.backgroundColor = [UIColor clearColor];
        t.textAlignment = NSTextAlignmentCenter;
        t.text = self.title;
        self.navigationItem.titleView = t;
    }
}

//- (MBProgressHUD *)errorHud
//{
//    if (!errorHud)
//    {
//        errorHud = [[MBProgressHUD alloc] initWithView:self.view];
//        errorHud.mode = MBProgressHUDModeText;
//        [[[UIApplication sharedApplication] keyWindow] addSubview:errorHud];
//    }
//    return errorHud;
//}

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    [(UILabel *)self.navigationItem.titleView setText:title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
