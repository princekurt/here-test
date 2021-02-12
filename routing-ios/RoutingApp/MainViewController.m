/*
 * Copyright (c) 2011-2020 HERE Europe B.V.
 * All rights reserved.
 */

#import "MainViewController.h"
#import "OlympicParkTileLayer.h"
#import <NMAKit/NMAKit.h>

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet NMAMapView* mapView;
@property (weak, nonatomic) IBOutlet UIButton* createRouteButton;
@property (nonatomic) NMACoreRouter* router;
@property (nonatomic) NMAMapRoute* mapRoute;
@property (nonatomic) NMAMapPackage* delaware;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // create geo coordinate
    NMAGeoCoordinates* geoCoordCenter =
        [[NMAGeoCoordinates alloc] initWithLatitude:49.260327 longitude:-123.115025];
    // set map view with geo center
    [self.mapView setGeoCenter:geoCoordCenter withAnimation:NMAMapAnimationNone];
    // set zoom level
    self.mapView.zoomLevel = 13.2;
    self.createRouteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  
    NMAMapLoader *mapLoader = [NMAMapLoader sharedMapLoader];
    mapLoader.delegate = self;
  
    [OlympicParkTileLayer addOlympicParkTileLayerToMapView:self.mapView];
    
//    [[NMAMapLoader sharedMapLoader] getMapPackages];
    NMAGeoCoordinates* delaware =
      [[NMAGeoCoordinates alloc] initWithLatitude:38.7746 longitude:-75.1393];
    [[NMAMapLoader sharedMapLoader] getMapPackageAtGeoCoordinates:delaware];
}

- (void)didReceiveMemoryWarning { [super didReceiveMemoryWarning]; }

- (void)mapLoader:(NMAMapLoader *)mapLoader didGetPackagesWithResult:(NMAMapLoaderResult)mapLoaderResult {
 
}

- (void)mapLoader:(NMAMapLoader *)mapLoader didGetMapPackage:(NMAMapPackage *)package atGeoCoordinates:(NMAGeoCoordinates *)coordinates withResult:(NMAMapLoaderResult)mapLoaderResult {
  self.delaware = package;
  NSLog(@"That package is %ld, %ld", (long)package.packageId, package.installationStatus);
  
}

- (void)mapLoader:(NMAMapLoader *)mapLoader didUpdateProgress:(float)progress {
  NSLog(@"Progress is %f", progress);
}

- (void)mapLoader:(NMAMapLoader *)mapLoader didInstallPackagesWithResult:(NMAMapLoaderResult)mapLoaderResult {
  NSLog(@"Did install package with status of %lu", (unsigned long)mapLoaderResult);
}


- (void)createRoute
{
    // Create an NSMutableArray to add two stops
    NSMutableArray* stops = [[NSMutableArray alloc] initWithCapacity:4];

    // START: Lewes, DE
    NMAGeoCoordinates* lewes =
        [[NMAGeoCoordinates alloc] initWithLatitude:38.7746 longitude:-75.1393];
    // END: Wilmington, DE
    NMAGeoCoordinates* wilmington =
        [[NMAGeoCoordinates alloc] initWithLatitude:39.7447 longitude:-75.5484];
    [stops addObject:lewes];
    [stops addObject:wilmington];

    // Create an NMARoutingMode, then set it to find the fastest car route without going on Highway.
    NMARoutingMode* routingMode =
        [[NMARoutingMode alloc] initWithRoutingType:NMARoutingTypeFastest
                                      transportMode:NMATransportModeTruck
                                     routingOptions:0];

    // Initialize the NMACoreRouter
    if ( !self.router )
    {
        self.router = [[NMACoreRouter alloc] init];
    }
    self.router.connectivity = NMACoreRouterConnectivityOffline;
    // Trigger the route calculation
    [self.router
        calculateRouteWithStops:stops
                    routingMode:routingMode
                completionBlock:^( NMARouteResult* routeResult, NMARoutingError error ) {
                  if ( !error )
                  {
                      if ( routeResult && routeResult.routes.count >= 1 )
                      {
                          // Let's add the 1st result onto the map
                          NMARoute* route = routeResult.routes[0];
                          self.mapRoute = [NMAMapRoute mapRouteWithRoute:route];
                          [self.mapView addMapObject:self.mapRoute];

                          // In order to see the entire route, we orientate the map view
                          // accordingly
                          [self.mapView setBoundingBox:route.boundingBox
                                         withAnimation:NMAMapAnimationLinear];
                      }
                      else
                      {
                          NSLog( @"Error:route result returned is not valid" );
                      }
                  }
                  else
                  {
                      NSLog( @"Error:route calculation returned error code %d", (int)error );
                  }
                }];
}

- (IBAction)buttonDidClicked:(id)sender
{
  NSLog(@"the sender is %@l", sender);
    // Clear map if previous results are still on map, otherwise proceed to creating route
    if ( self.mapRoute )
    {
        [self.mapView removeMapObject:self.mapRoute];
        self.mapRoute = nil;
    }
    else
    {
        [self createRoute];
    }
}

- (IBAction) startDownload:(id)sender
{
  NSArray *packageArray = [[NSArray alloc] initWithObjects:self.delaware, nil];
   [[NMAMapLoader sharedMapLoader] installMapPackages:packageArray];
}

@end
