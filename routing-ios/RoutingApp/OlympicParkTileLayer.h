//
//  OlympicParkTileLayer.h
//  RoutingApp
//
//  Created by Kurt Anderson on 2/12/21.
//  Copyright © 2021 HERE Burnaby. All rights reserved.
//


@interface OlympicParkTileLayer : NMAMapTileLayer <NMAMapTileLayerDataSource>
+ (void)addOlympicParkTileLayerToMapView:(NMAMapView*)mapView;
@end


