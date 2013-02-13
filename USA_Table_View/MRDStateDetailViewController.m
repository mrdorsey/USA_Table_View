//
//  MRDStateListViewController.m
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/11/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDStateData.h"
#import "MRDStateDetailViewController.h"
#import "MRDStateListViewController.h"

@interface MRDStateDetailViewController ()

@end

@implementation MRDStateDetailViewController

#pragma mark custom accessors

- (void)setStateData:(MRDStateData *)stateData;
{
	_stateData = stateData;
	
	self.title = [NSString stringWithFormat:@"%@ (%@)", stateData.name, stateData.abbreviation];
	
	UIImageView *headerImageView = [[UIImageView alloc] initWithImage:[self.stateData imageWithSize:MRDStateDataImageSizeLarge]];
	headerImageView.contentMode = UIViewContentModeCenter;
	self.tableView.tableHeaderView = headerImageView;
	
	if([self isViewLoaded]) {
		[self.tableView reloadData];
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"States";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	switch (section) {
		case 0: return 2;
		case 1: return 1;
		case 2: return 2;
		default: return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString * const kMRDStateDetailViewCellIdentifier = @"MRDStateDetailViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMRDStateDetailViewCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kMRDStateDetailViewCellIdentifier];
	}
	
	// City Section
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Capital";
				cell.detailTextLabel.text = self.stateData.capital;
				break;
			case 1:
				cell.textLabel.text = @"Most Populous";
				cell.detailTextLabel.text = self.stateData.populousCity;
				break;
			default:
				cell.textLabel.text = nil;
				cell.detailTextLabel.text = nil;
				break;
		}
	}
	else if (indexPath.section == 1) {
		assert(indexPath.row == 0);
		
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterMediumStyle];
		[formatter setTimeStyle:NSDateFormatterNoStyle];
		
		cell.textLabel.text = @"Statehood";
		cell.detailTextLabel.text = [formatter stringFromDate:self.stateData.date];
	}
	else if (indexPath.section == 2) {
		NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
		[formatter setUsesGroupingSeparator:YES];
		[formatter setGroupingSize:3];
		
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Population";
				cell.detailTextLabel.text = [formatter stringFromNumber:self.stateData.population];
				break;
			case 1:
				cell.textLabel.text = @"Area (sq. mi.)";
				cell.detailTextLabel.text = [formatter stringFromNumber:self.stateData.area];
				break;
			default:
				cell.textLabel.text = nil;
				cell.detailTextLabel.text = nil;
				break;
		}
	}
	else {
		cell.textLabel.text = nil;
		cell.detailTextLabel.text = nil;
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	if (section == 0) {
		return @"Cities";
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
{
	if (section == 2) {
		return @"Population and largest city based on 2010 census data";
	}
	
	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	// disallow selection
	return nil;
}



@end
