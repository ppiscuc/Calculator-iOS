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
@synthesize variables = _variables;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

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
    //@"" constant string     // nu %s, ca e un char * 
    // avem nevoie de %@, ca e un obiect, la care trimite mesajul "descriptiion", care returneaza un NSString
    NSLog(@"digit pressed = %@", digit);// or variable
    //UILabel *myDisplay = self.display; // GETTER [ self display ];
    //NSString *currentText = myDisplay.text; // [ myDisplay text ];//da-mi textul
    // daca tii apasat CTRL vezi documentatia, si obserivi ca text e si el getter
    // new text
    //NSString *newText = [ currentText stringByAppendingString:digit ];
    //[ myDisplay setText:newText ]; asta e setter pt getterul de mai sus, deci
    //myDisplay.text = newText;
    //totul se reduce la:
    //self.alldata.text = [ self.alldata.text stringByAppendingString:digit ];
    self.alldata.text = [CalculatorBrain descriptionOfProgram:digit ]; // TODO
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [ self.display.text stringByAppendingString:digit ];
    }
    else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        }
    }
//+++++++++++++++++++++

//+++++++++++++++++++++
- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
    [self syncronizeView];
}
- (IBAction)undoPressed:(id)sender {
    //daca introduce un numar, stergem ultima cifra
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
        //daca nu am ramas cu nimic
        if ( [self.display.text isEqualToString:@""] || 
            [self.display.text isEqualToString:@"-"]) {
            [self syncronizeView];
        }
    } else {
        //remote last item from the stack and syncronize view
        [self.brain removeLastItem];
        [self syncronizeView];
    }
}

//+++++++++++++++++++++++++++++++
- (IBAction)enterPressed {
    double valoareApasata = [ self.display.text doubleValue];
    [ self.brain pushOperand:valoareApasata];
    self.userIsInTheMiddleOfEnteringANumber = NO;// logic ca n umai sunt in mijlocul introducerii unui numar
}//++++++++++++++++++++++++++
- (IBAction)operationPressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber) [ self enterPressed ]; //?
    self.alldata.text = [ CalculatorBrain descriptionOfProgram:sender.currentTitle]; // TODO
    double result = [ self.brain performOperation:sender.currentTitle ];
    NSString *resultString = [ NSString stringWithFormat:@"%g", result ];
    self.display.text = resultString;
}
-(void) syncronizeView {
    //find the result of the test case run
    double result = [ CalculatorBrain runProgram:self.brain.program
                             usingVariableValues:self.testVariableValues];
    
    //if result string, display it, else put number description
    // if ([result isKindOfClass:[NSString class]]) {
    //     self.display.text = result;
    // }
    //  else {
    self.display.text = [NSString stringWithFormat:@"%g", result ];
    // }
    //now put the description of the program
    self.alldata.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    //dumping the variables
    self.variables.text = [[self programVariableValues] description ];
    //and the user is not in the middle of entering a number
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
}- (IBAction)test3Pressed:(id)sender {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:-4],@"x",
                               [NSNumber numberWithDouble:3], @"a",
                               [NSNumber numberWithDouble:4], @"b", nil];
    [self syncronizeView];
}
- (IBAction)test4Pressed:(id)sender {
    //one number provided
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:-5], @"x", nil];
    [self syncronizeView];
}
- (IBAction)testNilPressed:(id)sender {
    self.testVariableValues = nil;
    [self syncronizeView];
}

- (IBAction)testCase:(UIButton *)sender {
    
    //geting an instance of the brain
    CalculatorBrain *testBrain = [self brain];
    
    //setup the brain
    [testBrain pushVariable:@"a"];
    [testBrain pushVariable:@"a"];
    [testBrain pushOperation:@"*"];
    [testBrain pushVariable:@"b"];
    [testBrain pushVariable:@"b"];
    [testBrain pushOperation:@"*"];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperation:@"sqrt"];
    
    // retrieve the program
    NSArray *program = testBrain.program;
    
    //Setup the dictionary
    NSDictionary *dictionary = 
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithDouble:3], @"a",
     [NSNumber numberWithDouble:4], @"b", nil];
    
    //run thr program with variables
    double rezultat = [CalculatorBrain runProgram:program usingVariableValues:dictionary];
    NSLog(@"running the program with variables returns the value %g",
          rezultat);
    NSString *rezultatString = [NSString stringWithFormat:@"%g", rezultat ];
    self.display.text = rezultatString;
    
    //list the variables 
    NSLog(@"variables used in the program are: %@",
          [[CalculatorBrain variablesUsedInProgram:program] description]);
}
- (IBAction)testCaseForDescription:(id)sender {
    CalculatorBrain *testBrain = [self brain];
    
    //test a
    [testBrain pushOperand:3];
    [testBrain pushOperand:5];
    [testBrain pushOperand:6];
    [testBrain pushOperand:7];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperation:@"*"];
    [testBrain pushOperation:@"-"];
    
    //test b
    [testBrain pushOperand:3];
    [testBrain pushOperand:5];
    [testBrain pushOperation:@"+"];
    [testBrain pushOperation:@"sqrt"];
    
    // print the description
    NSLog(@"Program is: %@", [CalculatorBrain descriptionOfProgram:[testBrain program]]);
    //Program is: sqrt(3 + 5),3 - 5 * (6 + 7)
}
//--------
-(NSDictionary *) programVariableValues {
    //find the variables
    NSArray *variableArray = [[CalculatorBrain variablesUsedInProgram:self.brain.program] allObjects ];
    //return description of fict with key->values
    return [self.testVariableValues dictionaryWithValuesForKeys:variableArray];
}


- (void)viewDidUnload {
    [self setAlldata:nil];
    [self setVariables:nil];
    [super viewDidUnload];
}
@end
