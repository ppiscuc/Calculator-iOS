//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Paul on 01/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *alldata;
@property (weak, nonatomic) IBOutlet UILabel *variables;
@property (weak, nonatomic ) IBOutlet NSDictionary *testVariableValues;

@end
	