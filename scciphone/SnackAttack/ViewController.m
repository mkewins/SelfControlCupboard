//
//  ViewController.m
//  SnackAttack
//
//  Created by Adrian Kovacevic on 2016-04-16.
//  Copyright © 2016 Adrian Kovacevic. All rights reserved.
//

#import "ViewController.h"
#import <Firebase/Firebase.h>
@import HealthKit;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *goalLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentGoalProgress;
@property (weak, nonatomic) IBOutlet UILabel *calorieLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCalorieProgress;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong) HKHealthStore *healthStore;
@property (strong) Firebase *myRootRef;

@property NSMutableDictionary *healthData;
@property HKQuantityType *stepCountType;
@property HKSampleType *basalCalorieType;
@end

@implementation ViewController


- (void)updateHealthData {
    __block NSInteger totalSteps = 0;
    __block NSInteger totalCalories = 0;
    __block NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss"];
    
    if ([HKHealthStore isHealthDataAvailable]) {
        self.healthStore = [[HKHealthStore alloc] init];
        NSSet<HKSampleType*> *readTypes = [NSSet setWithObjects:_stepCountType, _basalCalorieType, nil];
        [_healthStore requestAuthorizationToShareTypes:nil readTypes:readTypes completion:^(BOOL success, NSError * _Nullable error) {
        }];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        
        NSDate *startDate = [calendar dateFromComponents:components];
        
        NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
        
        NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
        
        HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:_stepCountType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            if (!results) {
                NSLog(@"An error occured fetching the user's steps. The error was: %@.", error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (HKQuantitySample *sample in results) {
                    totalSteps += [sample.quantity doubleValueForUnit:([HKUnit countUnit])];
                }
                [_currentGoalProgress setText:[NSString stringWithFormat:@"%ld", (long)totalSteps]];
                [_healthData setObject:[NSNumber numberWithInteger:totalSteps] forKey:@"steps"];
                [_myRootRef setValue:_healthData];
            });
        }];
        
        [_healthStore executeQuery:query];
        
        query = [[HKSampleQuery alloc] initWithSampleType:_basalCalorieType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:nil resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            if (!results) {
                NSLog(@"An error occured fetching the user's calories. The error was: %@.", error);
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (HKQuantitySample *sample in results) {
                    totalCalories += [sample.quantity doubleValueForUnit:([HKUnit calorieUnit])];
                }
                totalCalories /= 1000;
                [_currentCalorieProgress setText:[NSString stringWithFormat:@"%ld", (long)totalCalories]];
                [_healthData setObject:[NSNumber numberWithInteger:totalCalories] forKey:@"calories"];
                [_myRootRef setValue:_healthData];
            });
        }];
        
        [_healthStore executeQuery:query];
    }
    now = [NSDate date];
    NSLog(@"Updated Firebase at: %@", [formatter stringFromDate:now]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View loaded");
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"LaunchImage"]]];

    
    _stepCountType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    _basalCalorieType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierBasalEnergyBurned];
    [_goalLabel setText:@"Steps"];
    [_calorieLabel setText:@"Calories"];
    [_titleLabel setText:@"SNACKATTACK"];
    [_subtitleLabel setText:@"The Self-Control Kitchen Cupboard"];
    _myRootRef = [[Firebase alloc] initWithUrl:@"https://snackattack.firebaseio.com/iphone"];
    _healthData = [[NSMutableDictionary alloc] init];
    [self updateHealthData];    
//    [self updateHealthData];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) updateHealthDataOnInterval:(NSTimer*) timer {
    [self updateHealthData];
}


-(void)fetchNewDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [self updateHealthData];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)startUpdatingHealthData {
    [self performSelectorOnMainThread:@selector(startTimer) withObject:nil waitUntilDone:YES];
    
}

- (void)stopUpdatingHealthData {
    [self performSelectorOnMainThread:@selector(stopTimer) withObject:nil waitUntilDone:YES];

}

- (void)startTimer {
    _healthDataTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateHealthDataOnInterval:) userInfo: nil repeats: YES];
}

- (void)stopTimer {
    [_healthDataTimer invalidate];
    _healthDataTimer = nil;
}


@end
