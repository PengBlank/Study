//
//  HYProductDetailNavigationTitleView.m
//  Teshehui
//
//  Created by Kris on 16/3/30.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYProductDetailNavigationTitleView.h"
#import "Masonry.h"

@interface HYProductDetailNavigationTitleView ()

@property (nonatomic, strong) HYHYMallOrderListFilterView *filter;
@property (nonatomic, strong) UILabel *title;

@end

@implementation HYProductDetailNavigationTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.filter = [[HYHYMallOrderListFilterView alloc]initWithFrame:CGRectMake(20, 0, frame.size.width-40, 35)];
        self.filter.showSpecLine = NO;
        self.filter.conditions = @[@"商品", @"详情"];
        self.filter.enabled = NO;
        self.filter.backgroundColor = [UIColor clearColor];
        [self.filter addTarget:self
                        action:@selector(filterClick)
              forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.filter];
//        [self.filter mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.mas_left).with.offset(10);
//            make.right.mas_equalTo(weakSelf.mas_right).with.offset(-10);
//            make.top.mas_equalTo(weakSelf.mas_top).with.offset(5);
//            make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-5);
//        }];
        
        self.title = [[UILabel alloc]init];
        self.title.frame = CGRectMake(20, 35, frame.size.width-40, 30);
        self.title.text = @"图文详情";
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.textColor = [UIColor blackColor];
        self.title.alpha = 0;
        [self addSubview:self.title];
    }
    return self;
}

#pragma mark public methods
-(void)changeTitle
{
    [UIView animateWithDuration:.4f animations:^{
        CGRect frame = self.filter.frame;
        frame.origin.y -= 20;
        self.filter.frame = frame;
        self.filter.alpha = 0;
        
        frame = self.title.frame;
        frame.origin.y -= 30;
        self.title.frame = frame;
        self.title.alpha = 1;
    }completion:^(BOOL finished) {
    
    }];
}

- (void)restoreTitle
{
    [UIView animateWithDuration:.4f animations:^{
        CGRect frame = self.filter.frame;
        frame.origin.y += 20;
        self.filter.frame = frame;
        self.filter.alpha = 1;
        
        frame = self.title.frame;
        frame.origin.y += 30;
        self.title.frame = frame;
        self.title.alpha = 0;
    }completion:^(BOOL finished) {
        
    }];
}

#pragma mark UI Event
- (void)filterClick
{
    if ([self.delegate respondsToSelector:@selector(filterAction)])
    {
        [self.delegate performSelector:@selector(filterAction)];
    }
}
@end
