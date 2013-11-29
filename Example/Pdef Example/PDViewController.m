//
//  PDViewController.m
//  Pdef Example
//
//  Created by Ivan Korobkov on 29.11.13.
//  Copyright (c) 2013 Pdef. All rights reserved.
//

#import "PDViewController.h"
#import "WorldPackage.h"

@interface PDViewController ()

@end

@implementation PDViewController {
    WorldClient *world;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self displayJohn];
    [self accessTheWorld];
}

- (void)displayJohn {
    // Create a new human.
    Human *human = [[Human alloc]init];
    human.id = 1;
    human.name = @"John";
    human.sex = Sex_MALE;
    human.continent = ContinentName_EUROPE;
    
    // Serialize a human to a JSON string.
    NSError *error = nil;
    NSData *humanData = [human toJsonError:&error];
    NSString *humanJson = [[NSString alloc] initWithData:humanData
                                                encoding:NSUTF8StringEncoding];
    
    self.name.text = @"John";
    self.json.text = humanJson;
}

- (void)accessTheWorld {
    // Create a world HTTP RPC client.
    if (!world) {
        PDRpcClient *client = [[PDRpcClient alloc]
            initWithDescriptor:WorldDescriptor()
                               baseUrl:@"http://example.com/world"];
        world = [[WorldClient alloc] initWithHandler:client];
    }
    
    // Switch the light.
    [world switchDayNightCallback:^(id result, NSError *error) {
        NSLog(@"Switched the light");
    }];
    
    // List the first ten people.
    [[world humans] allLimit:10 offset:0 callback:^(id result, NSError *error) {
        if (error) {
            self.rpcResult.text = error.localizedDescription;
        } else {
            NSArray *humans = result;
            for (Human *h in humans) {
                NSLog(@"%@", h.name);
            }
        }

    }];
}
@end
