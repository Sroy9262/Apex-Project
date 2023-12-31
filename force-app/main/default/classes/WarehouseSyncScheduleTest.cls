@IsTest
public with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    
    private testMethod static void testWarehouseCalloutServiceSchedule() {
        
        String scheduleTime = '00 00 01 * * ?';
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        String jobID=System.schedule('Warehouse Time To Schedule to Test', scheduleTime, new WarehouseSyncSchedule());
        Test.stopTest();
       
       // CronTrigger a=[SELECT Id FROM CronTrigger where NextFireTime > today];
        //System.assertEquals(jobID, a.Id);
        
        CronTrigger a=[SELECT Id FROM CronTrigger where CronJobDetail.Name = 'Warehouse Time To Schedule to Test'];
        System.assertEquals(jobID, a.Id);
        
       // system.assertEquals(1, [Select count() From Product2]);//it will not work cause the data is not created yet
        
    }
}