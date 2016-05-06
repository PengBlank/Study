//
//  TYSegmentView.m
//  Catering
//
//  Created by apple_administrator on 16/3/28.
//  Copyright © 2016年 TeYou. All rights reserved.
//

#import "TYSegmentView.h"
#import "UIColor+expanded.h"
#import "UIView+Frame.h"
#import "DefineConfig.h"
#import "DownMenuView.h"
CGFloat const GYTitleButtonMaxFont = 20;
CGFloat const GYTitleButtonMinFont = 15;
CGFloat const GYSegmentViewMargin = 10;
CGFloat const GYLastTitleWidth = 20;
CGFloat const GYaddButtonWidth = 40;
CGFloat const GYItemWitdh = 70;
CGFloat const GYItemHeight = 40;
CGFloat const GYItemViewMargin = 20;
CGFloat const GYsortButton = 60;
CGFloat const GYsortItemViewmaxCols = 4;
CGFloat const deletItemW = 15;
CGFloat const GYSegmentScrollViewMargin = 30;
CGFloat const GYSegmentViewHeight = 44;
NSInteger const GYSegmentMaxCount = 5;


@implementation TYSegmentView

#pragma mark - 懒加载

- (UIView *)lineView{

    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0xb80000"];
    }
    return _lineView;
}

- (UIView *)bottomView{

    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(self.x, self.height - 0.5, self.width, 0.5)];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
    }
    
    return _bottomView;
}

- (NSMutableArray *)scrollOffSet
{
    if (!_scrollOffSet) {
        _scrollOffSet = [NSMutableArray array];
    }
    return _scrollOffSet;
}
- (UIScrollView *)titleScroll
{
    if (!_titleScroll) {
        _titleScroll = [[UIScrollView alloc]init];
    }
    return _titleScroll;
}
- (NSMutableArray *)titleButtonArray
{
    if (!_titleButtonArray) {
        _titleButtonArray = [NSMutableArray array];
    }
    return _titleButtonArray;
}


#pragma  mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
#pragma  mark - 配置属性
- (void)setTitleArray:(NSMutableArray *)titleArray
{
    _titleArray = titleArray;
    [self setup];
}

- (void)setup
{
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    sc.backgroundColor = [UIColor clearColor];
    sc.showsHorizontalScrollIndicator = NO;
    self.titleScroll = sc;
    [self addSubview:self.titleScroll];
    
    [self setupTitleButton];
    [self addSubview:self.bottomView];
}



- (void)setupTitleButton
{
    CGFloat btnHeight = self.height;
    CGFloat btnX = GYSegmentViewMargin;
    CGFloat btnY = 0;
    
    _titileCount = _titleArray.count <= GYSegmentMaxCount ? _titleArray.count : GYSegmentMaxCount;
    
    NSMutableArray *array = [NSMutableArray array];
    if (self.titleButtonArray.count > 0) {
        [self.titleButtonArray removeAllObjects];
    }
    for (int i = 0; i < _titleArray.count; i++)
    {
        NSString *title = _titleArray[i];
        CGFloat btnWidth = title.length * GYTitleButtonMaxFont;
        
        UIButton *btn = [[UIButton alloc]init];
        [btn  setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:GYTitleButtonMinFont];
        btn.frame = CGRectMake(kScreen_Width/_titileCount * i, btnY, kScreen_Width/_titileCount, btnHeight);
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        btnX += btnWidth + GYSegmentViewMargin;
        btn.tag = i;
        
        [array addObject:btn];
        
        [self.titleScroll addSubview:btn];
        
        
//        CGRect rect = CGRectMake(btnX, self.height - 2, btnWidth, 2);
//        rect.origin.x = btn.size.width/2 - rect.size.width/2 + (btn.size.width * i);
        
        CGRect rect = CGRectMake(btn.x, self.height - 2, kScreen_Width/_titileCount, 2);
        [self.scrollOffSet addObject:[NSValue valueWithCGRect:rect]];
        
        if (i == 0) {
            
            CGRect rect = [self.scrollOffSet[i] CGRectValue];
            [self.lineView setFrame:rect];
        }
        
    }
    self.titleScroll.contentSize = CGSizeMake(kScreen_Width/_titileCount * _titleArray.count, self.height);
    
    [self.titleButtonArray addObjectsFromArray:array];
    [self.titleScroll addSubview:self.lineView];
}
#pragma mark -按钮点击
- (void)titleClick:(UIButton *)btn
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHideCategoryMenuItem object:nil];
    if (self.titlebtnClickBlock) {
        self.titlebtnClickBlock(btn);
    }
}

@end
