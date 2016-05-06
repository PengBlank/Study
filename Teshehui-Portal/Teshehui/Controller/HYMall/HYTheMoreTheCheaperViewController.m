//
//  HYTheMoreTheCheaperViewController.m
//  Teshehui
//
//  Created by Kris on 15/9/8.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYTheMoreTheCheaperViewController.h"
#import "HYLoadHubView.h"
#import "UIImage+Addition.h"

@interface HYTheMoreTheCheaperViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation HYTheMoreTheCheaperViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"越买越省";
 
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.size.height -= 64;
    self.view.frame = rect;
    
    [HYLoadHubView dismiss];
    _imgView.image = [UIImage imageNamed:@"mall_theMoreTheCheaper.jpg"];
    //    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    CGFloat imageW = _imgView.image.size.width;
    CGFloat imageH = _imgView.image.size.height;
    
    CGFloat scale = imageW/rect.size.width;
    
    _imgView.frame = CGRectMake(0, 0, imageW/scale, imageH/scale);
    
    _scrollView.frame = rect;
    _scrollView.contentSize = _imgView.bounds.size;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    NSLog(@"%@",NSStringFromCGRect(_imgView.frame));
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
