//
//  MainCarouselView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/7.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#define TYTitleSelecterColor [UIColor colorWithHexString:@"0xb80000"]
#define TYTitleNormalColor [UIColor blackColor]

#import "MainCarouselView.h"
#import "MainTableView.h"
#import "TYSegmentView.h"
#import "MainStoreView.h"
#import "DefineConfig.h"
#import "iCarousel.h"
#import "Masonry.h"
#import "UIView+Frame.h"
#import "UIColor+expanded.h"
#import "BusinessRootCtrl.h"
#import "SceneCategoryInfo.h"
@interface MainCarouselView ()<iCarouselDelegate,iCarouselDataSource,MainTableViewDelegate,MainStoreViewDelegate>

@property (nonatomic, strong) TYSegmentView             *segmentView;
@property (strong, nonatomic) iCarousel                 *myCarousel;
@property (assign, nonatomic) UIScrollView              *scrolBody;
@property (assign, nonatomic) NSInteger                 oldSelectedIndex;

@end

@implementation MainCarouselView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(245, 245, 245);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectCity:)
                                                     name:kNotificationWithSelecteCityBlock object:nil];
    }
    return self;
}

- (TYSegmentView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[TYSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _segmentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _segmentView;
}

- (void)setDataArray:(NSMutableArray *)array
{
    _dataArray = array;
    [self setup];
}

//- (NSMutableArray *)dataArray{
//    if (!_dataArray) {
//        _dataArray = [NSMutableArray array];
//    }
//    
//    return _dataArray;
//}

- (void)selectCity:(NSNotification *)notif{
    
    NSString *city = [notif object];
    self.cityName = city;
}

- (void)setup{
    
    [self setupSegmentView];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"PersonGuide"]) {
        if (_delegate &&[_delegate respondsToSelector:@selector(MainCarousePopPersonGuideView)]) {
            [_delegate MainCarousePopPersonGuideView];
        }
    }

    //添加myCarousel
    _myCarousel = ({
        iCarousel *icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,44, self.width, self.height-44)];
        icarousel.dataSource = self;
        icarousel.delegate = self;
        icarousel.decelerationRate = 0.5;
        icarousel.scrollSpeed = 1;
        icarousel.type = iCarouselTypeLinear;
        icarousel.pagingEnabled = YES;
        icarousel.clipsToBounds = YES;
        icarousel.bounces = NO;
        icarousel.bounceDistance = 0.2;
        [self addSubview:icarousel];
        icarousel;
    });
    self.icarouselScrollEnabled = YES;
    
    if ([self.cityName isEqualToString:@"深圳"]) {
        [self.myCarousel scrollToItemAtIndex:1 animated:NO];
    }
    

}

#pragma mark - 创建titleView数据
- (void)setupSegmentView
{
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"实体店", nil];
    for (SceneCategoryInfo *sInfo in self.dataArray) {
        [array addObject:sInfo.calName];
    }
    
    self.segmentView.titleArray = array;
    [self addSubview:self.segmentView];
    __weak typeof(self) weakSelf = self;
    self.segmentView.titlebtnClickBlock = ^(UIButton *btn){
        [weakSelf titleBtnChange:btn];
        [weakSelf.myCarousel scrollToItemAtIndex:btn.tag animated:NO];
    };
    
    if (([self.cityName isEqualToString:@"深圳"] ||  [self.cityName isEqualToString:@"上海"]) && self.segmentView.titleArray.count > 1) {
        CGRect rect = [weakSelf.segmentView.scrollOffSet[1] CGRectValue];
        [weakSelf.segmentView.lineView setFrame:rect];
        UIButton *btn = self.segmentView.titleButtonArray[1];
        [btn setTitleColor:TYTitleSelecterColor forState:UIControlStateNormal];
    }else{
        UIButton *btn = self.segmentView.titleButtonArray[0];
        [self titleBtnChange: btn];
    }
    

}

#pragma mark - titleView点击事件
- (void)titleBtnChange:(UIButton *)btn
{
    WS(weakSelf);
    [UIView animateWithDuration:0.1 animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideMainPageNavRightItem object:btn];
        for (UIButton *btn in weakSelf.segmentView.titleButtonArray) {
            [btn setTitleColor:TYTitleNormalColor forState:UIControlStateNormal];
        }
        
        [btn setTitleColor:TYTitleSelecterColor forState:UIControlStateNormal];
        CGRect rect = [weakSelf.segmentView.scrollOffSet[btn.tag] CGRectValue];
        [weakSelf.segmentView.lineView setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];

}

#pragma mark - icarousel相关代理
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    
    return self.segmentView.titleArray.count;
    
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{

    [view removeFromSuperview];
    view = nil;

    if (!view) {
        
        if(index == 0){

            view = [[UIView alloc] initWithFrame:carousel.bounds];
            MainStoreView *listView = [[MainStoreView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                      self.width, self.height - _segmentView.height)
                                                                      city:self.cityName location:self.coor];
            listView.delegate = self;
            
            [view addSubview:listView];

        }else{
            view = [[UIView alloc] initWithFrame:carousel.bounds];
            MainTableView *listView = [[MainTableView alloc] initWithFrame:CGRectMake(0, 0,
                                                                                      self.width, self.height - _segmentView.height)
                                                                      type:index - 1 models:self.dataArray city:self.cityName];
            listView.delegate = self;

            [view addSubview:listView];
        }
    }
    
    return view;
}



- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel{
    NSUInteger index = carousel.scrollOffset / 1;
    UIButton *btn = self.segmentView.titleButtonArray[index];
    [self titleBtnChange: btn];
}


- (void)setIcarouselScrollEnabled:(BOOL)icarouselScrollEnabled{
    _myCarousel.scrollEnabled = icarouselScrollEnabled;
}

- (void)QRcodeClickWithMainStoreView{
    
    if (_delegate &&[_delegate respondsToSelector:@selector(MainCarouseQRcodeClick)]) {
        [_delegate MainCarouseQRcodeClick];
    }
}

//- (void)popPersonGuideView{
//    if (_delegate &&[_delegate respondsToSelector:@selector(MainCarousePopPersonGuideView)]) {
//        
//        [_delegate MainCarousePopPersonGuideView];
//    }
//}

- (void)QRcodeClickWithMainTableView{
    if (_delegate &&[_delegate respondsToSelector:@selector(MainCarouseQRcodeClick)]) {
        [_delegate MainCarouseQRcodeClick];
    }
}



@end
