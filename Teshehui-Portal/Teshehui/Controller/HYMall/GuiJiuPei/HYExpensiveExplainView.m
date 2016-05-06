//
//  HYExpensiveExplainView.m
//  Teshehui
//
//  Created by apple on 15/4/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYExpensiveExplainView.h"
//贵就赔
#import "HYExpensiveExplainRequest.h"
#import "UIImage+Addition.h"
#import "UIImageView+WebCache.h"
#import "METoast.h"

@interface HYExpensiveExplainView ()

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UILabel *fakeLab;
@property (nonatomic, weak) IBOutlet UILabel *guiLab;
@property (nonatomic, weak) IBOutlet UILabel *shanLab;
@property (nonatomic, weak) IBOutlet UIImageView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *containView;

@property (nonatomic, strong) HYExpensiveExplainRequest *expensiveRequest;

@end

@implementation HYExpensiveExplainView

- (void)dealloc
{
    [_expensiveRequest cancel];
    _expensiveRequest = nil;
}


+ (instancetype)instance
{
    UINib *nib = [UINib nibWithNibName:@"HYExpensiveExplainView" bundle:nil];
    NSArray *views = [nib instantiateWithOwner:nil options:nil];
    if (views.count > 0)
    {
        return [views objectAtIndex:0];
    }
    return nil;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    [self dismiss];
}

- (void)showWithImage:(UIImage *)img
{
//    if (!self.superview)
//    {
//        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//        CGSize size = [UIScreen mainScreen].bounds.size;
//        self.frame =
//        [self setBackgroundColor:[UIColor whiteColor]];
//        [window addSubview:self];
//    }
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, 36, CGRectGetWidth(bounds), 500);
    _containView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _scrollView.frame = _containView.frame;
    if (img)
    {
        CGFloat imageW = img.size.width;
        CGFloat imageH = img.size.height;
        CGFloat ratio = imageH / imageW;
        CGFloat H = self.frame.size.width * ratio;
        CGFloat W = self.frame.size.width;
        
        self.bannerView.frame = CGRectMake(0, 0, W, H);
        self.bannerView.image = img;
        
        self.scrollView.scrollEnabled = YES;
        self.scrollView.contentSize = CGSizeMake(W, H);
    }
}

- (void)dismiss
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
