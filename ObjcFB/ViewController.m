//
//  ViewController.m
//  ObjcFB
//
//  Created by Ravi kumar on 17/10/16.
//  Copyright © 2016 Ravi kumar. All rights reserved.
//

#import "ViewController.h"
#import <linkedin-sdk/LISDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self sync];
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me"
                                  parameters:@{@"fields": @"email,name,first_name"}
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"ressss %@",result);
        
        // Handle the result
    }];
    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor=[UIColor darkGrayColor];
    myLoginButton.frame=CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    [myLoginButton setTitle: @"My Login Button" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [myLoginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
    
    UIButton *linkedInBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    linkedInBtn.backgroundColor=[UIColor darkGrayColor];
    linkedInBtn.frame=CGRectMake(0,50,180,40);
    //linkedInBtn.center = self.view.center;
    [linkedInBtn setTitle: @"LinkedIn" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [linkedInBtn
     addTarget:self
     action:@selector(execute:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:linkedInBtn];

    UIButton *linkedInBtnInit=[UIButton buttonWithType:UIButtonTypeCustom];
    linkedInBtnInit.backgroundColor=[UIColor darkGrayColor];
    linkedInBtnInit.frame=CGRectMake(0,100,180,40);
   // linkedInBtnInit.center = self.view.center;
    [linkedInBtnInit setTitle: @"LinkedIn Init" forState: UIControlStateNormal];
    
    // Handle clicks on the button
    [linkedInBtnInit
     addTarget:self
     action:@selector(sync) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:linkedInBtnInit];
    
}


- (IBAction)sync {
    NSLog(@"%s","sync pressed2");
    
   
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, LISDK_EMAILADDRESS_PERMISSION, nil]
                                         state:@"some state"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      NSLog(@"%s","success called!");
                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                      NSLog(@"value=%@ isvalid=%@",[session value],[session isValid] ? @"YES" : @"NO");
                                      NSMutableString *text = [[NSMutableString alloc] initWithString:[session.accessToken description]];
                                      [text appendString:[NSString stringWithFormat:@",state=\"%@\"",returnState]];
                                      NSLog(@"Response label text %@",text);
                                     // _responseLabel.text = text;
                                    //  self.lastError = nil;
                                      // retain cycle here?
                                     // [self updateControlsWithResponseLabel:NO];
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                       // self.lastError = error;
                                        //  _responseLabel.text = [error description];
                                       // [self updateControlsWithResponseLabel:YES];
                                    }
     ];
    NSLog(@"%s","sync pressed3");
}
- (IBAction)clearSession:(id)sender {
    NSLog(@"%s","clear pressed");
    [LISDKSessionManager clearSession];
}


- (void)updateControlsWithResponseLabel:(BOOL)updateResponseLabel {
    if ([LISDKSessionManager hasValidSession]) {
        if (updateResponseLabel) {
            NSString *token = [[[LISDKSessionManager sharedInstance] session].accessToken description];
        }
      
    }
    else {
       }
}

- (NSString *)getMethod {
    int method =  0;
    switch (method) {
        case 0:
            return @"GET";
        case 1:
            return @"PUT";
        case 2:
            return @"POST";
        case 3:
            return @"DELETE";
        default:
            return @"Error";
    }
}

- (IBAction)execute:(id)sender {
   // NSLog(@"execute called with %@ body %@ and %d", _resourceTextField.text, _bodyTextField.text, (int)[_methodTypeControl selectedSegmentIndex] );
    // save state when request was made
    NSString *resourceText = @"https://www.linkedin.com/v1/people/~";
    NSString *method = @"GET";
    [[LISDKAPIHelper sharedInstance] apiRequest:resourceText
                                         method:method
                                           body:[@"" dataUsingEncoding:NSUTF8StringEncoding]
                                        success:^(LISDKAPIResponse *response) {
                                            NSLog(@"success called %@", response.data);
                                            dispatch_sync(dispatch_get_main_queue(), ^{
                                                [self showAPIResponsePage:method
                                                                            status:response.statusCode
                                                                           request:resourceText
                                                                          response:response.data];
                                            });
                                        }
                                          error:^(LISDKAPIError *apiError) {
                                              NSLog(@"error called %@", apiError.description);
                                              dispatch_sync(dispatch_get_main_queue(), ^{
                                                  LISDKAPIResponse *response = [apiError errorResponse];
                                                  NSString *errorText;
                                                  if (response) {
                                                      errorText = response.data;
                                                  }
                                                  else {
                                                      errorText = apiError.description;
                                                  }
                                                  [self showAPIResponsePage:method
                                                                              status:[apiError errorResponse].statusCode
                                                                             request:resourceText
                                                                            response:errorText];
                                              });
                                          }];
}

- (void)showAPIResponsePage:(NSString *)method status:(int)statusCode request:(NSString *)requestUrl response:(NSString *)response {
    NSLog(@" showAPIResponsePage  %@ And %d ,%@,%@",method,statusCode,requestUrl,response);
//    if (_navController.topViewController == _apiResponseController) {
//        return;
//    }
//    _apiResponseController.method = method;
//    _apiResponseController.url = requestUrl;
//    _apiResponseController.status = [NSString stringWithFormat:@"%d",statusCode];
//    _apiResponseController.response = response;
//    
//    _apiResponseController.requestMethodLabel.text = method;
//    _apiResponseController.requestUrlLabel.text = requestUrl;
//    _apiResponseController.responseStatusLabel.text = [NSString stringWithFormat:@"%d",statusCode];
//    _apiResponseController.responseTextView.text = response;
//    
//    [self.navController pushViewController:self.apiResponseController animated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // Once the button is clicked, show the login dialog
-(void)loginButtonClicked
    {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login
         logInWithReadPermissions: @[@"public_profile"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error %@",error.localizedDescription);
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 
                 FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                               initWithGraphPath:@"me"
                                               parameters:@{@"fields": @"email,name,first_name"}
                                               HTTPMethod:@"GET"];
                 [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                       id result,
                                                       NSError *error) {
                     NSLog(@"ressss %@",result);
                     
                     // Handle the result
                 }];
                 NSLog(@"Logged in %@", result);
             }
         }];
    }
@end
