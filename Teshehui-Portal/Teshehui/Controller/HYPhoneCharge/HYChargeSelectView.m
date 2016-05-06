//
//  HYChargeSelectView.m
//  Teshehui
//
//  Created by Kris on 16/2/26.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYChargeSelectView.h"
#import "HYPhoneChargeButton.h"
#import "Masonry.h"

const NSInteger numberPerRow = 3;

@interface HYChargeSelectView ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) NSMutableArray *btnArray;
//for the temp storage
@property (strong, nonatomic) UIButton *tmpBtn;
@property (strong, nonatomic) HYChargeSelectViewModel *viewModel;

@end

@implementation HYChargeSelectView

- (void)dealloc
{
    for (HYPhoneChargeButton *btn in self.btnArray)
    {
        [btn removeObserver:self forKeyPath:@"selected"];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
    
    UIView *container = [[UIView alloc]init];
    self.container = container;

    [self.scrollView addSubview:container];
    WS(weakSelf);
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.scrollView);
        make.width.equalTo(weakSelf.scrollView);
    }];
}

- (void)bindDataWithViewModel:(HYChargeSelectViewModel *)model
{
    if ([model isKindOfClass:[HYChargeSelectViewModel class]])
    {
        self.viewModel = model;
        [self setupPriceButton];
    }
}

- (void)setupPriceButton
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < self.viewModel.dataList.count; ++i)
    {
        [self removeData];
        
        HYPhoneChargeButton *btn = [[HYPhoneChargeButton alloc]init];
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(btnClick:)
      forControlEvents:UIControlEventTouchUpInside];
        [btn addObserver:self forKeyPath:@"selected"
    options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 0.5;
        btn.layer.cornerRadius = 5;
    
        [self.container addSubview:btn];
        [array addObject:btn];
    }
    
    self.btnArray = array;
    
    //after the setup,then layout
    [self layoutPriceButton];
}

- (void)layoutPriceButton
{
    WS(weakSelf);

    //the sequence of btn in array
    int index;

    //the first column layout
    for (index = 0; index < self.viewModel.dataList.count; ++index)
    {
        NSInteger row = index / numberPerRow;
        NSInteger column = index % numberPerRow;
        HYPhoneChargeButton *btn = self.btnArray[index];
        
        if (0 == column)
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.container.mas_left).with.offset(TFScalePoint(15));
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),70));
            }];
        }
        //the last column layout
        else if (numberPerRow - 1 == column)
        {
//            UIButton *lastObject = self.btnArray[index-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),70));
//                make.left.equalTo(lastObject.mas_right).with.offset(TFScalePoint(10));
                make.right.equalTo(weakSelf.container.mas_right).with.offset(TFScalePoint(-5));
            }];
        }
        //the column between the first and the last
        else
        {
            UIButton *lastObject = self.btnArray[index-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastObject.mas_right).with.offset(TFScalePoint(10));
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),70));
            }];
        }
        
        //and layout the row
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.container.mas_top).with.offset(row *(70+15) + 10);
        }];
        
        //the last btn to calculate the containview's bottom
        if (index == self.viewModel.dataList.count-1)
        {
//            [self.container mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.equalTo(btn.mas_bottom).with.offset(5);
//            }];
            
            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(btn.mas_bottom).with.offset(20);
            }];
        }
        
        //set data
        [btn setPhoneChargeButtonData:self.viewModel.dataList[index]];
        
    }
}

- (void)removeData
{
    if (self.btnArray.count > 0)
    {
        [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //caution the kvo must be existing with the life cycle
        for (HYPhoneChargeButton *btn in self.btnArray)
        {
            [btn removeObserver:self forKeyPath:@"selected"];
        }
        [self.btnArray removeAllObjects];
    }
}

#pragma mark method from superclass
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    
}

#pragma mark observer
- (void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context
{
    HYPhoneChargeButton *btn = object;
    if (btn.selected)
    {
        btn.layer.borderColor = [UIColor redColor].CGColor;
        [btn setTextColor:[UIColor redColor]];
    }
    else
    {
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        [btn setTextColor:[UIColor blackColor]];
    }
}

#pragma mark Event
- (void)btnClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(addRechargeOrder:)])
    {
        [self.delegate performSelector:@selector(addRechargeOrder:)
                            withObject:sender];
    }
    
    if (_tmpBtn == nil)
    {
        sender.selected = YES;
        _tmpBtn = sender;
    }
    else if (_tmpBtn !=nil && _tmpBtn == sender)
    {
        sender.selected = YES;
    }
    else if (_tmpBtn!= sender && _tmpBtn!=nil)
    {
        _tmpBtn.selected = NO;
        sender.selected = YES;
        _tmpBtn = sender;
    }
}

@end
