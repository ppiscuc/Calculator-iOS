//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Paul on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
// aici definim chestii private
@property (nonatomic, strong) NSMutableArray *programStack; 

@end



@implementation CalculatorBrain
// trebuie sa implementam proprietarea de mai sus, cu getter si setter
@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init ];//aloc,ca
    //sa ma asigur ca nu e niciodata nill
    return _programStack;
}
- (void)setProgramStack:(NSMutableArray *)programStack
{
    _programStack = programStack;
}
//------------------
- (void)pushOperand:(NSString*)operand{
    NSLog(@"Digit pressed = %@", operand);
    
    // checking to see if push a variable or a number
    NSNumber *convertedNumber = [NSNumber numberWithInt:[operand intValue]];
    NSLog(@"converted value: %@", convertedNumber);
    if ([convertedNumber intValue] != 0) {
            //hit a digit
        NSLog(@"hit a digit: %@", convertedNumber);
            [ self.programStack addObject:convertedNumber ];
        }
        else {
            // hit a variable
            NSLog(@"hit a variable: %@", operand);
        [ self.programStack addObject:operand ]; //nu e bun cu operand, ca nu e obiect, asa ca tre sa ii fac un wrapper // trebuie sa ma asigur in getter ca nu fac operatii pe operandStack cand e nil, ca altfel nu se intampla nimica
    }
}
//-----------------
- (void)pushVariable:(NSString *)variable{
    NSLog(@"pushing variable: %@", variable);
    [self.programStack addObject:variable];
}
//----------------
// nu @syntesize program, ci implementez doar getterul
- (id) program
{
    return [ self.programStack copy ]; //e un snapshot, o copie
}
//-----------
+ (NSString *)descriptionOfProgram:(id)program
{
    //human readable description of program pana intr-un anumit moment
    return @"not implemented";
}
//----------------
//-----
+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    NSLog(@"poping elements from stack");
    double result = 0;
    
    id topOfStack = [ stack lastObject ];
    if (topOfStack) [stack removeLastObject ];//rezultatul poate fi NSNumber sau NSString
    NSLog(@"%@", topOfStack);
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack; // asign de id la string, si compilerul nu are nici o problema. eu tre sa stiu ce fac
        NSLog(@"operation: %@", operation);
        if ([operation isEqualToString:@"+" ]) {
            return [ self popOperandOffStack:stack ] + [ self popOperandOffStack:stack ];
        } // si acum trimit un MESAJ LA UN CONSTANT STRING
        else if ([ @"*" isEqualToString:operation]) {
            return [ self popOperandOffStack:stack ] * [ self popOperandOffStack:stack ];
        }
        else if ([operation isEqualToString:@"-" ]) {
            double secondOperand = [ self popOperandOffStack:stack ];
            return [ self popOperandOffStack:stack ] - secondOperand;
        }
        else if ([ operation isEqualToString:@"/"]){
            double divide = [ self popOperandOffStack:stack ];
            if (divide) return [self popOperandOffStack:stack ] / divide; // evitam impartirea la 0
        } 
        else if ([operation isEqualToString:@"sin"]){
            return sin([self popOperandOffStack:stack ]);
            
        }
        else if ([operation isEqualToString:@"cons"]){
            return cos([self popOperandOffStack:stack ]);
            
        }
        else if ([operation isEqualToString:@"sqrt"]){
            double numb = [ self popOperandOffStack:stack ];
            if (numb > 0) {
                return sqrt(numb);
            }
            else {
                return 0; //ca asa vrem noi
            }
        } else if ([operation isEqualToString:@"pi"]) {
            // nu iau nimic de pe stiva
            return M_PI;
        }

    }
    return result;
}
//----------

//--------------

+ (BOOL)isOperation:(NSString *)operation
{
    NSSet *supportedOperations = [[ NSSet alloc] 
                                  initWithObjects:@"+",@"-",@"/",@"*",@"sqrt",@"sin",@"cos",@"pi", nil];
    return [supportedOperations containsObject:operation];
    
}
//------------------------
+ (NSSet*)variablesUsedInProgram:(id)program
{
    // ne asiguram ca este nsarray
    if (![program isKindOfClass:[NSArray class]]) return nil;
    
    NSMutableSet *variables = [NSMutableSet set];
    
    //pentru orice item din program
    for (id obj in program) {
        //daca credem ca e variabila sa il punem in set
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            [variables addObject:obj];
        }
    }
    //return nil if no variables
    if ([variables count] == 0) return nil; else return [variables copy];//interesting 
}
//------------------------------
-(void) pushOperation:(NSString *)operation {
    [self.programStack addObject:operation];
}
//---------------------
+ (double) runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    //ne asiguram ca este nssarray
    if (![program isKindOfClass:[NSArray class]]) return  0;
    //facem o copiuta
    NSMutableArray *stack = [ program mutableCopy];
    
    //foreach item in the program
    for (int i=0; i < [stack count]; i++) {
        id obj = [ stack objectAtIndex:i];
        
        //verificam sa nu fie variabila
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            id value = [ variableValues objectForKey:obj];
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0 ];
            }
        [ stack replaceObjectAtIndex:i withObject:value ];
        }
    }
    //start popping of the stack
    return [self popOperandOffStack:stack];
}

//------------

+ (double)runProgram:(id)program
{
    return [self runProgram:program
        usingVariableValues:nil];   
}

//-------------------
- (double)performOperation:(NSString*) operation
{    
    [ self.programStack addObject:operation ];
    NSLog(@"running the program");
    return [CalculatorBrain runProgram:self.program ];
}
@end



//calculam rezultat in functie de operatie //[self pushOperand:result ];
// punem inapoi pe stiva nu mai e nevoie, din cauza implementarii recursivitatii [ self pushOperand:result ];
//- (double) popOperand 
//{
//    NSNumber *operandObject = [self.programStack lastObject ];
//    //atentie sa nu crasuim programul, incarcand sa scoatem dintrun array gol
//    if (operandObject != nil) [ self.programStack removeLastObject ];
//    return [ operandObject doubleValue ];

