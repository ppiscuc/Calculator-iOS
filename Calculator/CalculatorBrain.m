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
@property (nonatomic, strong) NSMutableArray *operandStack;

@end



@implementation CalculatorBrain
// trebuie sa implementam proprietarea de mai sus, cu getter si setter
@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack
{
    if (_operandStack == nil) _operandStack = [[NSMutableArray alloc] init ];//aloc,ca
    //sa ma asigur ca nu e niciodata nill
    return _operandStack;
}
- (void)setOperandStack:(NSMutableArray *)operandStack
{
    _operandStack = operandStack;
}
- (double) popOperand 
{
    NSNumber *operandObject = [self.operandStack lastObject ];
    //atentie sa nu crasuim programul, incarcand sa scoatem dintrun array gol
    if (operandObject != nil) [ self.operandStack removeLastObject ];
    return [ operandObject doubleValue ];
}
- (void)pushOperand:(double)operand{
    NSNumber * operandObject = [ NSNumber numberWithDouble:operand ];
    [ self.operandStack addObject:operandObject ]; //nu e bun cu operand, ca nu e obiect, asa ca tre sa ii fac un wrapper
    // trebuie sa ma asigur in getter ca nu fac operatii pe operandStack cand e nil, ca altfel nu se intampla nimica
    
}
- (double)performOperation:(NSString*) operation{
    double result = 0;
    //calculam rezultat in functie de operatie
    if ([operation isEqualToString:@"+" ]) {
        return [ self popOperand ] + [ self popOperand ];
    }
    // si acum trimit un MESAJ LA UN CONSTANT STRING
    else if ([ @"*" isEqualToString:operation])
    {
        return [ self popOperand ] * [ self popOperand ];
    }
    else if ([operation isEqualToString:@"-" ]) 
    {
        double secondOperand = [ self popOperand ];
        return [ self popOperand ] - secondOperand;
    }
    else if ([ operation isEqualToString:@"/"])
    {
        double divide = [ self popOperand ];
        if (divide) return [self popOperand ] / divide; // evitam impartirea la 0
    }
    
    [self pushOperand:result ];
    // punem inapoi pe stiva
    [ self pushOperand:result ];
    
    return result;
    
}

@end
