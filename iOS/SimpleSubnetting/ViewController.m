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
@property (weak, nonatomic) IBOutlet UILabel *textFieldBitIP;
@property (weak, nonatomic) IBOutlet UILabel *textFieldBitNetmask;
@property (weak, nonatomic) IBOutlet UILabel *textFieldBitNetwork;
@property (weak, nonatomic) IBOutlet UILabel *textFieldBitBroadcast;
@property (weak, nonatomic) IBOutlet UITextField *ip1;
@property (weak, nonatomic) IBOutlet UITextField *ip2;
@property (weak, nonatomic) IBOutlet UITextField *ip3;
@property (weak, nonatomic) IBOutlet UITextField *ip4;
@property (weak, nonatomic) IBOutlet UITextField *n1;
@property (weak, nonatomic) IBOutlet UITextField *n2;
@property (weak, nonatomic) IBOutlet UITextField *n3;
@property (weak, nonatomic) IBOutlet UITextField *n4;
@property (weak, nonatomic) IBOutlet UISegmentedControl *SegmentedNetworkClass;
@end

@implementation ViewController

- (void)resetFields
{
    _SegmentedNetworkClass.selectedSegmentIndex = UISegmentedControlNoSegment;
    _textFieldBroadcast.text = @"-";
    _textFieldNetmask.text = @"-";
    _textFieldNoOfHosts.text = @"-";
    _textFieldNetwork.text = @"-";
    _textFieldBitIP.text = @"-";
    _textFieldBitNetmask.text = @"-";
    _textFieldBitNetwork.text = @"-";
    _textFieldBitBroadcast.text = @"-";
}

- (void) displayErrorNetmask
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect Subnet Mask"
                                                    message:@"Please make sure the subnet mask is valid."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) displayErrorIP
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrect IP"
                                                    message:@"Please make sure the IP is valid."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)setNetworkClass: (int) nip1
{
    
    if( (0 < nip1) && (nip1 <= 127) )
    {
        _SegmentedNetworkClass.selectedSegmentIndex = 0;
    }
    if( (128 <= nip1) && (nip1 <= 191) )
    {
        _SegmentedNetworkClass.selectedSegmentIndex = 1;
    }
    if( (192 <= nip1) && (nip1 <= 223) )
    {
        _SegmentedNetworkClass.selectedSegmentIndex = 2;
    }

}

- (NSInteger)getSlash:(NSString *)input
{

    NSMutableArray *arrNetmaskBits = [[NSMutableArray alloc] initWithCapacity:[input length]];
    for (int i=0; i < [input length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [input characterAtIndex:i]];
        [arrNetmaskBits addObject:ichar];
    }
    
    NSInteger count = 0;
    
    for (NSInteger i = 0; i < [arrNetmaskBits count]; i++)
    {
        NSString *s = [arrNetmaskBits objectAtIndex:i];
//        NSLog(s);
        if([s isEqual: @"1"])
            count++;
        else
            break;
    }
    return count;
}

- (NSInteger)getNoOfHosts:(NSInteger)slash
{
    NSInteger nFreeBits = 32 - slash;
    NSInteger nHosts = pow(2, nFreeBits) - 2;
    return nHosts;
}

- (NSString *)getBinNetwork:(NSString *) binIP :(NSInteger) slash
{
    NSMutableArray *arrIPBits = [[NSMutableArray alloc] initWithCapacity:[binIP length]];
    for (int i=0; i < [binIP length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [binIP characterAtIndex:i]];
        [arrIPBits addObject:ichar];
    }
    
    for (int i = slash; i < 32; i++)
    {
        [arrIPBits replaceObjectAtIndex:i withObject:@"0"];
    }
    
    NSString *binNetwork = @"";
    for(int i=0; i < [arrIPBits count]; i++)
    {
        binNetwork = [NSString stringWithFormat:@"%@%@", binNetwork, [arrIPBits objectAtIndex: i]];
    }
    return binNetwork;
}

