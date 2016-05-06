//
//  HYSelectContactCell.m
//  Teshehui
//
//  Created by HYZB on 15/1/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYSelectContactCell.h"

@interface HYSelectContactCell ()

@end

@implementation HYSelectContactCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10, 14, 300, 16);
}

#pragma mark setter/getter
- (void)setPerson:(HYPerson *)person
{
    if (person != _person)
    {
        _person = person;
        self.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", person.name, person.mobile];
    }
}

@end
