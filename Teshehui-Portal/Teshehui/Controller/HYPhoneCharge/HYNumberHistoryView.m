//
//  HYNumberHistoryView.m
//  Teshehui
//
//  Created by 成才 向 on 16/2/29.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYNumberHistoryView.h"

@interface HYNumberHistoryView ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@end

@implementation HYNumberHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
//        self.backgroundColor = [UIColor redColor];
        UITableView *table = [[UITableView alloc] initWithFrame:frame];
        table.dataSource = self;
        table.delegate = self;
        table.rowHeight = 35;
        table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        table.backgroundColor = [UIColor clearColor];
        [self addSubview:table];
        self.table = table;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.table.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.table.frame = self.bounds;
}

#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(self.phoneInfos.count, 5) + _showClear;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
        
    }
    if (indexPath.row < self.phoneInfos.count)
    {
        NSDictionary *info = [self.phoneInfos objectAtIndex:indexPath.row];
        cell.textLabel.text = [info objectForKey:@"phone"];
        if ([info objectForKey:@"name"]) {
            cell.detailTextLabel.text = [info objectForKey:@"name"];
        }
        else {
            cell.detailTextLabel.text = info[@"info"];
        }
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clear"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clear"];
            
        }
        cell.textLabel.text = @"清除历史记录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.phoneInfos.count) {
        NSDictionary *info = [self.phoneInfos objectAtIndex:indexPath.row];
        if (self.didSelectInfo) {
            self.didSelectInfo(info);
        }
    }
    else
    {
        if (self.didClear)
        {
            self.didClear();
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
