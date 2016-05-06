//
//  HYMallCartSecFooter.m
//  Teshehui
//
//  Created by Kris on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallCartSecFooter.h"
#import "Masonry.h"

@interface HYMallCartSecFooter ()

@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;

@end


@implementation HYMallCartSecFooter

-(instancetype)init
{
    if (self = [super init])
    {
        [self setupSubViews];
        
    }
    return self;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    
//}

#pragma mark private methods
- (void)setupSubViews
{
    _btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn0 setTitle:@"移至收藏" forState:UIControlStateNormal];
    [_btn0 setBackgroundColor:[UIColor grayColor]];
    [_btn0 addTarget:self action:@selector(btn0Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn0];

 
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn1 setTitle:@"删除" forState:UIControlStateNormal];
    [_btn1 setBackgroundColor:[UIColor orangeColor]];
    [_btn1 addTarget:self action:@selector(btn1Click) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn1];
    
    WS(weakSelf);
    
    [_btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(0);
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(0);
        make.width.equalTo(weakSelf.mas_width).multipliedBy(0.5);
    }];
    
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(0);
        make.top.equalTo(weakSelf.mas_top).with.offset(0);
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(0);
        make.left.equalTo(weakSelf.btn0.mas_right);
    }];
}

- (void)btn0Click
{
    if (_firstBlock)
    {
        _firstBlock();
    }
}

-(void)btn1Click
{
    if (_secBlock)
    {
        _secBlock();
    }
}

@end
