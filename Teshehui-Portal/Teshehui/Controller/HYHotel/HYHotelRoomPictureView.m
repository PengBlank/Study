//
//  HYHotelRoomPictureView.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelRoomPictureView.h"
#import "DDPageControl.h"
#import "HYHotelPictureInfo.h"
#import "UIImageView+WebCache.h"

@interface HYHotelRoomPictureView ()<UIScrollViewDelegate>

@property (nonatomic, strong) DDPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HYHotelRoomPictureView

- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictures;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        frame.origin = CGPointZero;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        for (NSString *url in pictures)
        {
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:frame];
            [imageview sd_setImageWithURL:[NSURL URLWithString:url]
                      placeholderImage:[UIImage imageNamed:@"loading"]];
            [_scrollView addSubview:imageview];
            frame.origin.x += frame.size.width;
        }
        
        _scrollView.contentSize = CGSizeMake(frame.size.width*[pictures count], frame.size.height);
        
        if ([pictures count] > 1)
        {
            _pageControl = [[DDPageControl alloc] init] ;
            [_pageControl setNumberOfPages:pictures.count] ;
            [_pageControl setCurrentPage: 0] ;
            [_pageControl addTarget: self
                             action: @selector(pageControlClicked:)
                   forControlEvents: UIControlEventValueChanged];
            
            [_pageControl setDefersCurrentPageDisplay: YES] ;
            [_pageControl setType: DDPageControlTypeOnFullOffFull] ;
            [_pageControl setOnColor: [UIColor whiteColor]];
            [_pageControl setOffColor: [UIColor colorWithWhite: 0.2f alpha: 1.0f]] ;
            [_pageControl setIndicatorDiameter: 6.0f];
            [_pageControl setIndicatorSpace: 6.0f];
            [_pageControl setCenter:CGPointMake(160, frame.size.height-10)];
            [self addSubview:_pageControl];
        }
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
	CGFloat pageWidth = aScrollView.bounds.size.width ;
    float fractionalPage = aScrollView.contentOffset.x / pageWidth ;
	NSInteger nearestNumber = lround(fractionalPage) ;
	
	if (self.pageControl.currentPage != nearestNumber)
	{
		self.pageControl.currentPage = nearestNumber ;
        if (aScrollView.dragging)
			[self.pageControl updateCurrentPageDisplay] ;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)aScrollView
{
	// if we are animating (triggered by clicking on the page control), we update the page control
	[self.pageControl updateCurrentPageDisplay] ;
}

- (void)pageControlClicked:(id)sender
{
	DDPageControl *thePageControl = (DDPageControl *)sender ;
	
	[_scrollView setContentOffset: CGPointMake(_scrollView.bounds.size.width * thePageControl.currentPage,
                                               _scrollView.contentOffset.y)
                         animated: YES] ;
}

@end
