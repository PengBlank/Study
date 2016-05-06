//
//  HYProductParamInfoCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYProductParamInfoCell.h"
#import "HYMallParamView.h"

@interface HYProductParamInfoCell ()<HYMallParamViewDelegate>

@property (nonatomic, strong) UILabel *param1Lab;
@property (nonatomic, strong) UILabel *param2Lab;
@property (nonatomic, strong) HYMallParamView *param1View;
@property (nonatomic, strong) HYMallParamView *param2View;

@end

@implementation HYProductParamInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

#pragma mark - HYMallParamViewDelegate
- (void)didSelectProductParam:(HYProductSKU *)param index:(NSInteger)index isAttribute1:(BOOL)isAttribute1
{
    if (isAttribute1)
    {
        self.goodDetaiInfo.selectAtt1Index = index;
        self.goodDetaiInfo.selectAtt2Index = 0;
        
        [self updateSubviews];
    }
    else
    {
        self.goodDetaiInfo.selectAtt2Index = index;
    }
    
    self.goodDetaiInfo.currentsSUK = param;
    
    if ([self.delegate respondsToSelector:@selector(didSelectProductSKU:)])
    { 
        [self.delegate didSelectProductSKU:param];
    }
}

#pragma mark - private methods
- (void)addQuantity:(id)sender
{
    
}

- (void)minusQuantity:(id)sender
{
    
}

- (void)updateSubviews
{
    CGFloat oirg_y = 10;
    HYProductSKU *currSKU = nil;
    if ([[self.goodDetaiInfo attribute1List] count] > 0)
    {
        self.param1Lab.frame = CGRectMake(10, 15, 30, 20);
        self.param1Lab.text = self.goodDetaiInfo.attributeName1;
        
        self.param1View.showAttribute1 = YES;
        self.param1View.currSelectIndex = self.goodDetaiInfo.selectAtt1Index;
        [self.param1View setParamInfo:[self.goodDetaiInfo attribute1List]];
        [self.param1View setFrame:CGRectMake(50, 15, ScreenRect.size.width-70, self.param1View.height)];
        oirg_y += self.param1View.height+10;
        
        //如果没有第二属性的时候选择的就是该属性
        currSKU = [[self.goodDetaiInfo attribute1List] objectAtIndex:self.goodDetaiInfo.selectAtt1Index];
    }
    
    //关联的第二属性
    NSArray *array = [self.goodDetaiInfo attributeWithId:currSKU.attributeValue1];
    
    if ([array count] > 0)
    {
        self.param2Lab.frame = CGRectMake(0, CGRectGetMaxY(_param1View.frame)+10, 48, 20);
        self.param2Lab.text = self.goodDetaiInfo.attributeName2;
        
        self.param2View.currSelectIndex = self.goodDetaiInfo.selectAtt2Index;
        
        self.param2View.showAttribute1 = NO;
        [self.param2View setParamInfo:array];
        [self.param2View setFrame:CGRectMake(50, CGRectGetMaxY(_param1View.frame)+7, ScreenRect.size.width-70, self.param2View.height)];
        oirg_y += (self.param2View.height+45);
        
//        currSKU = [array objectAtIndex:self.goodDetaiInfo.selectAtt2Index];
    }
}

#pragma mark setter/getter
- (UILabel *)param1Lab
{
    if (!_param1Lab)
    {
        _param1Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
        _param1Lab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _param1Lab.backgroundColor = [UIColor clearColor];
        _param1Lab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_param1Lab];
    }
    
    return _param1Lab;
}

- (UILabel *)param2Lab
{
    if (!_param2Lab)
    {
        _param2Lab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 30, 20)];
        _param2Lab.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        _param2Lab.backgroundColor = [UIColor clearColor];
        _param2Lab.textAlignment = NSTextAlignmentCenter;
        _param2Lab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_param2Lab];
    }
    
    return _param2Lab;
}

- (HYMallParamView *)param1View
{
    if (!_param1View)
    {
        _param1View = [[HYMallParamView alloc] initWithFrame:CGRectMake(10, 0, ScreenRect.size.width-40, 20)];
//        _param1View.backgroundColor = [UIColor redColor];
        _param1View.delegate = self;
        [self.contentView addSubview:_param1View];
    }
    
    return _param1View;
}

- (HYMallParamView *)param2View
{
    if (!_param2View)
    {
        _param2View = [[HYMallParamView alloc] initWithFrame:CGRectMake(10, 0, ScreenRect.size.width-40, 20)];
//        _param2View.backgroundColor = [UIColor blueColor];
        _param2View.delegate = self;
        [self.contentView addSubview:_param2View];
    }
    
    return _param2View;
}

- (void)setGoodDetaiInfo:(HYMallGoodsDetail *)goodDetaiInfo
{
    if (goodDetaiInfo != _goodDetaiInfo)
    {
        _goodDetaiInfo = goodDetaiInfo;
        
        [self updateSubviews];
    }
}

@end
