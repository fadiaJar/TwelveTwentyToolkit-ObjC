#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TTTTimestamped.h"
#import "NSManagedObjectContext+TTTBatchManipulation.h"

@protocol TTTMogeneratorEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)moc;

+ (NSString *)entityName;

@end

extern const struct TTTIdentifiableAttributes
{
    __unsafe_unretained NSString *identifier;
} TTTIdentifiableAttributes;

@protocol TTTIdentifiable <TTTMogeneratorEntity>

@property(nonatomic, strong) NSNumber *identifier;

@end

extern const struct TTTSyncStatusAttributes
{
    __unsafe_unretained NSString *syncStatus;
} TTTSyncStatusAttributes;

typedef NSString *__unsafe_unretained TTTSyncStatus;

extern const struct TTTSyncStatusValues
{
    TTTSyncStatus synchronized;
    TTTSyncStatus inserted;
    TTTSyncStatus updated;
    TTTSyncStatus deleted;
} TTTSyncStatusValues;

@protocol TTTSynchronizable <TTTIdentifiable, TTTTimestampedLocally>

@property(nonatomic, strong) NSString *syncStatus;

@end

@interface TTTAbstractManagedObject : NSManagedObject <TTTMogeneratorEntity>

#pragma mark - Uniquing and batch manipulation

+ (id)uniqueEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context;

+ (id)existingEntityWithIdentifier:(NSNumber *)identifier inContext:(NSManagedObjectContext *)context;

+ (id)existingEntityWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context;

+ (id)existingEntityWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allEntitiesSortedByKey:(NSString *)sortKey ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context;

+ (NSArray *)allEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys sortedByKey:(NSString *)sortKey ascending:(BOOL)ascending inContext:(NSManagedObjectContext *)context;

+ (TTTDeleteCount)deleteEntitiesWithValue:(id)value forKey:(NSString *)key inContext:(NSManagedObjectContext *)context error:(NSError **)error;

+ (TTTDeleteCount)deleteEntitiesWithValues:(NSArray *)values forKeys:(NSArray *)keys inContext:(NSManagedObjectContext *)context error:(NSError **)error;

+ (TTTDeleteCount)deleteEntitiesWithNoRelationshipForKey:(NSString *)key inContext:(NSManagedObjectContext *)context error:(NSError **)error;

+ (TTTDeleteCount)deleteAllEntitiesInContext:(NSManagedObjectContext *)context error:(NSError **)error;

#pragma mark - Fetch requests and ~controllers

+ (NSFetchRequest *)fetchRequestWithSortingKeys:(id)sortingKeysWithAscendingFlag;

/**
* Defaults section name key path to nil
*/
+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context;

/**
* Defaults cache name to a randomized string.
*/
+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath;

+ (NSFetchedResultsController *)fetchedResultsControllerWithSortingKeys:(id)sortingKeysWithAscendingFlag
                                                   managedObjectContext:(NSManagedObjectContext *)context
                                                     sectionNameKeyPath:(NSString *)sectionNameKeyPath
                                                              cacheName:(NSString *)cacheName;

@end