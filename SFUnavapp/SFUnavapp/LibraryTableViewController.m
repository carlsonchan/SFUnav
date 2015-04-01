//
//  LibraryTableViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-26.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "LibraryHoursTableViewCell.h"
#import "ServicesURL.h"
#import "ServicesWebViewController.h"
#define FBOX(x) [NSNumber numberWithFloat:x]
#define IBOX(x) [NSNumber numberWithInteger:x]

@interface LibraryTableViewController ()
{
    NSMutableArray *hourResults;
    NSMutableDictionary *equipResults;
    NSMutableArray *links;
    NSDictionary *linkInfo;
}
@end


@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //navigation name
    self.navigationItem.title=@"Library";
    
    //get library hours api information
    NSString *str = @"http://api.lib.sfu.ca/hours/summary?date=";
    NSURL *url = [NSURL URLWithString:str];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    hourResults = [NSJSONSerialization
                   JSONObjectWithData:data
                   options:NSJSONReadingMutableContainers
                   error:&error];
    NSLog(@"Your JSON Object: %@ Or Error is: %@", hourResults, error);
    
    //get library equipment summary api information
    str = @"http://api.lib.sfu.ca/equipment/computers/free_summary";
    url = [NSURL URLWithString:str];
    data = [NSData dataWithContentsOfURL:url];
    error = nil;
    equipResults = [NSJSONSerialization
                   JSONObjectWithData:data
                   options:NSJSONReadingMutableContainers
                   error:&error];
    
    equipResults = [equipResults objectForKey:@"locations"];
    
    NSLog(@"Your JSON Object: %@ Or Error is: %@", equipResults, error);
    
   
    //holds links
    links = [[NSMutableArray alloc] init];
    
    ServicesURL *linkURL = [[ServicesURL alloc] init];
    linkURL.serviceName= @"SFU Library Search";
    linkURL.serviceURL = @"http://fastsearch.lib.sfu.ca";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"My SFU Library Account";
    linkURL.serviceURL = @"https://troy.lib.sfu.ca/patroninfo";
    [links addObject:linkURL];
    
    linkURL = [[ServicesURL alloc]init];
    linkURL.serviceName = @"Book a Group Study Room";
    linkURL.serviceURL = @"http://roombookings.lib.sfu.ca/studyrooms/day.php?area=1";
    [links addObject:linkURL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {   return 1; }
    else if (section == 2)
    {   return links.count;   }
     
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryHoursTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"libraryCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        //get info
        NSString *libraryName = [hourResults[indexPath.row] objectForKey:@"location"];
        BOOL inRange = [[hourResults[indexPath.row] objectForKey:@"in_range"]intValue];
        NSString *openTime = [hourResults[indexPath.row] objectForKey:@"open_time"];
        NSString *closeTime = [hourResults[indexPath.row] objectForKey:@"close_time"];
        BOOL openAllDay = [[hourResults[indexPath.row]objectForKey:@"open_all_day"]intValue];
        BOOL closeAllDay = [[hourResults[indexPath.row]objectForKey:@"close_all_day"]intValue];

        //NSLog([NSString stringWithFormat:@"%@ is open? %d, is closed? %d", libraryName, (int)openAllDay, (int)closeAllDay ]) ;
        
        //get open & close hours, convert to 24HR to int
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"hh:mma"];
        NSDate *openTimed = [df dateFromString:openTime];
        NSDate *closeTimed = [df dateFromString:closeTime];
        NSDate *timed = [NSDate date];
        [df setDateFormat:@"HH"];
        
        NSString *openTimeHR = [df stringFromDate:openTimed];
        NSString *closeTimeHR = [df stringFromDate:closeTimed];
        NSString *timeHR = [df stringFromDate:timed];
        
        int open = [openTimeHR intValue];
        int close = [closeTimeHR intValue];
        int time = [timeHR intValue];

        //is the library open?
        BOOL isOpen;
        if (openAllDay || (inRange && !closeAllDay)) {
            isOpen = YES;
        }
