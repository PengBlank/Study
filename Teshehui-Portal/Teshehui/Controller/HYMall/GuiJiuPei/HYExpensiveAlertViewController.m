//
//  HYExpensiveAlertViewController.m
//  Teshehui
//
//  Created by apple on 15/3/31.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveAlertViewController.h"
#import "UIImage+Addition.h"
#import "HYExpensiveApplyViewController.h"
#import "HYExpensiveExplainRequest.h"
#import "UIImageView+WebCache.h"

@interface HYExpensiveAlertViewController ()
<UIAlertViewDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *bannerView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) HYExpensiveExplainRequest *expensiveRequest;

@end

@implementation HYExpensiveAlertViewController

- (void)dealloc
{
    [_expensiveRequest cancel];
    _expensiveRequest = nil;
}

//手动初始化界面
- (void)loadView
{
    UINib *nib = [UINib nibWithNibName:self.nibName bundle:self.nibBundle];
    NSArray *views = [nib instantiateWithOwner:self options:nil];
    if (views.count > 0)
    {
        self.view = [views objectAtIndex:0];
    }
    else
    {
        self.view = [[UIView alloc] init];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"贵就赔";
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64;
    self.view.frame = frame;
    _scrollView.frame = frame;
    
    _bannerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height - 53);
    
    UIImage *cancelImage = [UIImage imageNamed:@"g_btn_cancel"];
    cancelImage = [cancelImage utilResizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_cancelBtn setBackgroundImage:cancelImage forState:UIControlStateNormal];
    UIImage *submitImage = [UIImage imageNamed:@"g_btn_apply"];
    submitImage = [submitImage utilResizableImageWithCapInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [_submitBtn setBackgroundImage:submitImage forState:UIControlStateNormal];
    
    _scrollView.contentSize = CGSizeMake(frame.size.width, CGRectGetMaxY(_submitBtn.frame)+20);
    frame = self.cancelBtn.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame)/4 - frame.size.width/2;
    frame.origin.y = CGRectGetMaxY(self.bannerView.frame) + 8;
    self.cancelBtn.frame = frame;
    frame = self.submitBtn.frame;
    frame.origin.x = CGRectGetWidth(self.view.frame)/4*3 - frame.size.width/2;
    frame.origin.y = CGRectGetMaxY(self.bannerView.frame) + 8;
    self.submitBtn.frame = frame;
    
    self.expensiveRequest = [[HYExpensiveExplainRequest alloc] init];
    self.expensiveRequest.img_key = @"guijiupei";
    [HYLoadHubView show];
    __weak typeof(self) b_self = self;
    [self.expensiveRequest sendReuqest:^(id result, NSError *error)
     {
         [HYLoadHubView dismiss];
         [b_self updateWithExplainResponse:result error:error];
     }];
}

- (void)updateWithExplainResponse:(HYExpensiveExplainResponse *)res error:(NSError *)err
{
    if (res.status == 200)
    {
        __weak typeof(self) b_self = self;
        HYExpensiveInfo *info = res.expensiveInfo;
        NSURL *url = [NSURL URLWithString:info.img_key1];
        [_bannerView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [HYLoadHubView dismiss];
             if (image)
             {
                 CGFloat imgheight = b_self.view.frame.size.width/image.size.width*image.size.height;
                 b_self.bannerView.frame = CGRectMake(0,
                                                      0,
                                                      CGRectGetWidth(b_self.view.frame),
                                                      imgheight);
                 b_self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(b_self.view.frame), imgheight + 53);
                 CGRect frame = b_self.cancelBtn.frame;
                 frame.origin.x = CGRectGetWidth(b_self.view.frame)/4 - frame.size.width/2;
                 frame.origin.y = CGRectGetMaxY(b_self.bannerView.frame) + 8;
                 b_self.cancelBtn.frame = frame;
                 frame = b_self.submitBtn.frame;
                 frame.origin.x = CGRectGetWidth(b_self.view.frame)/4*3 - frame.size.width/2;
                 frame.origin.y = CGRectGetMaxY(b_self.bannerView.frame) + 8;
                 b_self.submitBtn.frame = frame;
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取贵就赔信息失败，请稍后再试" delegate:b_self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                 [alert show];
             }
         }];
    }
    else
    {
        [HYLoadHubView dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:err.domain delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender
{
    HYExpensiveApplyViewController *apply = [[HYExpensiveApplyViewController alloc] initWithNibName:@"HYExpensiveApplyViewController" bundle:nil];
    apply.orderCode = self.orderCode;
    apply.productCode = self.productCode;
    apply.productSKUCode = self.productSKUCode;
    [self.navigationController pushViewController:apply animated:YES];
}



@end
