#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol TTTMogeneratorEntity

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName;

/**
* Defaults section name key path to nil and cache name to a randomized string.
*/
+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(NSDictionary *)sortingKeysWithAscendingFlag;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSString *)entityName;

@end

@interface TTTAbstractManagedObject : NSManagedObject <TTTMogeneratorEntity>
@end