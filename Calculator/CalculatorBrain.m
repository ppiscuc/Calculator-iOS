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
- (void)pushOperand:(double)operand{
    NSLog(@"Digit pressed = %@", operand);
    
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
    // checking to see if push a variable or a number
    //NSNumber *convertedNumber = [NSNumber numberWithInt:[operand intValue]];
    //NSLog(@"converted value: %@", convertedNumber);
    //if ([convertedNumber intValue] != 0) {
            //hit a digit
      //  NSLog(@"hit a digit: %@", convertedNumber);
        //    [ self.programStack addObject:convertedNumber ];
       // }
       // else {
            // hit a variable
       //     NSLog(@"hit a variable: %@", operand);
       // [ self.programStack addObject:operand ]; //nu e bun cu operand, ca nu e obiect, asa ca tre sa ii fac un wrapper // trebuie sa ma asigur in getter ca nu fac operatii pe operandStack cand e nil, ca altfel nu se intampla nimica
   // }
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
    if (![program isKindOfClass:[NSArray class]]) return 0;
    
    NSMutableArray *stack = [ program mutableCopy];
    NSMutableArray *expressionArray = [ NSMutableArray array];
    
    //recursion
    while (stack.count > 0) {
        [expressionArray addObject:[self deBracket:[self descriptionOfTopOfStack:stack]]];
    }
    return [expressionArray componentsJoinedByString:@","];
    
}
//----------------
// helper function
+ (NSString *)deBracket:(NSString *)expression {
    NSString *description = expression;
    
    //daca exista deja niste parateze, eliminale si returneaza
    if ([expression hasPrefix:@"("] && [expression hasSuffix:@")"]) {
        description = [ description substringFromIndex:1];
        description = [ description substringToIndex:[description length] - 1];
    }
    // sa avem grija ca atunci cand le eliminam sa nu ajungem la cazul
    // a+b) * (c +d ; daca avem asa ceva, le adaugam inapoi
    NSRange openBracket = [description rangeOfString:@"("];
    NSRange closeBracket = [description rangeOfString:@")"];
    
    if ( openBracket.location <= closeBracket.location ) return  description;
    else return expression;
}
//--------------------------
+ (BOOL) isNoOperandOrOperation:(NSString *)value {
    NSSet *operationSet = [NSSet setWithObjects:@"?",nil];
    return [ operationSet containsObject:value ];
}
+(BOOL) isOneOperandOperation:(NSString *)value {
    NSSet *operationSet = [NSSet setWithObjects:@"sin",@"cos",@"sqrt",@"+-", nil];
    return [ operationSet containsObject:value];
}
+(BOOL) isTwoOperandOperation: (NSString *)value {
    NSSet *operationSet = [NSSet setWithObjects:@"+",@"-",@"*",@"/", nil];
    return [ operationSet containsObject:value];
}
+(BOOL) isOperation2:(NSString *)operation {
    return 
    [ self isNoOperandOrOperation:operation ] ||
    [ self isOneOperandOperation:operation ] ||
    [ self isTwoOperandOperation:operation ];
}
//----------------
+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {
    //similar cu popOperandOfStack
    NSLog(@"parsing the description");
    
    NSString *description;
    
    id topOfStack = [ stack lastObject ];
    if (topOfStack) [ stack removeLastObject]; else return @"";
    
    //daca e numar il lasam asa - il returnam ca si nsstring
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        return [topOfStack description ];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        //need to do some formatting
        //daca este un no operand operation, sau daca e variabila, il lasam asa
        if (![self isOperation:topOfStack] || [self isNoOperandOrOperation:topOfStack]) {
            description = topOfStack;
        }
        //daca e doar 1 operand, sa facem ceva de genul f(x)
        else if ([self isOneOperandOperation:topOfStack]) {
            NSString *x=[ self deBracket:[self descriptionOfTopOfStack:stack]];
            description = [NSString stringWithFormat:@"%@(%@)", topOfStack, x];
        }
        //daca e cu 2 operatii, atunci returnam ceva de genul a + b
        else if ([self isTwoOperandOperation:topOfStack]) {
            NSString *y = [self descriptionOfTopOfStack:stack];
            NSString *x = [self descriptionOfTopOfStack:stack];
            
            // daca e + sau * trebuie sa luam in considerare precedenta
            if ([topOfStack isEqualToString:@"+"] || [topOfStack isEqualToString:@"-"]) {
                    description = [NSString stringWithFormat:@"(%@ %@ %@)",
                                   [self deBracket:x], topOfStack, [self deBracket:y]];
            }
            // altfel avem deaface cu * sau /
            else {
                description = [ NSString stringWithFormat:@"%@ %@ %@", 
                               x, topOfStack, y];
            }
        }
    }
    return  description;
}
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
//----------------------------
-(void)removeLastItem {
    [self.programStack removeLastObject];
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

