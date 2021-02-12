#import <NMAKit/NMAKit.h>
#import "OlympicParkTileLayer.h"



@implementation OlympicParkTileLayer

+(void)addOlympicParkTileLayerToMapView:(NMAMapView*)mapView
{
  OlympicParkTileLayer *tileLayer = [OlympicParkTileLayer new];
  [mapView addMapTileLayer:tileLayer];
  [mapView setGeoCenter:tileLayer.boundingBox.center
      zoomLevel:14.0
      orientation:NMAMapViewPreserveValue
      tilt:NMAMapViewPreserveValue
      withAnimation:NMAMapAnimationNone ];
  
}

-(id)init
{
  if (self = [super init]) {
    // Set the data source
    self.dataSource = self;

    // Set the bitmap format properties (must be compatible with pngs hosted on the
    // server)
    self.pixelFormat = NMAPixelFormatRGBA;
    self.transparent = YES;

    // Limit the tiles to the bounding box supported by the server
    NMAGeoBoundingBox *olympicParkBoundingBox =
    [NMAGeoBoundingBox geoBoundingBoxWithTopLeft:
      [NMAGeoCoordinates geoCoordinatesWithLatitude:71.28 longitude:-163.3166]
      bottomRight:
      [NMAGeoCoordinates geoCoordinatesWithLatitude:12.8909221 longitude: -51.4944]];
    self.boundingBox = olympicParkBoundingBox;

    // Customize the tile layer
    self.fadingEnabled = YES;
    // covers everything else on the map
    self.mapLayerType = NMAMapLayerTypeForeground;

//    // Enable caching
//    self.cacheTimeToLive = 60 * 60 * 24;  // 24 hours
//    self.cacheSizeLimit = 1024 * 1024 * 64; // 64MB
//    [self setCacheEnabled:YES withIdentifier:@"OlympicParkTileLayer"];
  }
  return self;
}

-(NSString *)mapTileLayer:(NMAMapTileLayer *)mapTileLayer
      urlForTileAtX:(NSUInteger)x
            y:(NSUInteger)y
        zoomLevel:(NSUInteger)zoomLevel
{
  // Return a URL for the specified tile
  // This tile source is hosted by HERE Global B.V. and may be removed at any time
  return [NSString stringWithFormat:
    @"https://maps.aerisapi.com/dFeHg9eBCz5ssENOKKDIO_zLV7zGBpJobhYeqAgomY1A8N3yjARI2LhDlAiPTP/radar:50,ftemperatures:25/%lu/%lu/%lu/current.png",
    zoomLevel,
    x,
    y ];
}

@end
