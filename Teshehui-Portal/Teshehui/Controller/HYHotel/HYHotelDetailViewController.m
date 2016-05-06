
//
//  HYHotelDetailViewController.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelDetailViewController.h"

#import "HYHotelDetailAddressCell.h"

#import "HYHotelPictureViewController.h"
#import "HYHotelInfoViewController.h"
#import "HYHotelReviewViewController.h"
#import "HYHotelFillOrderViewController.h"
#import "MWPhotoBrowser.h"

#import "HYHotelDetailReuqest.h"
#import "HYHotelDetailResponse.h"
#import "HYHotelRoomView.h"
#import "HYLoadHubView.h"
#import "NSDate+Addition.h"

#import "HYHotelMapViewController.h"
#import "HYHotelImageRequest.h"
#import "SKSTableView.h"
#import "HYHotelDetailRoomSubCell.h"
#import "HYUserInfo.h"
#import "HYAppDelegate.h"

//#import "HYHotelRoomTyoe.h"

@interface HYHotelDetailViewController ()
<MWPhotoBrowserDelegate,
SKSTableViewDelegate>
{
    HYHotelDetailReuqest *_hotelRequest;
//    HYHotelRoom *_room;
    BOOL _isLoading;
}

@property (nonatomic, strong) SKSTableView *tableView;
@property (nonatomic, strong) HYHotelInfoDetail *hotelInfoDetail;

@property (nonatomic,strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@property (nonatomic, strong) HYHotelImageRequest *imageRequest;
@property (nonatomic, strong) NSArray *pictureList;

@end

@implementation HYHotelDetailViewController

- (void)dealloc
{
    [HYLoadHubView dismiss];
    
    [_imageRequest cancel];
    _imageRequest = nil;
    
    [_hotelRequest cancel];
    _hotelRequest = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isLoading = NO;
    }
    return self;
}

- (void)loadView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.size.height -= 64.0;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor colorWithRed:237.0f/255.0f
                                           green:237.0f/255.0f
                                            blue:237.0f/255.0f
                                           alpha:1.0];
    self.view = view;
    
    //tableview
    SKSTableView *tableview = [[SKSTableView alloc] initWithFrame:frame
                                                          style:UITableViewStylePlain];
    tableview.SKSTableViewDelegate = self;
    tableview.shouldExpandOnlyOneCell = YES;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview.backgroundColor = [UIColor clearColor];
    tableview.backgroundView = nil;
    [self.view addSubview:tableview];
	self.tableView = tableview;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"hotel_detail", nil);
    
    [self loadHotelDetail];
    [self loadHotelImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
//加载酒店图片
- (void)loadHotelImage
{
    if (_imageRequest) {
        [_imageRequest cancel];
    }
    _imageRequest = [[HYHotelImageRequest alloc] init];
    _imageRequest.hotelId = self.hotleSummary.productId;
    __weak typeof(self) b_self = self;
    [_imageRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self loadHotelImageResult:result error:error];
    }];
}

- (void)loadHotelImageResult:(id)result error:(NSError *)error
{
    if ([result isKindOfClass:[HYHotelImageResponse class]])
    {
        self.pictureList = [(HYHotelImageResponse *)result imageList];
        [self.tableView reloadData];
    }
}


- (void)loadHotelDetail
{
    [HYLoadHubView show];
    
    if (_hotelRequest)
    {
        [_hotelRequest cancel];
        _hotelRequest = nil;
    }
    
    _hotelRequest = [[HYHotelDetailReuqest alloc] init];
//    _hotelRequest.hotelId = self.hotleSummary.productId;
     _hotelRequest.productId = self.hotleSummary.productId;
    _hotelRequest.startDate = self.checkInDate;
    _hotelRequest.endDate = self.checkOutDate;
    _isLoading = YES;
    self.tableView.userInteractionEnabled = NO;
    __weak typeof(self) b_self = self;
    [_hotelRequest sendReuqest:^(id result, NSError *error)
    {
        [b_self loadHotelDetailResult:result error:error];
    }];
}

