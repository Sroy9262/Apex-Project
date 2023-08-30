public with sharing class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    
    public void execute(SchedulableContext ctx){
        
        //system.enqueueJob(new WarehouseCalloutService());
        WarehouseCalloutService.func();
        
    }
    
}
//debug
/* Schedule Operation
 String str = '0 0 21 * * ?'
Id jobId =  system.schedule('WarehouseSyncScheduleJob',str,new WarehouseSyncSchedule());
system.debug('ID: '+jobId);
*/
/* Abort Operation
 CronTrigger exp = [SELECT Id FROM CronTrigger Where CronJobDetail.Name = 'WarehouseSyncScheduleJob'  AND State= 'WAITING'];
system.abortJob(exp.id);
*/