- (NSString *)getBinBroadcast:(NSString *) binIP :(NSInteger) slash
{
    NSMutableArray *arrIPBits = [[NSMutableArray alloc] initWithCapacity:[binIP length]];
    for (int i=0; i < [binIP length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [binIP characterAtIndex:i]];
        [arrIPBits addObject:ichar];
    }
    
    for (int i=slash; i < 32; i++)
    {
        [arrIPBits replaceObjectAtIndex:i withObject:@"1"];
    }
    
    NSString *binNetwork = @"";
    for(int i=0; i < [arrIPBits count]; i++)
    {
        binNetwork = [NSString stringWithFormat:@"%@%@", binNetwork, [arrIPBits objectAtIndex: i]];
    }
    return binNetwork;
}

- (NSString *)completeTheOctet:(NSString *)input
{
    if(input.length < 8)
    {
        int nAddZeros = 8 - input.length;
        for (NSInteger i = 0; i < nAddZeros; i++) {
            input = [NSString stringWithFormat:@"%@%@", @"0", input];
        }
    }
    return input;
}

- (NSString *)toBinary:(NSInteger)input
{
    NSString *bin = @"";
    if (input == 1 || input == 0)
    {
        bin = [NSString stringWithFormat:@"%d", input];
    }
    else
    {
        bin = [NSString stringWithFormat:@"%@%d", [self toBinary:input / 2], input % 2];
    }
    return bin;
}

- (int) binaryStringToInt:(NSString*) binaryString;
{
    unichar aChar;
    int value = 0;
    int index;
    for (index = 0; index<[binaryString length]; index++)
    {
        aChar = [binaryString characterAtIndex: index];
        if (aChar == '1')
            value += 1;
        if (index+1 < [binaryString length])
            value = value<<1;
    }
    return value;
}

- (NSString *)toDecimal:(NSString *)binIP
{
    NSString *bitIP1 = [binIP substringWithRange:NSMakeRange(0,8)];
    NSString *bitIP2 = [binIP substringWithRange:NSMakeRange(8,8)];
    NSString *bitIP3 = [binIP substringWithRange:NSMakeRange(16,8)];
    NSString *bitIP4 = [binIP substringWithRange:NSMakeRange(24,8)];
    
    int nIP1 = [self binaryStringToInt:bitIP1];
    int nIP2 = [self binaryStringToInt:bitIP2];
    int nIP3 = [self binaryStringToInt:bitIP3];
    int nIP4 = [self binaryStringToInt:bitIP4];
   
    NSString *strIP = [NSString stringWithFormat:@"%d.%d.%d.%d", nIP1, nIP2, nIP3, nIP4];
    
    return strIP;
}

- (NSString *)toBinaryWithPoints:(NSString *)binIP
{
    NSString *bitIP1 = [binIP substringWithRange:NSMakeRange(0,8)];
    NSString *bitIP2 = [binIP substringWithRange:NSMakeRange(8,8)];
    NSString *bitIP3 = [binIP substringWithRange:NSMakeRange(16,8)];
    NSString *bitIP4 = [binIP substringWithRange:NSMakeRange(24,8)];
    
    return [NSString stringWithFormat:@"%@.%@.%@.%@", bitIP1, bitIP2, bitIP3, bitIP4];
}