- (void)loadHotelDetailResult:(id)result error:(NSError *)error
{
    [HYLoadHubView dismiss];
    if (!error && [result isKindOfClass:[HYHotelDetailResponse class]])
    {
        HYHotelDetailResponse *response = (HYHotelDetailResponse *)result;
        self.hotelInfoDetail = response.hotelDetail;
        [self.hotelInfoDetail setWithSummaryInfo:self.hotleSummary];
        [self.tableView reloadData];
    }
    _isLoading = NO;
    self.tableView.userInteractionEnabled = YES;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    DebugNSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}


#pragma mark - HYHotelDetailSummaryCellDelegate
- (void)checkHotelPictures
{
    if (self.pictureList.count == 0)
    {
        return;
    }
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
	NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    BOOL displayActionButton = YES;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = NO;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    
    for (HYHotelPictureInfo * p in self.pictureList)
    {
        if ([p.bigUrl length] > 0)
        {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p.bigUrl]]];
            [thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:p.midUrl]]];
        }
    }
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;
    browser.displayNavArrows = displayNavArrows;
    browser.displaySelectionButtons = displaySelectionButtons;
    browser.alwaysShowControls = displaySelectionButtons;
    browser.wantsFullScreenLayout = YES;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = enableGrid;
    browser.startOnGrid = startOnGrid;
    [browser setCurrentPhotoIndex:0];
    [self.navigationController pushViewController:browser animated:YES];
}

