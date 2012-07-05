//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Paul on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
// aici declar chestii private
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
// includ modelul
@property (nonatomic, strong) CalculatorBrain *brain;// pointer catre Model

@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize alldata = _alldata;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

// facem layy instantionation
- (CalculatorBrain *) brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
// set-erul propietatii e checmat de iOS ca sa afiseze pe ecran
// get-ul il apelam noi, ca sa luam pointerul, si sa ii trimitem mesaje

// stabilim targetul din controller care sa il acceseze
//viewel cand e apasat butonul

// id = pointe r to unknown class of object
//IBAction e practic void. E pt XCODE

// cand dai copy / paste la buton, ii copie si target action
- (IBAction)digitPressed:(UIButton *)sender {
    NSString * digit = [ sender currentTitle ];
    //logging
    //e o functie
    //@"" constant string
    // nu %s, ca e un char * 
    // avem nevoie de %@, ca e un obiect, la care trimite mesajul "descriptiion", 
    // care returneaza un NSString
    NSLog(@"digit pressed = %@", digit);
    // sa luam displayul 
    //UILabel *myDisplay = self.display; // GETTER [ self display ];
    //NSString *currentText = myDisplay.text; // [ myDisplay text ];//da-mi textul
    // daca tii apasat CTRL vezi documentatia, si obserivi ca text e si el getter
    // new text
    //NSString *newText = [ currentText stringByAppendingString:digit ];
    //[ myDisplay setText:newText ]; asta e setter pt getterul de mai sus, deci
    //myDisplay.text = newText;
    //totul se reduce la:
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [ self.display.text stringByAppendingString:digit ];
        self.alldata.text = [ self.alldata.text stringByAppendingString:digit ];
    }
else {
    self.display.text = digit;
    self.alldata.text = [ self.alldata.text stringByAppendingString:digit ];
    self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}
- (IBAction)enterPressed {
    //NSString *value = self.display.text;
    //if ( [value isEqualToString:@"."]) value = [ NSString stringWithFormat:@"%d", 10 ]; // daca am punct, pun 10
    [ self.brain pushOperand:[self.display.text doubleValue ]];
    // logic ca n umai sunt in mijlocul introducerii unui numar
    self.userIsInTheMiddleOfEnteringANumber = NO;
}
- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) [ self enterPressed ]; //?
    self.alldata.text = [ self.alldata.text stringByAppendingString:sender.currentTitle ];
    if (sender.currentTitle != @"C") {
        double result = [ self.brain performOperation:sender.currentTitle ];
        NSString *resultString = [ NSString stringWithFormat:@"%g", result ];
        self.display.text = resultString;
    }
    else {
        self.display.text = [ NSString stringWithFormat:@"%d",0 ];
    }
}
- (void)viewDidUnload {
    [self setAlldata:nil];
    [super viewDidUnload];
}
@end
