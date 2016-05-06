//
//  HYMallBrandCell.m
//  Teshehui
//
//  Created by Kris on 16/3/23.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallBrandCell.h"
#import "HYMallBrandCellBtn.h"
#import "Masonry.h"

const NSInteger numberPerRowOfHYMallBrandViewCell = 3;

@interface HYMallBrandCell ()

@property (strong, nonatomic) NSArray<HYMallBrandSecModel *> *modelList;
@property (nonatomic, strong) NSMutableDictionary *tileViews;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation HYMallBrandCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
        self.contentView.backgroundColor = [UIColor colorWithWhite:.96 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark private method

#pragma mark Event
- (void)btnClick:(UIButton *)sender
{
    NSInteger index = sender.tag;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkBrandDetaill:)])
    {
        if (index < [self.modelList count])
        {
            HYMallBrandSecModel *data = self.modelList[index];
            [self.delegate checkBrandDetaill:data];
        }
    }
}

- (void)updateView
{
    //remove more tile
    NSInteger start = [self.modelList count];
    NSInteger max = [self.tileViews count];
    if (start < max)
    {
        for (; start<max; start++)
        {
            NSNumber *key = [NSNumber numberWithInteger:start];
            HYMallBrandCellBtn *tile = [self.tileViews objectForKey:key];
            [tile removeFromSuperview];
            [self.tileViews removeObjectForKey:key];
        }
    }
    
    //update
    NSInteger clu = 0;
    NSInteger row = 0;
    
    NSInteger index = 0;
    CGFloat width = (ScreenRect.size.width-10*4)/3;
    CGFloat height = width*3/4+20;
    for (HYMallBrandSecModel *data in self.modelList)
    {
        NSNumber *key = [NSNumber numberWithInteger:index];
        HYMallBrandCellBtn *tile = [self.tileViews objectForKey:key];
        if (!tile)
        {
            tile = [[HYMallBrandCellBtn alloc] initWithFrame:CGRectMake(0, 0, width
                                                                        , height)];
            [tile.clickBtn addTarget:self
                              action:@selector(btnClick:)
                    forControlEvents:UIControlEventTouchUpInside];
            tile.clickBtn.tag = index;
            [self.contentView addSubview:tile];
            
            [self.tileViews setObject:tile
                               forKey:key];
        }
        
        tile.frame = CGRectMake(10+clu*(width+10),
                                10+row*(height+10),
                                width,
                                height);
        [tile setData:data];
        
        clu++;
        
        if (!((index+1)%3))
        {
            row++;
            clu = 0;
        }
        
        index++;
    }
    
    _contentHeight =  (index+2)/3 * height;
}
#pragma mark setter & getter
- (NSMutableDictionary *)tileViews
{
    if (!_tileViews)
    {
        _tileViews = [[NSMutableDictionary alloc] init];
    }
    
    return _tileViews;
}

- (void)setModelList:(NSArray<HYMallBrandSecModel *> *)modelList
{
    if (modelList != _modelList)
    {
        _modelList = modelList;
        
        [self updateView];
    }
}
@end
