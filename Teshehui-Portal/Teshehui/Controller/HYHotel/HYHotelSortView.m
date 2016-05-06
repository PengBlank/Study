//
//  HYHotelSortView.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/22.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYHotelSortView.h"

@implementation HYHotelSortView
{
    UITableView *_tableView;
}
@synthesize delegate = _delegate;

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        _tableView = [[UITableView alloc]
                      initWithFrame:CGRectMake(0, 0, size.width, size.height)
                      style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:_tableView];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor grayColor];
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"默认排序";
            break;
        case 1:
            cell.textLabel.text = @"价格升序";
            break;
        case 2:
            cell.textLabel.text = @"价格降序";
            break;;
        case 3:
            cell.textLabel.text = @"名称排序";
            break;
        default:
            break;
    }
    
    if (indexPath.row == _selectedIdx)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:77/255.0 green:208/255.0 blue:246/255.0 alpha:1];
    }
    else
    {
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIdx = indexPath.row;
    if (self.delegate && [_delegate respondsToSelector:@selector(hotelSortViewDidSelectIndex:)])
    {
        [_delegate hotelSortViewDidSelectIndex:_selectedIdx];
    }
    [_tableView reloadData];
    [self dismissWithAnimation:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
