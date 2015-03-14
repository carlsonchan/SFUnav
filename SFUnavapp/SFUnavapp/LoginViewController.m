//
//  LoginViewController.m
//  SFUnavapp
//
//  Created by Arjun Rathee on 2015-03-10.
//  Copyright (c) 2015 Team NoMacs. All rights reserved.
//
#import "TFHpple.h"
#import "LoginViewController.h"
#import "ServicesTableViewController.h"
#import "Reachability.h"

@interface LoginViewController ()
{
    NSString *js;
    BOOL error;
    BOOL internetStatus;
}
@end

@implementation LoginViewController

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
    error=NO;

    
    
}

-(BOOL) checkInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        return NO;
    }
    NSLog(@"There IS internet connection");
    return  YES;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)loginButtonPress:(id)sender {
    
    internetStatus=[self checkInternet];
    error=NO;
    if (internetStatus==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Internet Connection Required" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    autoLogin=YES;
    username=_userName.text;
    password=_passWord.text;
    NSLog(@"%@ %@",username,password);
    if ([username isEqualToString:@""] && [password isEqualToString:@""])
    {
        _errorDisplay.text=@"Both username and password fields are required";
        return;
    }
    js= [NSString stringWithFormat:
    @"var usrname = document.getElementById('username');"
    @"usrname.value='%@';"
    @"var pwd= document.getElementById('password');"
    @"pwd.value='%@';"
    @"var form= document.getElementById('fm1');"
    @"form.submit();",username,password];
    //NSLog(@"JS CODE %@",js);
    //_web=[[UIWebView alloc] init];
    [self.view addSubview:_web];
    //[_web setDelegate:self];
    NSURL *url= [NSURL URLWithString:@"https://cas.sfu.ca/cas/login?"];
    NSMutableURLRequest *requestObj= [NSURLRequest requestWithURL:url];
//    [requestObj setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/536.26.17 (KHTML, like Gecko) Version/6.0.2 Safari/536.26.17" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"Loading webpage\n");
    [_web loadRequest:requestObj];
    
    
    

}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    if (error==NO)
    {
        error=YES;
        [_web stringByEvaluatingJavaScriptFromString:js];
        NSData *result = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"https://cas.sfu.ca/cas/login"]];
        TFHpple *xpath = [[TFHpple alloc] initWithHTMLData:result];
        //use xpath to search element
        
        //Burnaby Campus Extra Details
        NSArray *data = [xpath searchWithXPathQuery:@"//div[@class='section-layout']/h2"];
        NSLog(@"data size%d",[data count]);
        TFHppleElement *item=data[0];
        NSLog(@"%@",item.text);
        if ([data count])
            _errorDisplay.text=@"The credentials you provided cannot be determined to be authentic.";
        
    }
}

@end