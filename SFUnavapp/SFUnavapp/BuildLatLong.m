//
//  BuildLatLong.m
//  SFUnavapp
//
//  Created by James Leong on 2015-03-20.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "BuildLatLong.h"

@implementation BuildLatLong

//custom object for latitude and longitude
//note, could add to BuildingObject as a latitude and longitude version to optimize code

-(id) initWithBuildLL: (NSString *) name latitude: (double) lat longitude: (double) longi {
    self = [super init];
    self.buildingName = name;
    self.lati = lat;
    self.longi = longi;
    return self;
}


@end