//
//  HYAdsScrollView.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAdsScrollView.h"
#import "UIImageView+WebCache.h"
#import "HYLineStylePageControl.h"
#import "HYUmengMobClick.h"
#import "MJRefresh.h"

@interface HYAdsScrollView ()
{
    @protected

    UIPageControl *_pageControl;
    HYLineStylePageControl *_linePageControl;
    
    NSTimer *_timer;
}

@property (nonatomic, strong) NSArray *adsContents;

@property (nonatomic, copy) NSString *cacheTitle;
@property (nonatomic, retain) NSMutableArray *resultItems;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, assign) NSUInteger currentPage;
@end

@implementation HYAdsScrollView

- (void)dealloc
{
    _scorllView.delegate = nil;
    _scorllView = nil;
    
    _totalPages = 0;
    _adsContents = nil;
    _pageControl = nil;
    
    self.dataSource = nil;
    self.delegate = nil;
    
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    DebugNSLog(@"HYAdsScrollView dealloc %@", self);
}

- (id)initWithFrame:(CGRect)frame linePageControl:(BOOL)linePageControl;
{
    DebugNSLog(@"HYAdsScrollView alloc");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _autoScroll = NO;
        
        _scorllView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     frame.size.width,
                                                                     frame.size.height)];
        _scorllView.delegate = self;
        _scorllView.pagingEnabled = YES;
        _scorllView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
        _scorllView.scrollsToTop = NO;
        _scorllView.bounces = YES;
        [self addSubview:_scorllView];
        
        if (!linePageControl)
        {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((frame.size.width-160)/2, frame.size.height-16, 160, 10)];
            _pageControl.currentPage = 0;
            [_pageControl addTarget:self
                             action:@selector(didChangPageValue:)
                   forControlEvents:UIControlEventValueChanged];
            [self addSubview:_pageControl];
        }
        else
        {
            _linePageControl = [[HYLineStylePageControl alloc] initWithFrame:CGRectMake(0, frame.size.height-4, frame.size.width, 4)];
            _linePageControl.currentPage = 0;
            [_linePageControl addTarget:self
                             action:@selector(didChangPageValue:)
                   forControlEvents:UIControlEventValueChanged];
            [self addSubview:_linePageControl];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(didTapView:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame
               linePageControl:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark pulice methods
- (void) reloadData {
    //重置索引
    self.adsContents = [self.dataSource adsContents];
    NSInteger count = [self.adsContents count];
    _pageControl.numberOfPages = count;
    _totalPages = count;
    
    if (_totalPages > 1)
    {
        _pageControl.hidden = NO;
    }
    else
    {
        _pageControl.hidden = YES;
    }
    
    if (_totalPages > 0)
    {
        [self loadData];
    }
    else  //清除
    {
        NSArray *subViews = [_scorllView subviews];
        if([subViews count] != 0) {
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
}

- (void)cleanTimer
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark private methods
- (void)loadData
{
    //从scrollView上移除所有的subview
    NSArray *subViews = [_scorllView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i<3&&i<[_curViews count] ; i++) {
        UIView *v = [_curViews objectAtIndex:i];
        v.frame = CGRectMake(v.frame.size.width*i,
                             0,
                             v.frame.size.width,
                             v.frame.size.height);//CGRectOffset(v.frame, v.frame.size.width * i, 0);
        v.clipsToBounds = YES;
        [_scorllView addSubview:v];
    }
    
    if (_totalPages > 1) {
        _scorllView.contentSize = CGSizeMake(_scorllView.frame.size.width * 3, _scorllView.frame.size.height);
        [_scorllView setContentOffset:CGPointMake(_scorllView.frame.size.width, 0) animated:NO];
    }
    else {
        _scorllView.contentSize = CGSizeMake(_scorllView.frame.size.width * 1, _scorllView.frame.size.height);
        [_scorllView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    if (_totalPages > 1)
    {
        NSInteger pre = [self validPageValue:_curPage-1];
        NSInteger last = [self validPageValue:_curPage+1];
        
        if (!_curViews)
        {
            _curViews = [[NSMutableArray alloc] init];
        }
        
        [_curViews removeAllObjects];
        
        UIView *preview = [self loadControllerAtIndex:pre];
        if (preview)
        {
            [_curViews addObject:preview];
        }
        
        UIView *pageview = [self loadControllerAtIndex:page];
        if (pageview)
        {
            [_curViews addObject:pageview];
        }
        
        UIView *lastview = [self loadControllerAtIndex:last];
        if (lastview)
        {
            [_curViews addObject:lastview];
        }
    }
    else
    {
        if (!_curViews)
        {
            _curViews = [[NSMutableArray alloc] init];
        }
        
        [_curViews removeAllObjects];
        UIView *pageview = [self loadControllerAtIndex:page];
        if (pageview)
        {
            [_curViews addObject:pageview];
        }
    }
}

- (NSInteger)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    
    return value;
}

- (UIView *)loadControllerAtIndex:(NSInteger) index
{
    if (index >= self.adsContents.count || index < 0) return nil;
    
    NSString *str = [self.adsContents objectAtIndex:index];
    
    CGRect frame = CGRectMake(0,
                              0,
                              self.frame.size.width,
                              self.frame.size.height);
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [imageview sd_setImageWithURL:[NSURL URLWithString:str]
                 placeholderImage:nil];
    imageview.tag = 0;

    return imageview;
}

/*
- (void)reloadData
{
    if ([self.dataSource respondsToSelector:@selector(adsContents)])
    {
        NSArray *adsContents = [self.dataSource adsContents];
        NSInteger count = [adsContents count];
        if (count > 0)
        {
            self.adsContents = adsContents;
            
            CGFloat w = self.frame.size.width * count;
            CGRect rect = CGRectMake(0,
                                     0,
                                     self.frame.size.width,
                                     self.frame.size.height);
            
            [_scorllView setContentSize:CGSizeMake(w, rect.size.height)];
            
            for (int i=0; i<count; i++)
            {
                rect.origin.x = rect.size.width*i;
                NSString *str = [adsContents objectAtIndex:i];
                UIImageView *imageview = [[UIImageView alloc] initWithFrame:rect];
                [imageview sd_setImageWithURL:[NSURL URLWithString:str]
                          placeholderImage:nil];
                [_scorllView addSubview:imageview];
            }
            
            _pageControl.numberOfPages = count;
        }
    }
}
*/

#pragma mark setter/getter
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _scorllView.frame = self.bounds;
    
    CGRect rect = _pageControl.frame;
    rect.origin.y = _scorllView.frame.size.height-16;
    _pageControl.frame = rect;
    
    if ([_curViews count] > 1)
    {
        UIView *v = [_curViews objectAtIndex:1];
        rect = v.frame;
        rect.size.height = frame.size.height;
        rect.origin.y = (frame.origin.y+rect.size.height);
        v.frame = rect;
    }
    else
    {
        UIView *v = [_curViews lastObject];
        rect = v.frame;
        rect.size.height = frame.size.height;
        rect.origin.y = (frame.origin.y+rect.size.height);
        v.frame = rect;
    }
}

- (void)setScrollOffsetY:(CGFloat)scrollOffsetY
{
    if (scrollOffsetY != _scrollOffsetY)
    {
        _scrollOffsetY = scrollOffsetY;
        
        CGRect f = _scorllView.frame;
        f.origin.y = scrollOffsetY;
        f.size.height =  -scrollOffsetY;
        _scorllView.frame = f;
    }
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    CGRect frame = self.frame;
    
    [_scorllView removeFromSuperview];
    _scorllView = scrollView;
    
    _scorllView.frame = CGRectMake(0,
               0,
               frame.size.width,
                                   frame.size.height);
    _scorllView.delegate = self;
    _scorllView.pagingEnabled = YES;
    _scorllView.contentSize = CGSizeMake(frame.size.width * 3, frame.size.height);
    _scorllView.scrollsToTop = NO;
    _scorllView.bounces = YES;
    [self insertSubview:_scorllView belowSubview:_pageControl];
}

- (void)setDataSource:(id<HYAdsScrollViewDataSource>)dataSource
{
    if (dataSource != _dataSource)
    {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    if (autoScroll != _autoScroll)
    {
        _autoScroll = autoScroll;
        
        if (autoScroll)
        {
            _timer = [NSTimer scheduledTimerWithTimeInterval:6.5
                                                      target:self
                                                    selector:@selector(autoPlayAds:)
                                                    userInfo:nil
                                                     repeats:YES];
        }
        else
        {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

#pragma mark - private methods
- (void)autoPlayAds:(NSTimer *)timer
{
    if ([[self.dataSource adsContents] count]>1)
    {
        if (!_scorllView.isDragging)
        {
            CGPoint newOffset = CGPointMake(_scorllView.contentOffset.x + CGRectGetWidth(_scorllView.frame), _scorllView.contentOffset.y);
            
            if ((int)newOffset.x%(int)CGRectGetWidth(_scorllView.frame) != 0)
            {
                newOffset.x = (_pageControl.currentPage+1)*CGRectGetWidth(_scorllView.frame);
            };
            
            [_scorllView setContentOffset:newOffset animated:YES];
            //DebugNSLog(@"autoPlayAds %@", self);
        }
        
    }
}

- (void)didTapView:(id)sender
{

    if ([self.delegate respondsToSelector:@selector(didClickAdsIndex:)])
    {
        [self.delegate didClickAdsIndex:_pageControl.currentPage];
        
        // 友盟事件统计
        [HYUmengMobClick homePageBannerClickedWithNumber:(int)_pageControl.currentPage];
    }
}

- (void)didChangPageValue:(id)sender
{
    NSInteger page = _pageControl.currentPage;
    CGPoint contentOffset = CGPointMake(self.frame.size.width*page, 0);
    [_scorllView setContentOffset:contentOffset animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    if (_totalPages > 1)
    {
        //往下翻一张
        if(x >= (2*self.frame.size.width)) {
            _curPage = [self validPageValue:_curPage+1];
            [self loadData];
        }
        
        //往上翻
        if(x <= 0) {
            _curPage = [self validPageValue:_curPage-1];
            [self loadData];
        }
        
        _pageControl.currentPage = _curPage;
    }
}

@end