- (BOOL) checkIPs: (NSString *) binIP :(NSString *) binNetmask
{
    if([binIP length] != 32 )
    {
        [self displayErrorIP];
        return false;
    }
    
    NSString *binIP1 = [binIP substringWithRange:NSMakeRange(0,8)];
    NSInteger nIP1 = [self binaryStringToInt:binIP1];
    if((nIP1 == 0) || (nIP1 > 252))
    {
        [self displayErrorIP];
        return false;
    }
    
    if([binNetmask length] != 32)
    {
        [self displayErrorNetmask];
        return false;
    }
    
    NSMutableArray *arrNetmaskBits = [[NSMutableArray alloc] initWithCapacity:[binNetmask length]];
    for (int i=0; i < [binNetmask length]; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%c", [binNetmask characterAtIndex:i]];
        [arrNetmaskBits addObject:ichar];
    }
    
    BOOL bFoundZero = false;
    for(int i=0; i < [arrNetmaskBits count]; i++)
    {
        if([[arrNetmaskBits objectAtIndex:i]  isEqual: @"0"])
        {
            bFoundZero = true;
        }
        if((bFoundZero == true) && ([[arrNetmaskBits objectAtIndex:i] isEqual: @"1"]))
        {
            [self displayErrorNetmask];
            return false;
        }
    }
    
    return true;
}

- (void)tapPing: (NSString *) whatToPing {
    [SimplePingHelper ping: whatToPing
                    target:self sel:@selector(pingResult:)];
}

- (void)pingResult:(NSNumber*)success {
    if (success.boolValue) {
        NSLog(@"SUCCESS");
    } else {
        NSLog(@"FAIL");
    }
}

