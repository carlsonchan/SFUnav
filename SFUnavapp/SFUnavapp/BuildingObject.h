//
//  BuildingObject.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by James Leong on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
/*
    container for floorplan images and the respective building names
 */
#import <Foundation/Foundation.h>

@interface BuildingObject : NSObject

@property NSString* buildingName;
@property NSString* coordinateString;
@property UIImage* floorPlanImage;

-(id) initWithbuildingObj: (NSString *) name floorPlan: (UIImage *) floorImage;

@end
