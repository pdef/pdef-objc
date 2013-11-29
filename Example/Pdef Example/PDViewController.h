//
//  PDViewController.h
//  Pdef Example
//
//  Created by Ivan Korobkov on 29.11.13.
//  Copyright (c) 2013 Pdef. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *json;
@property (weak, nonatomic) IBOutlet UITextView *rpcResult;

@end
