//
//  HYProductFilterCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductFilterCell.h"
#import "HYMallParamItemView.h"

@implementation HYProductFilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _currSelectIndex = -1;
        self.clipsToBounds = YES;
        self.separatorLeftInset = 0;
    }
    return self;
}
- (void)updateItemView
{
    //clean view
    for (UIView *v in self.contentView.subviews)
    {
        if ([v isKindOfClass:[HYMallParamItemView class]])
        {
            [v removeFromSuperview];
        }
    }
    
    CGFloat org_x = 0;
    CGFloat spec = 10;
    CGFloat _itemHeight = [self.curSelectItem length] ? 50 : 10;
    
    if (self.curSelectItem)
    {
        //选择的下标无效
        self.currSelectIndex = -1;
        
        CGSize size = [self.curSelectItem sizeWithFont:self.textFont
                        constrainedToSize:CGSizeMake(self.maxWidth, MAXFLOAT)];
        if (size.width>(self.maxWidth-spec*2))
        {
            size.width = self.maxWidth-spec*2;
        }
        else
        {
            size.width = (size.width+6)>(self.maxWidth-spec*4)/3 ? (size.width+6) : (self.maxWidth-spec*4)/3;
        }
        
        HYMallParamItemView *v = [[HYMallParamItemView alloc] initWithFrameAndGoodsParamDescription:CGRectMake(10,
                                                                                                               10,
                                                                                                               size.width,
                                                                                                               30)
                                                                                               desc:self.curSelectItem
                                                                                               font:self.textFont];
        v.tag = self.currSelectIndex+1000;
        [v setIsSelected:YES];
        [v addTarget:self
              action:@selector(didSelectItem:)
    forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:v];
    }
    
    NSInteger i = 0;
    for (NSString *title in self.items)
    {
        CGSize size = [title sizeWithFont:self.textFont
                        constrainedToSize:CGSizeMake(self.maxWidth, MAXFLOAT)];
        if (size.width>(self.maxWidth-spec*2))
        {
            size.width = self.maxWidth-spec*2;
        }
        else
        {
            size.width = (size.width+6)>(self.maxWidth-spec*4)/3 ? (size.width+6) : (self.maxWidth-spec*4)/3;
        }
        
        if ((org_x+size.width+spec) > (self.maxWidth-spec))
        {
            org_x = 0;
            _itemHeight += (30+spec);
        }
        
        CGRect frame = CGRectMake(org_x+10,
                                  _itemHeight,
                                  size.width,
                                  30);
        
        HYMallParamItemView *v = [[HYMallParamItemView alloc] initWithFrameAndGoodsParamDescription:frame
                                                                                               desc:title
                                                                                               font:self.textFont];
        [v setIsSelected:(i == self.currSelectIndex)];
        
        v.tag = i+1000;
        [v addTarget:self
              action:@selector(didSelectItem:)
    forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:v];
        
        org_x += (size.width+spec);
        
        i++;
    }
}

- (void)setItems:(NSArray *)items
{
    if (items != _items)
    {
        _items = items;
        if (_currSelectIndex > 0)
        {
            _currSelectIndex = 0;
        }

        [self updateItemView];
    }
    else if (![items count])
    {
        [self updateItemView];
    }
}

- (void)setCurrSelectIndex:(NSInteger)currSelectIndex
{
    if (currSelectIndex != _currSelectIndex)
    {
        HYMallParamItemView *lastv = (HYMallParamItemView *)[self.contentView viewWithTag:(_currSelectIndex+1000)];
        [lastv setIsSelected:NO];
        
        HYMallParamItemView *v = (HYMallParamItemView *)[self.contentView viewWithTag:(currSelectIndex+1000)];
        [v setIsSelected:YES];
        
        _currSelectIndex = currSelectIndex;
    }
}

- (void)setCurSelectItem:(NSString *)curSelectItem
{
    if (curSelectItem != _curSelectItem)
    {
        _curSelectItem = curSelectItem;
    }
    
    if (curSelectItem)
    {
        [self setCurrSelectIndex:-1];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    _currSelectIndex = -1;
}

- (void)didSelectItem:(HYMallParamItemView *)view
{
    view.isSelected = !view.isSelected;
    
    if ((view.tag-1000)==self.currSelectIndex && !view.isSelected)
    {
        self.currSelectIndex = -1;
    }
    else
    {
        HYMallParamItemView *lastv = (HYMallParamItemView *)[self.contentView viewWithTag:(_currSelectIndex+1000)];
        [lastv setIsSelected:NO];
        
        self.currSelectIndex = (view.tag-1000);
    }
    
    //回调
    if (self.indexChange)
    {
        self.indexChange(self.currSelectIndex);
    }
}

@end
