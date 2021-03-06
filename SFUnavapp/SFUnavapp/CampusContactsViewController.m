//
//  CampusContactsViewController.m
//  SFUnavapp
//
//  Created by Serena Chan on 2015-03-01.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//

#import "CampusContactsViewController.h"


@interface CampusContactsViewController ()
{
    NSArray *campusContacts;
    NSArray *burnabyNumbers;
    NSArray *surreyNumbers;
    NSArray *vancouverNumbers;
}
@property (strong, nonatomic) IBOutlet UITableView *burnabyTable;
@property (strong, nonatomic) IBOutlet UITableView *surreyTable;
@property (strong, nonatomic) IBOutlet UITableView *vancouverTable;

@end

@implementation CampusContactsViewController
@synthesize burnabyView, surreyView, vancouverView;
@synthesize burnabyTable, surreyTable, vancouverTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //navigation name
    self.navigationItem.title=@"Campuses";
    self.navigationController.navigationBar.topItem.title = @"";
    
    campusContacts = [[NSArray alloc] initWithObjects:@"Switchboard", @"Security Services", @"Emergency", nil];
    burnabyNumbers = [[NSArray alloc] initWithObjects:@"778-782-3111", @"778-782-3100", @"778-782-4500",nil];
    surreyNumbers = [[NSArray alloc] initWithObjects:@"778-782-7400", @"778-782-7070", @"778-782-7511",nil];
    vancouverNumbers = [[NSArray alloc] initWithObjects:@"778-782-5000", @"778-782-5029", @"778–782–5252",nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segmentedValueChange:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex)
    {
        case 0: //selected burnaby
            self.burnabyView.hidden = NO;
            self.surreyView.hidden = YES;
            self.vancouverView.hidden = YES;
            self.burnabyTable.hidden = NO;
            self.surreyTable.hidden = YES;
            self.vancouverTable.hidden = YES;
            
            break;
            
        case 1: //selected surrey
            self.burnabyView.hidden = NO;
            self.surreyView.hidden = NO;
            self.vancouverView.hidden = YES;
            self.burnabyTable.hidden = YES;
            self.surreyTable.hidden = NO;
            self.vancouverTable.hidden = YES;
            break;
            
        case 2: // selected vancouver
            self.burnabyView.hidden = YES;
            self.surreyView.hidden = YES;
            self.vancouverView.hidden = NO;
            self.burnabyTable.hidden = YES;
            self.surreyTable.hidden = YES;
            self.vancouverTable.hidden = NO;
            break;
            
        default:
            break;
    }
}


- (IBAction)makeCall:(NSString *)phoneNumber{
    
    NSString *phoneStr = [[NSString alloc] initWithFormat:@"tel:%@",phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    NSLog(@"Called %@",phoneNumber);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return campusContacts.count;
    }
    else {
        return 1;
    }
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"campusContactCell" forIndexPath:indexPath];
     
     //semitransparent cell backgroung colour
     cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
     cell.textLabel.backgroundColor = [UIColor clearColor];
     cell.detailTextLabel.backgroundColor = [UIColor clearColor];
     cell.contentView.backgroundColor = [UIColor clearColor];
 
     // Configure the cell...
     if (indexPath.section == 0)
     {  //section 0 contains phone numbers
         cell.textLabel.text=campusContacts[indexPath.row];
         if(tableView == burnabyTable)
         {
             cell.detailTextLabel.text=burnabyNumbers[indexPath.row];
             cell.detailTextLabel.numberOfLines = 0;
         }
         else if(tableView == surreyTable)
         {
             cell.detailTextLabel.text=surreyNumbers[indexPath.row];
             cell.detailTextLabel.numberOfLines = 0;
         }
         else
         {
             cell.detailTextLabel.text=vancouverNumbers[indexPath.row];
             cell.detailTextLabel.numberOfLines = 0;
         }
     }
     else
     {  //section 1 contains the address
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.detailTextLabel.text = nil;
         cell.textLabel.numberOfLines = 0;
         if (tableView == burnabyTable) {
             cell.textLabel.text = @"8888 University Drive\nBurnaby, B.C. Canada. V5A 1S6";

         }
         else if (tableView == surreyTable) {
             cell.textLabel.text = @"250 - 13450 – 102nd Avenue\nSurrey, B.C. Canada. V3T 0A3";
         }
         else { //vancouver campus
             cell.textLabel.text = @"515 West Hastings Street\nVancouver, B.C. Canada. V6B 5K3";
         }
         
     }
     
 
 return cell;
 }


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.detailTextLabel.text != nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:cell.detailTextLabel.text
                              message:@""
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Call", nil];
        
        // Display Alert Message
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        [self makeCall:alertView.title];
    }
}


@end
