//
//  PTAppStoreHelper.m
//  Putao
//
//  Created by ChengQian on 12-10-13.
//  Copyright (c) 2012年 so.putao. All rights reserved.
//

#import "PTAppStoreHelper.h"
#import "HYLoadHubView.h"
#import "HYGetUpdateInfoRequest.h"
#import "HYAppDelegate.h"

// Add josnkit
#import "JSONKit_HY.h"


static PTAppStoreHelper *defaultAppStorehelper = nil;

@interface PTAppStoreHelper ()
{
    HYGetUpdateInfoRequest *_request;
    NSURLConnection* _conn;
}

@property (nonatomic, retain) NSMutableData *returnData;
@property (nonatomic, copy) NSString *trackViewUrl;

@end

@implementation PTAppStoreHelper

@synthesize returnData = _returnData;
@synthesize trackViewUrl = _trackViewUrl;

+ (PTAppStoreHelper *)defaultAppStoreHelper
{
    @synchronized(self)
    {
        if (!defaultAppStorehelper) {
            // Create the singleton
            defaultAppStorehelper = [[super allocWithZone:NULL] init];
        }
    }
    
    return defaultAppStorehelper;
}

- (id)init
{
    if (defaultAppStorehelper) {
        // Return the old one
        return defaultAppStorehelper;
    }
    
    self = [super init];
    
    return self;
}

- (void)updateInfoResult:(NSString *)version force:(BOOL)force
{
    NSString *appVersion =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    BOOL newVersion = [version caseInsensitiveCompare:appVersion] == NSOrderedDescending;
    if (newVersion)
    {
        _forceUpdate = force;
        [self checkNewVersionNeedAlert:YES];
    }
}

#pragma mark pubilc methods
- (void)checkForceupdate
{
    _request = [[HYGetUpdateInfoRequest alloc] init];
    
    __weak typeof(self) bself = self;
    [_request sendReuqest:^(id result, NSError *error) {
        if (!error && [result isKindOfClass:[HYGetUpdateInfoResponse class]])
        {
            HYGetUpdateInfoResponse *response = (HYGetUpdateInfoResponse *)result;
            [bself updateInfoResult:response.version_name
                              force:response.force_update];
        }
    }];
}

- (void)checkNewVersionNeedAlert:(BOOL)alert
{
    needAlert = alert;
    
    NSString *post=nil;
    post=[[NSString alloc]initWithFormat:@"id=%@",kAppId];
    NSData *postData=[post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength=[NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:@"http://itunes.apple.com/lookup?"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    self.returnData = data;
    
    [HYLoadHubView show];
    _conn = [NSURLConnection connectionWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.returnData appendData:data];
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HYLoadHubView dismiss];
    DebugNSLog(@"appstore info %@",[[NSString alloc] initWithData:_returnData
                                       encoding:NSUTF8StringEncoding]);
    
    NSString *jsonString=[[NSString alloc] initWithData:self.returnData
                                               encoding:NSUTF8StringEncoding];
    NSDictionary *jsonData=[jsonString objectFromJSONString];
    NSArray *infoArrays=[jsonData objectForKey:@"results"];
    
    if (infoArrays && (NSNull *)infoArrays != [NSNull null] && [infoArrays count] > 0)
    {
        NSDictionary *releaseInfo=[infoArrays objectAtIndex:0];
        NSString *appVersion =[releaseInfo objectForKey:@"version"];
        self.trackViewUrl = [releaseInfo objectForKey:@"trackViewUrl"];
        NSString *msg = [releaseInfo objectForKey:@"releaseNotes"];

        NSString *version =[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        
        BOOL newVersion = [appVersion caseInsensitiveCompare:version] == NSOrderedDescending;
        if (newVersion)
        {
            if (_forceUpdate)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"立即升级", nil];
                alert.tag = 10;
                [alert show];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:@"忽略"
                                                      otherButtonTitles:@"立即升级", nil];
                [alert show];
            }
        }
        else
        {
            self.trackViewUrl = nil;
            if (needAlert)
            {
                msg = @"当前已经是最新版本";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:msg
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"cancel", nil)
                                                      otherButtonTitles:NSLocalizedString(@"done", nil), nil];
                [alert show];
            }
        }
    }
    _returnData = nil;
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HYLoadHubView dismiss];
    _returnData = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (self.trackViewUrl && buttonIndex != alertView.cancelButtonIndex)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.trackViewUrl]];
    }
    
    //强制更新的 点击任何按钮都需要退出app
    if (alertView.tag == 10)
    {
        exit(0);
    }
    
    self.trackViewUrl = nil;
}

-(void)dealloc
{
    [_conn cancel];
    [_request cancel];
    [HYLoadHubView dismiss];
}

@end
