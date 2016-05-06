//
//  HYFolwerSerAdressViewController.m
//  Teshehui
//
//  Created by ichina on 14-3-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFlowerSetAddressViewController.h"
#import "HYInputCell.h"
#import "HYFlowerAddressPick.h"
#import "NSString+Addition.h"
#import "HYFlowerCityInfo.h"
#import "HYHotelFillUserInfoCell.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HYFlowerSetAddressViewController ()
<
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
ABPeoplePickerNavigationControllerDelegate,
HYFlowerAddressDelegate,
HYHotelFillUserInfoCellDelegate
>
{
    HYFlowerCityInfo *_proInfo;
    HYFlowerCityInfo *_cityInfo;
    HYFlowerCityInfo *_areaInfo;
}
@property(nonatomic, strong) UITableView *tableview;
@property(nonatomic, strong) HYFlowerAddressPick *pickerView;

@property (nonatomic, copy) NSString *contact;
@property (nonatomic, copy) NSString *phone;

@end

@implementation HYFlowerSetAddressViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"填写收货地址";
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                              0,
                                                              self.view.frame.size.width,
                                                              self.view.frame.size.height-64)];
    _tableview.scrollEnabled = NO;
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.backgroundView = nil;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableview];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 100)];
    UIButton * nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = TFRectMake(80,40, 160, 40);
    UIImage *image = [[UIImage imageNamed:@"flower_bg_title_bar_88"] stretchableImageWithLeftCapWidth:2
                                                                                         topCapHeight:10];
    [nextBtn setBackgroundImage:image forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont boldSystemFontOfSize:19.0f];
    [nextBtn addTarget:self
                action:@selector(setAdress:)
      forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextBtn];
    _tableview.tableFooterView = footerView;

    _pickerView = [[HYFlowerAddressPick alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 260)];
    _pickerView.delegate = self;
    _pickerView.title = @"选择配送区域";
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44.0f;
    }
    else
    {
        return 88.0f;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *addressCellId = @"addressCellId";
        HYInputCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellId];
        if (cell == nil)
        {
            cell = [[HYInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellId];
            cell.nameLab.frame = CGRectMake(10, 0,80, 50);
            cell.nameLab.font = [UIFont systemFontOfSize:16.0f];
            cell.nameLab.textColor = [UIColor darkGrayColor];
            cell.textField.frame = CGRectMake(100, 0,200, 50);
            cell.textField.font = [UIFont systemFontOfSize:16.0f];
            cell.textLab.frame = CGRectMake(100, 0,200, 50);
            cell.textLab.font = [UIFont systemFontOfSize:16.0f];
            cell.textField.tag = indexPath.row+1;
            cell.textField.delegate = self;
            cell.textField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        }
        switch (indexPath.row) {
            case 0:
            {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.textField.frame = CGRectMake(100, 0,180, 50);
                cell.nameLab.text = @"配送区域";
                cell.textField.placeholder = @"请选择配送区域";
                cell.textField.enabled = NO;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            }
            case 1:
            {
                cell.nameLab.text = @"详细地址";
                cell.textField.placeholder = @"请输入详细地址";
                cell.textField.returnKeyType = UIReturnKeyNext;
                break;
            }
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        static NSString *fillUserCellId = @"fillUserCellId";
        HYHotelFillUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:fillUserCellId];
        if (cell == nil)
        {
            cell = [[HYHotelFillUserInfoCell alloc]initWithStyle:UITableViewCellStyleValue1
                                                 reuseIdentifier:fillUserCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        cell.nameField.text = self.contact;
        cell.phoneField.text = self.phone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0 && indexPath.row == 0)
    {
        [_pickerView showWithAnimation:YES];
        [self.view endEditing:YES];
        [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

-(void)setAdress:(UIButton*)sender
{
    UITextField* t2 = (UITextField*)[self.view viewWithTag:2];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    HYHotelFillUserInfoCell *cell = (HYHotelFillUserInfoCell *)[self.tableview cellForRowAtIndexPath:indexPath];
    self.contact = cell.nameField.text;
    self.phone = cell.phoneField.text;
    
    [cell.phoneField resignFirstResponder];
    
    BOOL isok = YES;
    NSString* str;
    if (_proInfo == nil) {
        str = @"请设置配送区域";
        isok = NO;
    }else if (t2.text.length == 0){
        str = @"请完善收货地址";
        isok = NO;
    }else if (self.contact.length == 0){
        str = @"请完善收货人";
        isok = NO;
    }else if (![self.phone checkPhoneNumberValid]){
        str = @"请输入正确的电话号码";
        isok = NO;
    }else{
        isok = YES;
    }
    if (isok)
    {
        HYFlowerAddressInfo *address = [[HYFlowerAddressInfo alloc] init];
        address.province = _proInfo;
        address.city = _cityInfo;
        address.area = _areaInfo;
        address.detaillInfo = t2.text;
        address.userName = self.contact;
        address.mobile = self.phone;
        
        [self.delegate didSelectAdressInfo:address];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:str
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint size = CGPointZero;
    switch (textField.tag) {
        case 2:
        {
            size = CGPointMake(0, 0);
            break;
        }
        case 3:
        {
            size = CGPointMake(0,20);
            break;
        }
        case 4:
        {
            size = CGPointMake(0,100);
            break;
        }
        default:
            break;
    }
    [_tableview setContentOffset:size animated:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField* t3 = (UITextField*)[self.view viewWithTag:3];
    UITextField* t4 = (UITextField*)[self.view viewWithTag:4];
    if (textField.tag == 2)
    {
        [t3 becomeFirstResponder];
    }
    else if (textField.tag == 3)
    {
        [t4 becomeFirstResponder];
    }else
    {
        [_tableview setContentOffset:CGPointMake(0, 0) animated:YES];
        [t4 resignFirstResponder];
    }
    return YES;
}

- (void)selectComplete:(HYFlowerAddressPick *)pickerView
{
    _proInfo = pickerView.proInfo;
    _cityInfo = pickerView.cityInfo;
    _areaInfo = pickerView.areaInfo;
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    HYInputCell* cell = (HYInputCell*)[_tableview cellForRowAtIndexPath:indexpath];
    cell.textLab.hidden = NO;
    cell.textField.hidden = YES;
    cell.textLab.text = [NSString stringWithFormat:@"%@%@%@",(_proInfo !=nil)?_proInfo.name:@"",(_cityInfo != nil)?_cityInfo.name:@"",(_areaInfo !=nil)?_areaInfo.name:@""];
}

-(void)dealloc
{
    [_pickerView dismissWithAnimation:YES];
}

#pragma mark - HYHotelFillUserInfoCellDelegate
- (void)displayAllContacts
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    
    picker.peoplePickerDelegate = self;
	// Display only a person's phone, email, and birthdate
	NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty], nil];
	picker.displayedProperties = displayedItems;
	// Show the picker
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)didNameInputComplete:(UITableViewCell *)cell;
{
    if ([cell isKindOfClass:[HYHotelFillUserInfoCell class]])
    {
        HYHotelFillUserInfoCell *userCell = (HYHotelFillUserInfoCell *)cell;
        self.contact = userCell.nameField.text;
        self.phone = userCell.phoneField.text;
    }
}

- (void)cellBecomeFirstResponder:(UITableViewCell *)cell
{
    [self.tableview scrollRectToVisible:cell.frame animated:YES];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Called after a person has been selected by the user. only ios8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker
                         didSelectPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    CFStringRef chineseName = ABRecordCopyCompositeName(person);
    
    if ([(__bridge NSString *)chineseName length] > 0)
    {
        self.contact = (__bridge NSString *)chineseName;
    }
    else
    {
        ABMultiValueRef orgName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        if ([(__bridge NSString *)orgName length] > 0)
        {
            self.contact = (__bridge NSString *)orgName;
        }
        
        if (orgName)
            CFRelease(orgName);
    }
    
    if (chineseName)
    {
        CFRelease(chineseName);
    }
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phone = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    }
    
    if (values)
        CFRelease(values);
    if (phoneMulti)
        CFRelease(phoneMulti);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([self.tableview cellForRowAtIndexPath:indexPath])
    {
        [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
    
    CFStringRef chineseName = ABRecordCopyCompositeName(person);
    
    if ([(__bridge NSString *)chineseName length] > 0)
    {
        self.contact = (__bridge NSString *)chineseName;
    }
    else
    {
        ABMultiValueRef orgName = ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        if ([(__bridge NSString *)orgName length] > 0)
        {
            self.contact = (__bridge NSString *)orgName;
        }
        
        if (orgName)
            CFRelease(orgName);
    }
    
    if (chineseName)
    {
        CFRelease(chineseName);
    }
    
    //phones
    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    CFArrayRef values = ABMultiValueCopyArrayOfAllValues(phoneMulti);
    
    if ([(__bridge NSArray*)values count] > 0)
    {
        NSString *number = [(__bridge NSArray*)values objectAtIndex:0];
        NSCharacterSet *set = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        self.phone = [[number componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    }
    
    if (values)
        CFRelease(values);
    if (phoneMulti)
        CFRelease(phoneMulti);
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    if ([self.tableview cellForRowAtIndexPath:indexPath])
    {
        [self.tableview reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
    
	return NO;
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
	[self.navigationController dismissViewControllerAnimated:YES
                                                  completion:NULL];
}
@end
