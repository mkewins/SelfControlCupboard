//
//  ViewController.h
//  SnackAttack
//
//  Created by Adrian Kovacevic on 2016-04-16.
//  Copyright © 2016 Adrian Kovacevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler;
-(void)updateHealthData;
-(void)updateHealthDataOnInterval:(NSTimer*) timer;
-(void)stopUpdatingHealthData;
-(void)startUpdatingHealthData;
@property NSTimer *healthDataTimer;

@end

