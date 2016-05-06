//
//  HYMallMainProductListCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMainProductListCell.h"
#import "HYMallMainProductView.h"

@interface HYMallMainProductListCell ()

@property (nonatomic, strong) HYMallMainProductView *leftView;
@property (nonatomic, strong) HYMallMainProductView *rightView;

@end

@implementation HYMallMainProductListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setHiddenLine:YES];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
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

- (void)checkEvent:(id)sender
{
    HYMallMainProductView *v = (HYMallMainProductView *)sender;
    id data = nil;
    if (v.tag == 10)
    {
        data = [self.cellData objectAtRow:0];
    }
    else
    {
        data = [self.cellData objectAtRow:1];
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

- (HYMallMainProductView *)leftView
{
    if (!_leftView)
    {
        _leftView = [[HYMallMainProductView alloc] initWithFrame:TFRectMake(10, 6, 148, 220)];
        _leftView.backgroundColor = [UIColor whiteColor];
        _leftView.tag = 10;
        [_leftView addTarget:self
                      action:@selector(checkEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_leftView];
    }
    
    return _leftView;
}

- (HYMallMainProductView *)rightView
{
    if (!_rightView)
    {
        _rightView = [[HYMallMainProductView alloc] initWithFrame:TFRectMake(161, 6, 148, 220)];
        _rightView.backgroundColor = [UIColor whiteColor];
        _rightView.tag = 11;
        [_rightView addTarget:self
                       action:@selector(checkEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_rightView];
    }
    
    return _rightView;
}


@end
