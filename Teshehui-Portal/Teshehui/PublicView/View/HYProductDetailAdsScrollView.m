//
//  HYProductDetailAdsScrollView.m
//  Teshehui
//
//  Created by Kris on 16/3/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailAdsScrollView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import <objc/runtime.h>
#import "Masonry.h"
#import "HYProductDetailSliderView.h"

@interface HYProductDetailAdsScrollView ()
<UIScrollViewDelegate>
{
    BOOL _markForOnce;
    UIButton *_comparePriceBtn;
    UIButton *_playPriceBtn;
}

@property (nonatomic, strong) NSMutableArray *adsContents;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *imageArrays;
@property (nonatomic, strong) UIImageView *currentImage;
@property (nonatomic, strong) HYProductDetailSliderView *slider;
@property (nonatomic, copy) NSNumber *deltaX;

@end

@implementation HYProductDetailAdsScrollView

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}

-(instancetype)init
{
    if (self = [super init])
    {
        // 1.添加UISrollView
        [self setupScrollView];
        
        // 2.添加pageControl
        [self setupPageControl];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // 1.添加UISrollView
        [self setupScrollView];
        
        // 2.添加pageControl
        [self setupPageControl];
        
        //listen to the main frame
        [self addObserver:self
                   forKeyPath:@"frame"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    }
    return self;
}



#pragma mark private methods
- (void)cameraPlay
{
    if ([self.delegate respondsToSelector:@selector(playVideoWithUrl)])
    {
        [self.delegate performSelector:@selector(playVideoWithUrl)];
    }
}

- (void)beginComparing
{
    if ([self.delegate respondsToSelector:@selector(comparePrice)])
    {
        [self.delegate performSelector:@selector(comparePrice)];
    }
}
/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.bounds;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self addSubview:scrollView];
}

- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    CGFloat centerX = self.frame.size.width * 0.5;
    CGFloat centerY = self.frame.size.height - 30;
    
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:253/255.0
                                                                green:98/255.0
                                                                 blue:42/255.0
                                                                alpha:1.0];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:189/255.0
                                                         green:189/255.0
                                                          blue:189/255.0
                                                         alpha:1.0];
}

- (void)reloadData
{
    [self.adsContents removeAllObjects];
    self.adsContents = [[_dataSource adsContents]mutableCopy];
}

/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
    if (pageInt < self.imageArrays.count)
    {
        self.currentImage = self.imageArrays[pageInt];
    }
    //处理侧拉
    CGFloat x = _scrollView.contentOffset.x - (_scrollView.contentSize.width - _scrollView.frame.size.width);
    //inform KVO of setter
    if (x >= 80)
    {
        if (!_markForOnce)
        {
            _markForOnce = YES;
            [_slider changeArrow];
        }
        if (!scrollView.isDragging)
        {
           self.deltaX = [NSNumber numberWithFloat:x];
        }
    }
    else
    {
        if (_markForOnce)
        {
            _markForOnce = NO;
            [_slider restoreArrow];
        }
    }
}

- (void)addSliderViewWithObject:(UIImageView *)imgView
{
    [_scrollView addSubview:self.slider];
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgView.mas_right).with.offset(5);
        make.centerY.equalTo(imgView);
        make.size.mas_equalTo(CGSizeMake(60, 250));
    }];
}

- (void)addBtnOnImageView:(UIImageView *)imgView
{
    WS(weakSelf);
    
    _playPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *path2 = [NSString stringWithFormat:@"%@/productDetail_play.png",[NSBundle mainBundle].resourcePath];
    [_playPriceBtn setImage:[UIImage imageWithContentsOfFile:path2]
                      forState:UIControlStateNormal];
    [_playPriceBtn addTarget:self
                         action:@selector(cameraPlay)
               forControlEvents:UIControlEventTouchUpInside];
    _playPriceBtn.hidden = YES;
    [self addSubview:_playPriceBtn];
    
    [_playPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-60);
    }];
    
    _comparePriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *path1 = [NSString stringWithFormat:@"%@/productDetai_comparePrice.png",[NSBundle mainBundle].resourcePath];
    [_comparePriceBtn setImage:[UIImage imageWithContentsOfFile:path1]
                      forState:UIControlStateNormal];
    [_comparePriceBtn addTarget:self
                         action:@selector(beginComparing)
               forControlEvents:UIControlEventTouchUpInside];
    //    _comparePriceBtn.hidden = YES;
    [self addSubview:_comparePriceBtn];
    
    [_comparePriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
    }];
    _comparePriceBtn.hidden = YES;
}