- (void)checkHotelRating
{
    HYHotelReviewViewController *vc = [[HYHotelReviewViewController alloc] init];
    vc.navbarTheme = self.navbarTheme;
    vc.hotelInfo = self.hotelInfoDetail;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - CQDateSettingViewControllerDelegate
- (void)didSelectCheckInDate:(NSString *)checkInDate
                 checkInWeek:(NSString *)checkInWeek
                CheckOutDate:(NSString *)checkOutDate
                checkOutWeek:(NSString *)checkOutWeek
{
    self.checkInDate = checkInDate;
    self.checkOutDate = checkOutDate;
    
    //重新加载数据
    [self loadHotelDetail];
}

#pragma mark - HYHotelDetailDateInfoCellDelegate
- (void)modifyDate
{
    HYDateSettingViewController *vc = [[HYDateSettingViewController alloc] init];
    vc.title = @"选择入住时间";
    vc.delegate = self;
    NSDate *checkIn = [NSDate dateFromString:self.checkInDate];
    NSDate *checkOut = [NSDate dateFromString:self.checkOutDate];
    vc.checkInDate = checkIn;
    vc.checkOutDate = checkOut;
    vc.navbarTheme = self.navbarTheme;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

#pragma mark - HYHotelRoomTypeCellDelegate
//进入预订界面
- (void)advanceBookingRoom:(HYHotelSKU *)room
{
    NSString *userid = [HYUserInfo getUserInfo].userId;
    if (userid)
    {
        if (room)
        {
            HYHotelFillOrderViewController *vc = [[HYHotelFillOrderViewController alloc] init];
            vc.roomInfo = room;
            vc.hotelInfo = self.hotelInfoDetail;
            vc.checkInDate = self.checkInDate;
            vc.checkOutDate = self.checkOutDate;
            vc.isPrePay = room.isPrePay;
            vc.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
    }
    else
    {
        HYAppDelegate *appDelegate = (HYAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loadLoginView];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && indexPath.row > 0)
    {
        NSInteger index = (indexPath.row-1);
        if (index < [self.hotelInfoDetail.roomItems count])
        {
            NSArray *roomList = self.hotelInfoDetail.roomItems[index];
            return roomList.count;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    HYHotelDetailRoomSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"subCell"];
    if (!cell)
    {
        cell = [[HYHotelDetailRoomSubCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:@"subCell"];
    }
    NSInteger section = [indexPath indexAtPosition:0];
    NSInteger row = [indexPath indexAtPosition:1];
    if (section == 2 && row > 0)
    {
        NSInteger index = row - 1;
        if (index < [self.hotelInfoDetail.roomItems count])
        {
            NSArray *roomList = self.hotelInfoDetail.roomItems[index];
            
            NSInteger subRow = indexPath.subrow - 1;
            //if (subRow >= 0 && subRow < roomList.count)
            {
                HYHotelSKU *room = roomList[subRow];
                
                cell.plan = room;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 1;
    switch (section)
    {
        case 1:
            count = 2;
            break;
        case 2:
            count = [self.hotelInfoDetail.roomItems count]+1;
            break;
        default:
            break;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 44.0f;
    switch (indexPath.section)
    {
        case 0:
            height = 125.0f;
            break;
        case 1:
            height = 44.0f;
            break;
        case 2:
            if (indexPath.row > 0)
            {
                height = 85;
            }
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 10.0f;
    
    if (section == 0 || section == 1)
    {
        height = 0;
    }
    
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 10)];
    v.image = [[UIImage imageNamed:@"ticket_bg_gray_g5"] stretchableImageWithLeftCapWidth:2
                                                                             topCapHeight:4];
    
    return v;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
    if(indexPath.row == totalRow -1){
        //this is the last row in section.
        HYBaseLineCell *lineCell = (HYBaseLineCell *)cell;
        if ([lineCell isKindOfClass:[HYBaseLineCell class]])
        {
            lineCell.separatorLeftInset = 0.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        //酒店概览
        //点击可查看酒店点评
        case 0:
        {
            static NSString *hotelSummaryCell = @"hotelSummaryCell";
            HYHotelDetailSummaryCell *summaryCell = [tableView dequeueReusableCellWithIdentifier:hotelSummaryCell];
            if (!summaryCell)
            {
                summaryCell = [[HYHotelDetailSummaryCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                             reuseIdentifier:hotelSummaryCell];
                summaryCell.selectionStyle = UITableViewCellSelectionStyleGray;
                summaryCell.delegate = self;
            }
            
            [summaryCell setHotelInfo:self.hotelInfoDetail];
            summaryCell.picList = self.pictureList;
            
            cell = summaryCell;
        }
            break;
        
        //地址，信息
        case 1:
        {
            static NSString *hotelAddressCell = @"hotelAddressCell";
            HYHotelDetailAddressCell *addCell = [tableView dequeueReusableCellWithIdentifier:hotelAddressCell];
            if (!addCell)
            {
                addCell = [[HYHotelDetailAddressCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                      reuseIdentifier:hotelAddressCell];
                
            }
            
            if (indexPath.row == 0)
            {
                addCell.textLabel.numberOfLines = 0;
                addCell.textLabel.text = self.hotelInfoDetail.address;
                addCell.detailTextLabel.text = @"查看地图";
                addCell.accessaryView.image = [UIImage imageNamed:@"ico_arrow_list"];
                addCell.selectionStyle = UITableViewCellSelectionStyleGray;
                addCell.iconView.image = [UIImage imageNamed:@"icon_hotel_address"];
            }
            else
            {
                if ([self.hotelInfoDetail.establishmentTime length] > 0)
                {
                    addCell.textLabel.text = [NSString stringWithFormat:@"%@开业", self.hotelInfoDetail.establishmentTime];
                }
                else
                {
                    addCell.textLabel.text = @"酒店详情";
                }
                addCell.detailTextLabel.text = @"查看详情";
                addCell.iconView.image = [UIImage imageNamed:@"icon_hotel"];
                addCell.selectionStyle = UITableViewCellSelectionStyleGray;
                addCell.accessaryView.image = [UIImage imageNamed:@"ico_arrow_list"];
            }
            
            cell = addCell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0)  // 日期
            {
                static NSString *hotelDateInfoCell = @"hotelDateInfoCell";
                HYHotelDetailDateInfoCell *dateCell = [tableView dequeueReusableCellWithIdentifier:hotelDateInfoCell];
                if (!dateCell)
                {
                    dateCell = [[HYHotelDetailDateInfoCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:hotelDateInfoCell];
                    dateCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    dateCell.delegate = self;
                }
                
                dateCell.checkInDate = self.checkInDate;
                dateCell.checkOutDate = self.checkOutDate;
                
                cell = dateCell;
            }
            else    //酒店房型
            {
                static NSString *hotelRoomTypeCell = @"hotelRoomTypeCell";
                HYHotelRoomTypeCell *roomCell = [tableView dequeueReusableCellWithIdentifier:hotelRoomTypeCell];
                if (!roomCell)
                {
                    roomCell = [[HYHotelRoomTypeCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:hotelRoomTypeCell];
                    roomCell.selectionStyle = UITableViewCellSelectionStyleGray;
                    roomCell.delegate = self;
                }
                
                NSInteger index = (indexPath.row-1);
                if (index < [self.hotelInfoDetail.roomItems count])
                {
                    NSArray *roomList = self.hotelInfoDetail.roomItems[index];
                    for (HYHotelSKU *SKU in roomList)
                    {
                        [roomCell setRoomInfo:SKU];
                    }
                    roomCell.isExpandable = roomList.count > 0 ? YES : NO;
                  
                }
                
                cell = roomCell;
            }
        }
            break;
        default:
            DebugNSLog(@"cell is nil!!! indexpath:%ld.%ld", (long)indexPath.section, (long)indexPath.row);
            break;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1)
    {
        if (indexPath.row == 1) //查看酒店信息
        {
            HYHotelInfoViewController *vc = [[HYHotelInfoViewController alloc] init];
            vc.hotelInfo = self.hotelInfoDetail;
            vc.navbarTheme = self.navbarTheme;
            [self.navigationController pushViewController:vc
                                                 animated:YES];
        }
        else if (indexPath.row == 0) //点击查看地图
        {
            if (self.hotelInfoDetail)
            {
                HYHotelMapViewController *mapV = [[HYHotelMapViewController alloc] init];
                //mapV.hotelInfo = self.hotelInfoDetail;
                mapV.showAroundShops = YES;
                CLLocationCoordinate2D location = CLLocationCoordinate2DMake(_hotelInfoDetail.latitude, _hotelInfoDetail.longitude);
                mapV.location = location;
                mapV.annotationTitle = _hotelInfoDetail.productName;
                mapV.navbarTheme = self.navbarTheme;
                mapV.coorType = HYCoorGeneral;
                [self.navigationController pushViewController:mapV animated:YES];
            }
        }
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row <= 0)
        {
            [self modifyDate];
        }
        else if (indexPath.subrow != 0 && !_isLoading)
        {
            NSInteger row = [indexPath indexAtPosition:1];
            NSInteger index = row - 1;

            if (index < [self.hotelInfoDetail.roomItems count])
            {
                NSArray *roomList = self.hotelInfoDetail.roomItems[index];
                
                NSInteger subRow = indexPath.subrow-1;
                HYHotelSKU *room = roomList[subRow];
                room.selectIndex = subRow;
                    
                HYHotelRoomView *roomView = [[HYHotelRoomView alloc] initWithRoomInfo:room];
                roomView.delegate = self;
                [roomView showWithAnimation:YES];
            }
        }
    }
}

- (void)tableView:(SKSTableView *)tableView didExpandRowAtIndexPath:(NSIndexPath *)indexPath originalIndexPath:(NSIndexPath *)oriPath
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
//    {
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oriPath];
//        CGRect rect = CGRectMake(0, CGRectGetMaxY(cell.frame), 320, CGRectGetHeight(cell.frame));
//        [tableView scrollRectToVisible:rect animated:YES];
//    });
    
    if (indexPath.section == 2 && indexPath.row > 0)
    {
        @try
        {
            [tableView scrollToRowAtIndexPath:indexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
        }
        @catch (NSException *exception) {
            DebugNSLog(@"error: %@", exception.description);
        }
    }
}

@end
