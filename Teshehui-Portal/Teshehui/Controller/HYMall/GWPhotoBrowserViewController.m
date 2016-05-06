//
//  GWPhotoBrowserViewController.m
//  Teshehui
//
//  Created by Kris on 15/10/10.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "GWPhotoBrowserViewController.h"
#import <objc/runtime.h>

@interface GWPhotoBrowserViewController ()
<
UIScrollViewDelegate,
UIActionSheetDelegate
>

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *navTitle;

@end

@implementation GWPhotoBrowserViewController

static void *GWPhotoBrowserActionSheetKey = "GWPhotoBrowserActionSheetKey";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupScrollView];
    
    [self setupPageControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    self.navigationController.navigationBarHidden = YES;
    
    _navTitle = [UILabel new];
    _navTitle.frame = CGRectMake(0, 0, 40, 40);
    _navTitle.text = [NSString stringWithFormat:@"%ld/%ld",_index,self.picData.count];
    
    [self.navigationController.navigationItem setTitleView:_navTitle];
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(14)];
    back.frame = CGRectMake(15, 0, 40, 40);
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deletePhoto) forControlEvents:UIControlEventTouchDown];
    [delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    delete.titleLabel.font = [UIFont systemFontOfSize:TFScalePoint(14)];
    delete.frame = CGRectMake(15, 0, 40, 40);
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:delete];
    
    self.navigationItem.leftBarButtonItem = left;
    self.navigationItem.rightBarButtonItem = right;
}


#pragma mark private methods
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deletePhoto
{
    NSUInteger index = self.pageControl.currentPage;
    if (index < self.picData.count)
    {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [action showInView:self.view];
        
        void (^block)(NSUInteger) = ^(NSUInteger buttonIndex){
            if (0 == buttonIndex)
            {
                [self.picData removeObjectAtIndex:index];
                
                if ([self.delegate respondsToSelector:@selector(updatePicData:)])
                {
                    [self.delegate updatePicData:self.picData];
                }
                
                if (self.picData.count == 0)
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    return;
                }
                [_pageControl removeFromSuperview];
                [_scrollView removeFromSuperview];
                [self setupPageControl];
                [self setupScrollView];
            }
        };
        
        objc_setAssociatedObject(action, GWPhotoBrowserActionSheetKey, block, OBJC_ASSOCIATION_COPY);
    }

}

- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.picData.count;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 10;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0 green:98/255.0 blue:42/255.0 alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    // 2.添加图片
    CGFloat imageW = ScreenRect.size.width;
    CGFloat imageH = 0;
    int index = 0;
    NSInteger totalPicturesCount = self.picData.count;
    
    for (UIImage *img in self.picData)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        // 设置图片
        imageView.image = img;
        
        CGFloat W = imageView.image.size.width;
        CGFloat H = imageView.image.size.height;
        CGFloat ratio = H/W;
        
        imageH = imageW * ratio;
        
        // 设置frame
        CGFloat imageX = index * imageW;
        CGFloat imageY = (ScreenRect.size.height-imageH)/2;
        index++;
        imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showNav)];
        [self.view addGestureRecognizer:tap];
        [scrollView addSubview:imageView];
        
        // 3.设置滚动的内容尺寸
        scrollView.contentSize = CGSizeMake(imageW * totalPicturesCount, 0);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        
        _navTitle.text = [NSString stringWithFormat:@"1/%ld",self.picData.count];
        [self.navigationItem setTitleView:_navTitle];
    }
}

#pragma mark gesture
- (void)showNav
{
    [self.navigationController
     setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
    
    _navTitle.text = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.picData.count];
    [self.navigationItem setTitleView:_navTitle];
}

#pragma mark scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
    
    _navTitle.text = [NSString stringWithFormat:@"%ld/%ld",self.pageControl.currentPage+1,self.picData.count];
    [self.navigationItem setTitleView:_navTitle];
}

#pragma mark getter and setter
-(NSMutableArray *)picData
{
    if (!_picData)
    {
        _picData = [NSMutableArray array];
    }
    return _picData;
}

#pragma mark actionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    void (^block)(NSUInteger) = objc_getAssociatedObject(actionSheet, GWPhotoBrowserActionSheetKey);
    block(buttonIndex);
}

@end
