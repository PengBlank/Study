//
//  HYMallParamView.m
//  Teshehui
//
//  Created by HYZB on 14-9-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallParamView.h"
#import "HYMallParamItemView.h"

@implementation HYMallParamView

@synthesize height = _height;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

#pragma mark setter/getter
- (void)setParamInfo:(NSArray *)paramInfo
{
    if (paramInfo  != _paramInfo)
    {
        _paramInfo = paramInfo;
        
        //clean view
        for (UIView *v in self.subviews)
        {
            if ([v isKindOfClass:[HYMallParamItemView class]])
            {
                [v removeFromSuperview];
            }
        }
        
        CGFloat oirg_y = 0;
        CGFloat oirg_x = 0;
        
        CGFloat height = 26;
        CGFloat maxWidth = ScreenRect.size.width-70;
        int i = 0;
        for (HYProductSKU *item in paramInfo)
        {
            NSString *str = self.showAttribute1 ? item.attributeValue1 : item.attributeValue2;
           
            if ([str length] > 0)
            {
                UIFont *font = [UIFont systemFontOfSize:14];
                CGSize size = [str sizeWithFont:font
                              constrainedToSize:CGSizeMake(maxWidth, self.frame.size.height)];
                size.width = (size.width < 30) ? 60 : (size.width+30);
                size.height = height;
                
                if ((oirg_x+(size.width+12)) > (maxWidth+30))
                {
                    oirg_x = 0;
                    oirg_y += 34;
                }
                
                HYMallParamItemView *itemView = [[HYMallParamItemView alloc] initWithFrameAndGoodsParamDescription:CGRectMake(oirg_x, oirg_y, size.width, size.height)
                                                                                                              desc:str
                                                                                                              font:font];
                [itemView setIsSelected:(i == self.currSelectIndex)];
                itemView.tag = i;
                [itemView addTarget:self
                             action:@selector(didSelectItem:)
                   forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:itemView];
                
                oirg_x += (size.width+12);
                
                i++;
            }
        }
        
        _height = oirg_y+height;
    }
}

- (void)setCurrSelectIndex:(NSInteger)currSelectIndex
{
    if (currSelectIndex != _currSelectIndex)
    {
        for (UIView *v in self.subviews)
        {
            if ([v isKindOfClass:[HYMallParamItemView class]])
            {
                if (v.tag==_currSelectIndex)
                {
                    [(HYMallParamItemView *)v setIsSelected:NO];
                }
                else if (v.tag==currSelectIndex)
                {
                    [(HYMallParamItemView *)v setIsSelected:YES];
                }
            }
        }
        
        _currSelectIndex = currSelectIndex;
    }
}
#pragma mark - private methods
- (void)didSelectItem:(HYMallParamItemView *)view
{
    if (!view.isSelected)
    {
        view.isSelected = !view.isSelected;
        self.currSelectIndex = view.tag;
        
        if ([self.delegate respondsToSelector:@selector(didSelectProductParam:index:isAttribute1:)])
        {
            if (view.tag < [self.paramInfo count])
            {
                id item = [self.paramInfo objectAtIndex:view.tag];
                [self.delegate didSelectProductParam:item
                                               index:view.tag
                                        isAttribute1:self.showAttribute1];
            }
        }
    }
}



@end
