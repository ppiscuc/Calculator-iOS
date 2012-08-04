//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Paul on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(NSString*)operand;//primim numere si variabile
- (double)performOperation:(NSString*) operation;
- (void)pushVariable:(NSString *) variable;
- (void)pushOperation:(NSString *)operation;

@property (readonly) id program;// ramane la fel	

+ (double)runProgram:(	id)program; 

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;

+ (NSString *)descriptionOfProgram:(id)program; 

+ (NSSet *)variablesUsedInProgram:(id)program;

@end
