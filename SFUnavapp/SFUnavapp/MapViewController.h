//
//  MapViewController.h
//  SFUnavapp
//  Team NoMacs
//
//  Created by Arjun Rathee on 2015-03-03.
//  Edited by Arjun Rathee
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTImageMapView.h"

@interface MapViewController : UIViewController <MTImageMapDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *BuildingNames;
@property MTImageMapView *viewImageMap;

@end
