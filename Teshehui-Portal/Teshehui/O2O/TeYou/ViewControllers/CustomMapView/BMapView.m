//
//  BMapView.m
//  Teshehui
//
//  Created by apple_administrator on 15/10/9.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BMapView.h"
#import "CallOutAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"
#import "DefineConfig.h"
#import <BaiduMapAPI_Utils/BMKGeometry.h>
@interface BMapView ()<BMKMapViewDelegate,CallOutAnnotationViewDelegate>

@property (nonatomic,assign)id<BMapViewDelegate> delegate;
@property (nonatomic,strong)CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic,strong)NSMutableArray      *annotationArray;

@end

@implementation BMapView
- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        BMKMapView *mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height / 2)];
        mapView.delegate = self;
        mapView.showsUserLocation = YES;
        [self addSubview:mapView];
        self.BMKMapView =  mapView;
        self.span = 17000;
        
        _annotationArray = [NSMutableArray array];
    }
    return self;
}

- (id)initWithDelegate:(id<BMapViewDelegate>)delegate
{
    if (self = [self init]) {
        self.delegate = delegate;
    }
    return self;
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.BMKMapView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)beginLoad
{
    WS(weakSelf);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{

        int count = (int)[_delegate numbersWithCalloutViewForMapView];
            for (int i = 0; i < count; i++) {
                
                weakSelf.isOther = YES;
                CLLocationCoordinate2D location = [_delegate coordinateForMapViewWithIndex:i];
                BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:location.latitude
                                                                                 andLongitude:location.longitude tag:i];
                [_annotationArray addObject:annotation];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.BMKMapView addAnnotation:annotation];
                });
            }
    });
}

- (void)removeAnnotationView
{
    WS(weakSelf);

//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
//    dispatch_async(queue, ^{
//            
//        dispatch_async(dispatch_get_main_queue(), ^{
//           [weakSelf.BMKMapView removeAnnotations:_annotationArray];
//        });
//        
//    });
    
  [weakSelf.BMKMapView removeAnnotations:_annotationArray];
}

- (void)setMapRegionWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    BMKCoordinateRegion region;
   //只在第一次锁定显示区域时 设置一下显示范围 Map Region
    region = BMKCoordinateRegionMakeWithDistance(coordinate,_span ,_span );//BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(_span, _span));//越小地图显示越详细
    [self.BMKMapView setRegion:region animated:YES];//执行设定显示范围
    [self.BMKMapView setCenterCoordinate:coordinate animated:YES];//根据提供的经纬度为中心原点 以动画的形式移动到该区域
}

- (void)setUserPosition{
    
   // self.BMKMapView.centerCoordinate = self.coor;
    self.isUser = YES;
    BasicMapAnnotation *  annotation=[[BasicMapAnnotation alloc] initWithLatitude:self.coor.latitude andLongitude:self.coor.longitude tag:MaxTag];
    [_annotationArray addObject:annotation];
    [self.BMKMapView addAnnotation:annotation];
    [self setMapRegionWithCoordinate:self.coor];
}

- (void)largenMap{
    
    [self.BMKMapView zoomIn];
}

- (void)reduceMap{
    
    [self.BMKMapView zoomOut];
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{

    if ([view.annotation isKindOfClass:[BasicMapAnnotation class]]) {
        
        BasicMapAnnotation *annotation = (BasicMapAnnotation *)view.annotation;
        if (annotation.tag == MaxTag) {
            
            return;
        }
        
        if (_calloutAnnotation.coordinate.latitude == annotation.latitude&&
            _calloutAnnotation.coordinate.longitude == annotation.longitude)
        {
            return;
        }
        
        if (_calloutAnnotation) {
            [self.BMKMapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
            
        }
        
        self.calloutAnnotation = [[CalloutMapAnnotation alloc]
                                  initWithLatitude:annotation.latitude
                                  andLongitude:annotation.longitude
                                  tag:annotation.tag];
        
        [self.BMKMapView addAnnotation:_calloutAnnotation];
        

        [mapView setCenterCoordinate:_calloutAnnotation.coordinate animated:YES];

    }
}

- (void)didSelectAnnotationView:(CallOutAnnotationView *)view
{
    CalloutMapAnnotation *annotation = (CalloutMapAnnotation *)view.annotation;
    if([_delegate respondsToSelector:@selector(calloutViewDidSelectedWithIndex:)])
    {
        [_delegate calloutViewDidSelectedWithIndex:annotation.tag];
    }
    
    [self mapView:self.BMKMapView didDeselectAnnotationView:view];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    
    if (_calloutAnnotation)
    {
        if (_calloutAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutAnnotation.coordinate.longitude == view.annotation.coordinate.longitude)
        {
            [mapView removeAnnotation:_calloutAnnotation];
            self.calloutAnnotation = nil;
        }
    }
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotation *calloutAnnotation = (CalloutMapAnnotation *)annotation;
        
        CallOutAnnotationView *annotationView = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutView"];
        if (!annotationView)
        {
            annotationView = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutView" delegate:self];
        }
        for (UIView *view in  annotationView.contentView.subviews) {
            [view removeFromSuperview];
        }
        [annotationView.contentView addSubview:[_delegate mapViewCalloutContentViewWithIndex:calloutAnnotation.tag]];
        
        return annotationView;
    } else if ([annotation isKindOfClass:[BasicMapAnnotation class]])
    {
        BasicMapAnnotation *basicMapAnnotation = (BasicMapAnnotation *)annotation;
        BMKAnnotationView *annotationView = [self.BMKMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"];
        
        
        if (!annotationView)
        {
           // annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
//                                                          reuseIdentifier:@"CustomAnnotation"];
            
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ds"];
            ((BMKPinAnnotationView*)annotationView).canShowCallout = NO;
            ((BMKPinAnnotationView*)annotationView).animatesDrop = self.isRefresh ? NO : YES;
    
           if(self.isUser && !self.isOther){
                ((BMKPinAnnotationView*)annotationView).image = [UIImage imageNamed:@"personalposition"];
 
           } else{
               ((BMKPinAnnotationView*)annotationView).image = [_delegate baseMKAnnotationViewImageWithIndex:basicMapAnnotation.tag];
           }
        
        }
        
        return annotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    if([_delegate respondsToSelector:@selector(clickMapVieWToLargenView)])
    {
        [_delegate clickMapVieWToLargenView];
    }
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi{
    if([_delegate respondsToSelector:@selector(clickMapVieWToLargenView)])
    {
        [_delegate clickMapVieWToLargenView];
    }
}


@end
