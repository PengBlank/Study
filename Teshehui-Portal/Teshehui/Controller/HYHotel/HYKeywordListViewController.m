//
//  HYKeywordListViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYKeywordListViewController.h"
#import "HYHotelDistrictInfo.h"
#import "HYHotelCommercialInfo.h"
#import "HYHotelDistance.h"
#import "HYHotelMainViewController.h"
#import "HYBaseLineCell.h"

@interface HYKeywordListViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSoucre;

@end

@implementation HYKeywordListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
    
    //tableview
    UITableView *tableview = [[UITableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
	tableview.delegate = self;
	tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //line
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1.0)];
    lineView.image = [[UIImage imageNamed:@"line_cell_bottom"] stretchableImageWithLeftCapWidth:2
                                                                                   topCapHeight:0];
    tableview.tableHeaderView = lineView;
    
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //初始化数据
    [self initViewTitle];
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
- (void)initViewTitle
{
//    switch (self.condType)
//    {
//        case Business_Area:  //商业区
//        {
//            self.title = NSLocalizedString(@"business_areas", nil);
//        }
//            break;
//        case Administrative_Area:  //行政区
//        {
//            self.title = NSLocalizedString(@"administrative_area", nil);
//        }
//            break;
//        case Distance:  //距离
//        {
//            self.title = NSLocalizedString(@"distance", nil);
//        }
//            break;
//        case Service:  //配套服务
//        {
//            self.title = NSLocalizedString(@"service", nil);
//        }
//            break;
//        default:
//            break;
//    }
//    
//    self.dataSoucre = [self.condition getSubConditionListWithType:self.condType];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSoucre count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        lineCell.separatorLeftInset = 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *searchnearID = @"searchnearID";
    HYBaseLineCell *cell = [tableView dequeueReusableCellWithIdentifier:searchnearID];
    if (cell == nil)
    {
        cell = [[HYBaseLineCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:searchnearID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    
    if (indexPath.row < [self.dataSoucre count])
    {
        id obj = [self.dataSoucre objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[NSString class]])
        {
            NSString *string = (NSString *)obj;
            cell.textLabel.text = string;
        }
        else if ([obj isKindOfClass:[HYHotelDistrictInfo class]])
        {
            HYHotelDistrictInfo *h = (HYHotelDistrictInfo *)obj;
            cell.textLabel.text = h.name;
        }
        else if ([obj isKindOfClass:[HYHotelCommercialInfo class]])
        {
            HYHotelCommercialInfo *h = (HYHotelCommercialInfo *)obj;
            cell.textLabel.text = h.name;
        }
        else if ([obj isKindOfClass:[HYHotelDistance class]])
        {
            HYHotelDistance *d = (HYHotelDistance *)obj;
            cell.textLabel.text = d.distanceDesc;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //id obj = [self.dataSoucre objectAtIndex:indexPath.row];
    
//    BOOL popHotelSearchView = YES;
//    switch (self.condType)
//    {
//        case Business_Area:
//        {
//            if ([obj isKindOfClass:[HYHotelLocalDowntown class]])
//            {
//                HYHotelLocalDowntown *h = (HYHotelLocalDowntown *)obj;
//                CTypeInfo t = self.condition.cLocationInfo;
//                t.type = Administrative_Area;
//                t.index = indexPath.row;
//                self.condition.cLocationInfo = t;
//                self.condition.Zone = h.downtownId;
//                self.condition.Location = nil;
//                self.condition.showKeyword = h.name;
//            }
//        }
//            break;
//        case Administrative_Area:
//        {
//            if ([obj isKindOfClass:[HYHotelLocalDistrict class]])
//            {
//                HYHotelLocalDistrict *h = (HYHotelLocalDistrict *)obj;
//                CTypeInfo t = self.condition.cLocationInfo;
//                t.type = Business_Area;
//                t.index = indexPath.row;
//                self.condition.cLocationInfo = t;
//                self.condition.Zone = nil;
//                self.condition.Location = h.districtId;
//                self.condition.showKeyword = h.name;
//            }
//        }
//            break;
//        case Distance:
//        {
//            popHotelSearchView = NO;
//            if ([obj isKindOfClass:[HYHotelDistance class]])
//            {
//                HYHotelDistance *d = (HYHotelDistance *)obj;
//                self.condition.distance = d.distanceDesc;
//                self.condition.Radius = d.distance;
//            }
//        }
//            break;
//        case Service:
//            popHotelSearchView = NO;
//            
//            if (indexPath.row == 0)
//            {
//                self.condition.service = nil;
//            }
//            else if (indexPath.row == 1)
//            {
//                self.condition.service = @"BroadNet";
//            }
//            else if (indexPath.row == 2)
//            {
//                self.condition.service = @"Parking";
//            }
//            break;
//        default:
//            break;
//    }
    
//    if (popHotelSearchView)
//    {
//        NSArray *vcArray = [self.navigationController viewControllers];
//        
//        UIViewController *v = nil;
//        for (UIViewController *vc in vcArray)
//        {
//            if ([vc isKindOfClass:[HYHotelMainViewController class]])
//            {
//                v = vc;
//                break;
//            }
//        }
//        
//        if (v)
//        {
//            [self.navigationController popToViewController:v animated:YES];
//        }
//    }
//    else
//    {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

@end