/*
        if (isOpen) {
            cell.libraryName.textColor = [UIColor colorWithRed:0 green:.5 blue:0 alpha:1 ];
        }
        else {
            cell.libraryName.textColor = [UIColor redColor];
        }
*/
        NSString *status = (isOpen ? @"open" : @"closed");
        
        //text for labels
        cell.libraryName.text = libraryName;
        cell.libraryStatus.text = [NSString stringWithFormat:@"is %@",status];
        cell.openTime.text = openTime;
        cell.closeTime.text = closeTime;

        //format cell
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        
        //draw
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(125, 31, 187, 2)];
        line.backgroundColor =  [UIColor grayColor];
        [cell.contentView addSubview:line];
        
        
        //width of box
        UIView *hoursBox;
        if (openAllDay == 1) {
            hoursBox = [[UIView alloc] initWithFrame:CGRectMake(125, 27, 187, 10)];
        }
        else {
            int start = 187/23*open;
            int width = 187/23*close - start;
            hoursBox = [[UIView alloc] initWithFrame:CGRectMake(125+start, 27, width, 10)];
        }
        //colour of box
        if (isOpen) {
            hoursBox.backgroundColor =  [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0 ];
        }
        else{
            hoursBox.backgroundColor =  [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0 ];
        }
        [cell.contentView addSubview:hoursBox];
        
        //current time line
        int now = 187/23*time;
        UIView *nowLine = [[UIView alloc] initWithFrame:CGRectMake(125+now, 25, 2, 14)];
        nowLine.backgroundColor =  [UIColor blackColor];
        [cell.contentView addSubview:nowLine];
        
        
    }
    if (indexPath.section == 1) {
        //hide labels
        cell.libraryName.hidden = YES;
        cell.libraryStatus.hidden = YES;
        cell.openTime.hidden = YES;
        cell.closeTime.hidden = YES;
        //disable selection
        cell.userInteractionEnabled = NO;
        
        int benlaps = [[equipResults objectForKey:@"ben-checkout-laptops"]intValue];
        int ben2pc = [[equipResults objectForKey:@"ben-2-2105-pc"]intValue];
        int ben3Emac = [[equipResults objectForKey:@"ben-3-e-mac"]intValue];
        int ben3Epc = [[equipResults objectForKey:@"ben-3-e-pc"]intValue];
        int ben3Wpc =[[equipResults objectForKey:@"ben-3-w-pc"]intValue];
        int ben4pc =[[equipResults objectForKey:@"ben-4-4009-pc"]intValue];
        int ben5pc = [[equipResults objectForKey:@"ben-5-pc"]intValue];
        int ben6pc =[[equipResults objectForKey:@"ben-6-pc"]intValue];
        
        NSArray *counts = [NSArray arrayWithObjects:
                           IBOX(ben6pc),
                           IBOX(ben5pc),
                           IBOX(ben4pc),
                           IBOX(ben3Wpc),
                           IBOX(ben3Epc),
                           IBOX(ben3Emac),
                           IBOX(ben2pc),
                           IBOX(benlaps),
                           nil];
        
        float sum = 0.0;
        for(int i = 0; i < counts.count; i++){
            sum += (float)[counts[i]floatValue];
        }
        
        /*
        float BL = benlaps/sum;
        float B2 = ben2pc/sum;
        float B3EM = ben3Emac/sum;
        float B3EP = ben3Epc/sum;
        float B3W = ben3Wpc/sum;
        float B4 = ben4pc/sum;
        float B5 = ben5pc/sum;
        float B6 = ben6pc/sum;
        */
        
        NSArray *ratios = [NSArray arrayWithObjects:
                           FBOX(ben6pc/sum),
                           FBOX(ben5pc/sum),
                           FBOX(ben4pc/sum),
                           FBOX(ben3Wpc/sum),
                           FBOX(ben3Epc/sum),
                           FBOX(ben3Emac/sum),
                           FBOX(ben2pc/sum),
                           FBOX(benlaps/sum),
                           nil];
        
        NSLog(@"%d out of %f is %f", [counts[1]intValue], sum, [ratios[1]floatValue]);
        
        //labels
        NSArray *floors = @[@"6th Floor PC",@"5th Floor", @"4th Floor", @"3rd Floor, West", @"3rd Floor, East", @"3rd Floor, East", @"2nd Floor", @""];
        NSArray *comps = @[@"PCs",@"PCs", @"PCs", @"PCs", @"PCs", @"Macs", @"PCs", @"laptops"];
        
        int size = 150;
        int H = 0;
        
        UIView *box;
        UILabel *floor; UILabel *cnt;
        for (int i = 0; i < ratios.count; i++){
            
            //box
            float f = [ratios[i]floatValue];
            float height = f*size;
            
            box = [[UIView alloc] initWithFrame:CGRectMake(8, 8+H, 304, height)];
            box.backgroundColor =  [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:f+.5];
            [cell.contentView addSubview:box];
            
            //labels
            floor = [[UILabel alloc] initWithFrame:CGRectMake(8, 8+H, 304, height)];
            floor.text = [NSString stringWithFormat:@"%@", floors[i]];
            floor.textColor = [UIColor whiteColor];
            [floor setFont:[UIFont systemFontOfSize:height-1]];
            [cell.contentView addSubview:floor];
            
            cnt = [[UILabel alloc] initWithFrame:CGRectMake(8, 8+H, 304, height)];
            cnt.text = [NSString stringWithFormat:@"%d %@", [counts[i]intValue], comps[i]];
            cnt.textAlignment = NSTextAlignmentRight;
            cnt.textColor = [UIColor whiteColor];
            [cnt setFont:[UIFont systemFontOfSize:height-1]];
            [cell.contentView addSubview:cnt];
            
            H += height+3;
        }
    }
    
    if (indexPath.section == 2) {

        ServicesURL* url= [links objectAtIndex:indexPath.row];
        cell.libraryName.text = [url serviceName];
        cell.libraryStatus.hidden = YES;
        cell.openTime.hidden = YES;
        cell.closeTime.hidden = YES;
        
        //format cell
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.hidden = YES;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {   return @"Hours of Operation"; }
    if (section == 1)
    {   return @"Available Equipment";   }
    if (section == 2)
    {   return @"Quick Links";  }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && indexPath.row == 0) {
        return 185;
    }
    // "Else"
    return 44;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqual:@"openWebpage"])
    { // Get the new view controller using [segue destinationViewController].
        ServicesWebViewController *webcont = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        ServicesURL *send = links[path.row];
        webcont.hidesBottomBarWhenPushed = YES;
        [webcont setCurrentURL:send];
        
    }
}
 

@end