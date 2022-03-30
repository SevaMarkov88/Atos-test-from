public with sharing class TaskComponentController {

    @AuraEnabled(cacheable=true)
    public static List<User> searchUsers(String searchValue) {
        return TaskComponentHelper.searchUsers(searchValue);
}

    @AuraEnabled(cacheable=true)
    public static Boolean pushNewTask(String param){
        try {
            TaskComponentHelper.insertNewTask(param);
            return true;
        } catch (Exception e) {
            System.debug(e);
            return false;
        }
    }

    @AuraEnabled (cacheable=true)
    public static List<String> getNameOfLead(String recordId){
        return TaskComponentHelper.getLeadName(recordId);
    }
    
}