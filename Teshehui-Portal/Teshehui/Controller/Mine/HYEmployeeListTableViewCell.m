//
//  HYEmployeeListTableViewCell.m
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYEmployeeListTableViewCell.h"

@implementation HYEmployeeListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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

#pragma mark setter/getter
- (void)setEmployee:(HYEmployee *)employee
{
    if (_employee != employee)
    {
        _employee = employee;
        self.textLabel.text = _employee.real_name;
    }
}

@end
