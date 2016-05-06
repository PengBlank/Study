//
//  HYMallProductListCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-3-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallProductListCell.h"
#import "HYMallProductView.h"

@interface HYMallProductListCell ()

@property (nonatomic, strong) HYMallProductView *leftView;
@property (nonatomic, strong) HYMallProductView *rightView;

@end

@implementation HYMallProductListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(TFScalePoint(159.5), 0, 1, TFScalePoint(242))];
        lineView.image = [[UIImage imageNamed:@"Line_InCell"] stretchableImageWithLeftCapWidth:0
                                                                                  topCapHeight:2];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark private methods
- (void)checkEvent:(id)sender
{
    HYMallProductView *v = (HYMallProductView *)sender;
    id data = nil;
    if (v.tag == 10)
    {
        data = [self.cellData objectAtRow:0];
    }
    else
    {
        data = [self.cellData objectAtRow:1];
    }
    
    if (!data)
    {
        data = v.data;
    }
    
    if ([self.delegate respondsToSelector:@selector(checkProductDetail:)])
    {
        [self.delegate checkProductDetail:data];
    }
}

#pragma mark setter/getter
- (void)setCellData:(HYMallProductCellData *)cellData
{
    if (_cellData != cellData)
    {
        _cellData = cellData;
        
        [_leftView setHidden:YES];
        [_rightView setHidden:YES];
        
        if (cellData.count >= 2)
        {
            [self.leftView setHidden:NO];
            id leftData = [cellData objectAtRow:0];
            [self.leftView setData:leftData];
            
            [self.rightView setHidden:NO];
            id rightData = [cellData objectAtRow:1];
            [self.rightView setData:rightData];
        }
        else
        {
            [self.leftView setHidden:NO];
            id leftData = [cellData objectAtRow:0];
            [self.leftView setData:leftData];
        }
    }
}

- (HYMallProductView *)leftView
{
    if (!_leftView)
    {
        _leftView = [[HYMallProductView alloc] initWithFrame:TFRectMake(0, 0, 159.5, 262)];
        _leftView.backgroundColor = [UIColor clearColor];
        _leftView.tag = 10;
        [_leftView addTarget:self
                      action:@selector(checkEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftView];
    }
    
    return _leftView;
}

- (HYMallProductView *)rightView
{
    if (!_rightView)
    {
        _rightView = [[HYMallProductView alloc] initWithFrame:TFRectMake(160.5, 0, 159.5, 262)];
        _rightView.backgroundColor = [UIColor clearColor];
        _rightView.tag = 11;
        [_rightView addTarget:self
                      action:@selector(checkEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightView];
    }
    
    return _rightView;
}

- (void)setLeftItem:(HYProductListSummary *)litem rightItem:(HYProductListSummary *)ritem
{
    if (litem)
    {
        self.leftView.hidden = NO;
        [self.leftView setData:litem];
    }
    else
    {
        self.leftView.hidden = YES;
    }
    if (ritem)
    {
        self.rightView.hidden = NO;
        [self.rightView setData:ritem];
    }
    else
    {
        self.rightView.hidden = YES;
    }
}

@end
