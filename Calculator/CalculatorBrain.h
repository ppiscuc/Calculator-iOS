//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString*) operation;

@property (readonly) id program;

+ (double)runProgram:(id)program; // nu schimba implementarea

+ (NSString *)descriptionOfProgram:(id)program; // nu schimba implementarea

@end
