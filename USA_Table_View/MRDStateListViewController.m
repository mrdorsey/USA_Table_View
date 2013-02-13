//
//  MRDStateListViewController.m
//  USA_Table_View
//
//  Created by Michael Dorsey on 2/11/13.
//  Copyright (c) 2013 Michael Dorsey. All rights reserved.
//

#import "MRDStateData.h"
#import "MRDStateDetailViewController.h"
#import "MRDStateFactory.h"
#import "MRDStateListViewController.h"
#import "NSArray+MRDExtensions.h"

@interface MRDStateListViewController ()

@property (nonatomic, strong) NSDictionary *sortedStates;
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation MRDStateListViewController

#pragma mark custom accessors

- (NSDictionary *)sortedStates;
{
	if (_sortedStates == nil) {
		NSMutableDictionary *statesDict = [NSMutableDictionary dictionary];
		
		for (MRDStateData *stateData in [[MRDStateFactory sharedFactory] allStates]) {
			NSString *firstLetter = [[stateData.name substringToIndex:1] uppercaseString];
			
			if (statesDict[firstLetter] == nil) {
				statesDict[firstLetter] = [NSMutableArray array];
			}
			
			[statesDict[firstLetter] addObject:stateData];
		}
		
		for (NSString *firstLetter in statesDict) {
			[statesDict[firstLetter] sortUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:kMRDStateDataNameKey ascending:YES]]];
		}
			 
	    _sortedStates = statesDict;
	}
			 
	return _sortedStates;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.title = @"States";
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
	});
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	if (tableView == self.tableView) {
		return self.sortedStates.count;
	}
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		return 1;
	}
	else {
		return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
	if (tableView == self.tableView) {
		NSString *letter = [self _firstLetterAtIndex:section];
		return [self.sortedStates[letter] count];
	}
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		return self.searchResults.count;
	}
	else {
		return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	static NSString * const kMRDStateListViewCellIdentifier = @"MRDStateListViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMRDStateListViewCellIdentifier];
	if(cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kMRDStateListViewCellIdentifier];
	}
	
	MRDStateData *stateData = nil;
	if (tableView == self.tableView) {
		stateData = [self _stateDataAtIndexPath:indexPath];
	}
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		stateData = self.searchResults[indexPath.row];
	}
	
	cell.textLabel.text = stateData.name;
	cell.detailTextLabel.text = stateData.capital;
	cell.imageView.image = [stateData imageWithSize:MRDStateDataImageSizeSmall];
	cell.accessoryType = (tableView == self.searchDisplayController.searchResultsTableView) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	return MRDStateDataImageSizeSmall + 2.0f;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;
{
	if(tableView == self.tableView) {
		NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		NSMutableArray *titles = [NSMutableArray array];
		for (NSInteger i = 0; i < letters.length; i++) {
			[titles addObject:[letters substringWithRange:NSMakeRange(i, 1)]];
		}
		[titles insertObject:UITableViewIndexSearch atIndex:0];
		return titles;
	}
	
	return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;
{
	if (tableView == self.tableView) {
		NSArray *allTitles = [self sectionIndexTitlesForTableView:tableView];
		NSInteger section = NSNotFound;
		
		while (section == NSNotFound && index > 0) {
			section = [self _indexOfFirstLetter:title];
			index = [allTitles indexOfObject:title];
			title = [allTitles objectAtIndex:(index - 1)];
		}
		
		if (section == NSNotFound && index == 0) {
			// Hit the search display condition
			assert([title isEqualToString:UITableViewIndexSearch]);
			[self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
		}
		
		return section;
	}
	
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
	if (tableView == self.tableView) {
		return [self _firstLetterAtIndex:section];
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
	MRDStateDetailViewController *detailController = [[MRDStateDetailViewController alloc] initWithNibName:@"MRDStateDetailViewController" bundle:nil];
	
	if (tableView == self.tableView) {
		detailController.stateData = [self _stateDataAtIndexPath:indexPath];
	}
	else if (tableView == self.searchDisplayController.searchResultsTableView) {
		assert(indexPath.section == 0);
		detailController.stateData = self.searchResults[indexPath.row];
	}
	
	[self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark private helpers

- (NSUInteger)_indexOfFirstLetter:(NSString *)letter;
{
	if(![[self.sortedStates allKeys] containsObject:letter]) {
		return NSNotFound;
	}
	
	return [[[self.sortedStates allKeys] sortedStringArray] indexOfObject:letter];
}

- (NSString *)_firstLetterAtIndex:(NSInteger)sectionIndex;
{
	return [[[self.sortedStates allKeys] sortedStringArray] objectAtIndex:sectionIndex];
}


- (MRDStateData *)_stateDataAtIndexPath:(NSIndexPath *)indexPath;
{
	NSString *letter = [self _firstLetterAtIndex:indexPath.section];
	return self.sortedStates[letter][indexPath.row];
}


#pragma mark searching

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller;
{
	assert(controller = self.searchDisplayController);
	
	[self _updateSearchResultsWithString:controller.searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; {
	[self _updateSearchResultsWithString:searchText];
}

- (void)_updateSearchResultsWithString:(NSString *)searchString;
{
	self.searchResults = [[[MRDStateFactory sharedFactory] allStates] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
			assert([evaluatedObject isKindOfClass:[MRDStateData class]]);
			MRDStateData *stateData = (MRDStateData *)evaluatedObject;
			NSRange stringMatchRange = [stateData.name rangeOfString:searchString options:NSCaseInsensitiveSearch];
		
			return (stringMatchRange.location != NSNotFound);
	}]];
}

@end