- (IBAction)ButtonCalculate:(UIButton *)sender {
    NSLog(@"Button Calculate touched");
    [self.view endEditing:YES];

    int nip1 = [_ip1.text intValue];
    int nip2 = [_ip2.text intValue];
    int nip3 = [_ip3.text intValue];
    int nip4 = [_ip4.text intValue];
    int nn1 = [_n1.text intValue];
    int nn2 = [_n2.text intValue];
    int nn3 = [_n3.text intValue];
    int nn4 = [_n4.text intValue];
    
    NSString *binip1 = [self toBinary: nip1];
    binip1 = [self completeTheOctet: binip1];
    NSString *binip2 = [self toBinary: nip2];
    binip2 = [self completeTheOctet: binip2];
    NSString *binip3 = [self toBinary: nip3];
    binip3 = [self completeTheOctet: binip3];
    NSString *binip4 = [self toBinary: nip4];
    binip4 = [self completeTheOctet: binip4];
    
    NSString *binn1 = [self toBinary: nn1];
    binn1 = [self completeTheOctet: binn1];
    NSString *binn2 = [self toBinary: nn2];
    binn2 = [self completeTheOctet: binn2];
    NSString *binn3 = [self toBinary: nn3];
    binn3 = [self completeTheOctet: binn3];
    NSString *binn4 = [self toBinary: nn4];
    binn4 = [self completeTheOctet: binn4];
    
    NSLog(@"%@.%@.%@.%@", binip1, binip2, binip3, binip4);
    NSLog(@"%@.%@.%@.%@", binn1, binn2, binn3, binn4);
    
    NSString *binIP = [NSString stringWithFormat:@"%@%@%@%@", binip1, binip2, binip3, binip4];
    NSString *binNetmask = [NSString stringWithFormat:@"%@%@%@%@", binn1, binn2, binn3, binn4];
    
    if([self checkIPs: binIP: binNetmask])
    {
        NSString *givenIP = [NSString stringWithFormat:@"%d.%d.%d.%d", nip1, nip2, nip3, nip4];
        
        const char *hostName = [givenIP
                                cStringUsingEncoding:NSASCIIStringEncoding];
        SCNetworkConnectionFlags flags = 0;
        if (SCNetworkCheckReachabilityByName(hostName, &flags) && flags > 0) {
            NSLog(@"Host is reachable: %d", flags);
        }
        else {
            NSLog(@"Host is unreachable");
        }
        
        
        NSInteger slash = [self getSlash:binNetmask];
        [_textFieldNetmask setText:[NSString stringWithFormat:@"/%ld", (long)slash]];
    
        NSInteger nNoOfHosts = [self getNoOfHosts:slash];
        [_textFieldNoOfHosts setText:[NSString stringWithFormat:@"%ld hosts", (long)nNoOfHosts]];

        NSString *binNetwork = [self getBinNetwork:binIP : slash];
        [_textFieldNetwork setText:[self toDecimal:binNetwork]];
        
        NSString *binBroadcast = [self getBinBroadcast: binIP : slash];
        [_textFieldBroadcast setText:[self toDecimal:binBroadcast]];

        [self setNetworkClass: nip1];
        
        //Binary Display
        NSInteger slashIncludingDots = slash;
        if(slash > 24)
            slashIncludingDots += 3;
        else if(slash > 16)
            slashIncludingDots += 2;
        else if(slash > 8)
            slashIncludingDots += 1;
        
        NSMutableAttributedString *colorBinNetwork = [[NSMutableAttributedString alloc] initWithString: [self toBinaryWithPoints:binNetwork]];
        [colorBinNetwork addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(0, slashIncludingDots)];
       
        NSMutableAttributedString *colorBinBroadcast = [[NSMutableAttributedString alloc] initWithString: [self toBinaryWithPoints:binBroadcast]];
        [colorBinBroadcast addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(0, slashIncludingDots)];
        
        NSMutableAttributedString *colorBinIP = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@.%@.%@.%@", binip1, binip2, binip3, binip4]];
        [colorBinIP addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(0, slashIncludingDots)];
        
        NSMutableAttributedString *colorBinNetmask = [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@.%@.%@.%@", binn1, binn2, binn3, binn4]];
        [colorBinNetmask addAttribute: NSForegroundColorAttributeName value: [UIColor redColor] range: NSMakeRange(0, slashIncludingDots)];
        
        [_textFieldBitNetwork setAttributedText:colorBinNetwork];
        [_textFieldBitBroadcast setAttributedText:colorBinBroadcast];
        [_textFieldBitIP setAttributedText:colorBinIP];
        [_textFieldBitNetmask setAttributedText:colorBinNetmask];
    }
    else
    {
        [self resetFields];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textFieldNetwork.delegate = self;

    [self.myScrollView setScrollEnabled:YES];
    [self.myScrollView setContentSize:CGSizeMake(320, 1070)];
    
    UIToolbar* numberToolbarIP1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarIP1.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarIP1.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP1)],
                           nil];
    [numberToolbarIP1 sizeToFit];
    _ip1.inputAccessoryView = numberToolbarIP1;
    

    UIToolbar* numberToolbarIP2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarIP2.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarIP2.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP2)],
                           nil];
    [numberToolbarIP2 sizeToFit];
    _ip2.inputAccessoryView = numberToolbarIP2;
    
    UIToolbar* numberToolbarIP3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarIP3.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarIP3.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP3)],
                           nil];
    [numberToolbarIP3 sizeToFit];
    _ip3.inputAccessoryView = numberToolbarIP3;
    
    UIToolbar* numberToolbarIP4 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarIP4.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarIP4.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadIP4)],
                           nil];
    [numberToolbarIP4 sizeToFit];
    _ip4.inputAccessoryView = numberToolbarIP4;
    
    UIToolbar* numberToolbarN1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarN1.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarN1.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadN1)],
                              nil];
    [numberToolbarN1 sizeToFit];
    _n1.inputAccessoryView = numberToolbarN1;
    
    
    UIToolbar* numberToolbarN2 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarN2.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarN2.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadN2)],
                              nil];
    [numberToolbarN2 sizeToFit];
    _n2.inputAccessoryView = numberToolbarN2;
    
    UIToolbar* numberToolbarN3 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarN3.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarN3.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadN3)],
                              nil];
    [numberToolbarN3 sizeToFit];
    _n3.inputAccessoryView = numberToolbarN3;
    
    UIToolbar* numberToolbarN4 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbarN4.barStyle = UIBarStyleBlackTranslucent;
    numberToolbarN4.items = [NSArray arrayWithObjects:
                              [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                              [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPadN4)],
                              nil];
    [numberToolbarN4 sizeToFit];
    _n4.inputAccessoryView = numberToolbarN4;
    
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
