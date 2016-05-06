//
//  HYHotelInfoViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-15.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HYHotelInfoViewController.h"
#import "HYHotelInfoCell.h"
#import "HYHotelInfoSwitchCell.h"
#import "HYHotelTrafficCell.h"
#import "HYHotelTraffic.h"
#import "HYHotelInfoBriefCell.h"
#import "HYHotelInfoSummaryCell.h"

@interface HYHotelInfoViewController ()
<HYHotelInfoSwitchCellDelegate>
{
    BOOL _hotelIntroduction;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *descArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation HYHotelInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _hotelIntroduction = NO;
    }
    return self;
}

- (void)loadView
{
    self.title = NSLocalizedString(@"hotel_info", nil);
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    tableview.sectionHeaderHeight = 0;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initDescrptionInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if (!self.view.window)
    {
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        self.view = nil;
    }
}

#pragma mark - private methods
- (void)initDescrptionInfo
{
    if (!_descArray)
    {
        _descArray = [[NSMutableArray alloc] init];
    }
    
    if (!_titleArray)
    {
        _titleArray = [[NSMutableArray alloc] init];
    }
    
    if ([self.hotelInfo.generalAmenities length] > 0)
    {
        [_descArray addObject:self.hotelInfo.generalAmenities];
        [_titleArray addObject:@"酒店基础服务设施"];
    }
    
    if ([self.hotelInfo.roomAmenities length] > 0)
    {
        [_descArray addObject:self.hotelInfo.roomAmenities];
        [_titleArray addObject:@"酒店房间设施"];
    }
    
    if ([self.hotelInfo.recreationAmenities length] > 0)
    {
        [_descArray addObject:self.hotelInfo.recreationAmenities];
        [_titleArray addObject:@"酒店休闲娱乐设施"];
    }
    
    if ([self.hotelInfo.otherAmenities length] > 0)
    {
        [_descArray addObject:self.hotelInfo.otherAmenities];
        [_titleArray addObject:@"酒店其他设施"];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.descArray count]+1;
    if (section == 1)
    {
        count = 2;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            height = 64;
        }
        if (indexPath.row >= 1)
        {
            NSString *str = [self.descArray objectAtIndex:(indexPath.row-1)];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:13]
                          constrainedToSize:CGSizeMake(CGRectGetWidth(self.view.frame)-40, MAXFLOAT)
                              lineBreakMode:NSLineBreakByCharWrapping];
            size.height += 40;
            height = (height>size.height) ? (height+12) : size.height;
        }
    }
    else
    {
        if (indexPath.row >= 1)
        {
            CGFloat maxwidth = [UIScreen mainScreen].bounds.size.width - 40;
            NSString *desc = _hotelIntroduction ? self.hotelInfo.hotelDescriptionEscaped: self.hotelInfo.trafficEscaped;
            
            CGSize size = [desc sizeWithFont:[UIFont systemFontOfSize:15]
                           constrainedToSize:CGSizeMake(maxwidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
            
            size.height += 14;
            height = (height>size.height) ? height : size.height;
        }
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.view.frame),10)];
    tempView.backgroundColor=[UIColor clearColor];
    return tempView;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if((indexPath.row==totalRow-1) || indexPath.section == 1)
    {
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *baseCellId = @"baseCellId";
            HYHotelInfoSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:baseCellId];
            
            if (!cell)
            {
                cell = [[HYHotelInfoSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:baseCellId];
            }
            cell.hotelInfo = self.hotelInfo;
            
            return cell;
        }
        else
        {
            static NSString *infoCellId = @"infoCellId";
            HYHotelInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellId];
            if (cell == nil)
            {
                cell = [[HYHotelInfoCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                             reuseIdentifier:infoCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundView = nil;
            }
            
            switch (indexPath.row)
            {
                case 1:
                    cell.imageView.image = [UIImage imageNamed:@"hotel_detail_base_service"];
                    cell.textLabel.text = [self.titleArray objectAtIndex:0];
                    cell.detailTextLabel.text = [self.descArray objectAtIndex:0];
                    break;
                case 2:
                    cell.imageView.image = [UIImage imageNamed:@"hotel_detail_room_serviec"];
                    cell.textLabel.text = [self.titleArray objectAtIndex:1];
                    cell.detailTextLabel.text = [self.descArray objectAtIndex:1];
                    break;
                case 3:
                    cell.imageView.image = [UIImage imageNamed:@"hotel_detail_room_play"];
                    cell.textLabel.text = [self.titleArray objectAtIndex:2];
                    cell.detailTextLabel.text = [self.descArray objectAtIndex:2];
                    break;
                case 4:
                    cell.imageView.image = [UIImage imageNamed:@"hotel_detail_room_other"];
                    cell.textLabel.text = [self.titleArray objectAtIndex:3];
                    cell.detailTextLabel.text = [self.descArray objectAtIndex:3];
                    break;
                default:
                    break;
            }
            
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            static NSString *settingCellId = @"settingCellId";
            HYHotelInfoSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:settingCellId];
            if (cell == nil)
            {
                cell = [[HYHotelInfoSwitchCell alloc]initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:settingCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.delegate = self;
            }
            return cell;
        }
        else
        {
            static NSString *BriefCellId = @"BriefCellId";
            HYHotelInfoBriefCell *cell = [tableView dequeueReusableCellWithIdentifier:BriefCellId];
            if (cell == nil)
            {
                cell = [[HYHotelInfoBriefCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:BriefCellId];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.brief = _hotelIntroduction ? self.hotelInfo.hotelDescriptionEscaped:self.hotelInfo.trafficEscaped;
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -HYHotelInfoSwitchCellDelegate
- (void)swithShowInfo:(BOOL)traffic
{
    _hotelIntroduction = !traffic;
    [self.tableView reloadData];
}
@end
