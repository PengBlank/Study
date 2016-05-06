//
//  HYHotelOrderCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelFillOrderCell.h"
#import "HYPassengers.h"

@implementation HYHotelFillOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        _roomCount = 1;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        CGRect rect = CGRectMake(100, 12, CGRectGetWidth(self.frame)-120, 20);
        UITextField *_textField = [[UITextField alloc] initWithFrame:rect];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.tag = 1;
        _textField.delegate = self;
        _textField.placeholder = NSLocalizedString(@"hotel_placeholder1", nil);
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.textLabel.frame;
    frame.origin.x = 10;
    self.textLabel.frame = frame;
}

- (NSString *)fillInfo
{
    NSArray *tfs = [self.contentView subviews];
    
    NSMutableArray *users = [[NSMutableArray alloc] init];
    for (UIView *v in tfs)
    {
        if ([v isKindOfClass:[UITextField class]])
        {
            NSString *name = [(UITextField *)v text];
            if ([name length] > 0)
            {
                [users addObject:name];
            }
            else  //如果有没有填写完整的，无法预订成功
            {
                return nil;
            }
        }
    }
    
    NSString *fillInfo = nil;
    if ([users count] > 0)
    {
        fillInfo = [users componentsJoinedByString:@"|"];  //老版本为"," 新版修改为"｜"
    }
    return fillInfo;
}

- (void)setRoomCount:(NSInteger)roomCount
{
    if (roomCount < _roomCount)
    {
        _roomCount = roomCount;
        NSArray *tfs = [self.contentView subviews];
        
        for (UIView *v in tfs)
        {
            if ([v isKindOfClass:[UITextField class]] && v.tag > roomCount)
            {
                [v removeFromSuperview];
            }
        }
    }
    else if (roomCount > _roomCount)
    {
        CGFloat org_y = 12+_roomCount*32;
        for (NSInteger i=_roomCount; i<roomCount; i++)
        {
            NSInteger tag = i+1;
            
            CGRect rect = CGRectMake(100, org_y, CGRectGetWidth(self.frame)-120, 20);
            UITextField *tf = [[UITextField alloc] initWithFrame:rect];
            tf.returnKeyType = UIReturnKeyDone;
            tf.tag = tag;
            tf.clearButtonMode = UITextFieldViewModeWhileEditing;
            tf.font = [UIFont systemFontOfSize:15];
            tf.delegate = self;
            if (i < [self.guests count])
            {
                HYPassengers *p = [self.guests objectAtIndex:i];
                tf.text = p.name;
            }
            else
            {
                tf.placeholder = NSLocalizedString(@"hotel_placeholder1", nil);
            }
            
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [self.contentView addSubview:tf];
            org_y += 32;
        }
        
        _roomCount = roomCount;
    }
}

- (void)setGuests:(NSArray *)guests
{
    if (guests != _guests)
    {
        _guests = guests;
        
        NSArray *tfs = [self.contentView subviews];
        
        NSInteger index = 0;
        for (UIView *v in tfs)
        {
            if ([v isKindOfClass:[UITextField class]])
            {
                UITextField *tf = (UITextField *)v;

                if (index < [self.guests count])
                {
                    HYPassengers *p = [_guests objectAtIndex:index];
                    tf.text = p.name;
                }
                else
                {
                    tf.text = nil;
                    tf.placeholder = NSLocalizedString(@"hotel_placeholder1", nil);
                }
                index++;
            }
        }
    }
}

- (void)fieldResignFirstResponder
{
    [_tempFeild resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    _tempFeild = textField;
    if ([self.delegate respondsToSelector:@selector(didSelectHotelPassenger)])
    {
        [self.delegate didSelectHotelPassenger];
    }
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
