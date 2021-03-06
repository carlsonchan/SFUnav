//
//  BusRouteStorage.m
//  SFUnavapp
//  Team NoMacs
//  Created by Tyler Wong on 2015-02-26.
//
//	Edited by James Leong
//	Edited by Tyler Wong
//	Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "BusRouteStorage.h"

@implementation BusRouteStorage

/*-(void) printhello{
    NSLog(@"helloworld");
}*/

//this method is called when the object is initiated. It will take the parameters of the bus stop number and bus route requested, and add entries to the dictionary properties with the buses servicing that stop and the times they will come.
-(void) updatebustimes{

    
    NSString *info;
    NSString *routeinfo;
    
    // NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://api.translink.ca/rttiapi/v1/stops/59044/estimates?apikey=Inm4xjwOOLahxETIK89R&count=3&timeframe=60&routeNo="]];
    
    //setting up URL connection
    NSString *inputurlstring=[NSString stringWithFormat:@"http://api.translink.ca/rttiapi/v1/stops/%@/estimates?apikey=Inm4xjwOOLahxETIK89R&count=4&timeframe=60&routeNo=%@",self.busstopid,self.routnumber];
    NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:inputurlstring]];
    
    
    //PARSES HTML DOCUMENT
    TFHpple *xmldocument = [[TFHpple alloc]initWithHTMLData:result];
    NSArray *busnumber = [xmldocument searchWithXPathQuery:@"//nextbus/routeno"];
    
    //LOOPS THROUGH ALL THE BUS ROUTES THAT WILL COME, AND WILL RETURN THE TIMES ALONG WITH THE ROUTES IN DICTIONARY OBJECT
    for (TFHppleElement *item in busnumber)
    {   //write log
        NSMutableArray *bustimearray = [[NSMutableArray alloc] initWithCapacity:0]; // holds the bustimes
        
        NSMutableArray *buscountarray = [[NSMutableArray alloc] initWithCapacity:0]; //holds the expected countdown
        routeinfo=item.text;
        //NSLog(routeinfo);
        //NSLog(info);
        [self.busroutereturnvalues addObject:routeinfo];//this should create the array of busroutes servicing at the given busstopnumber
        
        //this xpath query fetches the leave times
        NSString *query = [NSString stringWithFormat:@"//nextbus[routeno=\"%@\"]/schedules/schedule/expectedleavetime",routeinfo];
        NSArray *expleavetime = [xmldocument searchWithXPathQuery:query];
        
        //this xpath query fetches the countdown times
        NSString *querycountDown = [NSString stringWithFormat:@"//nextbus[routeno=\"%@\"]/schedules/schedule/expectedcountdown",routeinfo];
        NSArray *countDownarr = [xmldocument searchWithXPathQuery:querycountDown];
        
        
        //this loops through the
        for (TFHppleElement *item in expleavetime)
        {   //write log
            //NSString *output = item.tagName;
            //NSLog(output);
            info=item.text;
            NSRange range = [info rangeOfString:@"m"];
            info = [info substringWithRange:NSMakeRange(0, range.location)];
            info = [info stringByAppendingString:@"m"];
            //NSLog(info);
            [bustimearray addObject:info];
        }
        //create a temporary dictionary of 1 entry, attatch the bus times to that entry, and attatch the temporary dictionary to the main dictionary.
        NSMutableDictionary *tempdictionary = [[NSMutableDictionary alloc] init];
        [tempdictionary setObject:bustimearray forKey:routeinfo];
        [self.dictionary addEntriesFromDictionary:tempdictionary];
        
        
        for (TFHppleElement *item in countDownarr) {
            info = item.text;
            //NSLog(info);
            
            [buscountarray addObject:info];
        }
        
        NSMutableDictionary *tempdict2 = [[NSMutableDictionary alloc] init];
        [tempdict2 setObject:buscountarray forKey:routeinfo];
        /*for(NSString *elem in buscountarray) {
            NSLog(elem);
        }*/
        [self.dictionary_count addEntriesFromDictionary:tempdict2];
    }
    
    /*
     NSArray *expleavetime = [xmldocument searchWithXPathQuery:@"//nextbus/schedules/schedule/expectedleavetime"];
     for (TFHppleElement *item in expleavetime)
     {   //write log
     NSString *output = item.tagName;
     NSLog(output);
     info=item.text;
     NSLog(info);
     [bustimearray addObject:info];
     }
     NSLog(@"PRINTING");
     for (NSString *i in bustimearray){
     test=i;
     NSLog(test);
     }
     for (NSString *i in busnumberarray){
     test=i;
     NSLog(test);
    }
     */
}


//CODE THAT WILL BE USED TO INSTANTIATE THE OBJECT
-(id) initWithbusroute: (NSString *) routenumber andbusid: (NSString *) busid{
    self=[super init];
    self.routnumber=routenumber;
    self.busstopid = busid;
    self.dictionary = [[NSMutableDictionary alloc] init];
    self.busroutereturnvalues = [[NSMutableArray alloc] init] ;
    self.dictionary_count = [[NSMutableDictionary alloc] init];
    [self updatebustimes];
    return self;
}

@end
