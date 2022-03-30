public with sharing class TaskCreationTriggerHelper {
    public static void taskCreation(Boolean isDel, List<Task> oldTrigger, List<Task> newTrigger, Map<Id,Task> oldTriggerMap) {
        
        List<User> result = new List<User>();
        List<Id> idsOfUser = new List<Id>();
        
        if (newTrigger != NUll) {
            for (Task ts : newTrigger) {
                idsOfUser.add(ts.OwnerId);
            }
        } else if (newTrigger == NULL && oldTrigger != Null) {
            for (Task ts : oldTrigger) {
                idsOfUser.add(ts.OwnerId);
            }
        }

        Map<Id,User> mapOfUsers = new Map<Id, User>([SELECT Id, Username, FirstName, LastName, Email, Not_Started_Tasks__c, In_Progress_Tasks__c FROM User WHERE Id in: idsOfUser]);
    
        if(isDel == False) {
            for (Task ts : newTrigger) {
                
                User currentUser = mapOfUsers.get(ts.OwnerId);
        
                if(oldTrigger != Null) {
        
                    Task oldTask = oldTriggerMap.get(ts.Id);
        
                    if (oldTask.Status != 'Not Started' && oldTask.Status != 'In Progress' && ts.Status == 'Not Started') {
                        currentUser.Not_Started_Tasks__c++;
                    } else if (oldTask.Status == 'Not Started' && ts.Status == 'Completed') {
                        currentUser.Not_Started_Tasks__c--;
                    }else if (oldTask.Status == 'Not Started' && ts.Status == 'In Progress') {
                        currentUser.Not_Started_Tasks__c--;
                        currentUser.In_Progress_Tasks__c++;
                    } else if (oldTask.Status == 'In Progress' && ts.Status == 'Completed') {
                        currentUser.In_Progress_Tasks__c--;
                    }
                    
                } else if (oldTrigger == Null) {
                    if (ts.Status == 'Not Started') {
                        currentUser.Not_Started_Tasks__c++;
                    } else if (ts.Status == 'In Progress') {
                        currentUser.In_Progress_Tasks__c++;
                    }
                }
    
                result.add(currentUser);
            }
        } else if (isDel == True) {
            for (Task ts : oldTrigger) {

                User currentUser = mapOfUsers.get(ts.OwnerId);

                if (ts.Status == 'Not Started') {
                    currentUser.Not_Started_Tasks__c--;
                } else if (ts.Status == 'In Progress') {
                    currentUser.In_Progress_Tasks__c--;
                }
                result.add(currentUser);
            }
        }

        update result;
    }
}