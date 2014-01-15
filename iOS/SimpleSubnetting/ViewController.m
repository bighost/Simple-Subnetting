//
//  ViewController.m
//  SimpleSubnetting
//
//  Created by Tudor on 1/15/14.
//  Copyright (c) 2014 firless.com. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldNetwork;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBroadcast;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNoOfHosts;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNetmask;
@property (weak, nonatomic) IBOutlet UITextField *ip1;
@property (weak, nonatomic) IBOutlet UITextField *ip2;
@property (weak, nonatomic) IBOutlet UITextField *ip3;
@property (weak, nonatomic) IBOutlet UITextField *ip4;
@property (weak, nonatomic) IBOutlet UITextField *n1;
@property (weak, nonatomic) IBOutlet UITextField *n2;
@property (weak, nonatomic) IBOutlet UITextField *n3;
@property (weak, nonatomic) IBOutlet UITextField *n4;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.textFieldNetwork.delegate = self;
    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP1)],
                           nil];
    [numberToolbar sizeToFit];
    _ip1.inputAccessoryView = numberToolbar;
    
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP2)],
                           nil];
    [numberToolbar sizeToFit];
    _ip2.inputAccessoryView = numberToolbar;
    
}

- (void)didReceiveMemoryWarnin
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

-(void)doneWithNumberPadIP1{
    [_ip1 resignFirstResponder];
}
-(void)doneWithNumberPadIP2{
    [_ip2 resignFirstResponder];
}
-(void)doneWithNumberPadIP3{
    [_ip3 resignFirstResponder];
}
-(void)doneWithNumberPadIP4{
    [_ip4 resignFirstResponder];
}
-(void)doneWithNumberPadN1{
    [_n1 resignFirstResponder];
}
-(void)doneWithNumberPadN2{
    [_n2 resignFirstResponder];
}
-(void)doneWithNumberPadN3{
    [_n3 resignFirstResponder];
}
-(void)doneWithNumberPadN4{
    [_n4 resignFirstResponder];
}


#define MAXLENGTH 3

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    _showPass.text = _masterPassField.text;
    return [textField resignFirstResponder];
}

@end
