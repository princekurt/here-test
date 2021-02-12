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
        [[NMAGeoCoordinates alloc] initWithLatitude:38.861505 longitude:-76.984645];
    // set map view with geo center
    [self.mapView setGeoCenter:geoCoordCenter withAnimation:NMAMapAnimationNone];
    // set zoom level
    self.mapView.zoomLevel = 13;
    self.createRouteButton.titleLabel.adjustsFontSizeToFitWidth = YES;
  
    NMAMapLoader *mapLoader = [NMAMapLoader sharedMapLoader];
    mapLoader.delegate = self;
  
//    [OlympicParkTileLayer addOlympicParkTileLayerToMapView:self.mapView];
    
//    [[NMAMapLoader sharedMapLoader] getMapPackages];
    NMAGeoCoordinates* delaware =
      [[NMAGeoCoordinates alloc] initWithLatitude:38.861505 longitude:-76.984645];
    [[NMAMapLoader sharedMapLoader] getMapPackageAtGeoCoordinates:delaware];
  
  NSDictionary *json = [self JSONFromFile];
  NSString *stringFromJSON = [self stringOutputForDictionary:json];
  NSArray *array = [json objectForKey:@"features"];
  NSDictionary *feature = array[0];
  NSDictionary *geometry = [feature objectForKey:@"geometry"];
  NSArray *coorindates = [geometry objectForKey:@"coordinates"];
  NSArray *polygon1 = coorindates[0];
  
  NSMutableArray<NMAGeoCoordinates *> *coordinates =  [[NSMutableArray alloc] init];

  NSMutableArray *polygons = [[NSMutableArray alloc] init];
 
  
  for (int y = 0; y < 10000; y++){
    NMAMapPolygon *Polygon = [[NMAMapPolygon alloc] init ];
    [Polygon setFillColor:[UIColor colorWithRed:(176.0) green:(200.0) blue:(55.0) alpha:(0.5)] ];
  
    for (int x = 0; x < polygon1.count; x++) {
      NSArray *polygon = polygon1[x];
      double longitude = [polygon[0] doubleValue] + y *.001;
      double latitude = [polygon[1] doubleValue] + y *.001;
      NMAGeoCoordinates *newCoordinate = [NMAGeoCoordinates geoCoordinatesWithLatitude:latitude longitude:longitude];
      [Polygon appendVertex:newCoordinate];
    }
    
    [polygons addObject:Polygon];
    NSLog(@"BDS %lu", (unsigned long)polygons.count);
  }
 
  
  [self.mapView addMapObjects:polygons];
  
  
  
  
  
}

- (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];

    NSLog(@"colorString :%@",colorString);
    CGFloat alpha, red, blue, green;

    // #RGB
    alpha = 1.0f;
    red   = [self colorComponentFrom: colorString start: 0 length: 2];
    green = [self colorComponentFrom: colorString start: 2 length: 2];
    blue  = [self colorComponentFrom: colorString start: 4 length: 2];

    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

- (NSString *)stringOutputForDictionary:(NSDictionary *)inputDict {
   NSMutableString * outputString = [NSMutableString stringWithCapacity:256];

   NSArray * allKeys = [inputDict allKeys];

   for (NSString * key in allKeys) {
        if ([[inputDict objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            [outputString appendString: [self stringOutputForDictionary: (NSDictionary *)inputDict]];
        }
        else {
        [outputString appendString: key];
        [outputString appendString: @": "];
        [outputString appendString: [[inputDict objectForKey: key] description]];
        }
    [outputString appendString: @"\n"];
    }

    return [NSString stringWithString: outputString];
}

- (NSDictionary *)JSONFromFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"park" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    [request setValue:@"application/geo+json" forHTTPHeaderField:@"accept"];
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }

    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
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
