//
//  MainHeaderView.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "MainHeaderView.h"
#import "UIButton+Common.h"
#import "UIImageView+WebCache.h"
#import "DefineConfig.h"
@implementation MainHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

#pragma  mark - 配置属性
- (void)setTopicArray:(NSMutableArray *)topicArray
{
    _topicArray = topicArray;
    [self setup];
}

- (void)setup{
    
    for (int i = 0; i < _topicArray.count; i++) {
        CGRect frame = CGRectMake(0 +  (kScreen_Width/_topicArray.count) * i, 10, (kScreen_Width/_topicArray.count), 80);
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
       // [selectButton.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loading"]];
        
        selectButton.frame=frame;
        [selectButton setImage:[UIImage imageNamed:@"sm_zhifu01"] forState:UIControlStateNormal];
        [selectButton setTitle:_topicArray[i] forState:UIControlStateNormal];
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[selectButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [selectButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [selectButton layoutButtonWithEdgeInsetsStyle:TYButtonEdgeInsetsStyleTop imageTitleSpace:5.0f];
        [self addSubview:selectButton];
    }

}

- (void)buttonPressed:(UIButton *)btn{

    if (_btnClickBlock) {
        _btnClickBlock(btn);
    }
    
}


@end
