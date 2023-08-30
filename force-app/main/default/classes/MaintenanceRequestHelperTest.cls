@isTest
public with sharing class MaintenanceRequestHelperTest {
    // implement scheduled code here
    
    private testMethod static void func(){
        
        List <Case> impCaseList = testUtility_MaintenanceRequestHelper.mockVal();
        Set<Id> ids = new Set<Id>();
        
        for(Case obj: impCaseList){
            
            obj.Status = 'Closed';
            ids.add(obj.id);
            
        }
        Test.startTest();
        update impCaseList;
        Test.stopTest();
        
        system.assertEquals(300, [Select COUNT() From Case Where ParentId IN :ids]);
        //system.assertEquals('New',impCaseList[0].Status);
        
    }
    
}