//
//  ViewController.m
//  WeatherClass
//
//  Created by Jitender Badlani on 7/22/15.
//  Copyright (c) 2015 Jitender Badlani. All rights reserved.
//

#import "ViewController.h"
#import  "AFNetworking.h"

static NSString* const BaseURLString = @"http://www.vikingcomputerconsulting.com/weather_sample/";

@interface ViewController ()

@property (nonatomic, strong) NSDictionary *weather;
@property(nonatomic, strong)NSDictionary *currentConditions;
//@property (nonatomic,strong)NSArray *keyArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *string = [NSString stringWithFormat:@"%@weather.php?format=json", BaseURLString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation
     setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        
        // 3
        self.weather = (NSDictionary *)responseObject;
        
        NSDictionary *tmpDict = [[NSDictionary alloc] initWithDictionary:[self.weather valueForKey:@"data"]];
        //NSArray *cCArray = [tmpDict objectForKey:@"current_condition"];
        self.currentConditions = [[tmpDict objectForKey:@"current_condition"] objectAtIndex:0];
        self.title = @"JSON Retrieved";
        [self.tableView reloadData];
        
        
        //self.keyArray = [[cCArray objectAtIndex:0] allKeys];
        //self.valueArray = [[cCArray objectAtIndex:0] allValues];
        //NSArray *valueArray = [dictionary allValues];
        //self.currentConditions = [NSArray arrayWithObject:tmpDict];
        //tmpDict valueForKey:@"current_condition"];
        //NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.weather options:0 error:nil];

    }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [operation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark Table View stuff

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.currentConditions.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:SimpleTableIdentifier];
    }
    if(self.currentConditions != nil)
    {
        NSArray *keyArray = [self.currentConditions allKeys];
        
        NSString *key = [keyArray objectAtIndex:indexPath.row];
        
        if([[self.currentConditions valueForKey:key] isKindOfClass:[NSString class]])
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", key, [self.currentConditions valueForKey:key]];
        }
        else
        {
            //if value is array, loop through the value
            NSArray *arrayValue = [self.currentConditions valueForKey:key];
            NSMutableString *concatenatedString = [NSMutableString stringWithCapacity:1000];
            for (int i = 0; i<arrayValue.count; i++) {
                [concatenatedString appendString:[[arrayValue objectAtIndex:i] valueForKey:@"value"]];
                if(i + 1 < arrayValue.count)
                {
                    [concatenatedString appendString:@", "];
                }
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", key, concatenatedString];
        }
    }
    return cell;
    
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
     
     if(cell == nil)
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:SimpleTableIdentifier];
     }
     //old way do it  --> cell.
     
     // NSString *weatherAttributes = [[NSString alloc]initWithString:[self.currentConditions objectAtIndex:indexPath.row]];
     
     //NSString *key = [self.currentConditions allKeys][indexPath.row];
     //NSArray *keyArray = [self.currentConditions allKeys];
     
     NSDictionary *myDictKey = [self.keyArray objectAtIndex:indexPath.row];
     NSDictionary *myDictValue = [self.valueArray objectAtIndex:indexPath.row];
     //NSLog(@"The key name is: %@", myDict);
     
     //cell.textLabel.text = [[myDict objectsForKey:@"key" string:<#(id)#>]
     //cell.textLabel.text =
     //NSLog(@"Weather Data is: %@", weatherAttributes);
     //NSLog(@"WeatherData is :)
     
     cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", myDictKey,myDictValue];
     
     return cell;
     
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
     if(cell == nil)
     {
     cell = [[UITableViewCell alloc]
     initWithStyle:UITableViewCellStyleDefault
     reuseIdentifier:SimpleTableIdentifier];
     
     
     }*/
}


@end