#pragma mark getter & setter
- (void)setDataSource:(id<HYProductDetailAdsScrollViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self reloadData];
    
    WS(weakSelf);
    //添加图片
    CGFloat imageW = _scrollView.frame.size.width;
    __block CGFloat imageH = _scrollView.frame.size.height;
    for (int index = 0; index < self.adsContents.count; ++index)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        // 设置图片
        NSString *str = [self.adsContents objectAtIndex:index];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            CGFloat W = imageView.image.size.width;
            CGFloat H = imageView.image.size.height;
            CGFloat ratio = H/W;
            
            imageH = imageW * ratio;
            
            // 设置frame
            CGFloat imageX = index * imageW;
            imageView.frame = CGRectMake(imageX, 0, self.frame.size.width, self.frame.size.height);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.userInteractionEnabled = YES;
            
            [weakSelf.scrollView addSubview:imageView];
            [weakSelf.imageArrays addObject:imageView];
            if (weakSelf.imageArrays.count > 0)
            {
                weakSelf.currentImage = weakSelf.imageArrays[0];
            }
            
            if (weakSelf.adsContents.count-1 == index)
            {
                //add slider
                [weakSelf addSliderViewWithObject:imageView];
            }
            
            if (0 == index)
            {
//                [weakSelf addBtnOnImageView:imageView];
            }
        }];
    }
    
    [self addBtnOnImageView:nil];
    // 3.设置滚动的内容尺寸
    _scrollView.contentSize = CGSizeMake(imageW * self.adsContents.count+10, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    
    _pageControl.numberOfPages = self.adsContents.count;
}

/*
-(UIImageView *)currentImage
{
    if (!_currentImage)
    {
        if (_imageArrays.count > 0)
        {
            _currentImage = _imageArrays[0];
        }
    }
    return _currentImage;
}
*/
-(void)setGoodDetail:(HYMallGoodsDetail *)goodDetail
{
    WS(weakSelf);
    if (goodDetail)
    {
        //有两个
        BOOL two = (goodDetail.productVideoUrl.length > 0 && _hasComparePriceData);
        BOOL none = (!(goodDetail.productVideoUrl.length > 0) && (!_hasComparePriceData));
        if (two)
        {
            _playPriceBtn.hidden = NO;
            _comparePriceBtn.hidden = NO;
        }
        //没有
        else if (none)
        {
            
        }
        //有一个
        else
        {
            if (goodDetail.productVideoUrl.length > 0)
            {
                _playPriceBtn.hidden = NO;
                _comparePriceBtn.hidden = YES;
                [_playPriceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.mas_right).with.offset(-10);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-15);
                }];
            }
            else if (_hasComparePriceData)
            {
                _comparePriceBtn.hidden = NO;
                _playPriceBtn.hidden = YES;
                [_comparePriceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(weakSelf.mas_right).with.offset(-10);
                    make.size.mas_equalTo(CGSizeMake(40, 40));
                    make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-15);
                }];
            }
        }
    }
}

-(NSMutableArray *)imageArrays
{
    if (!_imageArrays)
    {
        _imageArrays = [NSMutableArray array];
    }
    return _imageArrays;
}

-(HYProductDetailSliderView *)slider
{
    if (!_slider)
    {
        _slider = [[HYProductDetailSliderView alloc]init];
    }
    return _slider;
}

-(void)setHasComparePriceData:(BOOL)hasComparePriceData
{
    _hasComparePriceData = hasComparePriceData;
    
    _comparePriceBtn.hidden = !_hasComparePriceData;
}

#pragma mark observer
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if(self.currentImage)
    {
        NSValue *frame = change[@"new"];
        CGRect newFrame = [frame CGRectValue];
        CGRect oldFrame = _currentImage.frame;
        oldFrame.size.height = newFrame.size.height;
        _currentImage.frame = oldFrame;
        _scrollView.frame = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    }
}

#pragma mark message event
//+ (BOOL)resolveInstanceMethod:(SEL)sel
//{
//    if (sel == @selector(adsContents))
//    {
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

@end
