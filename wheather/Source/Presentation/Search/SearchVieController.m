//
//  SearchVieController.m
//  wheather
//
//  Created by Joe Franc on 10/11/17.
//  Copyright © 2017 Joe Franc. All rights reserved.
//

#import "SearchVieController.h"
#import "WANetworkManager.h"
#import "WANetworkingManagerDay.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "detailControllTableViewController.h"
#import "detailTableViewCell.h"
#import <MagicalRecord/MagicalRecord.h>
#import "City+CoreDataClass.h"
#import "City+CoreDataProperties.h"



static NSInteger const kcelsius = 273.15;
static NSString const * kcels = @"\u00B0";
static NSString const * kimageIcon = @"http://openweathermap.org/img/w/";

@interface SearchVieController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SDWebImageManagerDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBarCity;
@property (strong, nonatomic) IBOutlet UITableView *tableVIewSearch;
@property (strong, nonatomic) IBOutlet UILabel *cityLable;
@property (strong, nonatomic) IBOutlet UILabel *tempLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *cloudsLabel;
@property (strong, nonatomic) IBOutlet UILabel *descrLabel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailsViewController;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) NSString * selectedCell;
@end

@implementation SearchVieController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchBarCity.delegate = self;
    self.tableVIewSearch.delegate = self;
    self.tableVIewSearch.dataSource = self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchNotes];
    [self.tableVIewSearch reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
}


- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBarCity resignFirstResponder];

    [[WANetworkManagerDay sharedInstance] loadWeatherForTownDay:_searchBarCity.text completion:^(NSDictionary *resposeData) {
        NSNumber * temperatureNumber = [[resposeData valueForKey:@"main"]objectForKey:@"temp"];
        temperatureNumber = @([temperatureNumber integerValue] - kcelsius);
        NSString * temperatureString = [temperatureNumber stringValue];
        self.cityLable.text = [resposeData objectForKey:@"name"];
        self.tempLabel.text = [NSString stringWithFormat: @"%@%@",temperatureString,kcels];
        NSString *numberIcon = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
        NSLog(@"%@=====", numberIcon);
        NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:url]];
        NSNumber *numberWind = [[resposeData valueForKey:@"wind"]objectForKey:@"speed"];
        self.windLabel.text = [NSString stringWithFormat:@"wind: %@ m/s",numberWind];
        NSNumber *numberClouds = [[resposeData valueForKey:@"clouds"]valueForKey:@"all"];
        self.cloudsLabel.text = [NSString stringWithFormat:@"clouds: %@ %%",numberClouds];
        NSString * descriprions = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"description"];
        self.descrLabel.text = descriprions;
        
    }];
    
}

- (void)fetchNotes {
    self.cityArray = [NSMutableArray arrayWithArray:[City MR_findAll]];
}

- (IBAction)addCity:(id)sender {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * localContext) {
    
        City *cityName = [City MR_createEntity];
        cityName.cityID = _cityLable.text;
        NSLog(@"%@", cityName);
        NSLog(@"%@", _cityArray);
        NSLog(@"%lu", (unsigned long)_cityArray.count);
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        [self.tableVIewSearch reloadData];
    }];
  
}

- (IBAction)tapEditBtn:(id)sender{
    [_tableVIewSearch setEditing:YES animated:YES];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *cellIden;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIden"];
    if(cell == nil) {
    cell = [[UITableViewCell new] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    City *city = [self.cityArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[city cityID]];
    

    return cell;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete){
        City *city = [self.cityArray objectAtIndex:indexPath.row];
        [city MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        [self.cityArray removeObjectAtIndex:indexPath.row];
        [_tableVIewSearch deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedCell = [[[tableView cellForRowAtIndexPath:indexPath]textLabel]text];
    NSLog(@"%@",_selectedCell);
    [[WANetworkManagerDay sharedInstance] loadWeatherForTownDay:_selectedCell completion:^(NSDictionary *resposeData) {
        //          self.cityLable.text = [resposeData valueForKeyPath:@"city.name"];
        NSNumber * temperatureNumber = [[resposeData valueForKey:@"main"]objectForKey:@"temp"];
        temperatureNumber = @([temperatureNumber integerValue] - kcelsius);
        NSString * temperatureString = [temperatureNumber stringValue];
        self.cityLable.text = [resposeData objectForKey:@"name"];
        self.tempLabel.text = [NSString stringWithFormat: @"%@%@",temperatureString,kcels];
        NSString *numberIcon = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"icon"];
        NSLog(@"%@=====", numberIcon);
        NSString *url = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",numberIcon];
        [self.iconImg sd_setImageWithURL:[NSURL URLWithString:url]];
        NSNumber *numberWind = [[resposeData valueForKey:@"wind"]objectForKey:@"speed"];
        self.windLabel.text = [NSString stringWithFormat:@"wind: %@ m/s",numberWind];
        NSNumber *numberClouds = [[resposeData valueForKey:@"clouds"]valueForKey:@"all"];
        self.cloudsLabel.text = [NSString stringWithFormat:@"clouds: %@ %%",numberClouds];
        NSString * descriprions = [[[resposeData valueForKey:@"weather"]objectAtIndex:0]valueForKey:@"description"];
        self.descrLabel.text = descriprions;
        
        
        
        
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"detailWeather"]){
         detailControllTableViewController*vc = segue.destinationViewController;
        vc.detailSearchBarCity = _cityLable.text;
        
    }
}


@end
