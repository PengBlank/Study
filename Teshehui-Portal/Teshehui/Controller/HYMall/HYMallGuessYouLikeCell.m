//
//  HYMallGuessYouLikeCell.m
//  Teshehui
//
//  Created by Kris on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallGuessYouLikeCell.h"
#import "HYMallBrandCellBtn.h"
#import "Masonry.h"

const NSInteger numberPerRowOfHYMallGuessYouLikeCell = 3;

@interface HYMallGuessYouLikeCell ()
{
    UILabel *_title;
}
@property (copy, nonatomic) NSArray *modelList;
@property (strong, nonatomic) NSMutableArray *btnArray;
//for the temp storage
@property (strong, nonatomic) UIButton *tmpBtn;

@end

@implementation HYMallGuessYouLikeCell

- (void)dealloc
{
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf);
        _title = [[UILabel alloc]init];
        _title.text = @"大家都在买";
        _title.textColor = [UIColor darkGrayColor];
        _title.font = [UIFont systemFontOfSize:14.0];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 30));
            make.top.equalTo(weakSelf.mas_top).with.offset(5);
            make.left.equalTo(weakSelf.mas_left).with.offset(14);
        }];
    }
    return self;
}

#pragma mark private method
- (void)setupPriceButton
{
    NSMutableArray *array = [NSMutableArray array];
    NSUInteger count = (self.modelList.count > 3 ? 3 : self.modelList.count);
    
    [self removeData];
    
    for (int i = 0; i < count; ++i)
    {
        HYMallBrandCellBtn *btn = [HYMallBrandCellBtn instanceView];
        [btn.clickBtn addTarget:self
                         action:@selector(btnClick:)
               forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
        [array addObject:btn];
    }
    
    self.btnArray = array;
    
    //after the setup,then layout
    [self layoutPriceButton];
}

- (void)removeData
{
    if (self.btnArray.count > 0)
    {
        [self.btnArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.btnArray removeAllObjects];
    }
}

- (void)layoutPriceButton
{
    WS(weakSelf);
    
    //the sequence of btn in array
    int index;
    NSUInteger count = (self.modelList.count > 3 ? 3 : self.modelList.count);
    
    //the first column layout
    for (index = 0; index < count; ++index)
    {
        NSInteger row = index / numberPerRowOfHYMallGuessYouLikeCell;
        NSInteger column = index % numberPerRowOfHYMallGuessYouLikeCell;
        HYMallBrandCellBtn *btn = self.btnArray[index];
        
        if (0 == column)
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakSelf.contentView.mas_left).with.offset(TFScalePoint(15));
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),TFScalePoint(90)+40));
//                btn.clickBtn.frame = CGRectMake(0, 0, TFScalePoint(90), TFScalePoint(90));
            }];
        }
        //the last column layout
        else if (numberPerRowOfHYMallGuessYouLikeCell - 1 == column)
        {
            //            UIButton *lastObject = self.btnArray[index-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),TFScalePoint(90)+40));
                //                make.left.equalTo(lastObject.mas_right).with.offset(TFScalePoint(10));
                make.right.equalTo(weakSelf.contentView.mas_right).with.offset(TFScalePoint(-15));
            }];
        }
        //the column between the first and the last
        else
        {
            UIView *lastObject = self.btnArray[index-1];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastObject.mas_right).with.offset(TFScalePoint(10));
                make.size.mas_equalTo(CGSizeMake(TFScalePoint(90),TFScalePoint(90)+40));
            }];
        }
        
        //and layout the row
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentView.mas_top).with.offset(row *(100+10) + 40);
        }];
        
        [btn setData:self.modelList[index]];
    }
}

#pragma mark button event
- (void)btnClick:(UIButton *)sender
{
    UIResponder *temp = self.nextResponder;
    do {
        if ([temp isKindOfClass:[UITableView class]])
        {
            UITableView *tableView = (UITableView *)temp;
            if ([tableView.delegate respondsToSelector:@selector(cellBtnClick:)])
            {
                HYMallBrandCellBtn *btn = (HYMallBrandCellBtn *)sender.superview;
                [tableView.delegate performSelector:@selector(cellBtnClick:) withObject:btn];
            }
            break;
        }
        else
        {
            temp = temp.nextResponder;
        }
    } while (temp);
    //        if ([self. respondsToSelector:@selector(addRechargeOrder:)])
    //        {
    //            [self.delegate performSelector:@selector(addRechargeOrder:)
    //                                withObject:sender];
    //        }
    
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

#pragma mark getter & setter
-(void)setData:(id)data
{
    if ([data isKindOfClass:[NSArray class]])
    {
        self.modelList = data;
        [self setupPriceButton];
    }
}
@end
