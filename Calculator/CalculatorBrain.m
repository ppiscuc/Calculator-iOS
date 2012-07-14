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
//- (double) popOperand 
//{
//    NSNumber *operandObject = [self.programStack lastObject ];
//    //atentie sa nu crasuim programul, incarcand sa scoatem dintrun array gol
//    if (operandObject != nil) [ self.programStack removeLastObject ];
//    return [ operandObject doubleValue ];
//}
- (void)pushOperand:(double)operand{
    NSNumber * operandObject = [ NSNumber numberWithDouble:operand ];
    [ self.programStack addObject:operandObject ]; //nu e bun cu operand, ca nu e obiect, asa ca tre sa ii fac un wrapper
    // trebuie sa ma asigur in getter ca nu fac operatii pe operandStack cand e nil, ca altfel nu se intampla nimica
    
}
// nu @syntesize program, ci implementez doar getterul
- (id) program
{
    return [ self.programStack copy ]; //e un snapshot, o copie
}

+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement in assignment 2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [ stack lastObject ];
    if (topOfStack) [stack removeLastObject ];//rezultatul poate fi NSNumber sau NSString
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack; // asign de id la string, si compilerul nu are nici o problema. eu tre sa stiu ce fac
        
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
+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy]; // program e ID
    }
    return [self popOperandOffStack:stack];
}

- (double)performOperation:(NSString*) operation{
    
    [ self.programStack addObject:operation ];
    return [CalculatorBrain runProgram:self.program ];
}
    //calculam rezultat in functie de operatie
        //[self pushOperand:result ];
    // punem inapoi pe stiva
    //nu mai e nevoie, din cauza implementarii recursivitatii [ self pushOperand:result ];

@end
